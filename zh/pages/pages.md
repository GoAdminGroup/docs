# 自定义页面
---

框架支持自己定义一个页面显示，调用引擎的```Content```方法，如下：

```go
package main

import (
	_ "github.com/GoAdminGroup/go-admin/adapter/gin"
	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/examples/datamodel"
	"github.com/GoAdminGroup/go-admin/modules/config"
	"github.com/GoAdminGroup/go-admin/plugins/admin"
	"github.com/GoAdminGroup/go-admin/plugins/example"
	"github.com/GoAdminGroup/go-admin/template/types"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	eng := engine.Default()

	cfg := config.Config{}

	adminPlugin := admin.NewAdmin(datamodel.Generators)

	examplePlugin := example.NewExample()

	if err := eng.AddConfig(cfg).AddPlugins(adminPlugin, examplePlugin).Use(r); err != nil {
		panic(err)
	}

	r.Static("/uploads", "./uploads")

	// 这样子去自定义一个页面：

	r.GET("/"+cfg.PREFIX+"/custom", func(ctx *gin.Context) {
		engine.Content(ctx, func() types.Panel {
			return datamodel.GetContent()
		})
	})

	r.Run(":9033")
}
```

Content方法会将内容写入到框架的context中。

GetContent方法代码如下：

```go
package datamodel

import (
	"github.com/GoAdminGroup/go-admin/modules/config"
	template2 "github.com/GoAdminGroup/go-admin/template"
	"github.com/GoAdminGroup/go-admin/template/types"
	"html/template"
)

func GetContent() types.Panel {

	components := template2.Get(config.Get().THEME)
	colComp := components.Col()

	infobox := components.InfoBox().
		SetText("CPU TRAFFIC").
		SetColor("blue").
		SetNumber("41,410").
		SetIcon("ion-ios-gear-outline").
		GetContent()

	var size = map[string]string{"md": "3", "sm": "6", "xs": "12"}
	infoboxCol1 := colComp.SetSize(size).SetContent(infobox).GetContent()
	row1 := components.Row().SetContent(infoboxCol1).GetContent()

	return types.Panel{
		Content:     row1,
		Title:       "Dashboard",
		Description: "this is a example",
	}
}
```
