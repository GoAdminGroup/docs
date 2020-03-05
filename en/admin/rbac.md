# Authority management
---

GoAdmin has built in [RBAC] (https://www.google.com/search?oq=rbac) permission control module. After entering the home page as a super administrator, expand the management of the left sidebar. There are three management panels for users, roles, and permissions:

![rbac](http://quick.go-admin.cn/docs/rbac.png)


## Instructions

Permission management is the route and method for limit, the route url can use golang regular match rules. As long as the method and route to correspond, permission test will pass. So the need to each route and method for configuration, so as to decide the granularity of its permission.

On a form of management, the corresponding routing to add and delete, assuming that form called ` ` ` users ` ` `, as follows:

|  Permission   | url path  | method  | 
|  ----  | ----  | ----  |
| List page | /info/users | GET |
| Edit page of all rows | /info/users/edit | GET |
| Edit page of specify row | /info/users/edit?id=2 | GET |
| Edit operation of all rows | /edit/users | POST |
| Edit operation of specify row | /edit/users?id=2 | POST |
| New page | /info/users/new | GET |
| Create operation | /new/users | POST |
| Export operation | /export/users | POST |
| All permission | * | (empty)

**Note: instructions of route matching rules**

As you can see, there is such like ```id=2``` parameters in the url of the table above. It is a rule of the admin plugin, that is if the request url has the parameters that are on the match of the parameters of the rule url, it will pass the permission test. In addition, the parameters, **__goadmin_edit_pk**， **__goadmin_detail_pk**，**__goadmin_detail_pk** can be replaced as **id**. For example: 

> verifying request url: /info/users/edit?__page=1&__pageSize=10&__sort=id&__sort_type=desc&__goadmin_edit_pk=3632
> rule url: /info/users/edit?id=3632
> test result: pass

**Note: set up the authority does not mean the left side menu can be seen**

Set the permissions, if need to display on the left side of the menu, you also need to in the menu editor page set up corresponding role.

**Note: the role of permissions is higher than in the menu configuration**

That is to say, assuming the menu 1, corresponding operator is the role of, and have all permissions users can still access the menu 1.