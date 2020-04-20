# 使用新主题
---

使用新主题需要两步：（注意：GoAdmin版本需要在v1.0.2以上）

- 引入新主题包
- 全局配置中配置新主题名

如：

```go
package main

import (
	...

	_ "github.com/GoAdminGroup/themes/sword" // 引入 sword 主题包

    ...
)

func main() {
	r := gin.Default()

	gin.SetMode(gin.ReleaseMode)
	gin.DefaultWriter = ioutil.Discard

	eng := engine.Default()

	cfg := config.Config{
		...

		Theme:    "sword", // 配置主题名字

        ...
	}

    ...
}
```

当然你可以引入多个主题，设置一个默认主题后，可以在实时配置中心进行切换。