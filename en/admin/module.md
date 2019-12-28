# Modules
---

When GoAdmin engine is building, some modules are built. Such as: database module, user authentication module. And this chapter tells you how to reuse the modules.

## Database Module

Database module can be used afrer the engine set the global config. For example:

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
		Databases: config.DatabaseList{
			"default": {
				Host:       "127.0.0.1",
				Port:       "3306",
				User:       "root",
				Pwd:        "root",
				Name:       "godmin",
				MaxIdleCon: 50,
				MaxOpenCon: 150,
				Driver:     config.DriverMysql,
			},
		},
        ...
	}
	
    _ = eng.AddConfig(cfg). // Here the database module built.
        AddPlugins(adminPlugin).
        Use(r)
    
    // get mysql connection
    conn := eng.MysqlConnection()
    
    // get postgresql connection
    conn := eng.PostgresqlConnection()

    // get sqlite connection
    conn := eng.SqliteConnection()

    // Note: you get a pointer here which is point to the global database connection object.
    // If you want to reuse in you table models file, then you should call before the .Use(r) method.
    // Or it will panic. Like:
    //
    // _ = eng.AddConfig(cfg).
    //     ResolveMysqlConnection(tables.SetConn)
    //     AddPlugins(adminPlugin).
    //     Use(r)
    //
    // In your tables.go:
    //
    // var conn db.Connection
    //
    // func SetConn(c db.Connection) {
    //    conn = c   
    // }
    // 
    // And then you call the conn in your table model file.

    // get connection by setter function
    eng.ResolveMysqlConnection(SetConn)

    ...
}

var globalConn db.Connection

func SetConn(conn db.Connection) {
    globalConn = conn
}
```

When you receive ```connection``` object, you can call the built-in sql helper methods: 

```go

import (
    ...
    "github.com/GoAdminGroup/go-admin/modules/db"
    "github.com/GoAdminGroup/go-admin/modules/db/dialect"
    ...
)

func main() {

    // query
    db.WithDriver(globalConn).Table("users").Select("id", "name").First()

    // update
    db.WithDriver(globalConn).Table("users").Where("id", "=", 10).
        Update(dialect.H{
            "name": "jack",
        })

    // insert
    db.WithDriver(globalConn).Table("users").
        Insert(dialect.H{
            "name": "jack",
        })  
        
    // delete
    db.WithDriver(globalConn).Table("users").Where("id", "=", 10).Delete()

    // and so on...
}

```

## User Authentication Module

When we write the page content, need to get the corresponding login user, and to validate its information, need to use user authentication module.

```go

import (
    ...
    adapter "github.com/GoAdminGroup/go-admin/adapter/gin"
    "github.com/GoAdminGroup/go-admin/engine"
    ...
)

func main() {

    ...

    eng := engine.Default()

	cfg := config.Config{        
        ...
    }
    
    if err := eng.AddConfig(cfg).
		AddPlugins(adminPlugin, examplePlugin).
		Use(r); err != nil {
		panic(err)
	}

    r.GET("/admin", adapter.Content(func(ctx *gin.Context) (types.Panel, error) {
        // get the auth user
        user, _ := engine.User(ctx)
        
        // Verify the permissions
        if !user.CheckPermission("dashboard") {
            return types.Panel{}, errors.New("没有权限") 
        }

        // Verify the roles
        if !user.CheckRole("operator") {
            return types.Panel{}, errors.New("没有权限") 
        }
	})
    ...
}
```