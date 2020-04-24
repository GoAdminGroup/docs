# Plugins Development
---

A plugin needs to implement the corresponding four interfaces, such as:

```go
// Plug-in is an important part of GoAdmin. Different plug-ins have different features.
type Plugin interface {

    // Get handlers
    GetHandler() context.HandlerMap
    
    // Initialize the plug-in
    InitPlugin(services service.List)
    
    // Get plugin name
    Name() string
    
    // Url prefix
	Prefix() string
}
```

Create a new plug-in must inherit```plugin.Base```. For example: 

```go
package example

import (
	c "github.com/GoAdminGroup/go-admin/modules/config"
	"github.com/GoAdminGroup/go-admin/modules/service"
	"github.com/GoAdminGroup/go-admin/plugins"
)

type Example struct {
	*plugins.Base
}

func NewExample() *Example {
	return &Example{
		Base: &plugins.Base{PlugName: "example", URLPrefix: "example"},
	}
}

func (e *Example) InitPlugin(srv service.List) {
	e.InitBase(srv)
	e.App = e.initRouter(c.Prefix(), srv)
}

func (e *Example) initRouter(prefix, srv service.List) {

	app := context.NewApp()
    route := app.Group(prefix)
    // Join the certification middleware
	route.GET("/show/me/something", auth.Middleware(db.GetConnection(srv)), func(ctx *context.Context){
        // Controller logic
    })
	return app
}
```

More: <br>

- [Develop a source plug-ins](https://github.com/GoAdminGroup/go-admin/blob/master/plugins/example/example.go)
- [Develop a binary plugins](https://github.com/GoAdminGroup/go-admin/blob/master/plugins/example/go_plugin/main.go)