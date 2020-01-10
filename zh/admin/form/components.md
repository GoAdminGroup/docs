# 表单组件使用
---

## Default

```go
formList.AddField("name", "name", db.Varchar, form.Default)
```

## Text

```go
formList.AddField("name", "name", db.Varchar, form.Text)
```

## SelectSingle

```go
formList.AddField("sex", "sex", db.Int, form.SelectSingle).
        // 单选的选项，field代表显示内容，value代表对应值
		FieldOptions([]map[string]string{ 
            {"field": "man","value": "0"},
            {"field": "women","value": "1"},
        }).
        // 这里返回一个[]string，对应的值是本列的sex字段的值，即编辑表单时会显示的对应值
        FieldDisplay(func(model types.FieldModel) interface{} {
            return []string{"0"}
        })
```

## Select

```go
formList.AddField("drink", "drink", db.Int, form.Select).
        // 多选的选项，field代表显示内容，value代表对应值
		FieldOptions([]map[string]string{
            {
                "field": "beer",
                "value": "beer",
            }, {
                "field": "juice",
                "value": "juice",
            }, {
                "field": "water",
                "value": "water",
            }, {
                "field": "red bull",
                "value": "red bull",
            },
        }).
        // 这里返回一个[]string，对应的值是本列的drink字段的值，即编辑表单时会显示的对应值
        FieldDisplay(func(model types.FieldModel) interface{} {
            return []string{"beer"}
        })
```

## IconPicker

```go
formList.AddField("icon", "icon", db.Varchar, form.IconPicker)
```

## SelectBox

```go
formList.AddField("fruit", "fruit", db.Int, form.SelectBox).
        // 多选的选项，field代表显示内容，value代表对应值
		FieldOptions([]map[string]string{
            {
                "field": "apple",
                "value": "apple",
            }, {
                "field": "banana",
                "value": "banana",
            }, {
                "field": "watermelon",
                "value": "watermelon",
            }, {
                "field": "pear",
                "value": "pear",
            },
        }).
        // 这里返回一个[]string，对应的值是本列的fruit字段的值，即编辑表单时会显示的对应值
        FieldDisplay(func(model types.FieldModel) interface{} {
            return []string{"pear"}
        })
```

## File

```go
formList.AddField("file", "file", db.Varchar, form.File)
```

## Password

```go
formList.AddField("password", "password", db.Varchar, form.Password)
```

## RichText

```go
formList.AddField("content", "content", db.Varchar, form.RichText)
```

## Datetime

```go
formList.AddField("birthday", "birthday", db.Varchar, form.Datetime)
```

## Radio

```go
formList.AddField("gender", "gender", db.Int, form.Radio).
        // radio的选项，field代表字，label代表显示内容，value代表对应值
		FieldOptions([]map[string]string{
            {
                "field":    "gender",
                "label":    "male",
                "value":    "0",
                "selected": "checked",
            },
            {
                "field":    "gender",
                "label":    "female",
                "value":    "1",
                "selected": "",
            },
        }).FieldDefault("0") // 设置默认的值
```

## Email

```go
formList.AddField("email", "email", db.Varchar, form.Email)
```

## Url

```go
formList.AddField("url", "url", db.Varchar, form.Url)
```

## Ip

```go
formList.AddField("ip", "ip", db.Varchar, form.Ip)
```

## Color

```go
formList.AddField("color", "color", db.Varchar, form.Color)
```

## Currency

```go
formList.AddField("money", "money", db.Varchar, form.Currency)
```

## Number

```go
formList.AddField("num", "num", db.Varchar, form.Number)
```

## TextArea

```go
formList.AddField("content", "content", db.Varchar, form.TextArea)
```

## Custom

自定义表单内容

```go
formList.AddField("content", "content", db.Varchar, form.Custom).
    FieldCustomContent(template.HTML(``)).
    FieldCustomCss(template.CSS(``)).
    FieldCustomJs(template.JS(``))
```

以下表单自定义的模板文件结构，设置的```CustomContent```，```CustomCss```，```CustomJs```将插入到对应的位置。

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
