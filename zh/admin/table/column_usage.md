# 列的使用
---

**InfoPanel**内置了很多对于列的操作方法，可以通过这些方法很灵活的操作列数据。

### 设置列宽

注意需要先设置表格布局类型为fixed

```go
info.SetTableFixed()
info.AddField("Name", "name", db.Varchar).FieldWidth(100)
```

### 默认隐藏列

```go
info.AddField("Name", "name", db.Varchar).FieldHide()
```

### 设置为可排序

```go
info.AddField("Name", "name", db.Varchar).FieldSortable()
```

### 设置为固定

```go
info.AddField("Name", "name", db.Varchar).FieldFixed()
```

### 设置为可筛选

```go
info.AddField("Name", "name", db.Varchar).FieldFilterable()
```

设置筛选的操作符与操作表单类型：

```go

// 设置操作符为like，模糊查询
info.AddField("Name", "name", db.Varchar).FieldFilterable(types.FilterType{Operator: types.FilterOperatorLike})

// 设置为单选类型
info.AddField("Gender", "gender", db.Tinyint).
    FieldFilterable(types.FilterType{FormType: form.SelectSingle}).
    FieldFilterOptions(types.FieldOptions{
      {Value: "0", Text: "men"},
      {Value: "1", Text: "women"},
    }).FieldFilterOptionExt(map[string]interface{}{"allowClear": true})
    
// 设置为时间范围类型，范围查询
info.AddField("CreatedAt", "created_at", db.Timestamp).FieldFilterable(types.FilterType{FormType: form.DatetimeRange})

// 设置过滤字段处理函数
info.AddField("Name", "name", db.Varchar).
FieldFilterable(types.FilterType{Operator: types.FilterOperatorLike}).
FieldFilterProcess(func(s string) string {
    // 即使前端错误输入带空格，在这里可以过滤空格进行sql查询
    return strings.TrimSpace(s)
})
```

## 列操作按钮

```go
// 第一个参数为标题，第二个参数为对应的操作
info.AddActionButton("操作", action.Jump("https://google.com"))
```

操作的类Action为一个接口，如下：

```go
type Action interface {
  // 返回对应的JS
  Js() template.JS
  // 返回按钮的属性
  BtnAttribute() template.HTML
  // 返回额外的HTML
  ExtContent() template.HTML
  // 设置按钮的ID，供给Js()方法调用
  SetBtnId(btnId string)
  // 返回请求节点，包括路由方法和对应控制器方法
  GetCallbacks() context.Node
}
```

可以自己实现一个```Action```，也可以直接使用框架提供的```Action```。系统内置提供以下两个```Action```，一个是popup操作，一个是跳转操作。

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
    return true, "", "<h2>hello world</h2>"
})

// 返回一个Ajax Action，参数一为url，参数二为对应的控制器方法。
action.Ajax("/admin/ajax",
func(ctx *context.Context) (success bool, msg string, data interface{}) {
    // 获取参数
    // ctx.FormValue["id"]
    // ctx.FormValue["ids"]
    return true, "success", ""
})

```



### 列上开关

在列上做一个简单的开关

```go
import "github.com/GoAdminGroup/go-admin/template/types/table"

info.AddField("显示状态", "show_status", db.Tinyint).FieldEditAble(table.Switch).FieldEditOptions(types.FieldOptions{
		{Value: "1", Text: "允许"}, // 放在第一个代表 on
		{Value: "2", Text: "禁止"},
	})
```

还可以为这个列直接增加搜索功能

```go
info.AddField("显示状态", "show_status", db.Tinyint).FieldEditAble(table.Switch).FieldEditOptions(types.FieldOptions{
		{Value: "1", Text: "允许"}, // 放在第一个代表 on
		{Value: "2", Text: "禁止"},
	}).FieldFilterable(types.FilterType{FormType: form.SelectSingle}).FieldFilterOptions(types.FieldOptions{
		{Value: "1", Text: "允许"},
		{Value: "2", Text: "禁止"},
	}).FieldFilterOptionExt(map[string]interface{}{"allowClear": true})
```

### 列上图片

如果`avatar`字段保存的是图片的完整地址，或者路径，可以通过下面的方式将该列渲染为图片显示

```go
info.AddField("头像", "avatar", db.Varchar).FieldImage("50", "50")  
```

当然也可以为图片增加访问前缀

```go
info.AddField("头像", "avatar", db.Varchar).FieldImage("50", "50", "https://prefix.com")
```





## 帮助方法

### 字符串操作

限制输出长度

```go
info.AddField("Name", "name", db.Varchar).FieldLimit(10)
```

首字母大写

```go
info.AddField("Name", "name", db.Varchar).FieldToTitle()
```

去除空格

```go
info.AddField("Name", "name", db.Varchar).FieldTrimSpace()
```

字符串截取

```go
info.AddField("Name", "name", db.Varchar).FieldSubstr(0, 3)
```

字符串转大写

```go
info.AddField("Name", "name", db.Varchar).FieldToUpper()
```

字符串转小写

```go
info.AddField("Name", "name", db.Varchar).FieldToLower()
```

**如果想要全局进行过滤操作**

那么可以调用插件的方法：

```go
adminPlugin := admin.NewAdmin(...)

// 限制输出
adminPlugin.AddDisplayFilterLimit(limit int)

// 去除空格
adminPlugin.AddDisplayFilterTrimSpace()

// 截取字符串
adminPlugin.AddDisplayFilterSubstr(start int, end int)

// 首字母大写
adminPlugin.AddDisplayFilterToTitle()

// 大写
adminPlugin.AddDisplayFilterToUpper()

// 小写
adminPlugin.AddDisplayFilterToLower()

// xss过滤
adminPlugin.AddDisplayFilterXssFilter()

// js过滤
adminPlugin.AddDisplayFilterXssJsFilter()

```

**如果想要在表格或表单显示层面进行过滤操作**

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