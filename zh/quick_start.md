# 快速开始
---

GoAdmin通过各种适配器使得你在各个web框架中使用都十分的方便。目前支持的web框架有：

- [gin](http://github.com/gin-gonic/gin)
- [beego](https://github.com/astaxie/beego)
- [fasthttp](https://github.com/valyala/fasthttp)
- [buffalo](https://github.com/gobuffalo/buffalo)
- [echo](https://github.com/labstack/echo)
- [gorilla/mux](http://github.com/gorilla/mux)
- [iris](https://github.com/kataras/iris)
- [chi](https://github.com/go-chi/chi)
- [gf](https://github.com/gogf/gf)

你可以选择你拿手的或者业务项目正在用的框架开始，如果上述没有你喜欢的框架，欢迎给我们提[issue](https://github.com/GoAdminGroup/go-admin/issues/new?assignees=&labels=&template=proposal.md&title=%5BProposal%5D)！

下面以gin这个框架为例子，演示搭建过程。

## main.go

在你的项目文件夹下新建一个```main.go```文件，内容如下：

```go
package main

import (
	_ "github.com/GoAdminGroup/go-admin/adapter/gin" // 引入适配器，必须引入，如若不引入，则需要自己定义
	_ "github.com/GoAdminGroup/themes/adminlte" // 引入主题，必须引入，不然报错
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql" // 引入对应数据库引擎

	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/examples/datamodel"
	"github.com/GoAdminGroup/go-admin/modules/config"
	"github.com/GoAdminGroup/go-admin/modules/language"
	"github.com/GoAdminGroup/go-admin/plugins/admin"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// 实例化一个GoAdmin引擎对象
	eng := engine.Default()

	// GoAdmin全局配置，也可以写成一个json，通过json引入
	cfg := config.Config{
		Databases: config.DatabaseList{
			"default": {
				Host:       "127.0.0.1",
				Port:       "3306",
				User:       "root",
				Pwd:        "root",
				Name:       "godmin",
				MaxIdleCon: 50,
				MaxOpenCon: 150,
				Driver:     config.DriverMysql,
			},
		},
		UrlPrefix: "admin", // 访问网站的前缀
		// Store 必须设置且保证有写权限，否则增加不了新的管理员用户
		Store: config.Store{
			Path:   "./uploads",
			Prefix: "uploads",
		},
		Language: language.CN,
	}

	// 这里引入你需要管理的业务表配置
	// 关于Generators，详见 https://github.com/GoAdminGroup/go-admin/blob/master/examples/datamodel/tables.go
	adminPlugin := admin.NewAdmin(datamodel.Generators)

	// 增加配置与插件，使用Use方法挂载到Web框架中
	_ = eng.AddConfig(cfg).AddPlugins(adminPlugin).Use(r)

	_ = r.Run(":9033")
}
```

请<b>留意以上代码与注释</b>，对应的步骤都加上了注释，使用十分简单，只需要：

- 引入<b>适配器</b>，<b>主题</b>与<b>数据库驱动</b>（必须）
- 设置全局的配置项
- 初始化插件
- 设置插件与配置
- 挂载到Web框架中

接着执行```go run main.go```运行代码，访问：[http://localhost:9033/admin/login](http://localhost:9033/admin/login) <br>
<br>
默认登录账号：admin<br>
默认登录密码：admin

注意：golang版本高于1.11强烈建议开启```GO111MODULE=on```，如果运行下载依赖有问题，这里提供了依赖包下载：

- [vendor_v1.2.0.zip](http://file.go-admin.cn/go_admin/vendor/v1_2_0/vendor.zip)

其他框架的例子可以参考：[https://github.com/GoAdminGroup/go-admin/tree/master/examples](https://github.com/GoAdminGroup/go-admin/tree/master/examples)

## 添加自己的业务表进行管理

详见：

{% page-ref page="plugins/plugins.md" %}

{% page-ref page="plugins/admin.md" %}

## 全局配置项说明

[https://github.com/GoAdminGroup/go-admin/blob/master/modules/config/config.go](https://github.com/GoAdminGroup/go-admin/blob/master/modules/config/config.go)

```go
package config

import (
	"html/template"
)

type Database struct {
	Host         string  // 地址
	Port         string  // 端口
	User         string  // 用户名
	Pwd          string  // 密码
	Name         string  // 数据库名
	MaxIdleCon   int     // 最大闲置连接数
	MaxOpenCon   int     // 最大打开连接数
	Driver       string  // 驱动名
	File         string  // 文件名
}

// 数据库配置
// 为一个map，其中key为数据库连接的名字，value为对应的数据配置
// 注意：key为default的数据库是默认数据库，也是框架所用的数据库，而你可以
// 配置多个数据库，提供给你的业务表使用，实现对不同数据库的管理。
type DatabaseList map[string]Database

// 存储目录：存储头像等上传文件
type Store struct {
	Path   string
	Prefix string
}

type Config struct {
	// 数据库配置
	Databases DatabaseList `json:"database"`

	// 登录域名
	Domain string `json:"domain"`

	// 网站语言
	Language string `json:"language"`

	// 全局的管理前缀
	UrlPrefix string `json:"prefix"`

	// 主题名
	Theme string `json:"theme"`

	// 上传文件存储的位置
	Store Store `json:"store"`

	// 网站的标题
	Title string `json:"title"`

	// 侧边栏上的Logo
	Logo template.HTML `json:"logo"`

	// 侧边栏上的Logo缩小版
	MiniLogo template.HTML `json:"mini_logo"`

	// 登录后跳转的路由
	IndexUrl string `json:"index"`

	// 是否开始debug模式
	Debug bool `json:"debug"`

	// Info日志路径
	InfoLogPath string `json:"info_log"`

	// Error log日志路径
	ErrorLogPath string `json:"error_log"`

	// Access log日志路径
	AccessLogPath string `json:"access_log"`

	// 是否开始数据库Sql操作日志
	SqlLog bool `json:"sql_log"`

	// 是否关闭access日志
	AccessLogOff bool `json:"access_log_off"`
	// 是否关闭info日志
	InfoLogOff   bool `json:"info_log_off"`
	// 是否关闭error日志
	ErrorLogOff  bool `json:"error_log_off"`

	// 网站颜色主题
	ColorScheme string `json:"color_scheme"`

	// Session的有效时间，单位为秒
	SessionLifeTime int `json:"session_life_time"`
	
	// Cdn链接，为全局js/css配置cdn链接
	AssetUrl string `json:"asset_url"`

	// 文件上传引擎
	FileUploadEngine FileUploadEngine `json:"file_upload_engine"`

	// 自定义头部js/css
	CustomHeadHtml template.HTML `json:"custom_head_html"`

	// 自定义尾部js/css
	CustomFootHtml template.HTML `json:"custom_foot_html"`

	// 登录页面标题
	LoginTitle string `json:"login_title"`

	// 登录页面logo
	LoginLogo template.HTML `json:"login_logo"`
}

```
