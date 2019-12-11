# 权限管理

GoAdmin已经内置了[RBAC](https://www.baidu.com/s?wd=rbac)权限控制模块。以超级管理员身份进入主页后，展开左侧边栏的管理，下面有用户、角色、权限三项的管理面板：

![rbac](http://quick.go-admin.cn/docs/rbac.png)

## 说明

关于某个表格的管理，相应的增删改查路由为，假设表格名为`users`，如下：

| 权限 | 路由 | 方法 |
| :--- | :--- | :--- |
| 列表页面 | /info/users | GET |
| 所有记录编辑页面 | /info/users/edit | GET |
| 指定记录编辑页面 | /info/users/edit?id=2 | GET |
| 所有记录编辑操作 | /edit/users | POST |
| 指定记录编辑操作 | /edit/users?id=2 | POST |
| 新增页面 | /info/users/new | GET |
| 新建操作 | /new/users | POST |
| 导出操作 | /export/users | POST |
| 所有权限 | \* | \(留空\) |

**注意1：设置了权限并不意味着左侧菜单就可以看到了**

设置了权限，如果需要左侧菜单显示出来，还需要在菜单编辑页面中设置**对应的角色**

**注意2：权限设置的高于在菜单配置的角色**

也就是说，假设菜单1，对应的角色是operator，而拥有所有权限的用户依然可以访问菜单1。

