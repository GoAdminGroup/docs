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

