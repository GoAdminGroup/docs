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
	
    _ = eng.AddConfig(cfg). // 这里生成了数据库模块，获取连接需要再AddConfig之后
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

使用，获取到 ```connection``` 后，可以调用内置的数据库sql连接辅助方法库对sql数据库进行操作，如：

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
    
    // 指定连接，第一个参数为连接名，也就是全局配置config.Config中的Databases的key
    db.WithDriverAndConnection(connName string, conn Connection)

    // 等等...
}

```

也可以直接使用 ```Connection``` 的api，进行操作，定义如下：

```go
// Connection is a connection handler of database.
type Connection interface {

    // 初始化
	InitDB(cfg map[string]config.Database) Connection

	// 获取驱动名
	Name() string

    // 关闭连接
	Close() []error

	// 获取分隔符
	GetDelimiter() string

    // 获取DB对象
	GetDB(key string) *sql.DB

	// 查询方法，使用默认连接
	Query(query string, args ...interface{}) ([]map[string]interface{}, error)

	// Exec方法，使用默认连接
	Exec(query string, args ...interface{}) (sql.Result, error)

	// 查询方法，使用指定连接，第一个参数为连接名，也就是全局配置config.Config中的Databases的key
	QueryWithConnection(conn, query string, args ...interface{}) ([]map[string]interface{}, error)

	// Exec方法，使用指定连接
	ExecWithConnection(conn, query string, args ...interface{}) (sql.Result, error)

    // 以下是事务操作：

    // 开始事务
    BeginTx() *sql.Tx
	QueryWithTx(tx *sql.Tx, query string, args ...interface{}) ([]map[string]interface{}, error)
	ExecWithTx(tx *sql.Tx, query string, args ...interface{}) (sql.Result, error)
	BeginTxWithReadUncommitted() *sql.Tx
	BeginTxWithReadCommitted() *sql.Tx
	BeginTxWithRepeatableRead() *sql.Tx
	BeginTxWithLevel(level sql.IsolationLevel) *sql.Tx
	BeginTxWithReadUncommittedAndConnection(conn string) *sql.Tx
	BeginTxWithReadCommittedAndConnection(conn string) *sql.Tx
	BeginTxWithRepeatableReadAndConnection(conn string) *sql.Tx
	BeginTxAndConnection(conn string) *sql.Tx
	BeginTxWithLevelAndConnection(conn string, level sql.IsolationLevel) *sql.Tx	
}
```

当然也可以使用orm，比如```gorm```，如下：

```go
package main

import (
    ...
    "github.com/jinzhu/gorm"
    ...
)

func initORM() {
    // 这里的conn为上面的connection对象
    orm, _ := gorm.Open("mysql", conn.GetDB("default"))
    // gorm用法，详见：https://gorm.io/zh_CN/docs/index.html
}
```

## 用户认证模块

我们编写页面内容时或在数据模型文件中，需要获取对应的登录用户，并对其信息进行验证时，需要用到用户认证模块。

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

在数据模型文件中获取登录用户：

```go

import (
    ...
    "github.com/GoAdminGroup/go-admin/modules/auth"
    "github.com/GoAdminGroup/go-admin/plugins/admin/models"
    ...
)

func GetUserTable(ctx *context.Context) table.Table {
    // 获取登录用户模型
    user = auth.Auth(ctx)
}

```