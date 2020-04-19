# 命令行工具介绍
---

GoAdmin提供了一个命令行工具，以提高开发效率，简化开发流程。

## 安装


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

## 使用

使用

```
adm --help
```

会列出帮助信息。

|  命令名  |  子命令名   | 选项  | 功能  | 
|  ---- | ---- | ----  | ----  |
| generate  |  - | - | 生成数据模型文件
| compile  | asset| **-s, --src** 输入前端资源文件夹路径<br>**-d, --dist** 输出合并go文件路径<br>**p, --package** 输出go文件包名 | 编译所有资源文件为一个go文件
| compile  | tpl | **-s, --src** 输入golang tmpl模板文件夹路径<br>**-d, --dist** 输出合并模板go文件路径<br>**p, --package** 输出合并模板go文件包名 | 编译所有模板文件为一个go文件
| combine  | css| **-s, --src** 输入css文件夹路径<br>**-d, --dist** 输出合并css文件路径 | 合并css文件为一个css文件
| combine  | js | **-s, --src** 输入js文件夹路径<br>**-d, --dist** 输出合并js文件路径 | 合并js文件为一个js文件
| develop  | tpl | **-m, --module** golang模块名或$GOPATH下的路径<br>**-n, --name** 主题名 | 远程拉取主题开发模板到本地
