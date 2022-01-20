# 准备工作
---

本程序是基于```golang```语言编写，推荐使用golang版本高于1.11，golang相关信息具体可以访问其[官网](https://golang.org)查询。

## 准备数据

以下sql文件内容为框架所需数据表，假设你的业务数据库为：```database_a```；那么你可以将以下框架sql文件导入到```database_a```中，也可以另外建一个数据库```database_b```再导入，可以为不同驱动的数据库，比方说你的业务数据库为```mysql```，框架数据库为```sqlite```。框架目前支持多个数据库连接操作。关于如何配置，后面文档会具体介绍。

### 下载

[sqlite](https://gitee.com/go-admin/go-admin/raw/master/data/admin.db) / [mssql](https://gitee.com/go-admin/go-admin/raw/master/data/admin.mssql) / [postgresql](https://gitee.com/go-admin/go-admin/raw/master/data/admin.pgsql) / [mysql](https://gitee.com/go-admin/go-admin/raw/master/data/admin.sql)

### 导入

#### sqlite

直接下载即可。但windows用户需要安装gcc才能使用sqlite golang驱动。

#### mysql 

```bash
mysql -h 127.0.0.1 -P 3306 -u root -p root go_admin < ./admin.sql
```

#### mssql 

```bash
sqlcmd -S 127.0.0.1 -U SA -P 123456 -d go_admin -i ./admin.sql
```

#### postgresql

```bash
PGPASSWORD=root psql -h 127.0.0.1 -p 5432 -d go_admin -U postgres -f ./admin.sql
```

## 安装命令行工具

下载对应系统的二进制文件到本地，并配置到环境变量中。

|  文件名   | 系统  | 架构  | 大小  |
|  ----  | ----  | ----  |----  |
| [adm_darwin_x86_64_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_darwin_x86_64_v1.2.24.zip)  | macOs | x86-64 | 4.77 MB
| [adm_linux_x86_64_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_linux_x86_64_v1.2.24.zip)  | Linux | x86-64   | 6.52 MB
| [adm_linux_armel_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_linux_armel_v1.2.24.zip)  | Linux | x86   | 6.06 MB
| [adm_windows_i386_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_windows_i386_v1.2.24.zip)  | Windows | x86  |6.16 MB
| [adm_windows_x86_64_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_windows_x86_64_v1.2.24.zip)  | Windows | x86-64   |6.38 MB



或使用命令安装：

```bash
$ go install github.com/GoAdminGroup/adm
```

🍺🍺 到这里准备工作完毕~~