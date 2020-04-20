# 插件的使用
---

框架的插件内容包括：控制器，路由以及视图。具体的插件开发在项目开发中会讲，这里演示如何进行使用。

example插件是我们的演示例子。

使用插件分为：使用第三方包源代码插件和使用动态链接库插件（.so文件，目前仅支持linux和mac平台）

注：以下这部分内容可以不用理解，如果你的目的是搭一个crud的管理后台的话，可以直接看下一章内容。

## 第三方包插件

第三方包插件的使用，只需要调用引擎的AddPlugins方法即可。

如：

```go
package main

import (	
	_ "github.com/GoAdminGroup/go-admin/adapter/gin" // 必须引入，如若不引入，则需要自己定义
	_ "github.com/GoAdminGroup/themes/adminlte" // 必须引入，不然报错
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql" // 引入数据库驱动

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
		AddPlugins(adminPlugin, examplePlugin).  // 加载插件
		Use(r)

	r.Run(":9033")
}
```

## 二进制插件

加载```.so```文件，需要调用```plugins.LoadFromPlugin```方法进行加载。

如：

```go
package main

import (	
	_ "github.com/GoAdminGroup/go-admin/adapter/gin" // 必须引入，如若不引入，则需要自己定义
	_ "github.com/GoAdminGroup/themes/adminlte" // 必须引入，不然报错
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql" // 引入数据库驱动

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

	// 从.so文件中加载插件
	examplePlugin := plugins.LoadFromPlugin("../datamodel/example.so")
	
	eng.AddConfig(cfg).
		AddPlugins(adminPlugin, examplePlugin).  // 加载插件
		Use(r)

	r.Run(":9033")
}
```