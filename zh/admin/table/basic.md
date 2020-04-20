# 基本使用
---

使用命令行将sql表生成一个数据表格类型，如：

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

生成了：

```go
package main

import (
	...
)

func GetUserTable(ctx *context.Context) (userTable table.Table) {

	// 初始化数据表模型
	userTable = table.NewDefaultTable(table.Config{...})

	info := userTable.GetInfo()

	// 设置ID为可排序
	info.AddField("ID", "id", db.Int).FieldSortable(true)
	info.AddField("Name", "name", db.Varchar)
    
    ...

	// 设置页面标题和描述
	info.SetTable("users").SetTitle("Users").SetDescription("Users").
		SetAction(template.HTML(`<a href="http://google.com"><i class="fa fa-google"></i></a>`))  // custom operation button

    ...
}
```

### 添加列

```go

// 添加一个字段，字段标题为 ID，字段名为 id，字段类型为 int
info.AddField("ID", "id", db.Int)

// 添加第二个字段，字段标题为 Name，字段名为 name，字段类型为 varchar
info.AddField("Name", "name", db.Varchar)

// 添加第三个字段，一个sql表不存在的字段
info.AddField("Custom", "custom", db.Varchar)

```

### 修改显示输出

```go

// 根据字段的值输出对应的内容
info.AddField("Gender", "gender", db.Tinyint).FieldDisplay(func(model types.FieldModel) interface{} {
    if model.Value == "0" {
        return "men"
    }
    if model.Value == "1" {
        return "women"
    }
    return "unknown"
})

// 输出html
info.AddField("Name", "name", db.Varchar).FieldDisplay(func(model types.FieldModel) interface{} {    
    return "<span class='label'>" +  model.Value + "</span>"
})
```

**FieldDisplay**方法接收的匿名函数绑定了当前行的数据对象，可以在里面调用当前行的其它字段数据

```go
info.AddField("First Name", "first_name", db.Varchar).FieldHide()
info.AddField("Last Name", "last_name", db.Varchar).FieldHide()

// 不存的字段列
info.AddField("Full Name", "full_name", db.Varchar).FieldDisplay(func(model types.FieldModel) interface{} {    
    return model.Row["first_name"].(string) + " " + model.Row["last_name"].(string)
})
```

### 禁用创建按钮

```go
info.HideNewButton()
```

### 隐藏编辑按钮

```go
info.HideEditButton()
```

### 隐藏导出按钮

```go
info.HideExportButton()
```

### 隐藏删除按钮

```go
info.HideDeleteButton()
```

### 隐藏详情按钮

```go
info.HideDetailButton()
```

### 默认隐藏列选择框

```go
info.HideRowSelector()
```

### 默认隐藏筛选框

```go
info.HideFilterArea()
```

### 预查询

```go
// 字段, 操作符, 参数
info.Where("type", "=", 0)
// 原生sql
info.WhereRaw("type = 0 or sex = 1")
// or语句，以下会生成：type = 3 or type = 0
info.Where("type", "=", 3).WhereOr("type", "=", 0) 
```

### 导出设置

```go
// 设置导出未经显示处理的原生值，默认为显示处理后的值
info.ExportValue()
```

## 设置筛选表单布局

```go
info.SetFilterFormLayout(layout form.Layout)
```

## 设置筛选表单项宽度

```go
// 设置标题宽度，1到12，默认为2
info.SetFilterFormHeadWidth(w int)
// 设置输入框宽度，1到12，默认为10，两者之和为12
info.SetFilterFormInputWidth(w int)
```

## 设置默认排序规则

```go
// 顺序
info.SetSortAsc()
// 倒序
info.SetSortDesc()
```

## 设置默认排序字段

```go
info.SetSortField("created_at")
```

## 连表

连表需要设置连表表名与连表字段

```go

// 增加字段名
info.AddField("Role Name", "role_name", db.Varchar).FieldJoin(types.Join{
    Table: "role",         // 连表的表名 
	Field: "id",           // 要连表的字段 
	JoinField: "user_id",  // 连表的表的字段
})

```

这将会生成类似这样的sql语句：

```sql
select ..., role.`role_name` from users left join role on users.`id` = role.`user_id` where ...
```

## 新增按钮

如果您需要新增一些功能按钮，可以调用：

```go
info.AddButton(title template.HTML, icon string, action Action, color ...template.HTML)
```

其中，```title```为Button的标题，```icon```为Button的icon，```action```为Button的操作，```color```为背景色与文字颜色。

例如：
```go

import (
    ...
	"github.com/GoAdminGroup/go-admin/template/icon"
	"github.com/GoAdminGroup/go-admin/template/types/action"
    ...
)

info.AddButton("今日情况", icon.Save, action.PopUp("/admin/data/analyze", "数据分析"))
```

添加了一个popup的操作，将会去请求对应路由，对应路由返回的就是popup的内容，「数据分析」为对应popup的标题。

操作的类Action为一个接口，如下：

```go
type Action interface {
    // 返回对应的JS
    Js() template.JS
    // 获取class
    BtnClass() template.HTML
    // 返回按钮的属性
    BtnAttribute() template.HTML
    // 返回额外的HTML
    ExtContent() template.HTML
    // 设置按钮的ID，供给Js()方法调用
    SetBtnId(btnId string)
    // 设置数据
    SetBtnData(data interface{})
    // 返回请求节点，包括路由方法和对应控制器方法
    GetCallbacks() context.Node
}
```

可以自己实现一个```Action```，也可以直接使用框架提供的```Action```。系统内置提供以下四个```Action```，一个是popup操作，一个是跳转操作，一个ajax操作，还有过滤操作（用于下拉框）。

```go

import (
    "github.com/GoAdminGroup/go-admin/template/types/action"
)

// 返回一个Jump Action，参数一为url，参数二为额外的html
// Jump Action是一个跳转操作。如果需要跳转url中带上id，可以这样写：
//
// action.Jump("/admin/info/manager?id={{.Id}}")
//
// 其中{{.Id}}为id的占位符
action.Jump("/admin/info/manager")
action.JumpInNewTab("/admin/info/manager", "管理员")

// 返回一个PopUp Action，参数一为url，参数二为popup标题，参数三为对应的控制器方法。
// 用户点击按钮后会请求对应的方法，带上请求id，请求转发到对应控制器方法后进行处理返回。
action.PopUp("/admin/popup", "Popup Example", func(ctx *context.Context) (success bool, msg string, data interface{}) {
    // 获取参数
    // ctx.FormValue["id"]
    // ctx.FormValue["ids"]

    // 这里返回的data为前端显示html内容
    return true, "", "<h2>hello world</h2>"
})

// 返回一个Ajax Action，参数一为url，参数二为对应的控制器方法。
action.Ajax("/admin/ajax",
func(ctx *context.Context) (success bool, msg string, data interface{}) {
    // 获取参数
    // ctx.FormValue["id"]  选择的id
    // ctx.FormValue["ids"] 选择的id列表，是逗号分割的字符串
    return true, "success", ""
})

```

新增下拉筛选按钮

```go
// 参数一位标题，参数二为选项，参数三为action
info.AddSelectBox("gender", types.FieldOptions{
        {Value: "", Text: ""},
		{Value: "0", Text: "men"},
		{Value: "1", Text: "women"},
	}, action.FieldFilter("gender"))
```

FieldFilter中的参数为筛选字段名。

## 新增列按钮

有时候想要增加一个列的操作按钮，可以使用：

```go
info.AddColumnButtons(head string, buttons ...Button)
```

## 增加列内容

如果你单纯想增加一列，跟数据库字段不是一对一，可以使用这个API。

```go
info.AddColumn(head string, fn FieldFilterFn)
```

## 设置详情页

可以自定义详情页显示内容

```go
package datamodel

import (
	...
)

func GetUserTable(ctx *context.Context) (userTable table.Table) {

	userTable = table.NewDefaultTable(table.Config{...})

	detail := userTable.GetDetail()

	detail.AddField("ID", "id", db.Int)
    detail.AddField("Name", "name", db.Varchar)
    
    detail.SetTable("users").
		SetTitle("用户详情").
		SetDescription("用户详情")
    
    ...
}
```

如果你想直接复制列表的设置，并且再增加额外的字段

```go
detail := userTable.GetDetailFromInfo()
detail.AddField("额外字段", "external", db.Varchar)
```

注意：如果不设置的话，则默认用列表页设置的显示



## 自定义数据源

如果您想自己定义一个数据源，不想从SQL数据库中自动读取，可以有两种方式：

### 编写自定义数据源函数

```go

package main

import (
    ...
    "github.com/GoAdminGroup/go-admin/plugins/admin/modules/parameter"
    ...
)

func GetUserTable(ctx *context.Context) (userTable table.Table) {

	userTable = table.NewDefaultTable(table.Config{
        ...
    })

    info := externalTable.GetInfo()
	info.AddField("ID", "id", db.Int).FieldSortable()
    info.AddField("Title", "title", db.Varchar)
    
    info.SetTable("external").
		SetTitle("Externals").
		SetDescription("Externals").
        // 返回值：第一个为数据列表，第二个为数据量
        SetGetDataFn(func(param parameter.Parameters) (data []map[string]interface{}, size int) {
            // 注意需要对以下两种情况进行处理

            // 情况1：返回全部数据
            param.IsAll()
            
            // 情况2：返回指定主键对应的数据
            param.PK()
            
            // 对于参数说明
            // 
            // param.SortField     排序字段
            // param.Fields        筛选的字段
            // param.SortType      排序类型
            // param.Columns       隐藏的字段
            // param.PageSize      每页数据数
            // param.Page          当面页码
            
            return []map[string]interface{}{
                    {
                        "id":    10,
                        "title": "this is a title",
                    }, {
                        "id":    11,
                        "title": "this is a title2",
                    }, {
                        "id":    12,
                        "title": "this is a title3",
                    }, {
                        "id":    13,
                        "title": "this is a title4",
                    },
                }, 10
        })

    ...
}
```

### 通过设置数据源URL

设置数据源链接，GoAdmin将自动从数据源链接拉取数据。如下：

```go

package main

import (
	...
)

func GetUserTable(ctx *context.Context) (userTable table.Table) {

	// 初始化数据表模型，并设置数据源url
	userTable = table.NewDefaultTable(table.Config{
        ...
		SourceURL: "http://xx.xx.xx.xx/xxx",
        ...
    })

    info := userTable.GetInfo()
    
	// 设置ID为可排序
	info.AddField("ID", "id", db.Int).FieldSortable(true)
	info.AddField("Name", "name", db.Varchar)
    
    ...

```

设置好数据源url后，数据源需满足返回的数据格式为JSON，并按照以下结构返回：

```json
{
	"data": [
        {
            "id": 1,
            "name":"张三"
        },{
            "id": 2,
            "name":"李四"
        }
    ], 
    "size": 10
}
```

说明：

> data: 为数据表数据，是数组，每一个数组项表示一行数据，数据项的键表示字段名，对应值表示字段值。
>
> size: 为所有数据的总量

在数据源url对应接口中，会收到以下URL参数：

> __page: 当面页码
>
> __pageSize: 页面数据数
>
> __sort: 排序字段
>
> __sort_type: 排序类型
>
> __columns: 隐藏的字段

接口需拿取对应的URL参数进行处理返回对应的JSON格式数据，GoAdmin会将数据展示出来。