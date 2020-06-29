# Usage Of Column
---

**InfoPanel** has a lot of built-in operation methods for columns, which can be used to manipulate column data very flexibly.

### Set Width

```go
info.SetTableFixed()
info.AddField("Name", "name", db.Varchar).FieldWidth(100)
```

### Hide

```go
info.AddField("Name", "name", db.Varchar).FieldHide()
```

### Be Sortable

```go
info.AddField("Name", "name", db.Varchar).FieldSortable()
```

### Be Fixed

```go
info.AddField("Name", "name", db.Varchar).FieldFixed()
```

### Be Filterable

```go
info.AddField("Name", "name", db.Varchar).FieldFilterable()
```

Set filter operator and operation form type:

```go

// Set the operator to like, fuzzy query
info.AddField("Name", "name", db.Varchar).FieldFilterable(types.FilterType{Operator: types.FilterOperatorLike})

// Set to single selection type
info.AddField("Gender", "gender", db.Tinyint).
    FieldFilterable(types.FilterType{FormType: form.SelectSingle}).
    FieldFilterOptions(types.FieldOptions{
      {Value: "0", Text: "men"},
      {Value: "1", Text: "women"},
    }).FieldFilterOptionExt(map[string]interface{}{"allowClear": true})
    
// Set to the time range type, range queries
info.AddField("CreatedAt", "created_at", db.Timestamp).FieldFilterable(types.FilterType{FormType: form.DatetimeRange})

// Set the filter field processing function
info.AddField("Name", "name", db.Varchar).
FieldFilterable(types.FilterType{Operator: types.FilterOperatorLike}).
FieldFilterProcess(func(s string) string {
    // Even if the error input with extra spaces from the request, here can filter the spaces for SQL queries
    return strings.TrimSpace(s)
})
```

## Add column operation button

If you want to add some function button, then you can do like this:

```go
info.AddActionButton(title template.HTML, icon string, action Action, color ...template.HTML)
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

info.AddActionButton("Today Data", icon.Save, action.PopUp("/admin/data/analyze", "Data Analysis"))
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
// action.Jump("/admin/info/manager?id={{.Id}}")
//
// {{.Id}} is the placeholder of id.
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

### FieldSwitch

Show as a switch

```go
import "github.com/GoAdminGroup/go-admin/template/types/table"

info.AddField("ShowEnable", "show_status", db.Tinyint).FieldEditAble(table.Switch).FieldEditOptions(types.FieldOptions{
		{Value: "1", Text: "Enable"}, 
		{Value: "2", Text: "Disable"},
	})
```

Maybe you want to add filter together

```go
info.AddField("ShowEnable", "show_status",db.Tinyint).FieldEditAble(table.Switch).FieldEditOptions(types.FieldOptions{
		{Value: "1", Text: "Enable"}, 
		{Value: "2", Text: "Disable"},
	}).FieldFilterable(types.FilterType{FormType: form.SelectSingle}).FieldFilterOptions(types.FieldOptions{
		{Value: "1", Text: "Enable"},
		{Value: "2", Text: "Disable"},
	}).FieldFilterOptionExt(map[string]interface{}{"allowClear": true})
```

## Help Methods

### String manipulation

Limit the output length

```go
info.AddField("Name", "name", db.Varchar).FieldLimit(10)
```

Title

```go
info.AddField("Name", "name", db.Varchar).FieldToTitle()
```

Trim space

```go
info.AddField("Name", "name", db.Varchar).FieldTrimSpace()
```

String interception

```go
info.AddField("Name", "name", db.Varchar).FieldSubstr(0, 3)
```

String to uppercase

```go
info.AddField("Name", "name", db.Varchar).FieldToUpper()
```

String to lowercase

```go
info.AddField("Name", "name", db.Varchar).FieldToLower()
```


**If you want to add global filtering operation**

Then you can do like this:

```go
adminPlugin := admin.NewAdmin(...)

// limit output
adminPlugin.AddDisplayFilterLimit(limit int)

// trim space
adminPlugin.AddDisplayFilterTrimSpace()

// substr
adminPlugin.AddDisplayFilterSubstr(start int, end int)

// make title
adminPlugin.AddDisplayFilterToTitle()

// to upper
adminPlugin.AddDisplayFilterToUpper()

// to lower
adminPlugin.AddDisplayFilterToLower()

// xss filter
adminPlugin.AddDisplayFilterXssFilter()

// js filter
adminPlugin.AddDisplayFilterXssJsFilter()

```

**If you want to add filtering operation in display level of info table or forms**

```go
info := table.NewDefaultTable(...).GetInfo()

info.AddLimitFilter(limit int)
info.AddTrimSpaceFilter()
info.AddSubstrFilter(start int, end int)
info.AddToTitleFilter()
info.AddToUpperFilter()
info.AddToLowerFilter()
info.AddXssFilter()
info.AddXssJsFilter()

form := table.NewDefaultTable(...).GetForm()

form.AddLimitFilter(limit int)
form.AddTrimSpaceFilter()
form.AddSubstrFilter(start int, end int)
form.AddToTitleFilter()
form.AddToUpperFilter()
form.AddToLowerFilter()
form.AddXssFilter()
form.AddXssJsFilter()
```