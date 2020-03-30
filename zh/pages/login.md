# 更改登录界面
---

通过组件的方式可以修改登录界面，如下例子：

更多登录界面组件[看这里](https://github.com/GoAdminGroup/components/blob/master/login/README.md)；加载后引入即可。

```go
package main

import (
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

    // 增加登录组件
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
