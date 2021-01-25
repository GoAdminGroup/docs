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

首先新建一个项目文件夹，然后进入文件夹中使用最新版命令行工具 adm 执行：

```
adm init -l cn
```

根据指示填写就可以初始化一个项目模板。

或者使用版本高于 **v1.2.19** 的adm，执行以下命令可以进行基于web的可视化安装：

```
adm init web -l cn
```

## main.go

初始化完成后，在你的项目文件夹下有一个```main.go```文件，内容如下：

```go
package main

import (
	"io/ioutil"
	"log"
	"os"
	"os/signal"

	_ "github.com/GoAdminGroup/go-admin/adapter/gin" // 引入适配器，必须引入，如若不引入，则需要自己定义
	_ "github.com/GoAdminGroup/themes/adminlte" // 引入主题，必须引入，不然报错
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql" // 引入对应数据库引擎

	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/template"
	"github.com/GoAdminGroup/go-admin/template/chartjs"
	"github.com/gin-gonic/gin"

	"xxx/pages"
	"xxx/tables"
)

func main() {
	startServer()
}

func startServer() {
	gin.SetMode(gin.ReleaseMode)
	gin.DefaultWriter = ioutil.Discard

	r := gin.Default()

	template.AddComp(chartjs.NewChart())

	// 实例化一个GoAdmin引擎对象
	eng := engine.Default()

	// 增加配置与插件，使用Use方法挂载到Web框架中
	if err := eng.AddConfigFromJSON("./config.json").
		// 这里引入你需要管理的业务表配置
		// 后面会介绍如何使用命令行根据你自己的业务表生成Generators
		AddGenerators(tables.Generators).
		Use(r); err != nil {
		panic(err)
	}

	r.Static("/uploads", "./uploads")

	eng.HTML("GET", "/admin", pages.GetDashBoard)
	eng.HTMLFile("GET", "/admin/hello", "./html/hello.tmpl", map[string]interface{}{
		"msg": "Hello world",
	})

	_ = r.Run(":9033")

	quit := make(chan os.Signal)
	signal.Notify(quit, os.Interrupt)
	<-quit
	log.Print("closing database connection")
	eng.MysqlConnection().Close()
}
```

请<b>留意以上代码与注释</b>，对应的步骤都加上了注释，十分好理解：

- 匿名引入<b>适配器</b>，<b>主题</b>与<b>数据库驱动</b>（必须）
- 载入设置好的全局配置项：```eng.AddConfig```
- 挂载到Web框架中：```eng.Use```

接着根据提示依次执行：
(以下为mac/linux用户执行命令，windows用户需根据提示执行)

```
make init module=xxx
GORPOXY=https://goproxy.io make install
make serve
```

运行代码，访问：[http://localhost:9033/admin/login](http://localhost:9033/admin/login) <br>
<br>
默认登录账号：admin<br>
默认登录密码：admin

注意：golang版本高于1.11强烈建议开启```GO111MODULE=on```，如果运行下载依赖有问题，这里提供了依赖包下载：

- [vendor_v1.2.19.zip](http://file.go-admin.cn/go_admin/vendor/v1_2_19/vendor.zip)

## 添加自己的业务表进行管理

详见：

{% page-ref page="plugins/plugins.md" %}

{% page-ref page="plugins/admin.md" %}

- [插件介绍](plugins/plugins.md)
- [内置admin插件](plugins/admin.md)

## 全局配置项说明

[https://github.com/GoAdminGroup/go-admin/blob/master/modules/config/config.go](https://github.com/GoAdminGroup/go-admin/blob/master/modules/config/config.go)


<strong>注意：配置一旦初始化生成后，后续修改请在网站右上角中进入配置中心修改！</strong><br>
<strong>注意：配置一旦初始化生成后，后续修改请在网站右上角中进入配置中心修改！</strong><br>
<strong>注意：配置一旦初始化生成后，后续修改请在网站右上角中进入配置中心修改！</strong>

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
	DSN          string  // DSN语句：如果设置了DSN语句，则优先使用DSN进行连接
	Params       map[string]string  // DSN的额外参数
}

// 数据库配置
// 为一个map，其中key为数据库连接的名字，value为对应的数据配置
// 注意：key为default的数据库是默认数据库，也是框架所用的数据库，而你可以
// 配置多个数据库，提供给你的业务表使用，实现对不同数据库的管理。
type DatabaseList map[string]Database

// 存储目录：存储头像等上传文件
type Store struct {
	Path   string // 存储路径
	Prefix string // url访问前缀
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

	// 自定义登录路由地址
	LoginUrl string `json:"login_url",yaml:"login_url",ini:"login_url"`

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

	// 日志配置
	Logger Logger `json:"logger",yaml:"logger",ini:"logger"`

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

	// 自定义认证用户的数据表
	AuthUserTable string `json:"auth_user_table",yaml:"auth_user_table",ini:"auth_user_table"`

	// 额外
	Extra ExtraInfo `json:"extra",yaml:"extra",ini:"extra"`

	// 页面动画
	Animation PageAnimation `json:"animation",yaml:"animation",ini:"animation"`

	// 是否不限制不同IP登录，默认限制
	NoLimitLoginIP bool `json:"no_limit_login_ip",yaml:"no_limit_login_ip",ini:"no_limit_login_ip"`

	// 网站开关
	SiteOff bool `json:"site_off",yaml:"site_off",ini:"site_off"`

	// 是否隐藏配置中心入口，默认显示
	HideConfigCenterEntrance bool `json:"hide_config_center_entrance",yaml:"hide_config_center_entrance",ini:"hide_config_center_entrance"`

	// 是否隐藏应用信息入口，默认显示
	HideAppInfoEntrance bool `json:"hide_app_info_entrance",yaml:"hide_app_info_entrance",ini:"hide_app_info_entrance"`

	// 隐藏模块列表入口，默认显示
	HidePluginEntrance bool `json:"hide_plugin_entrance,omitempty" yaml:"hide_plugin_entrance,omitempty" ini:"hide_plugin_entrance,omitempty"`

	// 自定义404页面
	Custom404HTML template.HTML `json:"custom_404_html,omitempty",yaml:"custom_404_html",ini:"custom_404_html"`

	// 自定义403页面
	Custom403HTML template.HTML `json:"custom_403_html,omitempty",yaml:"custom_403_html",ini:"custom_403_html"`

	// 自定义500页面
	Custom500HTML template.HTML `json:"custom_500_html,omitempty",yaml:"custom_500_html",ini:"custom_500_html"`

	// 配置更新处理函数
	UpdateProcessFn UpdateConfigProcessFn `json:"-",yaml:"-",ini:"-"`

	// 是否开放admin的json apis，默认关闭
	OpenAdminApi bool `json:"open_admin_api",yaml:"open_admin_api",ini:"open_admin_api"`

	// 隐藏访客用户设置菜单
	HideVisitorUserCenterEntrance bool `json:"hide_visitor_user_center_entrance",yaml:"hide_visitor_user_center_entrance",ini:"hide_visitor_user_center_entrance"`

	// 需要排除的主题模块
	ExcludeThemeComponents []string `json:"exclude_theme_components,omitempty" yaml:"exclude_theme_components,omitempty" ini:"exclude_theme_components,omitempty"`

	// 引导文件路径
	BootstrapFilePath string `json:"bootstrap_file_path,omitempty" yaml:"bootstrap_file_path,omitempty" ini:"bootstrap_file_path,omitempty"`

	// go mod文件路径
	GoModFilePath string `json:"go_mod_file_path,omitempty" yaml:"go_mod_file_path,omitempty" ini:"go_mod_file_path,omitempty"`
}

```

日志设置：

```golang

type Logger struct {
	// 编码设置
	Encoder EncoderCfg `json:"encoder",yaml:"encoder",ini:"encoder"`
	// 分割设置
	Rotate  RotateCfg  `json:"rotate",yaml:"rotate",ini:"rotate"`
	// 日志级别
	Level   int8       `json:"level",yaml:"level",ini:"level"`
}

// 日志输出内容编码设置
type EncoderCfg struct {
	// 时间键内容，默认为 ts
	TimeKey       string `json:"time_key",yaml:"time_key",ini:"time_key"`
	// 级别键内容，默认为 level
	LevelKey      string `json:"level_key",yaml:"level_key",ini:"level_key"`
	// 名字键内容，默认为 logger
	NameKey       string `json:"name_key",yaml:"name_key",ini:"name_key"`
	// 调用者键内容，默认为 caller
	CallerKey     string `json:"caller_key",yaml:"caller_key",ini:"caller_key"`
	// 消息键内容，默认为 msg
	MessageKey    string `json:"message_key",yaml:"message_key",ini:"message_key"`
	// 栈键内容，默认为 stacktrace
	StacktraceKey string `json:"stacktrace_key",yaml:"stacktrace_key",ini:"stacktrace_key"`
	// 级别编码器，默认为 大写带颜色
	Level         string `json:"level",yaml:"level",ini:"level"`
	// 时间编码器，默认为 ISO8601
	Time          string `json:"time",yaml:"time",ini:"time"`
	// 间隔时间编码器，默认为 秒
	Duration      string `json:"duration",yaml:"duration",ini:"duration"`
	// 调用者编码器，默认为 简短路径
	Caller        string `json:"caller",yaml:"caller",ini:"caller"`
	// 输出格式，默认console
	Encoding      string `json:"encoding",yaml:"encoding",ini:"encoding"`
}

// 日志分割设置
type RotateCfg struct {
	// 文件最大大小，单位为m，默认为 10m
	MaxSize    int  `json:"max_size",yaml:"max_size",ini:"max_size"`
	// 最多文件数，默认为 5个
	MaxBackups int  `json:"max_backups",yaml:"max_backups",ini:"max_backups"`
	// 存储最长时间，单位为天，默认为 30天
	MaxAge     int  `json:"max_age",yaml:"max_age",ini:"max_age"`
	// 是否压缩，默认为 不开启
	Compress   bool `json:"compress",yaml:"compress",ini:"compress"`
}

```