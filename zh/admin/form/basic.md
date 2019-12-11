# 基本使用
---

使用命令行将sql表生成一个数据表单类型，如：

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

### 添加字段

```go

// 添加一个字段，字段标题为 ID，字段名为 id，字段类型为 int，表单类型为 Default
formList.AddField("ID", "id", db.Int, form.Default)

// 添加第二个字段，字段标题为 Ip，字段名为 ip，字段类型为 varchar，表单类型为 Text
formList.AddField("Ip", "ip", db.Varchar, form.Text)

// 添加第三个字段，一个sql表不存在的字段
formList.AddField("Custom", "custom", db.Varchar, form.Text)

```

### 不允许编辑

```go

formList.AddField("id", "id", db.Int, form.Default).FieldNotAllowEdit()

```

### 不允许新增

```go

formList.AddField("id", "id", db.Int, form.Default).FieldNotAllowAdd()

```