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
| [adm_darwin_x86_64_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_darwin_x86_64_v1.2.24.zip)  | macOs | x86-64 | 4.77 MB
| [adm_linux_x86_64_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_linux_x86_64_v1.2.24.zip)  | Linux | x86-64   | 6.52 MB
| [adm_linux_armel_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_linux_armel_v1.2.24.zip)  | Linux | x86   | 6.06 MB
| [adm_windows_i386_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_windows_i386_v1.2.24.zip)  | Windows | x86  |6.16 MB
| [adm_windows_x86_64_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_windows_x86_64_v1.2.24.zip)  | Windows | x86-64   |6.38 MB


Or use the command:

```
go install github.com/GoAdminGroup/adm
```

<br>

🍺🍺 Get ready to work here, next to the [Quick start](quick_start.md)

<br>

> English is not my main language. If any typo or wrong translation you found, you can help to translate in [github here](https://github.com/GoAdminGroup/docs). I will very appreciate it.


