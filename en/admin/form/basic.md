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

### Add Fields

```go

// Add a field with the field title ID, field name id, field type int, form type Default
formList.AddField("ID", "id", db.Int, form.Default)

// Add a second field with the field title Ip, the field name ip, the field type varchar, and the form type Text
formList.AddField("Ip", "ip", db.Varchar, form.Text)

// Add a third field, a field that does not exist in the sql table
formList.AddField("Custom", "custom", db.Varchar, form.Text)

```

### Prohibit editing

```go

formList.AddField("id", "id", db.Int, form.Default).FieldNotAllowEdit()

```

### No new additions

```go

formList.AddField("id", "id", db.Int, form.Default).FieldNotAllowAdd()

```