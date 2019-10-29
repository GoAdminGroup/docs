# 使用新主题
---

使用新主题需要两步：（注意：GoAdmin版本需要在v1.0.6以上）

- 1. 引入新主题包
- 2. 全局配置中配置新主题名

如：

```go
package main

import (
	...

	_ "github.com/GoAdminGroup/themes/sword"

    ...
)

func main() {
	r := gin.Default()

	gin.SetMode(gin.ReleaseMode)
	gin.DefaultWriter = ioutil.Discard

	eng := engine.Default()

	cfg := config.Config{
		...

		Theme:    "sword",

        ...
	}

    ...
}
```