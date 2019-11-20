# 权限管理
---

GoAdmin已经内置了[RBAC](https://www.baidu.com/s?wd=rbac)权限控制模块。以超级管理员身份进入主页后，展开左侧边栏的管理，下面有用户、角色、权限三项的管理面板：

![rbac](http://quick.go-admin.cn/docs/rbac.png)

## 说明

关于某个表格的管理，相应的增删改查路由为，假设表格名为```users```，如下：

|  权限   | 路由  | 方法  | 
|  ----  | ----  | ----  |
| 列表页面 | /info/users | GET |
| 编辑页面 | /info/users/edit | GET |
| 新增页面 | /info/user/new | GET |
| 所有权限 | * | (留空)

**注意：权限设置的高于在菜单配置的角色**

也就是说，假设菜单1，对应的角色是operator，而拥有所有权限的用户依然可以访问菜单1。