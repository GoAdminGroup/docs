# 列的使用
---

**InfoPanel**内置了很多对于列的操作方法，可以通过这些方法很灵活的操作列数据。

### 设置列宽

```go
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

### 设置为可过滤

```go
info.AddField("Name", "name", db.Varchar).FieldFilterable()
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