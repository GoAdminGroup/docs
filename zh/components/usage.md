# 组件使用
---

所有组件都有```GetContent()```方法，该方法返回组件拼接完成的HTML。

## Col（列）

获取默认模板主题，再获取Col组件，设置大小后调用```GetContent()```获取组件的HTML内容。

```golang
import (
    ...
    "github.com/GoAdminGroup/go-admin/template"
    "github.com/GoAdminGroup/go-admin/template/types"
    ...
)

func xxxx() {
    col1 := template.Default().Col().
                SetContent(infobox1).             // 设置内容为infobox1
                SetSize(types.SizeXS(6).SM(3)).   // 设置大小为  xs-6 sm-3
                GetContent()
    col2 := template.Default().Col().
                SetContent(infobox2).             // 设置内容为infobox2  
                SetSize(types.SizeXS(6).SM(3)).   // 设置大小为  xs-6 sm-3
                GetContent()                
}
```

GoAdmin采用的是bootstrap的布局系统，关于size的设置，详细可以看：[https://getbootstrap.net/docs/layout/overview](https://getbootstrap.net/docs/layout/overview)

简单说，是将每一行都分为十二等份，```types.SizeXS(6).SM(3)``` 表示，在 xs 大小的时候该列宽度占六份，在 sm 大小的时候占三份。

关于不同大小的说明：

> Extra small screen / phone
> xs: 0
>
> Small screen / phone
> sm: 576px
>
> Medium screen / tablet
> md: 768px
>
> Large screen / desktop
> lg: 992px
>
> Extra large screen / wide desktop
> xl: 1200px

## Row（行）

```golang
row := template.Default().Row().
            SetContent(col1 + col2). // 设置内容为col1+col2(列1+列2)
            GetContent()
```

## Link（链接）

```golang
link := template.Default().Link().
			SetURL("/xxxxxx").  // 设置跳转路由
			SetContent("百度").  // 设置链接内容
			OpenInNewTab().  // 是否在新的tab页打开
			SetTabTitle("Manager Detail").  // 设置tab的标题
			GetContent()
```

## Image

```golang
image := template.Default().Image().
			SetSrc("/xxxxxx.jpg"). // 设置图片链接
			SetHeight("120"). // 设置高度，单位为px
            SetWidth("120"). // 设置宽度，单位为px
            WithModal(). // 是否可以点击查看
            GetContent()
```

## Label

```golang
label := template.Default().Label().
			SetContent("成功"). // 设置标签内容
            SetType("success"). // 设置标签样式：default,primary,success,info,warning,danger
            // SetColor("#ffffff"). // 设置颜色
			GetContent()
```

## Table

```golang
table := template.Default().Table().
		    SetStyle("striped").
		    SetHideThead().
		    SetMinWidth("0.01%").
		    SetThead(types.Thead{
			    types.TheadItem{Head: "key", Width: "50%"},
			    types.TheadItem{Head: "value"},
		    }).
		    SetInfoList(list).
            GetContent()
```


## DataTable

```golang
dataTable := template.Default().DataTable().
            SetInfoList([]map[string]types.InfoItem{
                {
                    "id":     {Content: "0"},
                    "name":   {Content: "Jack"},
                    "gender": {Content: "men"},
                    "age":    {Content: "20"},
                },
                {
                    "id":     {Content: "1"},
                    "name":   {Content: "Jane"},
                    "gender": {Content: "women"},
                    "age":    {Content: "23"},
                },
            }).
            SetPrimaryKey("id").
            SetThead(types.Thead{
                {Head: "ID", Field: "id"},
                {Head: "Name", Field: "name"},
                {Head: "Gender", Field: "gender"},
                {Head: "Age", Field: "age"},
            })
```

实际例子：[https://github.com/GoAdminGroup/demo.go-admin.cn/blob/master/pages/table.go](https://github.com/GoAdminGroup/demo.go-admin.cn/blob/master/pages/table.go)

## Paginator

```golang
import "github.com/GoAdminGroup/go-admin/plugins/admin/modules/paginator"

paginator.Get(paginator.Config{
				Size:         50,
				PageSizeList: []string{"10", "20", "30", "50"},
				Param:        parameter.GetParam("https://xxxxxx?xxx=xxxx", 10),
			}).GetContent()
```

实际例子：[https://github.com/GoAdminGroup/demo.go-admin.cn/blob/master/pages/table.go](https://github.com/GoAdminGroup/demo.go-admin.cn/blob/master/pages/table.go)

## Tabs

```golang
tabs := template.Default().Tabs().
        SetData([]map[string]template.HTML{
		{
			"title": "tabs1",
			"content": template.HTML(`<b>How to use:</b>

                <p>Exactly like the original bootstrap tabs except you should use
                  the custom wrapper <code>.nav-tabs-custom</code> to achieve this style.</p>
                A wonderful serenity has taken possession of my entire soul,
                like these sweet mornings of spring which I enjoy with my whole heart.
                I am alone, and feel the charm of existence in this spot,
                which was created for the bliss of souls like mine. I am so happy,
                my dear friend, so absorbed in the exquisite sense of mere tranquil existence,
                that I neglect my talents. I should be incapable of drawing a single stroke
                at the present moment; and yet I feel that I never was a greater artist than now.`),
		}, {
			"title": "tabs2",
			"content": template.HTML(`
                The European languages are members of the same family. Their separate existence is a myth.
                For science, music, sport, etc, Europe uses the same vocabulary. The languages only differ
                in their grammar, their pronunciation and their most common words. Everyone realizes why a
                new common language would be desirable: one could refuse to pay expensive translators. To
                achieve this, it would be necessary to have uniform grammar, pronunciation and more common
                words. If several languages coalesce, the grammar of the resulting language is more simple
                and regular than that of the individual languages.
              `),
		}, {
			"title": "tabs3",
			"content": template.HTML(`
                Lorem Ipsum is simply dummy text of the printing and typesetting industry.
                Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
                when an unknown printer took a galley of type and scrambled it to make a type specimen book.
                It has survived not only five centuries, but also the leap into electronic typesetting,
                remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset
                sheets containing Lorem Ipsum passages, and more recently with desktop publishing software
                like Aldus PageMaker including versions of Lorem Ipsum.
              `),
		},
	}).GetContent()
```

## Popup

```golang
popup := template.Default().Popup().
        SetID("exampleModal"). // 设置ID
		SetFooter("Save Change"). // 设置底部HTML
		SetTitle("this is a popup"). // 设置标题
		SetBody(`<h1>Hello</h1>`). // 设置内容
		GetContent()
```

## Box

```golang
box := template.Default().Box().
		WithHeadBorder(). // 带顶部的边栏
		SetHeader("Latest Orders"). // 设置头部内容
		SetHeadColor("#f7f7f7"). // 设置头部背景色
		SetBody(`Hello`). // 设置内容
		SetFooter(`<div class="clearfix"><a href="javascript:void(0)" class="btn btn-sm btn-info btn-flat pull-left">处理订单</a><a href="javascript:void(0)" class="btn btn-sm btn-default btn-flat pull-right">查看所有新订单</a></div>`). // 设置底部HTML
		GetContent()
```

## Form

```golang
var panel = types.NewFormPanel()
panel.AddField("名字", "name", db.Varchar, form.Text)
panel.AddField("年龄", "age", db.Int, form.Number)
panel.AddField("主页", "homepage", db.Varchar, form.Url).FieldDefault("http://google.com")
panel.AddField("邮箱", "email", db.Varchar, form.Email).FieldDefault("xxxx@xxx.com")
panel.AddField("生日", "birthday", db.Varchar, form.Datetime).FieldDefault("2010-09-05")
panel.AddField("密码", "password", db.Varchar, form.Password)
panel.AddField("IP", "ip", db.Varchar, form.Ip)
panel.AddField("证件", "certificate", db.Varchar, form.Multifile).FieldOptionExt(map[string]interface{}{
    "maxFileCount": 10,
})
panel.AddField("金额", "currency", db.Int, form.Currency)
panel.AddField("内容", "content", db.Text, form.RichText).
    FieldDefault(`<h1>343434</h1><p>34344433434</p><ol><li>23234</li><li>2342342342</li><li>asdfads</li></ol><ul><li>3434334</li><li>34343343434</li><li>44455</li></ul><p><span style="color: rgb(194, 79, 74);">343434</span></p><p><span style="background-color: rgb(194, 79, 74); color: rgb(0, 0, 0);">434434433434</span></p><table border="0" width="100%" cellpadding="0" cellspacing="0"><tbody><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr></tbody></table><p><br></p><p><span style="color: rgb(194, 79, 74);"><br></span></p>`)

panel.AddField("站点开关", "website", db.Tinyint, form.Switch).
    FieldHelpMsg("站点关闭后将不能访问，后台可正常登录").
    FieldOptions(types.FieldOptions{
        {Value: "0"},
        {Value: "1"},
    })
panel.AddField("水果", "fruit", db.Varchar, form.SelectBox).
    FieldOptions(types.FieldOptions{
        {Text: "苹果", Value: "apple"},
        {Text: "香蕉", Value: "banana"},
        {Text: "西瓜", Value: "watermelon"},
        {Text: "梨", Value: "pear"},
    }).
    FieldDisplay(func(value types.FieldModel) interface{} {
        return []string{"梨"}
    })
panel.AddField("性别", "gender", db.Tinyint, form.Radio).
    FieldOptions(types.FieldOptions{
        {Text: "男生", Value: "0"},
        {Text: "女生", Value: "1"},
    })
panel.AddField("饮料", "drink", db.Tinyint, form.Select).
    FieldOptions(types.FieldOptions{
        {Text: "啤酒", Value: "beer"},
        {Text: "果汁", Value: "juice"},
        {Text: "白开水", Value: "water"},
        {Text: "红牛", Value: "red bull"},
    }).FieldDefault("beer")
panel.AddField("工作经验", "experience", db.Tinyint, form.SelectSingle).
    FieldOptions(types.FieldOptions{
        {Text: "两年", Value: "0"},
        {Text: "三年", Value: "1"},
        {Text: "四年", Value: "2"},
        {Text: "五年", Value: "3"},
    }).FieldDefault("beer")
panel.SetTabGroups(types.TabGroups{
    {"name", "age", "homepage", "email", "birthday", "password", "ip", "certificate", "currency", "content"},
    {"website", "fruit", "gender", "drink", "experience"},
})
panel.SetTabHeaders("input", "select")

fields, headers := panel.GroupField()

aform := template.Default().Form().
    SetTabHeaders(headers).
    SetTabContents(fields).
    SetPrefix(config.PrefixFixSlash()).
    SetUrl("/admin/form/update"). // 设置表单请求路由
    SetTitle("Form").
    SetHiddenFields(map[string]string{
        form2.PreviousKey: "/admin",
    }).
    SetOperationFooter(col1 + col2).
    GetContent()
```

实际例子：[https://github.com/GoAdminGroup/demo.go-admin.cn/blob/master/pages/form.go](https://github.com/GoAdminGroup/demo.go-admin.cn/blob/master/pages/form.go)

## Button

```golang
button := template.Default().Button().
        SetType("submit"). // 设置类型
		SetContent("Save"). // 设置内容
		SetThemePrimary(). // 设置主题
		GetContent()
```

## Alert

获取一个警告框

```golang
alert := template.Default().Alert().Warning("内部错误")
```

## Tree

获取一个菜单树

```golang
tree := template.Default().Tree().
		SetTree(MenuList). // 设置内容
		SetEditUrl("/xxxx"). // 设置编辑路由
		SetUrlPrefix(config.GetPrefix()). // 设置全局路由前缀
		SetDeleteUrl("/xxxxx"). // 设置删除路由
		SetOrderUrl("/xxxxx"). // 设置排序路由
        GetContent()
        
// 内容为一个 []Item 类型，Item 定义如下：

type Item struct {
	Name         string
	ID           string
	Url          string
	Icon         string
	Header       string
	Active       string
	ChildrenList []Item
}

// 因此需要用户去生成这样一个树数据结构，然后传到 tree 当中。
```