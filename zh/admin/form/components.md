# 表单组件使用
---

## 文本类型

### Default

```go
formList.AddField("name", "name", db.Varchar, form.Default)
```

### Text

```go
formList.AddField("name", "name", db.Varchar, form.Text)
```

### IconPicker

```go
formList.AddField("icon", "icon", db.Varchar, form.IconPicker)
```


### File

```go
formList.AddField("file", "file", db.Varchar, form.File)
```

### Password

```go
formList.AddField("password", "password", db.Varchar, form.Password)
```

### RichText

```go
formList.AddField("content", "content", db.Varchar, form.RichText)
```

### Datetime

```go
formList.AddField("birthday", "birthday", db.Varchar, form.Datetime)
```

### Email

```go
formList.AddField("email", "email", db.Varchar, form.Email)
```

### Url

```go
formList.AddField("url", "url", db.Varchar, form.Url)
```

### Ip

```go
formList.AddField("ip", "ip", db.Varchar, form.Ip)
```

### Code
```go
formList.AddField("code", "code", db.Text, form.Code)
formList.AddField("code", "code", db.Text, form.Code).FieldOptionExt(map[string]interface{}{
    "theme": "monokai",
    "font_size": 14,
    "language": "php",
    "options": "{useWorker: false}",
})
```

### Color

```go
formList.AddField("color", "color", db.Varchar, form.Color)
```

### Currency

```go
formList.AddField("money", "money", db.Varchar, form.Currency)
```

### Number

```go
formList.AddField("num", "num", db.Varchar, form.Number)
```

### TextArea

```go
formList.AddField("content", "content", db.Varchar, form.TextArea)
```

## 选择类型

### SelectSingle

```go
formList.AddField("sex", "sex", db.Int, form.SelectSingle).
        // 单选的选项，text代表显示内容，value代表对应值
		FieldOptions(types.FieldOptions{ 
            {Text: "man",Value: "0"},
            {Text: "women",Value: "1"},
        }).
        // 设置默认值
        FieldDefault("0")
```

### Select

```go
formList.AddField("drink", "drink", db.Int, form.Select).
        // 多选的选项，text代表显示内容，value代表对应值
		FieldOptions(types.FieldOptions{
            {
                Text: "beer",
                Value: "beer",
            }, {
                Text: "juice",
                Value: "juice",
            }, {
                Text: "water",
                Value: "water",
            }, {
                Text: "red bull",
                Value: "red bull",
            },
        }).
        // 这里返回一个[]string，对应的值是本列的drink字段的值，即编辑表单时会显示的对应值
        FieldDisplay(func(model types.FieldModel) interface{} {
            return []string{"beer"}
        })
```

### Radio

```go
formList.AddField("gender", "gender", db.Int, form.Radio).
        // radio的选项，Text代表显示内容，Value代表对应值
		FieldOptions(types.FieldOptions{
            {Text: "male",Value: "0"},
            {Text: "female",Value: "1"},
        }).
        FieldDefault("0") // 设置默认的值
```

### Switch

```go
formList.AddField("site", "site", db.Int, form.Switch).
        // switch的选项，Text代表显示内容，Value代表对应值
		FieldOptions(types.FieldOptions{
			{Text: trueStr, Value: "true"},
			{Text: falseStr, Value: "false"},
		})
        FieldDefault("0") // 设置默认的值
```

### SelectBox

```go
formList.AddField("fruit", "fruit", db.Int, form.SelectBox).
        // 多选的选项，text代表显示内容，value代表对应值
		FieldOptions(types.FieldOptions{
            {
                Text: "apple",
                Value: "apple",
            }, {
                Text: "banana",
                Value: "banana",
            }, {
                Text: "watermelon",
                Value: "watermelon",
            }, {
                Text: "pear",
                Value: "pear",
            },
        }).
        // 这里返回一个[]string，对应的值是本列的fruit字段的值，即编辑表单时会显示的对应值
        FieldDisplay(func(model types.FieldModel) interface{} {
            return []string{"pear"}
        })
```

### 表单选择类型动态加载

从ajax中加载数据：

```go

import "github.com/GoAdminGroup/go-admin/template/types/form/select"

formList.AddField("City", "city", db.Int, form.SelectSingle).        
        // 第一个参数为 ajax 路由
        // 第二个参数为 路由对应的控制器方法。路由和控制器方法将会被注入到web框架中
        // 第三个参数为 搜索延时，单位为毫秒，可以不传，不传默认为 500 毫秒
		FieldOnSearch("/search/city", func(ctx *context.Context) (success bool, msg string, data interface{}, 1000) {
            return true, "ok", selection.Data{
                Results: selection.Options{
                    {Text: "广州", ID: "0"},
                    {Text: "深圳", ID: "1"},
                    {Text: "北京", ID: "2"},
                    {Text: "上海", ID: "3"},
                }
            }
        }).
        FieldOptionInitFn(func(val types.FieldModel) types.FieldOptions {
            // 编辑时的显示，根据行数据 val 返回options
            return types.FieldOptions{
                {Text: val.Value, ID: "0"}
            }
        }).
        // 设置默认值
        FieldDefault("0")
```

表单联动 API 说明：

```go
// 自定义js，选中后触发该js内容
func (f *FormPanel) FieldOnChooseCustom(js template.HTML) *FormPanel

// 选中后触发内容，传入map，格式为：
// map[string]types.LinkField{
//		"men": {Field: "ip", Value:"127.0.0.1"},	 
//		"women": {Field: "ip", Hide: true},
//		"other": {Field: "ip", Disable: true}
// }
// 意思是选中的值为men，则将ip这个表单项设置为127.0.0.1
// 选中的值为women，则将ip这个表单项设置为隐藏
// 选中的值为other，则将ip这个表单项设置为禁止输入
func (f *FormPanel) FieldOnChooseMap(m map[string]LinkField) *FormPanel

// 选中后触发，如果选中值为val，则将field这个表单项设置为value
func (f *FormPanel) FieldOnChoose(val, field string, value template.HTML) *FormPanel

// 选中后触发Ajax，选中后将选中的值通过ajax经url发到handler，返回的内容(data)将赋给field这个表单项，
// 如果返回的是字符串将直接赋值，如果返回的是对象则会赋为下拉表单的选项。对象格式为：
// [{"id":0, "text":"men"}, {"id":1, "text":"women"}]
func (f *FormPanel) FieldOnChooseAjax(field, url string, handler Handler) *FormPanel

// 选中后触发，如果选中值为val，则将对应field的表单项隐藏
func (f *FormPanel) FieldOnChooseHide(value string, field ...string) *FormPanel

// 选中后触发，如果选中值为val，则将对应field的表单项显示
func (f *FormPanel) FieldOnChooseShow(value string, field ...string) *FormPanel

// 选中后触发，如果选中值为val，则将对应field的表单项禁止
func (f *FormPanel) FieldOnChooseDisable(value string, field ...string) *FormPanel
```

## 自定义类型

### Custom

自定义表单内容

```go
formList.AddField("content", "content", db.Varchar, form.Custom).
    FieldCustomContent(template.HTML(``)).
    FieldCustomCss(template.CSS(``)).
    FieldCustomJs(template.JS(``))
```

以下表单自定义的模板文件结构，设置的```CustomContent```，```CustomCss```，```CustomJs```将插入到以下对应的位置。

```go
{{define "form_custom"}}
    {{if eq .Must true}}
        <label for="{{.Field}}" class="col-sm-2 asterisk control-label">{{.Head}}</label>
    {{else}}
        <label for="{{.Field}}" class="col-sm-2 control-label">{{.Head}}</label>
    {{end}}
    <div class="col-sm-8">
        <div class="input-group">
            {{.CustomContent}}
        </div>
    </div>
    {{if .CustomJs}}
        <script>
            {{.CustomJs}}
        </script>
    {{end}}
    {{if .CustomCss}}
        <style>
            {{.CustomCss}}
        </style>
    {{end}}
{{end}}
```

在```CustomContent```，```CustomCss```，```CustomJs```中会传入一个```FormField```类型进行模板渲染，定义如下：

```golang
type FormField struct {
	Field    string  // 字段名
	TypeName db.DatabaseType
	Head     string  // 表单字段头部名
	FormType form2.Type

	Default                template.HTML
	Value                  template.HTML // 字段值
	Value2                 string
	Options                FieldOptions
	DefaultOptionDelimiter string
	Label                  template.HTML

	Placeholder string

	CustomContent template.HTML
	CustomJs      template.JS
	CustomCss     template.CSS

	Editable    bool
	NotAllowAdd bool
	Must        bool
	Hide        bool

	Width int

	Join Join

	HelpMsg template.HTML

	OptionExt    template.JS
	OptionInitFn OptionInitFn
	OptionTable  OptionTable

	FieldDisplay
	PostFilterFn PostFieldFilterFn
}
```

因此可以在```CustomContent```中，使用这样的模板语法来表示编辑时字段的值：```{{.Value}}```
