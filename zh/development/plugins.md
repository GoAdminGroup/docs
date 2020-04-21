# 插件开发
---

一个插件需要实现对应的四个接口，如：

```go
// 插件是GoAdmin的重要组成部分。不同插件有不同的功能特性。
type Plugin interface {

    // 获取控制器方法
    GetHandler() context.HandlerMap
    
    // 初始化插件，接口框架的服务列表
    InitPlugin(services service.List)
    
    // 插件名字
    Name() string
    
    // 插件路由前缀
	Prefix() string
}
```

新建一个自己的插件必须继承```plugin.Base```。如以下例子：

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
    // 加入认证中间件
	route.GET("/show/me/something", auth.Middleware(db.GetConnection(srv)), func(ctx *context.Context){
        // 控制器逻辑
    })
	return app
}
```

更多源码：<br>

- [开发一个源码插件](https://github.com/GoAdminGroup/go-admin/blob/master/plugins/example/example.go)
- [开发一个二进制插件](https://github.com/GoAdminGroup/go-admin/blob/master/plugins/example/go_plugin/main.go)