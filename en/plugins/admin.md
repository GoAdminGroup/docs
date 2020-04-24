# How To Use Admin Plugin
---

The Admin plugin can help you to quickly generate a platform for database data table query, adding, deleting, and editing.

## Quick Start

Following the steps:

- Generate a configuration file corresponding to the data table
- Set access routing
- Initialize and load in the engine
- Set access menu

### Step 1. Generate configuration file

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

Use the command line tools - ```adm``` to help you quickly generate configuration files:

- install adm

```bash
go install github.com/GoAdminGroup/go-admin/adm
```

- generate

<br>
Execute the command in your project folder

```bash
adm generate
```

**Notice: use space to choose table, not enter**

Fill in the information according to the prompts. After the run, a file ```users.go``` will be generated. This is the configuration file corresponding to the data table. How to configure it is described in detail later.

### Step 2. Set access url

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
The corresponding access routing address is: http://localhost:9033/admin/info/user

### Step 3. Initialize and load in the engine

To initialize, you need to call the ```eng.AddGenerators``` method, and then pass the ```Generators``` above.

```go
package main

import (
	_ "github.com/GoAdminGroup/go-admin/adapter/gin" // Import the adapter, it must be imported. If it is not imported, you need to define it yourself.
	_ "github.com/GoAdminGroup/themes/adminlte" // Import the theme
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql" // Import the sql driver

	"github.com/gin-gonic/gin"
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

	// AddGenerator can also be used to load the Generator, like:
	// eng.AddGenerator("user", GetUserTable)
	
	eng.AddConfig(cfg).
		AddGenerators(Generators).  // 加载插件
		Use(r)

	r.Run(":9033")
}
```

### Step 4. Set access menu

After running, access the login URL, enter the menu management page, and then set the management menu of the data table to enter in the sidebar.

> In the above example, the login URL is http://localhost:9033/admin/login
>
> The menu management page is http://localhost:9033/admin/menu

## Introduction of the business data table generation method

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

func GetUserTable(ctx *context.Context) (userTable table.Table) {

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
	formList.AddField("ID", "id", db.Int, form.Default).FieldNotAllowEdit()
	formList.AddField("Ip", "ip", db.Varchar, form.Text)
	formList.AddField("Name", "name", db.Varchar, form.Text)

	// use FieldOptions.
	formList.AddField("Gender", "gender", db.Tinyint, form.Radio).
		FieldOptions(types.FieldOptions{
			{
				Text:    "male",
				Value:    "0",
			}, {
				Text:    "female",
				Value:    "1",
			},
		}).FieldDefault("0")
	formList.AddField("Phone", "phone", db.Varchar, form.Text)
	formList.AddField("City", "city", db.Varchar, form.Text)

	// add a custom field and use FieldPostFilterFn to do more things.
	formList.AddField("Custom Field", "role", db.Varchar, form.Text).
		FieldPostFilterFn(func(value types.PostFieldModel) interface{} {
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

Initialized by calling ```models.NewDefaultTable(models.DefaultTableConfig)``` method to pass <strong>data table model configuration</strong>. The data table model is configured as:

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
	GetDetail() *types.InfoPanel
	GetDetailFromInfo() *types.InfoPanel
	GetForm() *types.FormPanel

	GetCanAdd() bool
	GetEditable() bool
	GetDeletable() bool
	GetExportable() bool

	GetPrimaryKey() PrimaryKey

	GetData(params parameter.Parameters) (PanelInfo, error)
	GetDataWithIds(params parameter.Parameters) (PanelInfo, error)
	GetDataWithId(params parameter.Parameters) (FormInfo, error)
	UpdateData(dataList form.Values) error
	InsertData(dataList form.Values) error
	DeleteData(pk string) error

	GetNewForm() FormInfo

	Copy() Table
}
```

It mainly includes ```GetInfo()``` and ```GetForm()```. The UI corresponding to the type returned by these two functions is the table for displaying data and the form for editing or creating data. The screenshots are as follows:

- This is the ```Info```.

<br>

![](http://quizfile.dadadaa.cn/everyday/app/jlds/img/006tNbRwly1fxoy26qnc5j31y60u0q91.jpg)

- This is the ```Form```.

<br>

![](http://quizfile.dadadaa.cn/everyday/app/jlds/img/006tNbRwly1fxoy2w3cobj318k0ooabv.jpg)

### Info

```go
type InfoPanel struct {
	FieldList   FieldList

	Table       string   
	Title       string   
	Description string   

	TabGroups  TabGroups  
	TabHeaders TabHeaders 

	Sort      Sort     
	SortField string   

	PageSizeList    []int 
	DefaultPageSize int   

	ExportType int

	IsHideNewButton    bool 
	IsHideExportButton bool 
	IsHideEditButton   bool 
	IsHideDeleteButton bool 
	IsHideDetailButton bool 
	IsHideFilterButton bool 
	IsHideRowSelector  bool 
	IsHidePagination   bool 
	IsHideFilterArea   bool 
	FilterFormLayout   form.Layout 

	FilterFormHeadWidth  int
	FilterFormInputWidth int

	Wheres    Wheres    
	WhereRaws WhereRaw  

	TableLayout string 

	DeleteHook  DeleteFn 
	PreDeleteFn DeleteFn 
	DeleteFn    DeleteFn 

	DeleteHookWithRes DeleteFnWithRes 

	GetDataFn GetDataFn

	Action        template.HTML 
	HeaderHtml    template.HTML 
	FooterHtml    template.HTML 
}

type Field struct {
	Head     string				// title	
	Field    string				// field name
	TypeName db.DatabaseType	// database type name

	Join Join // join table setting

	Width      int    // width
	Sortable   bool   // sortable
	Fixed      bool   // fixed
	Filterable bool   // filterable
	Hide       bool   // hide or not

	EditType    table.Type    // edit type
	EditOptions FieldOptions  // edit options

	Display              FieldFilterFn           // display filter callback function
	DisplayProcessChains DisplayProcessFnChains  // display process function chains
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
	PreProcessFn FormPreProcessFn // form post pre process function

	IsHideContinueEditCheckBox bool
	IsHideContinueNewCheckBox  bool
	IsHideResetButton          bool
	IsHideBackButton           bool

	HeaderHtml template.HTML  // header custom html content
	FooterHtml template.HTML  // footer custom html content

	UpdateFn FormPostFn // Form update function, set up this function, it took over the form of updates, PostHook is no longer in effect
	InsertFn FormPostFn // Form inserts function, set up this function, it took over the form of the insert, PostHook effect no longer
}

type FormPostFn func(values form.Values) error

// form hook function type
type PostHookFn func(values form.Values)

type FormField struct {
	Field        string               
	TypeName     string               
	Head         string               
	FormType     form.Type            

	Default      		   string               
	Value                  string               
	Options                []map[string]string  
	DefaultOptionDelimiter string				

	Editable     bool 
	NotAllowAdd  bool 
	Must         bool 
	Hide         bool 

	HelpMsg   template.HTML 
	OptionExt template.JS   
	
	Display              FieldFilterFn          
	DisplayProcessChains DisplayProcessFnChains 
	PostFilterFn PostFieldFilterFn              

	Placeholder string

	CustomContent template.HTML
	CustomJs      template.JS  
	CustomCss     template.CSS 

	Width int

	Divider      bool  
	DividerTitle string

	OptionExt    template.JS 
	OptionInitFn OptionInitFn
	OptionTable  OptionTable 
}
```

The currently supported form types are:

- default
- normal text
- Single selection
- Password
- rich text
- File
- Code
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

```go

import "github.com/GoAdminGroup/go-admin/template/types/form"

...
FormType: form.File,
...

```

See more in：[admin form components](admin/form/components.md)

Where field is the name of the field and value is the value corresponding to the selection.

### Filter function FilterFn and processing function PostFn description

The data which framework retrieve from database will be displayed in the table or form. If you want to transform them before displaying, for example turn capital or add some html style etc, you can do that using the field filter callback function. Of course, the framework have some built-in data process functions which will be introduced in the chapter of admin table.

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

func (r FieldModelValue) Value() string {
	return r.First()
}

func (r FieldModelValue) First() string {
	return r[0]
}
```

<br>

> English is not my main language. If any typo or wrong translation you found, you can help to translate in [github here](https://github.com/GoAdminGroup/docs). I will very appreciate it.

