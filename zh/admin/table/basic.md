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

### 禁用编辑按钮

```go
info.HideEditButton()
```

### 禁用导出按钮

```go
info.HideExportButton()
```

### 禁用删除按钮

```go
info.HideDeleteButton()
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