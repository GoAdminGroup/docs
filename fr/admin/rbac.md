# Authority management
---

GoAdmin has built in [RBAC] (https://www.google.com/search?oq=rbac) permission control module. After entering the home page as a super administrator, expand the management of the left sidebar. There are three management panels for users, roles, and permissions:

![rbac](http://quick.go-admin.cn/docs/rbac.png)


## Instructions

On a form of management, the corresponding routing to add and delete, assuming that form called ` ` ` users ` ` `, as follows:

|  Permission   | url path  | method  | 
|  ----  | ----  | ----  |
| List page | /info/users | GET |
| Edit page | /info/users/edit | GET |
| New page | /info/user/new | GET |
| All permission | * | (empty)

**Note: the role of permissions is higher than in the menu configuration**

That is to say, assuming the menu 1, corresponding operator is the role of, and have all permissions users can still access the menu 1.