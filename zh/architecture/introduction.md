# 项目架构
---

GoAdmin的项目模块如下：

|  模块名   | 模块功能  | 模块位置  | 
|  ----  | ----  | ----  |
| engine  | engine是GoAdmin最核心的模块，此模块的功能是利用web框架适配器将插件的路由与控制器方法的映射关系注入到框架中 | ./engine/engine.go
| adapter  | adapter的功能是实现web框架的context与GoAdmin的context的相互转换 | ./adapter/adapter.go
| context  | context是一个请求的上下文，记录包括了请求的路由参数与方法信息，context会被传入到插件的方法中 | ./context/context.go
| plugin  | plugin有自己的路由与控制器方法，在接收由adapter转换过来的context后经控制器方法处理返回给adapter再输出到web框架中去 | ./plugins/plugins.go
| template  | template是前端代码对应的golang实体化，前端代码对应的组件部分，比如表单，行，列等实体化为golang的一个接口，因此可以通过调用接口方法获取到该组件的html代码，此功能提供给插件去调用 | ./template/template.go
| auth  | auth实现了对cookie的管理，将前端的cookie存储并转换为登录的用户，同时实现了对权限的拦截 | ./modules/auth/auth.go
| config  | config是系统的全局配置 | ./modules/config/config.go
| db  | db是一个sql连接库，连接了sql数据库提供查询等帮助方法，支持多个driver | ./modules/db/connection.go
| language  | language实现了简单的语言映射，从而支持语言本地化 | ./modules/language/language.go
| file  | file实现了一个文件上传引擎 | ./modules/file/file.go
| logger  | logger是项目的日志模块 | ./modules/logger/logger.go
| menu  | menu是对项目菜单的管理 | ./modules/menu/menu.go
| cli  | cli命令行模块，包括生成文件和开发的一些基本命令 | ./adm/cli.go