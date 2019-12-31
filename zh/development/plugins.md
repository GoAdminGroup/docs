# 插件开发
---

一个插件需要实现对应的三个接口，如：

```go
// Plugin as one of the key components of goAdmin has three
// methods. GetRequest return all the path registered in the
// plugin. GetHandler according the url and method return the
// corresponding handler. InitPlugin init the plugin which do
// something like init the database and set the config and register
// the routes. The Plugin must implement the three methods.
type Plugin interface {

    // 以下这两个接口内容基本是固定的，可参考后面的example插件，照写即可

    // 获取请求
    GetRequest() []context.Path
    
    // 获取控制器方法
    GetHandler(url, method string) context.Handlers
    
    // 初始化插件，接口框架的服务列表
	InitPlugin(services service.List)
}
```

参考例子：<br>

- [开发一个源码插件](https://github.com/GoAdminGroup/go-admin/blob/master/plugins/example/example.go)
- [开发一个二进制插件](https://github.com/GoAdminGroup/go-admin/blob/master/plugins/example/go_plugin/main.go)