# Customize authentication user table
---

The authentication user table of the framework is the most basic information, if you need to customize a lot of extra information, such as mobile phone/IP/gender, etc. You can custom an authentication user table.

First, you need to prepare your own user table. Such as: goadmin_super_manager。And then modify configuration item ```auth_user_table``` in the global configuration. Then generate data model file, overwriting the official user table model file: 

**Note: the user table fields remain with the official line, then on the basis of the official user table field extension.**

```go
import (
    ...
    "github.com/GoAdminGroup/go-admin/engine"
    ...
)

func main() {

    ...

    eng := engine.Default()

	cfg := config.Config{
        ...
		AuthUserTable: "goadmin_super_manager",
        ...
    }

    if err := eng.AddConfig(cfg).
        // Super administrator access, data model logic can refer to the official documents:https://github.com/GoAdminGroup/go-admin/blob/master/plugins/admin/modules/table/generators.go#L40
        AddGenerator("manager", GetGoAdminSuperManager).
        // Ordinary users to access
        AddGenerator("normal_manager", GetGoAdminSuperNormalManager).
        ...
        Use(r); err != nil {
        panic(err)
    }

    ...
    
}
```