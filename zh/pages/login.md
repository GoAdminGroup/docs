# 更改登录界面
---

自定义登录界面教程：[http://discuss.go-admin.com/t/goadmin/53](http://discuss.go-admin.com/t/goadmin/53)

通过组件的方式可以修改登录界面，如下例子：

更多登录界面组件[看这里](https://github.com/GoAdminGroup/components/blob/master/login/README.md)；加载后引入即可。

```go
package main

import (
	_ "github.com/GoAdminGroup/go-admin/adapter/gin" // 适配器
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql" // 数据库驱动
	_ "github.com/GoAdminGroup/themes/adminlte" // 主题

	"github.com/GoAdminGroup/demo/login"
	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/template"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	eng := engine.Default()

    // 增加登录组件
	template.AddLoginComp(login.GetLoginComponent())

	if err := eng.AddConfigFromJson("./config.json").
		Use(r); err != nil {
		panic(err)
	}

	r.Static("/uploads", "./uploads")

	_ = r.Run(":9033")
}
```
