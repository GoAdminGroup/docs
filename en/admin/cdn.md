# Setting CDN
---

For your website set up CDN, static resources need to be placed into your CDN website.

The official built-in themes of static resources:

- [adminlte](https://github.com/GoAdminGroup/themes/tree/master/adminlte/resource/assets/dist)
- [sword](https://github.com/GoAdminGroup/themes/tree/master/sword/resource/assets/dist)

After set up your cdn, you should keep the assets/dist directory. Which means if your cdn address is https://xxxx-cdn.xxxx.com. Then the resource request url is like: https://xxxx-cdn.xxxx.com/assets/dist/css/..../xxxx.css

To take effect also need to set in the global configuration: asset_url items.