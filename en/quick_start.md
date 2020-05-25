# Quick Start
---

GoAdmin makes it easy to use in various web frameworks through various adapters. Currently supported web frameworks are:

- [gin](http://github.com/gin-gonic/gin)
- [beego](https://github.com/astaxie/beego)
- [fasthttp](https://github.com/valyala/fasthttp)
- [buffalo](https://github.com/gobuffalo/buffalo)
- [echo](https://github.com/labstack/echo)
- [gorilla/mux](http://github.com/gorilla/mux)
- [iris](https://github.com/kataras/iris)
- [chi](https://github.com/go-chi/chi)
- [gf](https://github.com/gogf/gf)

<br>

You can choose the framework which your own project is using. If there is no framework you like, please feel free to give us an [issue](https://github.com/GoAdminGroup/go-admin/issues/new?assignees=&labels=&template=proposal.md&title=%5BProposal%5D) or pr!

Let's take the gin framework for example to demonstrate the build process.

## main.go

Firstly, create a new ```main.go``` file in your project folder with the following contents:

```go
package main

import (
	_ "github.com/GoAdminGroup/go-admin/adapter/gin" // Import the adapter, it must be imported. If it is not imported, you need to define it yourself.
	_ "github.com/GoAdminGroup/themes/adminlte" // Import the theme
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql" // Import the sql driver

	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/modules/config"
	"github.com/GoAdminGroup/go-admin/modules/language"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// Instantiate a GoAdmin engine object.
	eng := engine.Default()

	// GoAdmin global configuration, can also be imported as a json file.
	cfg := config.Config{
		Databases: []config.Database{
			{
				Host:         "127.0.0.1",
				Port:         "3306",
				User:         "root",
				Pwd:          "root",
				Name:         "godmin",
				MaxIdleCon:   50,
				MaxOpenCon:   150,
				Driver:       "mysql",
			},
		},
		UrlPrefix: "admin", // The url prefix of the website.
		// Store must be set and guaranteed to have write access, otherwise new administrator users cannot be added.
		Store: config.Store{
			Path:   "./uploads",
			Prefix: "uploads",
		},
		Language: language.EN,
	}

	// Add configuration and plugins, use the Use method to mount to the web framework.
	_ = eng.AddConfig(cfg).
		Use(r)

	_ = r.Run(":9033")
}
```

Please pay attention to the above code and comments, the corresponding steps are added to the comments, it is simple to use. Summary of up to five steps:

- Import the adapter, the theme and the sql driver
- Set global configuration items
- Mounted to the web framework

<br>

Then execute ```go run main.go``` to run the code and access: [http://localhost:9033/admin/login](http://localhost:9033/admin/login) <br>
<br>
default account: admin<br>
default password: admin

more web framework example: [https://github.com/GoAdminGroup/go-admin/tree/master/examples](https://github.com/GoAdminGroup/go-admin/tree/master/examples)

## Add your own business table for management

See:

{% page-ref page="plugins/plugins.md" %}

{% page-ref page="plugins/admin.md" %}

## Global configuration item description

[https://github.com/GoAdminGroup/go-admin/blob/master/modules/config/config.go](https://github.com/GoAdminGroup/go-admin/blob/master/modules/config/config.go)

```go
package config

import (
	"html/template"
)

// Database is a type of database connection config.
// Because a little difference of different database driver.
// The Config has multiple options but may be not used.
// Such as the sqlite driver only use the FILE option which
// can be ignored when the driver is mysql.
//
// If the Dsn is configured, when driver is mysql/postgresql/
// mssql, the other configurations will be ignored, except for
// MaxIdleCon and MaxOpenCon.
type Database struct {
	Host         string
	Port         string
	User         string
	Pwd          string
	Name         string
	MaxIdleCon   int
	MaxOpenCon   int
	Driver       string
	File         string
	Dsn          string
}

// Database configuration
// which is a map where key is the name of the database connection and 
// value is the corresponding data configuration.
// The key is the default database is the default database, but also 
// the database used by the framework, and you can configure multiple 
// databases to be used by your business tables to manage different databases.
type DatabaseList map[string]Database

// Store is the file store config. Path is the local store path.
// and prefix is the url prefix used to visit it.
type Store struct {
	Path   string
	Prefix string
}

// Config type is the global config of goAdmin. It will be
// initialized in the engine.
type Config struct {
	// An map supports multi database connection. The first
	// element of Databases is the default connection. See the
	// file connection.go.
	Databases DatabaseList `json:"database"`

	// The cookie domain used in the auth modules. see
	// the session.go.
	Domain string `json:"domain"`

	// Used to set as the localize language which show in the
	// interface.
	Language string `json:"language"`

	// The global url prefix.
	UrlPrefix string `json:"prefix"`

	// The theme name of template.
	Theme string `json:"theme"`

	// The path where files will be stored into.
	Store Store `json:"store"`

	// The title of web page.
	Title string `json:"title"`

	// Logo is the top text in the sidebar.
	Logo template.HTML `json:"logo"`

	// Mini-logo is the top text in the sidebar when folding.
	MiniLogo template.HTML `json:"mini_logo"`

	// The url redirect to after login
	IndexUrl string `json:"index"`

	// Debug mode
	Debug bool `json:"debug"`

	// Env is the environment, which maybe local, test, prod.
	Env string

	// Info log path
	InfoLogPath string `json:"info_log"`

	// Error log path
	ErrorLogPath string `json:"error_log"`

	// Access log path
	AccessLogPath string `json:"access_log"`

	// Sql operator record log switch
	SqlLog bool `json:"sql_log"`

	AccessLogOff bool
	InfoLogOff   bool
	ErrorLogOff  bool

	// Color scheme
	ColorScheme string `json:"color_scheme"`

	// Session life time, unit is second.
	SessionLifeTime int `json:"session_life_time"`

	// Cdn link of assets
	AssetUrl string `json:"asset_url"`

	// File upload engine, default "local"
	FileUploadEngine FileUploadEngine `json:"file_upload_engine"`

	// Custom html in the tag head.
	CustomHeadHtml template.HTML `json:"custom_head_html"`

	// Custom html after body.
	CustomFootHtml template.HTML `json:"custom_foot_html"`

	// Login page title
	LoginTitle string `json:"login_title"`

	// Login page logo
	LoginLogo template.HTML `json:"login_logo"`

	// Auth user table
	AuthUserTable string `json:"auth_user_table",yaml:"auth_user_table",ini:"auth_user_table"`

	// Extra config info
	Extra ExtraInfo `json:"extra",yaml:"extra",ini:"extra"`

	// Page animation
	Animation PageAnimation `json:"animation",yaml:"animation",ini:"animation"`

	// Limit login with different IPs
	NoLimitLoginIP bool `json:"no_limit_login_ip",yaml:"no_limit_login_ip",ini:"no_limit_login_ip"`

	// When site off is true, website will be closed
	SiteOff bool `json:"site_off",yaml:"site_off",ini:"site_off"`

	// Hide config center entrance flag
	HideConfigCenterEntrance bool `json:"hide_config_center_entrance",yaml:"hide_config_center_entrance",ini:"hide_config_center_entrance"`

	// Hide app info entrance flag
	HideAppInfoEntrance bool `json:"hide_app_info_entrance",yaml:"hide_app_info_entrance",ini:"hide_app_info_entrance"`

	// Update Process Function
	UpdateProcessFn UpdateConfigProcessFn `json:"-",yaml:"-",ini:"-"`

	// Is open admin plugin json api
	OpenAdminApi bool `json:"open_admin_api",yaml:"open_admin_api",ini:"open_admin_api"`

	HideVisitorUserCenterEntrance bool `json:"hide_visitor_user_center_entrance",yaml:"hide_visitor_user_center_entrance",ini:"hide_visitor_user_center_entrance"`

	// Custom 404 Page
	Custom404HTML template.HTML `json:"custom_404_html,omitempty",yaml:"custom_404_html",ini:"custom_404_html"`

	// Custom 403 Page
	Custom403HTML template.HTML `json:"custom_403_html,omitempty",yaml:"custom_403_html",ini:"custom_403_html"`

	// Custom 500 Page
	Custom500HTML template.HTML `json:"custom_500_html,omitempty",yaml:"custom_500_html",ini:"custom_500_html"`
}

```

<br>

Logger configuration:

```golang

type Logger struct {
	Encoder EncoderCfg `json:"encoder",yaml:"encoder",ini:"encoder"`
	Rotate  RotateCfg  `json:"rotate",yaml:"rotate",ini:"rotate"`
	Level   int8       `json:"level",yaml:"level",ini:"level"`
}

// Logger encode configuration
type EncoderCfg struct {
	// TimeKey, default is ts
	TimeKey       string `json:"time_key",yaml:"time_key",ini:"time_key"`
	// LevelKey, default is level
	LevelKey      string `json:"level_key",yaml:"level_key",ini:"level_key"`
	// LevelKey, default is logger
	NameKey       string `json:"name_key",yaml:"name_key",ini:"name_key"`
	// CallerKey caller
	CallerKey     string `json:"caller_key",yaml:"caller_key",ini:"caller_key"`
	// MessageKey, default is msg
	MessageKey    string `json:"message_key",yaml:"message_key",ini:"message_key"`
	// StacktraceKey, default is stacktrace
	StacktraceKey string `json:"stacktrace_key",yaml:"stacktrace_key",ini:"stacktrace_key"`
	// Level Encoder, default is CapticalColor
	Level         string `json:"level",yaml:"level",ini:"level"`
	// Time Encoder, default is ISO8601
	Time          string `json:"time",yaml:"time",ini:"time"`
	// Duration Encoder, default is seconds
	Duration      string `json:"duration",yaml:"duration",ini:"duration"`
	// Caller Encoder, default is short
	Caller        string `json:"caller",yaml:"caller",ini:"caller"`
	// Encoding Format, default is console
	Encoding      string `json:"encoding",yaml:"encoding",ini:"encoding"`
}

// Logger rotate configuration
type RotateCfg struct {
	// Max file size, unit is m, default is 10m
	MaxSize    int  `json:"max_size",yaml:"max_size",ini:"max_size"`
	// Max file backups, default is 5
	MaxBackups int  `json:"max_backups",yaml:"max_backups",ini:"max_backups"`
	// Max store age, unit is day, default is 30 day
	MaxAge     int  `json:"max_age",yaml:"max_age",ini:"max_age"`
	// Is compress or not, defaul is false
	Compress   bool `json:"compress",yaml:"compress",ini:"compress"`
}

```

> English is not my main language. If any typo or wrong translation you found, you can help to translate in [github here](https://github.com/GoAdminGroup/docs). I will very appreciate it.