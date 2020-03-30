# Customize Login Page
---

You can modify the login interface by means of components, as in the following example:

More login interface components [see here](https://github.com/GoAdminGroup/components/blob/master/login/README.md)；It can be introduced after loading.

```go
package main

import (
	"github.com/GoAdminGroup/demo/ecommerce"
	"github.com/GoAdminGroup/demo/login"
	"github.com/GoAdminGroup/demo/pages"
	_ "github.com/GoAdminGroup/go-admin/adapter/gin"
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql"
	_ "github.com/GoAdminGroup/themes/adminlte"
	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/examples/datamodel"
	"github.com/GoAdminGroup/go-admin/plugins/admin"
	"github.com/GoAdminGroup/go-admin/plugins/example"
	"github.com/GoAdminGroup/go-admin/template"
	"github.com/GoAdminGroup/go-admin/template/types"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	eng := engine.Default()

    //  Add login component
	template.AddLoginComp(login.GetLoginComponent())

	// you can custom a plugin like:

	examplePlugin := example.NewExample()

	rootPath := "/data/www/go-admin"

	if err := eng.AddConfigFromJson(rootPath+"/config.json").
		AddGenerators(datamodel.Generators).
		AddGenerator("user", datamodel.GetUserTable).
		AddPlugins(examplePlugin).
		Use(r); err != nil {
		panic(err)
	}

	r.Static("/uploads", rootPath+"/uploads")

	_ = r.Run(":9033")
}
```
