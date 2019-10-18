# Basic Usage
---

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

func GetUserTable() (userTable table.Table) {

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