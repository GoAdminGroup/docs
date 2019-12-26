# 模块
---

GoAdmin在构建中，生成了一些模块，如：数据库模块，用户认证模块；本节介绍如何获取和使用。

## 数据库模块

数据库在配置后，引擎设置全局配置的时候生成，生成后可以通过引擎获取该模块的控制权。

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

	// 这里生成了数据库模块
    _ = eng.AddConfig(cfg).
        AddPlugins(adminPlugin).
        Use(r)
    
    // 获取mysql连接
    conn := eng.MysqlConnection()
    
    // 获取mssql连接
    conn := eng.MssqlConnection()
    
    // 获取postgresql连接
    conn := eng.PostgresqlConnection()

    // 获取sqlite连接
    conn := eng.SqliteConnection()

    // 注意，获取到的一个指针，指向的是全局唯一的真正的数据库连接对象。
    // 如果你要在数据模型文件中复用，那么你必须在 .Use(r) 调用前对连接对象进行设置
    // 否则会报空指针错误。比如：
    //
    // _ = eng.AddConfig(cfg).
    //     ResolveMysqlConnection(tables.SetConn)
    //     AddPlugins(adminPlugin).
    //     Use(r)
    //
    // 在tables.go文件中是：
    //
    // var conn db.Connection
    //
    // func SetConn(c db.Connection) {
    //    conn = c   
    // }
    //
    // 然后在数据模型文件中调用 conn，进行数据库操作

    // 通过setter函数获取
    eng.ResolveMysqlConnection(SetConn)

    ...
}

var globalConn db.Connection

func SetConn(conn db.Connection) {
    globalConn = conn
}
```

使用，获取到 ```connection``` 后，可以调用内置的数据库连接方法对sql数据库进行操作，如：

```go

import (
    ...
    "github.com/GoAdminGroup/go-admin/modules/db"
    "github.com/GoAdminGroup/go-admin/modules/db/dialect"
    ...
)

func main() {

    // 传入获取的数据库模块，调用sql数据库方法

    // 查询
    db.WithDriver(globalConn).Table("users").Select("id", "name").First()

    // 更新
    db.WithDriver(globalConn).Table("users").Where("id", "=", 10).
        Update(dialect.H{
            "name": "张三",
        })

    // 插入
    db.WithDriver(globalConn).Table("users").
        Insert(dialect.H{
            "name": "张三",
        })  
        
    // 删除
    db.WithDriver(globalConn).Table("users").Where("id", "=", 10).Delete()

    // 等等...
}

```

## 用户认证模块

我们编写页面内容时，需要获取对应的登录用户，并对其信息进行验证时，需要用到用户认证模块。

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
        // 获取登录用户
        user, _ := engine.User(ctx)
        
        // 验证其权限
        if !user.CheckPermission("dashboard") {
            return types.Panel{}, errors.New("没有权限") 
        }

        // 验证其角色
        if !user.CheckRole("operator") {
            return types.Panel{}, errors.New("没有权限") 
        }
	})
    ...
}
```