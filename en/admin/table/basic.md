# Basic Usage

Use the command line to generate a data table type for the sql table, such as:

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

Generated:

```go
package datamodel

import (
    ...
)

func GetUserTable(ctx *context.Context) (userTable table.Table) {

    // config the table model.
    userTable = table.NewDefaultTable(table.Config{...})

    info := userTable.GetInfo()

    // set id sortable.
    info.AddField("ID", "id", db.Int).FieldSortable(true)
    info.AddField("Name", "name", db.Varchar)

    ...

    // set the title and description of table page.
    info.SetTable("users").SetTitle("Users").SetDescription("Users").
        SetAction(template.HTML(`<a href="http://google.com"><i class="fa fa-google"></i></a>`))  // custom operation button

    ...
}
```

### Add Field

```go
// Add a field with the field title ID, field name id, field type int
info.AddField("ID", "id", db.Int)

// Add the second field, the field title is Name, the field name is name, and the field type is varchar
info.AddField("Name", "name", db.Varchar)

// Add a third field, a field that does not exist in the sql table
info.AddField("Custom", "custom", db.Varchar)
```

### Modify display output

```go
// Output the corresponding content according to the value of the field
info.AddField("Gender", "gender", db.Tinyint).FieldDisplay(func(model types.FieldModel) interface{} {
    if model.Value == "0" {
        return "men"
    }
    if model.Value == "1" {
        return "women"
    }
    return "unknown"
})

// Output html
info.AddField("Name", "name", db.Varchar).FieldDisplay(func(model types.FieldModel) interface{} {    
    return "<span class='label'>" +  model.Value + "</span>"
})
```

The anonymous function received by the **FieldDisplay** method binds the data object of the current row, and can call other field data of the current row in it.

```go
info.AddField("First Name", "first_name", db.Varchar).FieldHide()
info.AddField("Last Name", "last_name", db.Varchar).FieldHide()

// non-existing field columns
info.AddField("Full Name", "full_name", db.Varchar).FieldDisplay(func(model types.FieldModel) interface{} {    
    return model.Row["first_name"].(string) + " " + model.Row["last_name"].(string)
})
```

### Hide create button

```go
info.HideNewButton()
```

### Hide edit button

```go
info.HideEditButton()
```

### Hide export button

```go
info.HideExportButton()
```

### Hide delete button

```go
info.HideDeleteButton()
```

### Hide detail button

```go
info.HideDetailButton()
```

### Hide Row Selector

```go
info.HideRowSelector()
```

### Hide filter area by default

```go
info.HideFilterArea()
```

### Pre query

```go
// field, operator, argument
info.Where("type", "=", 0)
```

## Set filter area form layout

```go
info.SetFilterFormLayout(layout form.Layout)
```

## Set default order rule

```go
// increase
info.SetSortAsc()
// decrease
info.SetSortDesc()
```

## Set default sort field

```go
info.SetSortField("created_at")
```

## Join Table

The table needs to set the table name and the table field

```go
info.AddField("Role Name", "role_name", db.Varchar).FieldJoin(types.Join{
    Table: "role",         // table name which you want to join 
    Field: "id",           // table field name of your own 
    JoinField: "user_id",  // table field name of the table which you want to join 
})
```

It will generate a sql statement like this:

```sql
select ..., role.`role_name` from users left join role on users.`id` = role.`user_id` where ...
```


## Add Button

If you want to add some function button, then you can do like this:

```go
info.AddButton(title template.HTML, icon string, action Action, color ...template.HTML)
```

```title``` is the title of Button, ```icon```is the icon of Button, ```action```is a set of operations of Button and ```color``` are the background color and text color.

For example: 
```go

import (
    ...
	"github.com/GoAdminGroup/go-admin/template/icon"
	"github.com/GoAdminGroup/go-admin/template/types/action"
    ...
)

info.AddButton("Today Data", icon.Save, action.PopUp("/admin/data/analyze", "Data Analysis"))
```

Added a popup operation, will go to request the corresponding routing, corresponding routing return is the content of the popup, "data analysis" as the title for the popup.

Operation of class Action as an interface, as follows:

```go
type Action interface {
    // Returns the corresponding JS
    Js() template.JS
    // Access to the class
    BtnClass() template.HTML
    // Returns the button properties
    BtnAttribute() template.HTML
    // Returns the extra HTML
    ExtContent() template.HTML
    // The set up button ID, supply Js () method call
    SetBtnId(btnId string)
    // SetData
    SetBtnData(data interface{})
    // Return request node, including routing method and the corresponding controller
    GetCallbacks() context.Node
}
```

You can implement a ```Action``` yourself or use the ```Action``` provided of framework. There are three default ```Action```: PopUp, Ajax and Jump.

```go

import (
    "github.com/GoAdminGroup/go-admin/template/types/action"
)

// Return a Jump Action，parameter one is the url，two is the extra html.
// Jump Action is a link jump operation. If you need to carry the id  of operation row, you can do like this:
//
// action.Jump("/admin/info/manager?id={%id}")
//
// {%id} is the placeholder of id.
action.Jump("/admin/info/manager")
action.JumpInNewTab("/admin/info/manager", "管理员")

// Return a PopUp Action, parameter one is the url, two is the title, three is handler method.
// When user click the button, the request will be sent to the handler with the row id.
action.PopUp("/admin/popup", "Popup Example", func(ctx *context.Context) (success bool, msg string, data interface{}) {
    // Access to the paramters:
    //
    // ctx.FormValue["id"]
    // ctx.FormValue["ids"]

    // The data return is the content of popup.
    return true, "", "<h2>hello world</h2>"
})

// Return a Ajax Action, parameter one is the url, two is the handler method.
action.Ajax("/admin/ajax",
func(ctx *context.Context) (success bool, msg string, data interface{}) {
    // Access to the paramters:
    //
    // ctx.FormValue["id"]
    // ctx.FormValue["ids"]
    return true, "success", ""
})

```

New drop-down filter button

```go
// Parameters, first is the title, the second is options, third is the action
info.AddSelectBox("gender", types.FieldOptions{
        {Value: "", Text: ""},
		{Value: "0", Text: "men"},
		{Value: "1", Text: "women"},
	}, action.FieldFilter("gender"))
```

Parameter of ```FieldFilter``` is the field name for filter.


## Configure Detail Page

You can customize details page display content, if it is not set, the default Settings display using list page

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
		SetTitle("Users Detail").
		SetDescription("Users Detail")

    ...
}
```


## Custom data source

If you want to define a data source, don't want to read automatically from the SQL database, you have two ways:

### Writing a custom data source function

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
        // Return values: the first is the list of data, the second for the amount of data
        SetGetDataFn(func(param parameter.Parameters) (data []map[string]interface{}, size int) {
            // Pay attention to the need to deal with the following two cases

            // Case 1: return all data
            param.IsAll()
            
            // Situation 2: returns the data corresponding to the specified primary key 
            param.PK()
            
            // Parameter specification
            // 
            // param.SortField     
            // param.Fields        
            // param.SortType      
            // param.Columns       
            // param.PageSize      
            // param.Page          
            
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

### By setting the data source URL

Set up the data source link, GoAdmin will automatically pull data from the data source link. As follows:

```go

package main

import (
	...
)

func GetUserTable(ctx *context.Context) (userTable table.Table) {

	// Initialization data table model, and set up the data source url
	userTable = table.NewDefaultTable(table.Config{
        ...
		SourceURL: "http://xx.xx.xx.xx/xxx",
        ...
    })

    info := userTable.GetInfo()
    
	info.AddField("ID", "id", db.Int).FieldSortable(true)
	info.AddField("Name", "name", db.Varchar)
    
    ...

```

After setting up the data source url, need to satisfy the returned as JSON data format, data source and return according to the following structure:

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

Statement:

> data: For the data table data is an array, each array item said a row, the key of a data item said the field name, the corresponding value indicates that the field values.
>
> size: is the amount of all the data

In the data source url corresponding interface, will receive the following url parameters:

> __page: the page number
>
> __pageSize: size of per page data
>
> __sort: sort field name
>
> __sort_type: sort type
>
> __columns: hidden fields

Interfaces need to take the corresponding URL parameters for processing returns the corresponding JSON format data, GoAdmin data will be displayed.