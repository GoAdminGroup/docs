# Introduction
---

The GoAdmin project module is as follows:

|  Name   | Function  | Path  | 
|  ----  | ----  | ----  |
| engine  | Engine is the core module of GoAdmin. The function of this module is to use the web framework adapter to inject the mapping between the plugin's routing and controller methods into the framework. | ./engine/engine.go
| adapter  | The function of the adapter is to realize the mutual conversion between the context of the web framework and the context of GoAdmin. | ./adapter/adapter.go
| context  | Context is the context of a request, the record includes the routing parameters and method information of the request, the context will be passed to the method of the plugin | ./context/context.go
| plugin  | Each plugin has its own routing and controller method. After receiving the context converted by the adapter, it is processed by the controller method and returned to the adapter and then output to the web framework. | ./plugins/plugins.go
| template  | Template is the golang materialization corresponding to the front-end code, and the component parts corresponding to the front-end code, such as forms, rows, columns, etc., are instantiated as an interface of golang, so the html code of the component can be obtained by calling the interface method, and this function is provided to Plugin to call | ./template/template.go
| auth  | Auth implements the management of cookies, stores and converts the front-end cookie to the logged-in user, and implements the interception of the privilege. | ./modules/auth/auth.go
| config  | Config is the global configuration of the system | ./modules/config/config.go
| db  | db is a sql connection library, connected to the sql database to provide query and other help methods, support for multiple drivers | ./modules/db/connection.go
| language  | Language implements a simple language mapping to support language localization | ./modules/language/language.go
| file  | File implements a file upload engine | ./modules/file/file.go
| logger  | The logger is the log module of the project | ./modules/logger/logger.go
| menu  | Menu is the management of the project menu | ./modules/menu/menu.go
| cli  | Cli command line module, including some basic commands for generating files and development | ./adm/cli.go