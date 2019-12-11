# Column Usage

**InfoPanel** has a lot of built-in operation methods for columns, which can be used to manipulate column data very flexibly.

### Set Width

```go
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

