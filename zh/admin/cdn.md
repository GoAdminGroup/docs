# 设置cdn
---

为您的网站设置cdn，需要将静态资源放置到您的cdn网站上。

官方内置主题的静态资源：

- [adminlte](https://github.com/GoAdminGroup/themes/tree/master/adminlte/resource/assets/dist)
- [sword](https://github.com/GoAdminGroup/themes/tree/master/sword/resource/assets/dist)

放到cdn后，需保留assets/dist文件夹。也就说如果你的cdn地址是：https://xxxx-cdn.xxxx.com，那么资源请求地址就是：https://xxxx-cdn.xxxx.com/assets/dist/css/..../xxxx.css

要生效还需要设置全局配置中的：asset_url项。