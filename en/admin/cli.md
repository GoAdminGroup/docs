# Cli Introduction
---

GoAdmin provides a command line tool to increase development efficiency and streamline the development process.

## Install


Download the binary of the corresponding system:

|  File name   | OS  | Arch  | Size  |
|  ----  | ----  | ----  |----  |
| [adm_darwin_x86_64_v1.2.10.zip](http://file.go-admin.cn/go_admin/cli/v1_2_10/adm_darwin_x86_64_v1.2.10.zip)  | macOs | x86-64 | 4.77 MB
| [adm_linux_x86_64_v1.2.10.zip](http://file.go-admin.cn/go_admin/cli/v1_2_10/adm_linux_x86_64_v1.2.10.zip)  | Linux | x86-64   | 6.52 MB
| [adm_linux_armel_v1.2.10.zip](http://file.go-admin.cn/go_admin/cli/v1_2_10/adm_linux_armel_v1.2.10.zip)  | Linux | x86   | 6.06 MB
| [adm_windows_i386_v1.2.10.zip](http://file.go-admin.cn/go_admin/cli/v1_2_10/adm_windows_i386_v1.2.10.zip)  | Windows | x86  |6.16 MB
| [adm_windows_x86_64_v1.2.10.zip](http://file.go-admin.cn/go_admin/cli/v1_2_10/adm_windows_x86_64_v1.2.10.zip)  | Windows | x86-64   |6.38 MB


Or use the command to install:

```
go install github.com/GoAdminGroup/go-admin/adm
```

## Usage

Use

```
adm --help
```

Will list help information.

|  Command  |  Subcommand   | Options  | Function  | 
|  ---- | ---- | ----  | ----  |
| generate  |  - | - | generate a data model file.
| compile  | asset| **-s, --src** front-end resource folder path<br>**-d, --dist** output go file path | compile all resource files into one single go file.
| compile  | tpl | **-s, --src** the input golang tmpl template folder path<br>**-d, --dist** output go file path<br>**p, --package** output go file package name | compile all template files into one single go file.
| combine  | css| **-s, --src** the input css folder path<br>**-d, --dist** the output css file path<br>**p, --package** output go file package name | combine the css files into one single css file.
| combine  | js | **-s, --src** the input js folder path<br>**-d, --dist** the output js file path | combine the js files into one single js file.
| develop  | tpl | **-m, --module** golang module name or path under $GOPATH<br>**-n, --name** theme name | fetch remotely theme development templates to local.
