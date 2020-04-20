# Admin插件使用 
---

admin插件可以帮助你实现快速生成数据库数据表增删改查的Web数据管理平台。

## 快速开始

需要如下几步：

- 生成数据表对应的配置文件
- 设置访问路由
- 初始化，并在引擎中加载
- 设置访问菜单

### 生成配置文件

假设你的数据库里面有一个数据表users，如：

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

使用自带的命令行工具可以帮助你快速生成数据模型文件，如：

- 安装

```bash
go install github.com/GoAdminGroup/go-admin/adm
```

- 生成

<br>
在项目文件夹下执行：

```bash
adm generate
```

**注意：选择表格的时候，按空格选择，不是按回车**

根据提示填写信息，运行完之后，会生成一个文件```users.go```，这个就是对应数据表的配置文件了，关于如何配置，在后面详细介绍。

### 设置访问路由

生成完配置文件后，同时也会生成一个路由配置文件```tables.go```以及```Generators```变量，如：

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
// "user" => http://localhost:9033/admin/info/user
//
var Generators = map[string]models.TableGenerator{
	"user":    GetUserTable,
}
```

其中，```"user"```就是对应的访问路由前缀，```GetUserTable```就是表格数据生成方法。
对应的访问路由地址就是：[http://localhost:9033/admin/info/user](http://localhost:9033/admin/info/user)

### 初始化，并在引擎中加载

初始化，调用```eng.AddGenerators```，将上面的```Generators```传进去即可。

```go
package main

import (
	_ "github.com/GoAdminGroup/go-admin/adapter/gin" // 必须引入，如若不引入，则需要自己定义
	_ "github.com/GoAdminGroup/themes/adminlte" // 必须引入，不然报错
	_ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql" // 数据库驱动

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
				Name:       "go-admin",
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

	// 也可以调用 AddGenerator 方法加载
	// eng.AddGenerator("user", GetUserTable)
	
	eng.AddConfig(cfg).
		AddGenerators(Generators).  // 加载插件
		Use(r)

	r.Run(":9033")
}
```

运行代码：

```
GO111MODULE=on go run .
```

### 设置访问菜单

运行起来后，访问[登录网址](http://localhost:9033/admin/login)，进入到[菜单管理页面](http://localhost:9033/admin/menu)，设置好数据表的管理菜单就可以在侧边栏中进入了。

> 注：
>
> 在以上例子中，登录网址为：http://localhost:9033/admin/login
>
> 菜单管理页面为：http://localhost:9033/admin/menu

## 业务数据表生成方法文件介绍

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

	// 设置模型配置
	userTable = table.NewDefaultTable(table.Config{
		Driver:     db.DriverMysql,
		CanAdd:     true,  // 是否可以新增
		Editable:   true,  // 是否可以编辑
		Deletable:  true,  // 是否可以删除
		Exportable: true,  // 是否可以导出为excel
		Connection: table.DefaultConnectionName,
		PrimaryKey: table.PrimaryKey{ // 自定义主键，默认为id，类型为Int
			Type: db.Int,
			Name: table.DefaultPrimaryKeyName,
		},
	})

	info := userTable.GetInfo()

	// AddField方法，第一个参数为标题，第二参数为字段名，第三个参数为字段的数据库类型

	// 设置主键id为可排序
	info.AddField("ID", "id", db.Int).FieldSortable(true)
	info.AddField("Name", "name", db.Varchar)

	// 使用 FieldDisplay 过滤性别显示
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

	// 设置表格页面标题和描述，以及对应sql表名
	info.SetTable("users").SetTitle("Users").SetDescription("Users").
		SetAction(template.HTML(`<a href="http://google.com"><i class="fa fa-google"></i></a>`))  // 自定义操作按钮

	formList := userTable.GetForm()

	// 设置主键Id不可以编辑
	formList.AddField("ID", "id", db.Int, form.Default).FieldNotAllowEdit()
	formList.AddField("Ip", "ip", db.Varchar, form.Text)
	formList.AddField("Name", "name", db.Varchar, form.Text)

	// 使用 FieldOptions 设置 radio 类型内容
	formList.AddField("Gender", "gender", db.Tinyint, form.Radio).
		FieldOptions(types.FieldOptions{ 
            {Text: "man",Value: "0"},
            {Text: "women",Value: "1"},
        }).
	formList.AddField("Phone", "phone", db.Varchar, form.Text)
	formList.AddField("City", "city", db.Varchar, form.Text)

	// 自定义一个表单字段，使用 FieldPostFilterFn 可以进行连表操作
	formList.AddField("Custom Field", "role", db.Varchar, form.Text).
		FieldPostFilterFn(func(value types.PostFieldModel) interface{} {
			fmt.Println("user custom field", value)
			return ""
		})

	formList.AddField("UpdatedAt", "updated_at", db.Timestamp, form.Default).FieldNotAllowAdd(true)
	formList.AddField("CreatedAt", "created_at", db.Timestamp, form.Default).FieldNotAllowAdd(true)

	// 使用 SetTabGroups 将表单分为几部分tab显示
	formList.SetTabGroups(types.
		NewTabGroups("id", "ip", "name", "gender", "city").
		AddGroup("phone", "role", "created_at", "updated_at")).
		SetTabHeaders("profile1", "profile2")

	// 设置表单页面标题和描述，以及对应sql表名
	formList.SetTable("users").SetTitle("Users").SetDescription("Users")

	// 使用 SetPostHook 设置表单提交后的触发操作
	formList.SetPostHook(func(values form2.Values) {
		fmt.Println("userTable.GetForm().PostHook", values)
	})

	return
}
```

通过调用```models.NewDefaultTable(models.DefaultTableConfig)```方法传入<strong>数据表模型配置</strong>进行初始化，数据表模型配置为：

```go
type Config struct {
	Driver     string       // 数据库驱动
	Connection string       // 数据库连接名，在全局配置中定义
	CanAdd     bool         // 是否可以新增数据
	Editable   bool         // 是否可以编辑
	Deletable  bool         // 是否可以删除
	Exportable bool         // 是否可以导出
	PrimaryKey PrimaryKey   // 数据表的主键
}

type PrimaryKey struct {
	Type db.DatabaseType  // 主键字段类型
	Name string           // 主键字段名
}
```

业务数据表生成方法是一个函数，返回了```models.Table```这个类型对象。以下是```models.Table```的定义：

```go
type Table interface {
	GetInfo() *types.InfoPanel
	GetForm() *types.FormPanel
	GetCanAdd() bool
	GetEditable() bool
	GetDeletable() bool
	GetExportable() bool
	GetPrimaryKey() PrimaryKey
	GetDataFromDatabase(path string, params parameter.Parameters, isAll bool) (PanelInfo, error)
	GetDataFromDatabaseWithIds(path string, params parameter.Parameters, ids []string) (PanelInfo, error)
	GetDataFromDatabaseWithId(id string) ([]types.FormField, [][]types.FormField, []string, string, string, error)
	UpdateDataFromDatabase(dataList form.Values) error
	InsertDataFromDatabase(dataList form.Values) error
	DeleteDataFromDatabase(id string) error
}
```

主要包括了```GetInfo()```和```GetForm()```，这两个函数返回的类型对应的ui就是显示数据的表格和编辑新建数据的表单，截图展示如下：

- 此为**数据表格**

<br>

![](http://quizfile.dadadaa.cn/everyday/app/jlds/img/006tNbRwly1fxoy26qnc5j31y60u0q91.jpg)

- 此为**数据表单**

<br>

![](http://quizfile.dadadaa.cn/everyday/app/jlds/img/006tNbRwly1fxoy2w3cobj318k0ooabv.jpg)

### Info表格

```go
// 表格数据对象
type InfoPanel struct {
	FieldList   FieldList // 字段列表

	Table       string    // 表格
	Title       string    // 标题
	Description string    // 描述

	TabGroups  TabGroups   // tab分组
	TabHeaders TabHeaders  // tab分组标题

	Sort      Sort      // 默认排序
	SortField string    // 默认排序字段

	PageSizeList    []int  // 页码列表，默认为：10, 20, 30, 50, 100
	DefaultPageSize int    // 默认页码，默认为：10

	ExportType int // 导出设置，是否导出原生值

	IsHideNewButton    bool  // 是否隐藏新建按钮
	IsHideExportButton bool  // 是否隐藏导出按钮
	IsHideEditButton   bool  // 是否隐藏编辑按钮
	IsHideDeleteButton bool  // 是否隐藏删除按钮
	IsHideDetailButton bool  // 是否隐藏详情按钮
	IsHideFilterButton bool  // 是否隐藏筛选按钮
	IsHideRowSelector  bool  // 是否隐藏列选择按钮
	IsHidePagination   bool  // 是否隐藏分页
	IsHideFilterArea   bool  // 是否隐藏筛选区域
	FilterFormLayout   form.Layout  // 筛选表单布局

	FilterFormHeadWidth  int // 筛选表单项标题宽度
	FilterFormInputWidth int // 筛选表单项输入框宽度

	Wheres    Wheres     // 预查询内容
	WhereRaws WhereRaw   // 预查询原生内容

	TableLayout string  // 表格布局

	DeleteHook  DeleteFn  // 删除hook函数
	PreDeleteFn DeleteFn  // 删除预检查函数
	DeleteFn    DeleteFn  // 删除逻辑，替换自带逻辑

	DeleteHookWithRes DeleteFnWithRes  // 删除hook函数，带通知结果

	GetDataFn GetDataFn // 获取数据逻辑，替换表格数据获取逻辑

	Action        template.HTML  // 表单操作html内容
	HeaderHtml    template.HTML  // 头部自定义html内容
	FooterHtml    template.HTML  // 底部自定义html内容
}

type Field struct {
	Head     string				// 标题	
	Field    string				// 字段名
	TypeName db.DatabaseType	// 字段类型

	Join Join // 连表设置

	Width      int    // 宽度，单位为px
	Sortable   bool   // 是否可以排序
	Fixed      bool   // 是否固定
	Filterable bool   // 是否可以筛选
	Hide       bool   // 是否隐藏

	EditType    table.Type    // 表格字段编辑类型
	EditOptions FieldOptions  // 表格字段编辑选项

	Display              FieldFilterFn           // 显示过滤函数
	DisplayProcessChains DisplayProcessFnChains  // 显示处理函数
}

// 连表设置
// 例子：left join Table on Table.JoinField = Field
type Join struct {
	Table     string  // 连表表名
	Field     string  // 字段
	JoinField string  // 连表字段名
}
```

### Form表单

```go
type FormPanel struct {
	FieldList    FormFields      // 字段列表
	Table        string          // 表格
	Title        string          // 标题
	Description  string          // 描述

	TabGroups    TabGroups      // tab分组，使用示例：[这里](https://github.com/GoAdminGroup/go-admin/blob/master/examples/datamodel/user.go#L76)
	TabHeaders   TabHeaders     // tab分组标题，使用示例：[这里](https://github.com/GoAdminGroup/go-admin/blob/master/examples/datamodel/user.go#L78)

	HeaderHtml    template.HTML   // 头部自定义内容
	FooterHtml    template.HTML   // 底部自定义内容	

	Validator    FormPostFn       // 表单验证函数
	PostHook     FormPostFn       // 表单提交后触发函数
	PreProcessFn FormPreProcessFn // 表单提交预处理函数

	IsHideContinueEditCheckBox bool // 是否隐藏继续编辑按钮
	IsHideContinueNewCheckBox  bool // 是否隐藏继续新建按钮
	IsHideResetButton          bool // 是否隐藏重设按钮
	IsHideBackButton           bool // 是否隐藏返回按钮

	UpdateFn FormPostFn // 表单更新函数
	InsertFn FormPostFn // 表单插入函数
}

type FormPostFn func(values form.Values) error

type FormField struct {
	Field        string                // 字段名
	TypeName     string                // 字段类型名
	Head         string                // 标题
	FormType     form.Type             // 表单类型

	Default      		   string                // 默认
	Value                  string                // 表单默认值
	Options                []map[string]string   // 表单选项
	DefaultOptionDelimiter string				 // 默认分隔符

	Editable     bool  // 是否可编辑
	NotAllowAdd  bool  // 是否不允许新增
	Must         bool  // 是否为必填项
	Hide         bool  // 是否隐藏

	HelpMsg   template.HTML  // 帮助信息
	OptionExt template.JS    // 单选/多选的额外设置，详见：https://select2.org/configuration/options-api
	
	Display              FieldFilterFn           // 显示过滤函数
	DisplayProcessChains DisplayProcessFnChains  // 显示处理函数
	PostFilterFn PostFieldFilterFn               // 表单过滤函数：用于对提交字段值的处理，处理后插入数据库

	Placeholder string // 表单输入提示语

	CustomContent template.HTML // 自定义表单项HTML
	CustomJs      template.JS   // 自定义表单项JS
	CustomCss     template.CSS  // 自定义表单项CSS

	Width int // 表单宽度

	Divider      bool   // 表单分割线
	DividerTitle string // 表单分割线标题

	OptionExt    template.JS  // 表单选项内容
	OptionInitFn OptionInitFn // 表单选项内容
	OptionTable  OptionTable  // 表单选项连表表格名字
}
```

目前支持的表单类型有：

- 默认
- 普通文本
- 单选
- 密码
- 富文本
- 文件
- 双选择框
- 多选
- icon下拉选择框
- 时间选择框
- radio选择框
- email输入框
- url输入框
- ip输入框
- 颜色选择框
- 货币输入框
- 数字输入框

</br>

详见：https://github.com/GoAdminGroup/go-admin/blob/master/template/types/form/form.go

这样子去引用：

```

import "github.com/GoAdminGroup/go-admin/template/types/form"

...
FormType: form.File,
...

```

其中，field为显示内容，value为选择对应的值。
具体使用，详见：[表单组件使用一节](admin/form/components.md)

### 显示过滤函数FieldFilterFn说明

框架从数据库拿到数据后，会将数据展示到表格或表单。如果想要对数据进行转化展示（比如过滤css/js，字符串转大写，加上一些html样式等等），则可以通过设置过滤函数实现。当然，框架内置了很多常见显示过滤操作，会在admin插件下面进行介绍。

```go

// 表格设置显示过滤函数
info.AddField(...).FieldDisplay(func(value FieldModel) interface{})

// 表单设置显示过滤函数
formList.AddField(...).FieldDisplay(func(value FieldModel) interface{})

```

显示过滤函数为一个回调函数，传入参数为字段和该行数据的值，可以对此进行转化后返回，返回内容将显示在表格或表单中。

```go
// FieldModel 其中ID为主键，Value为对应的字段在该主键下的值
type FieldModel struct {
	ID    string
	Value string
}

// FieldFilterFn 过滤函数决定从数据库取到的值Value传到前端显示的格式。
// 目前接受返回的类型为：template.HTML, string, []string
//
// 对于表格，可以返回template.HTML类型，包括html和css样式，使得表格中字段可以个性化的显示，如：
// 
// FilterFn: func(model types.FieldModel) interface{} {
// 	return template.Default().Label().SetContent(template2.HTML(model.Value)).GetContent()
// },
//
// 对于表单，需要注意的是，如果是为选择框类型：Select/SelectSingle/SelectBox，则需要返回数组：[]string，如：
//
// FilterFn: func(model types.FieldModel) interface{} {
// 	return strings.Split(model.Value, ",")
// },
// 
// 对于其他表单类型，则应返回string类型
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

