# 适配器
---

适配器的作用是实现web框架context与GoAdmin自身context的转换。
开发一个adapter需要实现以下接口方法：

```go
package adapter

import (
	"github.com/GoAdminGroup/go-admin/plugins"
	"github.com/GoAdminGroup/go-admin/template/types"
)

type WebFrameWork interface {
	// 返回web框架的名字
	Name() string

	// Use 方法将插件中的路由和控制器映射关系插入到web框架中，第一个参数为web框架引擎
	Use(app interface{}, plugins []plugins.Plugin) error

	// Content 方法将回调参数返回的面板html写入到web框架的context中，也就是第一个参数
	Content(ctx interface{}, fn types.GetPanelFn, navButtons ...types.Button)

	// User 方法返回认证用户模型
	User(ctx interface{}) (models.UserModel, bool)

	// AddHandler 增加路由与控制器到web框架中
	AddHandler(method, path string, handlers context.Handlers)

	// 禁止web框架日志输出
	DisableLog()

	// 静态目录文件服务器
	Static(prefix, path string)

	// 辅助函数
	// ================================

	SetApp(app interface{}) error
	SetConnection(db.Connection)
	GetConnection() db.Connection
	SetContext(ctx interface{}) WebFrameWork
	GetCookie() (string, error)
	Path() string
	Method() string
	FormParam() url.Values
	IsPjax() bool
	Redirect()
	SetContentType()
	Write(body []byte)
	CookieKey() string
	HTMLContentType() string
}
```

更多请参考：[https://github.com/GoAdminGroup/go-admin/tree/master/adapter](https://github.com/GoAdminGroup/go-admin/tree/master/adapter)