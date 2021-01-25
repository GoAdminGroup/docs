# Get Ready
---

This program is based on ```golang```. It is recommended to use ```golang``` with version higher than 1.11. More infomation, please visit: [https://golang.org](https://golang.org)

## Import the program required sql to the corresponding self-built database

The content of the sql file are the data tables required by the framework. Suppose your business database is: ```database_a```; then you can import the framework sql into ```database_a```, or you can create another database ```database_b``` to import into. Besides, they can be different driver databases, for example, your business database is ```mysql```, the framework database is ```sqlite```. GoAdmin currently supports multiple database connection operations. How to configure, will be described in detail later.

- [mysql](https://raw.githubusercontent.com/GoAdminGroup/go-admin/master/data/admin.sql)
- [sqlite](https://raw.githubusercontent.com/GoAdminGroup/go-admin/master/data/admin.db)
- [postgresql](https://raw.githubusercontent.com/GoAdminGroup/go-admin/master/data/admin.pgsql)
- [mssql](https://raw.githubusercontent.com/GoAdminGroup/go-admin/master/data/admin.mssql)

## Install command line tools

Download the binary excecute file: 

|  File name   | OS  | Arch  | Size  |
|  ----  | ----  | ----  |----  |
| [adm_darwin_x86_64_v1.2.19.zip](http://file.go-admin.cn/go_admin/cli/v1_2_19/adm_darwin_x86_64_v1.2.19.zip)  | macOs | x86-64 | 4.77 MB
| [adm_linux_x86_64_v1.2.19.zip](http://file.go-admin.cn/go_admin/cli/v1_2_19/adm_linux_x86_64_v1.2.19.zip)  | Linux | x86-64   | 6.52 MB
| [adm_linux_armel_v1.2.19.zip](http://file.go-admin.cn/go_admin/cli/v1_2_19/adm_linux_armel_v1.2.19.zip)  | Linux | x86   | 6.06 MB
| [adm_windows_i386_v1.2.19.zip](http://file.go-admin.cn/go_admin/cli/v1_2_19/adm_windows_i386_v1.2.19.zip)  | Windows | x86  |6.16 MB
| [adm_windows_x86_64_v1.2.19.zip](http://file.go-admin.cn/go_admin/cli/v1_2_19/adm_windows_x86_64_v1.2.19.zip)  | Windows | x86-64   |6.38 MB


Or use the command:

```
go install github.com/GoAdminGroup/go-admin/adm
```

<br>

🍺🍺 Get ready to work here!!

<br>

> English is not my main language. If any typo or wrong translation you found, you can help to translate in [github here](https://github.com/GoAdminGroup/docs). I will very appreciate it.


