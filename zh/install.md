# 准备工作
---

本程序是基于```golang```，推荐使用版本高于```golang 1.11```，具体请访问：[https://golang.org](https://golang.org)

#### 导入程序所需sql到对应自建数据库中

以下sql文件内容为框架所需数据表，假设你的业务数据库为：```database_a```；那么你可以将以下框架sql文件导入到```database_a```中，也可以另外建一个数据库```database_b```再导入，可以为不同驱动的数据库，比方说你的业务数据库为```mysql```，框架数据库为```sqlite```。框架目前支持多个数据库连接操作。关于如何配置，后面会详细介绍。

- [mysql](https://raw.githubusercontent.com/GoAdminGroup/go-admin/master/data/admin.sql)
- [sqlite](https://raw.githubusercontent.com/GoAdminGroup/go-admin/master/data/admin.db)
- [postgresql](https://raw.githubusercontent.com/GoAdminGroup/go-admin/master/data/admin.pgsql)

#### 安装命令行工具

下载对应系统的二进制文件到本地：

|  File name   | OS  | Arch  | Size  |
|  ----  | ----  | ----  |----  |
| [adm_darwin_x86_64_v1.2.9.zip](http://file.go-admin.cn/go_admin/cli/v1_2_9/adm_darwin_x86_64_v1.2.9.zip)  | macOs | x86-64 | 4.77 MB
| [adm_linux_x86_64_v1.2.9.zip](http://file.go-admin.cn/go_admin/cli/v1_2_9/adm_linux_x86_64_v1.2.9.zip)  | Linux | x86-64   | 6.52 MB
| [adm_linux_armel_v1.2.9.zip](http://file.go-admin.cn/go_admin/cli/v1_2_9/adm_linux_armel_v1.2.9.zip)  | Linux | x86   | 6.06 MB
| [adm_windows_i386_v1.2.9.zip](http://file.go-admin.cn/go_admin/cli/v1_2_9/adm_windows_i386_v1.2.9.zip)  | Windows | x86  |6.16 MB
| [adm_windows_x86_64_v1.2.9.zip](http://file.go-admin.cn/go_admin/cli/v1_2_9/adm_windows_x86_64_v1.2.9.zip)  | Windows | x86-64   |6.38 MB



或使用命令安装：

```
go install github.com/GoAdminGroup/go-admin/adm
```

<br>

🍺🍺 到这里准备工作完毕~~