# Basic Usage
---

Use the cli to generate a data form type for the sql table, such as:

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
	userTable = table.NewDefaultTable(...)

  ...

	formList := userTable.GetForm()

	// set id editable is false.
	formList.AddField("ID", "id", db.Int, form.Default).FieldNotAllowEdit()
	formList.AddField("Ip", "ip", db.Varchar, form.Text)
	formList.AddField("Name", "name", db.Varchar, form.Text)

  ...

	return
}
```


## Type

- ```Default```
- ```Text```
- SingleSelection ```SelectSingle```
- ```Password```
- ```RichText```
- ```File```
- ```SelectBox```
- ```Select```
- ```IconPicker```
- ```Datetime```
- ```Radio```
- ```Email```
- ```Url```
- ```Ip```
- ```Color```
- ```Currency```
- ```Number```

Example:

```go

import (
    ...
    "github.com/GoAdminGroup/go-admin/template/types/form"  
    ...
)

func GetxxxTable(ctx *context.Context) table.Table {
    formList.AddField("ID", "id", db.Int, form.Default)
}

```

## Operations

### Add fields

```go

// Add a field with the field title ID, field name id, field type int, form type Default
formList.AddField("ID", "id", db.Int, form.Default)

// Add a second field with the field title Ip, the field name ip, the field type varchar, and the form type Text
formList.AddField("Ip", "ip", db.Varchar, form.Text)

// Add a third field, a field that does not exist in the sql table
formList.AddField("Custom", "custom", db.Varchar, form.Text)

```

### Default value

```go
formList.AddField("header", "header", db.Varchar, form.Text).FieldDefault("header")
```

### Required field

```go
formList.AddField("header", "header", db.Varchar, form.Text).FieldMust()
```

### Help msg

```go
formList.AddField("header", "header", db.Varchar, form.Text).FieldHelpMsg("length should be more than 5")
```

### Prohibit editing

```go

formList.AddField("id", "id", db.Int, form.Default).FieldNotAllowEdit()

```

### Prohibit creating

```go

formList.AddField("id", "id", db.Int, form.Default).FieldNotAllowAdd()

```

### Validator

```go
formList.SetPostValidator(func(values form2.Values) error {
		if values.Get("sex") != "women" && values.Get("sex") != "men" {
			return fmt.Errorf("error info")
		}
		return nil
})
```

### Filter function before update/insert operation

```go
formList.AddField("Link", "url", db.Varchar, form.Text).
		FieldPostFilterFn(func(value types.PostFieldModel) interface{} {
			return "http://xxxx.com/" + value.Get("url")
		})
```

*If the insert field need to be NULL*

```go
formList.AddField("avatar", "avatar", db.Varchar, form.Text).
		FieldPostFilterFn(func(value types.PostFieldModel) interface{} {
			if value.Value == "" {
        return sql.NullString{}
      }
      return value.Value
		})
```

### Display filter procress functions

```go

// Limit length
formList.AddField("链接", "url", db.Varchar, form.Text).FieldLimit(limit int)

// Trim space
formList.AddField("链接", "url", db.Varchar, form.Text).FieldTrimSpace()

// Truncate
formList.AddField("链接", "url", db.Varchar, form.Text).FieldSubstr(start int, end int)

// Title
formList.AddField("链接", "url", db.Varchar, form.Text).FieldToTitle()

// Upper
formList.AddField("链接", "url", db.Varchar, form.Text).FieldToUpper()

// Lower
formList.AddField("链接", "url", db.Varchar, form.Text).FieldToLower()

// xss fliter
formList.AddField("链接", "url", db.Varchar, form.Text).FieldXssFilter()

```

### Rewrite the insert/update logic functions

If your form inserts and the update operation is complicated, the framework can not meet you need, then you can rewrite and replace the default logics.

```go

// replace the default insert logic
formList.SetInsertFn(func(values form2.Values) error {
      // values are the form parameters
  })
  
// replace the default update logic
formList.SetUpdateFn(func(values form2.Values) error {
      // values are the form parameters
	})  
```