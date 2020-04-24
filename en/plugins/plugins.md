# How To Use Plugins
---

The framework's plugins include: controllers, routing, and views. The specific plug-in development will be discussed in the project development part, here just show you how to use it.

The example plugin is our demo.

Using plugins are divided into: using the third package source code plugin and use the dynamic link library plugin (.so file, currently only supports linux and mac platforms)

You can skip this part, if you just want to build a crud administrative platform.

## Using the third package source code plugin

For example: 

```go
package main

import (
	_ "github.com/GoAdminGroup/go-admin/adapter/gin" // Import the adapter
	_ "github.com/GoAdminGroup/themes/adminlte" // Import the theme
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql" // Import the sql driver

	"github.com/gin-gonic/gin"
	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/plugins/admin"
	"github.com/GoAdminGroup/go-admin/plugins/example"
	"github.com/GoAdminGroup/go-admin/modules/config"
	"github.com/GoAdminGroup/go-admin/examples/datamodel"
)

func main() {
	r := gin.Default()
	eng := engine.Default()
	cfg := config.Config{}

	adminPlugin := admin.NewAdmin(datamodel.Generators)
	examplePlugin := example.NewExample()
	
	eng.AddConfig(cfg).
		AddPlugins(adminPlugin, examplePlugin).  // loading
		Use(r)

	r.Run(":9033")
}
```


## Using the binary plugin

Load the ```.so```file, and call```plugins.LoadFromPlugin```.

如：

```go
package main

import (	
	_ "github.com/GoAdminGroup/go-admin/adapter/gin" // Import the adapter
	_ "github.com/GoAdminGroup/themes/adminlte" // Import the theme
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql" // Import the sql driver

	"github.com/gin-gonic/gin"
	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/plugins/admin"
	"github.com/GoAdminGroup/go-admin/plugins"
	"github.com/GoAdminGroup/go-admin/modules/config"
	"github.com/GoAdminGroup/go-admin/examples/datamodel"
)

func main() {
	r := gin.Default()
	eng := engine.Default()
	cfg := config.Config{}

	adminPlugin := admin.NewAdmin(datamodel.Generators)

	// load plugin from .so file.
	examplePlugin := plugins.LoadFromPlugin("../datamodel/example.so")
	
	eng.AddConfig(cfg).
		AddPlugins(adminPlugin, examplePlugin).
		Use(r)

	r.Run(":9033")
}
```