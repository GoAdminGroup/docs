# Get Ready
---

This program is based on ```golang```. It is recommended to use ```golang``` with version higher than 1.11. Please visit: [https://golang.org](https://golang.org)

## Import the program required sql to the corresponding self-built database

The contents of the sql file are the data tables required by the framework. Suppose your business database is: database_a; then you can import the framework sql into ```database_a```, or you can create another database ```database_b``` Import, can be a different driver database, for example, your business database is ```mysql```, the framework database is ```sqlite```. The framework currently supports multiple database connection operations. How to configure, will be described in detail later.

- [mysql](https://raw.githubusercontent.com/GoAdminGroup/go-admin/master/data/admin.sql)
- [sqlite](https://raw.githubusercontent.com/GoAdminGroup/go-admin/master/data/admin.db)
- [postgresql](https://raw.githubusercontent.com/GoAdminGroup/go-admin/master/data/admin.pgsql)

## Install command line tools

Download the binary excecute file: 

|  File name   | OS  | Arch  | Size  |
|  ----  | ----  | ----  |----  |
| [admincli_darwin_x86_64_v1.0.0.zip](http://file.go-admin.cn/go_admin/cli/v1_0_0/admincli_darwin_x86_64_v1.0.0.zip)  | macOs | x86-64 | 4.75 MB
| [admincli_linux_x86_64_v1.0.0.zip](http://file.go-admin.cn/go_admin/cli/v1_0_0/admincli_linux_x86_64_v1.0.0.zip)  | Linux | x86-64   | 6.47 MB
| [admincli_linux_armel_v1.0.0.zip](http://file.go-admin.cn/go_admin/cli/v1_0_0/admincli_linux_armel_v1.0.0.zip)  | Linux | x86   | 6.02 MB
| [admincli_windows_i386_v1.0.0.zip](http://file.go-admin.cn/go_admin/cli/v1_0_0/admincli_windows_i386_v1.0.0.zip)  | Windows | x86  |6.12 MB
| [admincli_windows_x86_64_v1.0.0.zip](http://file.go-admin.cn/go_admin/cli/v1_0_0/admincli_windows_x86_64_v1.0.0.zip)  | Windows | x86-64   |6.33 MB



Or Use the command:

```
go install github.com/GoAdminGroup/go-admin/admincli
```

<br>

🍺🍺 Get ready to work here, next to the [Quick start](init-project)

<br>

> English is not my main language. If any typo or wrong translation you found, you can help to translate in [github here](https://github.com/GoAdminGroup/docs). I will very appreciate it.


