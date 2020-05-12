# API 说明
---

admin插件可以通过配置全局配置项```OpenAdminApi```为true，打开JSON API。包括对表格的增删改查，导出。目前仅支持使用Cookie进行认证。

## 查询表格信息

**方法：** GET
**路径：** /api/list/:__prefix
**参数：**

|  参数名  | 参数解释  | 取值  | 例子  |
|  ----  | ----  | ----  | ----  |
|  __prefix  | 模型路由前缀  | - | user |
|  __is_all  | 是否获取全部  | true/false | true |
|  __page |  当面页码 | 整数 | 1 |
|  __pageSize |  页面数据数 | 整数 | 1 |
|  __sort |  排序字段 | 字段 | id |
|  __sort_type |  排序类型 | desc/asc | asc |
|  __columns |  隐藏的字段 | 字段以逗号分割 | name,city |
|  name |  不以__开头参数都是筛选字段 | 筛选的值 | jack |
|  name__goadmin_operator__ | 字段拼接上__goadmin_operator__为筛选的操作 | like,gr,gq,eq,ne,le,lq,free | like |

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
todo
```

**例子：**

```
todo
```

## 查询表格详情

**方法：** GET
**路径：** /api/detail/:__prefix
**参数：**

|  参数名  | 参数解释  | 取值  | 例子  |
|  ----  | ----  | ----  | ----  |
|  __prefix  | 模型路由前缀  | - | user |
|  __goadmin_detail_pk  | 主键值  | - | 3 |

**返回：**

```
todo
```

**例子：**

```
todo
```

## 删除表格内容

**方法：** POST
**头部：** content-type: multipart/form-data
**路径：** /api/delete/:__prefix
**参数：**

|  参数名  | 参数解释  | 取值  | 例子  |
|  ----  | ----  | ----  | ----  |
|  __prefix  | 模型路由前缀  | - | user |
|  id  | 主键值  | - | 3 |


**返回：**

```
todo
```

**例子：**

```
todo
```

## 更新表格单个记录内容

**方法：** GET
**头部：** content-type: multipart/form-data
**路径：** /api/update/:__prefix
**参数：**

|  参数名  | 参数解释  | 取值  | 例子  |
|  ----  | ----  | ----  | ----  |
|  __prefix  | 模型路由前缀  | - | user |
|  pk  | 主键值  | - | 3 |
|  name  | 要更新字段  | - | name |
|  value  | 要更新字段的值  | - | Jack |


**返回：**

```
todo
```

**例子：**

```
todo
```


## 获取更新表单内容

**方法：** GET
**路径：** /api/edit/form/:__prefix
**参数：**

|  参数名  | 参数解释  | 取值  | 例子  |
|  ----  | ----  | ----  | ----  |
|  __prefix  | 模型路由前缀  | - | user |
|  __goadmin_edit_pk  | 主键值  | - | 3 |


**返回：**

```
todo
```

**例子：**

```
todo
```


## 更新表格

**方法：** GET
**路径：** /api/edit/:__prefix
**参数：**

|  参数名  | 参数解释  | 取值  | 例子  |
|  ----  | ----  | ----  | ----  |
|  __prefix  | 模型路由前缀  | - | user |
|  __goadmin_edit_pk  | 主键值  | - | 3 |


**返回：**

```
todo
```

**例子：**

```
todo
```


## 获取创建表单内容

**方法：** GET
**路径：** /api/create/form/:__prefix
**参数：**

|  参数名  | 参数解释  | 取值  | 例子  |
|  ----  | ----  | ----  | ----  |
|  __prefix  | 模型路由前缀  | - | user |


**返回：**

```
todo
```

**例子：**

```
todo
```


## 创建表格

**方法：** GET
**路径：** /api/create/:__prefix
**参数：**

|  参数名  | 参数解释  | 取值  | 例子  |
|  ----  | ----  | ----  | ----  |
|  __prefix  | 模型路由前缀  | - | user |


**返回：**

```
todo
```

**例子：**

```
todo
```


## 导出表格内容

**方法：** GET
**路径：** /api/export/:__prefix
**参数：**

|  参数名  | 参数解释  | 取值  | 例子  |
|  ----  | ----  | ----  | ----  |
|  __prefix  | 模型路由前缀  | - | user |
|  is_all  | 是否导出全部  | true/false | true |
|  id  | 导出记录id，逗号分割  | - | 3,4,5 |


**返回：**

```
todo
```

**例子：**

```
todo
```