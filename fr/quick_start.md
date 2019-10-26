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

<br>

You can choose the framework you are using or the business project is using. If there is no framework you like, please feel free to give us an issue or pr!

Let's take the gin framework as an example to demonstrate the build process.

## main.go

Create a new ```main.go``` file in your project folder with the following contents:

```go
package main

import (
	_ "github.com/GoAdminGroup/go-admin/adapter/gin" // Import the adapter, it must be imported. If it is not imported, you need to define it yourself.
	_ "github.com/GoAdminGroup/themes/adminlte" // Import the theme
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql"
	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/examples/datamodel"
	"github.com/GoAdminGroup/go-admin/modules/config"
	"github.com/GoAdminGroup/go-admin/modules/language"
	"github.com/GoAdminGroup/go-admin/plugins/admin"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// Instantiate a go-admin engine object.
	eng := engine.Default()

	// go-admin global configuration, can also be written as a json, imported by json.
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

	// Import the business table configuration you need to manage here.
	// About Generators，see: https://github.com/GoAdminGroup/go-admin/blob/master/examples/datamodel/tables.go
	adminPlugin := admin.NewAdmin(datamodel.Generators)

	// Add configuration and plugins, use the Use method to mount to the web framework.
	_ = eng.AddConfig(cfg).AddPlugins(adminPlugin).Use(r)

	_ = r.Run(":9033")
}
```

Please pay attention to the above code and comments, the corresponding steps are added to the comments, it is simple to use, the following steps:

- Introducing an adapter
- Set global configuration items
- Initialize the plugin
- Set up plugins and configurations
- Mounted to the web framework

<br>

Then execute ```go run main.go``` to run the code and access: [http://localhost:9033/admin/login](http://localhost:9033/admin/login) <br>
<br>
default account: admin<br>
default password: admin

more web framework example: [https://github.com/GoAdminGroup/go-admin/tree/master/examples](https://github.com/GoAdminGroup/go-admin/tree/master/examples)

## Add your own business table for management

See：<br><br>
1 [How To Use Plugins](plugins/plugins)<br>
2 [How To Use Admin Plugin](plugins/admin)

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
}

```

<br>

> English is not my main language. If any typo or wrong translation you found, you can help to translate in [github here](https://github.com/GoAdminGroup/docs). I will very appreciate it.