# 自定义认证用户表
---

官方提供的管理用户表是最基本的信息，如果你需要自定义很多信息，比如管理用户的手机/IP/性别等等。那么你可以自定义认证用户表来实现。

首先你需要准备好自己的用户表，比方说叫：goadmin_super_manager。然后在全局配置中修改配置```auth_user_table```为goadmin_super_manager，接着生成数据模型文件，覆盖掉官方的用户表模型文件。如下：

**注意：用户表字段保持跟官方一致，然后在官方用户表基础上进行字段扩展。**

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
        // 超级管理员访问，数据模型文件逻辑可以参考官方：https://github.com/GoAdminGroup/go-admin/blob/master/plugins/admin/modules/table/generators.go#L40
        AddGenerator("manager", GetGoAdminSuperManager).
        // 普通用户访问
        AddGenerator("normal_manager", GetGoAdminSuperNormalManager).
        ...
        Use(r); err != nil {
        panic(err)
    }

    ...
    
}
```