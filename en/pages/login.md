# Customize Login Page
---

You can modify the login interface by means of components, as in the following example:

More login interface components [see here](https://github.com/GoAdminGroup/components/blob/master/login/README.md)；It can be introduced after loading.

```go
package main

import (
	_ "github.com/GoAdminGroup/go-admin/adapter/gin"	    
    _ "github.com/GoAdminGroup/go-admin/adapter/gin"
    _ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql"
    // import the theme2 login theme, if you don`t use, don`t import
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
	
	// load the CAPTCHA driver if you use it
	adminPlugin.SetCaptcha(map[string]string{"driver": login.CaptchaDriverKeyDefault})

    // use the login theme component
    login.Init(login.Config{
        Theme: "theme2", // theme name
        CaptchaDigits: 5, // Use captcha images, here on behalf of how many authentication code Numbers
        // Use tencent verification code, need to offer appID and appSecret
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

	r.Static("/uploads", "./uploads")

	_ = r.Run(":9033")
}
```
