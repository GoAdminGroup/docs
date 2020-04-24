# 更改登录界面
---

自定义登录界面教程：[http://discuss.go-admin.com/t/goadmin/53](http://discuss.go-admin.com/t/goadmin/53)

通过组件的方式可以修改登录界面，如下例子：

更多登录主题[看这里](https://github.com/GoAdminGroup/components/blob/master/login/README_CN.md)；加载后引入即可。

```go
package main

import (
	_ "github.com/GoAdminGroup/go-admin/adapter/gin"	    
    _ "github.com/GoAdminGroup/go-admin/adapter/gin"
    _ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql"
    // 引入theme2登录页面主题，如不用，可以不导入
    _ "github.com/GoAdminGroup/components/login/theme2"
	
	"github.com/GoAdminGroup/components/login"
	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/examples/datamodel"
	"github.com/GoAdminGroup/go-admin/plugins/admin"
	"github.com/gin-gonic/gin"
	"io/ioutil"
)

func main() {
	r := gin.Default()

	gin.SetMode(gin.ReleaseMode)
	gin.DefaultWriter = ioutil.Discard

	eng := engine.Default()
	adminPlugin := admin.NewAdmin(datamodel.Generators)
	adminPlugin.AddGenerator("user", datamodel.GetUserTable)

    // 使用登录页面组件
    login.Init(login.Config{
        Theme: "theme2",
        CaptchaDigits: 5, // 使用图片验证码，这里代表多少个验证码数字
        // 使用腾讯验证码，需提供appID与appSecret
        // TencentWaterProofWallData: login.TencentWaterProofWallData{
        //    AppID:"",
        //    AppSecret: "",
        // }   
    })

	if err := eng.AddConfigFromJson("./config.json").
		AddPlugins(adminPlugin).
		Use(r); err != nil {
		panic(err)
	}
		
	// 载入对应验证码驱动，如没使用不用载入
	adminPlugin.SetCaptcha(map[string]string{"driver": login.CaptchaDriverKeyDefault})

	r.Static("/uploads", "./uploads")

	_ = r.Run(":9033")
}
```
