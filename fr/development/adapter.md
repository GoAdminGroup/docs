# Adapter Development
---

The role of the adapter is to achieve the conversion of the web framework context and GoAdmin's own context.
To make a Adapter, you need implemente three methods:

```go
package adapter

import (
	"github.com/GoAdminGroup/go-admin/plugins"
	"github.com/GoAdminGroup/go-admin/template/types"
)

// WebFrameWork is a interface which is used as an adapter of
// framework and goAdmin. It must implement two methods. Use registers
// the routes and the corresponding handlers. Content writes the
// response to the corresponding context of framework.
type WebFrameWork interface {
	Use(interface{}, []plugins.Plugin) error
	Content(interface{}, types.GetPanel)
}
```

In addition to ```Use``` and ```Content```, you need to implement ```init```

## Use

**Use** receives two parameters, the first parameter type is **interface{}**, which is the context of the web framework, and the second parameter is the plugin array. The return value is a **error**.
The role of **Use** is to use the incoming plugin array to associate the routing of the web framework with the controller methods in the plugin array to implement the correspondence between the web framework and the GoAdmin plugin method. For example, in the plugin example:

```go
"/admin/example" => ShowExample(ctx *context.Context)
```

After processing by ```Use```, it will be injected into the web framework.

## Content

The **Content** method takes two arguments, the first argument type is **interface{}**, which is the context of the web framework, and the second argument is the **types.GetPanel** type.

As follow:

```go
type GetPanel func(ctx interface{}) (Panel, error)
```

The role of **Content** is to pass the web framework's context when customizing the page, and then write the return of the custom page content to the web framework's context.

## init

The **init** method injects the adapter into the engine so it can be used by others.

```go
func init() {
	engine.Register(new(Beego))
}
```