# How To Use Admin Plugin
---

The Admin plugin can help you to quickly generate a database data table for adding, deleting, and changing database data tables.

## Quick Start

Following the steps:

- Generate a configuration file corresponding to the data table
- Set access routing
- Initialize and load in the engine
- Set access menu

### Generate configuration file

Suppose you have a data table users in your database, such as:

```sql
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` tinyint(4) DEFAULT NULL,
  `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

Use the command line tools - admincli to help you quickly generate configuration files:

- install

```bash
go install github.com/GoAdminGroup/go-admin/admincli
```

- generate

<br>
Execute in the project folder

```bash
admincli generate
```

Fill in the information according to the prompts. After the run, a file ```users.go``` will be generated. This is the configuration file corresponding to the data table. How to configure it is described in detail later.

### Set access url

After the configuration file is generated, a routing configuration file ```tables.go``` will also be generated :

```go
package main

import "github.com/GoAdminGroup/go-admin/plugins/admin/models"

// The key of Generators is the prefix of table info url.
// The corresponding value is the Form and Table data.
//
// http://{{config.DOMAIN}}:{{PORT}}/{{config.PREFIX}}/info/{{key}}
//
// example:
//
// "user"   => http://localhost:9033/admin/info/user
//
var Generators = map[string]models.TableGenerator{
	"user":    GetUserTable,
}
```

```"user"``` is the corresponding access route prefix, ```GetUserTable``` is the table data generation method.
The corresponding access routing address is: http://localhost:9033/admin/info/users

### Initialize and load in the engine

To initialize, you need to call the ```NewAdmin``` method, and then pass the ```Generators``` above. Then call the engine's ```AddPlugins``` method to load the engine.

```go
package main

import (
	"github.com/gin-gonic/gin"
	_ "github.com/GoAdminGroup/go-admin/adapter/gin"
	_ "github.com/GoAdminGroup/themes/adminlte"
	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/plugins/admin"
	"github.com/GoAdminGroup/go-admin/modules/config"
	"github.com/GoAdminGroup/go-admin/modules/language"
)

func main() {
	r := gin.Default()
	eng := engine.Default()
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
		UrlPrefix: "admin",
		Store: config.Store{
			Path:   "./uploads",
			Prefix: "uploads",
		},
		Language: language.CN,
	}

	adminPlugin := admin.NewAdmin(Generators)

	// AddGenerator can also be used to load the Generator, like:
	// adminPlugin.AddGenerator("user", GetUserTable)
	
	eng.AddConfig(cfg).
		AddPlugins(adminPlugin).  // 加载插件
		Use(r)

	r.Run(":9033")
}
```

### Set access menu

After running, access the login URL, enter the menu management page, and set the management menu of the data table to enter in the sidebar.

> PS:
>
> In the above example, the login URL is http://localhost:9033/admin/login
>
> The menu management page is http://localhost:9033/admin/menu

## Introduction to the business data table generation method file

```go
package datamodel

import (
	"fmt"
	"github.com/GoAdminGroup/go-admin/modules/db"
	form2 "github.com/GoAdminGroup/go-admin/plugins/admin/modules/form"
	"github.com/GoAdminGroup/go-admin/plugins/admin/modules/table"
	"github.com/GoAdminGroup/go-admin/template/types"
	"github.com/GoAdminGroup/go-admin/template/types/form"
)

func GetUserTable() (userTable table.Table) {

	// config the table model.
	userTable = table.NewDefaultTable(table.Config{
		Driver:     db.DriverMysql,
		CanAdd:     true,
		Editable:   true,
		Deletable:  true,
		Exportable: true,
		Connection: table.DefaultConnectionName,
		PrimaryKey: table.PrimaryKey{
			Type: db.Int,
			Name: table.DefaultPrimaryKeyName,
		},
	})

	info := userTable.GetInfo()

	// set id sortable.
	info.AddField("ID", "id", db.Int).FieldSortable(true)
	info.AddField("Name", "name", db.Varchar)

	// use FieldDisplay.
	info.AddField("Gender", "gender", db.Tinyint).FieldDisplay(func(model types.FieldModel) interface{} {
		if model.Value == "0" {
			return "men"
		}
		if model.Value == "1" {
			return "women"
		}
		return "unknown"
	})
	
	info.AddField("Phone", "phone", db.Varchar)
	info.AddField("City", "city", db.Varchar)
	info.AddField("CreatedAt", "created_at", db.Timestamp)
	info.AddField("UpdatedAt", "updated_at", db.Timestamp)

	// set the title and description of table page.
	info.SetTable("users").SetTitle("Users").SetDescription("Users").
		SetAction(template.HTML(`<a href="http://google.com"><i class="fa fa-google"></i></a>`))  // custom operation button

	formList := userTable.GetForm()

	// set id editable is false.
	formList.AddField("ID", "id", db.Int, form.Default).FieldEditable(false)
	formList.AddField("Ip", "ip", db.Varchar, form.Text)
	formList.AddField("Name", "name", db.Varchar, form.Text)

	// use FieldOptions.
	formList.AddField("Gender", "gender", db.Tinyint, form.Radio).
		FieldOptions([]map[string]string{
			{
				"field":    "gender",
				"label":    "male",
				"value":    "0",
				"selected": "true",
			}, {
				"field":    "gender",
				"label":    "female",
				"value":    "1",
				"selected": "false",
			},
		})
	formList.AddField("Phone", "phone", db.Varchar, form.Text)
	formList.AddField("City", "city", db.Varchar, form.Text)

	// add a custom field and use FieldPostFilterFn to do more things.
	formList.AddField("Custom Field", "role", db.Varchar, form.Text).
		FieldPostFilterFn(func(value types.PostFieldModel) string {
			fmt.Println("user custom field", value)
			return ""
		})

	formList.AddField("UpdatedAt", "updated_at", db.Timestamp, form.Default).FieldNotAllowAdd(true)
	formList.AddField("CreatedAt", "created_at", db.Timestamp, form.Default).FieldNotAllowAdd(true)

	// use SetTabGroups to group a form into tabs.
	formList.SetTabGroups(types.
		NewTabGroups("id", "ip", "name", "gender", "city").
		AddGroup("phone", "role", "created_at", "updated_at")).
		SetTabHeaders("profile1", "profile2")

	// set the title and description of form page.
	formList.SetTable("users").SetTitle("Users").SetDescription("Users")

	// use SetPostHook to add operation when form posted.
	formList.SetPostHook(func(values form2.Values) {
		fmt.Println("userTable.GetForm().PostHook", values)
	})

	return
}
```

Initialize by calling ```models.NewDefaultTable(models.DefaultTableConfig)``` method to pass <strong>data table model configuration</strong>. The data table model is configured as:

```go
type Config struct {
	Driver      string // database driver
	Connection  string // database connection name, defined in the global configuration
	CanAdd      bool   // Can I add data
	Editable    bool   // Can I edit
	Deletable   bool   // Can I delete it
	Exportable  bool   // Whether it can be exported
	PrimaryKey  PrimaryKey // primary key of the data table
}

type PrimaryKey struct {
	Type db.DatabaseType  // primary key type
	Name string           // primary key name
}
```

The business data table generation method is a function that returns a type object of ```models.Table```. The following is the definition of ```models.Table```:

```go
type Table interface {
	GetInfo() *types.InfoPanel
	GetForm() *types.FormPanel
	GetCanAdd() bool
	GetEditable() bool
	GetDeletable() bool
	GetFiltersMap() []map[string]string
	GetDataFromDatabase(path string, params *Parameters) PanelInfo
	GetDataFromDatabaseWithId(id string) ([]types.Form, string, string)
	UpdateDataFromDatabase(dataList map[string][]string)
	InsertDataFromDatabase(dataList map[string][]string)
	DeleteDataFromDatabase(id string)
}
```

It mainly includes ```GetInfo()``` and ```GetForm()```. The ui corresponding to the type returned by these two functions is the table for displaying data and the form for editing new data. The screenshots are as follows:

- This is the ```Info```.

<br>

![](http://quizfile.dadadaa.cn/everyday/app/jlds/img/006tNbRwly1fxoy26qnc5j31y60u0q91.jpg)

- This is the ```Form```.

<br>

![](http://quizfile.dadadaa.cn/everyday/app/jlds/img/006tNbRwly1fxoy2w3cobj318k0ooabv.jpg)

### Info

```go
type InfoPanel struct {
	FieldList         []Field
	curFieldListIndex int

	Table       string
	Title       string
	Description string

	// Warn: may be deprecated future.
	TabGroups  TabGroups      // tabs contents
	TabHeaders TabHeadersq	  // tabs headers

	Sort Sort

	Action     template.HTML
	HeaderHtml template.HTML
	FooterHtml template.HTML
}

type Field struct {
	FilterFn   FieldFilterFn     // filter function
	Field      string            // field name
	TypeName   db.DatabaseType   // field type
	Head       string            // title
	Width      int               // width, unit is px
	Join       Join              // join table setting
	Sortable   bool              // can be sorted or not
	Filterable bool              // can be filtered or not
	Hide       bool              // hide or not
}

// Field is the table field.
type Field struct {
	Head     string				// title
	Field    string				// field name
	TypeName db.DatabaseType	// field type

	Join Join // join table setting

	Width      int   // width, unit is px
	Sortable   bool	 // can be sorted or not
	Fixed      bool  // can be sorted or not
	Filterable bool  // can be filtered or not
	Hide       bool  // hide or not

	Display              FieldFilterFn           // field display filter function
	DisplayProcessChains DisplayProcessFnChains  // field value process function list
}


// join table setting
// example: left join Table on Table.JoinField = Field
type Join struct {
	Table     string
	Field     string
	JoinField string
}
```

### Form

```go
type FormPanel struct {
	FieldList         FormFields  // form field list
	curFieldListIndex int

	// Warn: may be deprecated future.
	TabGroups  TabGroups    // tabs, [example](https://github.com/GoAdminGroup/go-admin/blob/master/examples/datamodel/user.go#L76)
	TabHeaders TabHeaders   // tabs headers, [example](https://github.com/GoAdminGroup/go-admin/blob/master/examples/datamodel/user.go#L78)

	Table       string
	Title       string
	Description string

	Validator FormValidator   // form post validator function
	PostHook  FormPostHookFn  // form post hook function

	HeaderHtml template.HTML  // header custom html content
	FooterHtml template.HTML  // footer custom html content
}

// form validator function type
type PostValidator func(values form.Values) error

// form hook function type
type PostHookFn func(values form.Values)

type FormField struct {
	Field    string
	TypeName db.DatabaseType
	Head     string
	FormType form.Type

	Default                string
	Value                  string
	Options                []map[string]string
	DefaultOptionDelimiter string

	Editable    bool
	NotAllowAdd bool
	Must        bool

	Display              FieldFilterFn           // field display filter function
	DisplayProcessChains DisplayProcessFnChains  // field value process function list
	PostFilterFn PostFieldFilterFn
}
```

The currently supported form types are:

- default
- normal text
- Single selection
- Password
- rich text
- File
- double selection box
- Multiple choices
- icon drop-down selection box
- time selection box
- radio selection box
- email input box
- url input box
- ip input box
- color selection box
- Currency input box
- Digital input box

</br>

Can be used like this:

```

import "github.com/GoAdminGroup/go-admin/template/types/form"

...
FormType: form.File,
...

```

For the selection type: single selection, multiple selection, selection box, you need to specify the Options value. The format is:

```
...
Options: []map[string]string{
	{
        "field": "name",
        "value": "joe",
    },{
        "field": "name",
        "value": "jane",
    },
}
...
```

Where field is the name of the field and value is the value corresponding to the selection.

### Filter function FilterFn and processing function PostFn description

```go
// FieldModel contains ID and value of the single query result.
type FieldModel struct {
	ID    string
	Value string
}

// FieldFilterFn determines the value that is retrieved from the database 
// and passes to the format displayed by the front end.
//
// The type currently accepted for return is: template.HTML, string, []string
//
// For tables, you can return the template.HTML type, including html and css 
// styles, so that the fields in the table can be personalized, such as:
// 
// FilterFn: func(model types.FieldModel) interface{} {
// 	return template.Get("adminlte").Label().SetContent(template2.HTML(model.Value)).GetContent()
// },
//
// For forms, note that if it is a select box type: Select/SelectSingle/SelectBox, 
// you need to return an array: []string, such as:
//
// FilterFn: func(model types.FieldModel) interface{} {
// 	return strings.Split(model.Value, ",")
// },
// 
// For other form types, return the string type
//
type FieldFilterFn func(value FieldModel) interface{}

// PostFieldModel contains ID and value of the single query result.
type PostFieldModel struct {
	ID    string
	Value FieldModelValue
	Row   map[string]interface{}
}

type FieldModelValue []string

// PostFieldFilterFn is used to process the form data when submitting the form. 
// The form data is passed over, processed by the form submission filter 
// function and then stored in the database.
//
// If it is for the select type: Select/SelectSingle/SelectBox，you need to 
// convert the array type to a string type, such as:
//
// PostFilterFn: func(model types.PostFieldModel) string {
// 	return strings.Join(model.Value, ",")
// },
//
// Also it can be used for the processing of non-form fields, which can be used to update 
// or insert data with tables.
//
// Custom fields, such as the role of the user table, need to be updated. 
// Here, the table update can be performed based on the passed primary key 
// ID and the form data Value. Such as:
// 
// PostFilterFn: func(model types.PostFieldModel) {
//   db.Table("role").Insert(dialect.H{
//	  	"user_id": model.ID,  
//	  	"role_id": model.Value.Value(),
//   })
// },
//
type PostFieldFilterFn func(value PostFieldModel) string

<br>

> English is not my main language. If any typo or wrong translation you found, you can help to translate in [github here](https://github.com/GoAdminGroup/docs). I will very appreciate it.

