# API 说明
---

admin插件可以通过配置全局配置项```OpenAdminApi```为true，打开JSON API。包括对表格的增删改查，导出。目前使用Cookie进行认证。

## 查询表格信息

**方法：** GET
**路径：** /api/list/:__prefix
**参数：**

|  参数名  | 参数解释  | 取值  | 例子  |
|  ----  | ----  | ----  | ----  |
|  __prefix  | 模型路由前缀  | - | user |
|  __is_all  | 是否获取全部  | true/false | true |
|  __is_all  | 是否获取全部  | true/false | true |
|  __page |  当面页码 | 整数 | 1 |
|  __pageSize |  页面数据数 | 整数 | 1 |
|  __sort |  排序字段 | 字段 | id |
|  __sort_type |  排序类型 | desc/asc | asc |
|  __columns |  隐藏的字段 | 字段以逗号分割 | name,city |
|  name |  不以__开头都是筛选字段 | 筛选的值 | jack |
|  name__goadmin_operator__ | 字段拼接上__goadmin_operator__为筛选的操作 | like,gr,gq,eq,ne,le,lq,free | like

操作符代表意思：

| 操作符 | 含义 |
| ----  | ---- |
| like | like |
| gr | > |
| gq | >= |
| eq | = |
| ne | != |
| le | < |
| lq | <= |
| free | free |

**返回：**

```

```

**例子：**

## 查询表格详情

**方法：** GET
**路径：** /api/detail/:__prefix
**参数：**

```
__prefix： 模型路由前缀


```

**返回：**

```

```

**例子：**

## 删除表格内容

**方法：** GET
**路径：** /api/list/:__prefix
**参数：**

```
__prefix： 模型路由前缀


```

**返回：**

```

```

**例子：**

## 更新表格单个记录内容

**方法：** GET
**路径：** /api/list/:__prefix
**参数：**

```
__prefix： 模型路由前缀


```

**返回：**

```

```

**例子：**


## 获取表格更新表单

**方法：** GET
**路径：** /api/list/:__prefix
**参数：**

```
__prefix： 模型路由前缀


```

**返回：**

```

```

**例子：**


## 更新表格

**方法：** GET
**路径：** /api/list/:__prefix
**参数：**

```
__prefix： 模型路由前缀


```

**返回：**

```

```

**例子：**


## 获取创建表格内容

**方法：** GET
**路径：** /api/list/:__prefix
**参数：**

```
__prefix： 模型路由前缀


```

**返回：**

```

```

**例子：**


## 创建表格

**方法：** GET
**路径：** /api/list/:__prefix
**参数：**

```
__prefix： 模型路由前缀


```

**返回：**

```

```

**例子：**


## 导出表格内容

**方法：** GET
**路径：** /api/list/:__prefix
**参数：**

```
__prefix： 模型路由前缀


```

**返回：**

```

```

**例子：**