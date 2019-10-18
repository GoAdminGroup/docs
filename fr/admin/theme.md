# Use New Theme
---

Follow two steps：（Notice：GoAdmin version should be higher than v1.0.2）

- 1. import the theme package
- 2. set theme name in your config

Ex:

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