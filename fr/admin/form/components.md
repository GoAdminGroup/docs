# Usage Of Form Components
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
        // Radio options, field represents the display content, value on behalf of the corresponding value
		FieldOptions(types.FieldOptions{ 
            {Text: "man",Value: "0"},
            {Text: "women",Value: "1"},
        }).
        // This returns []string, the corresponding value is that the value of the sex of this column, the corresponding value is displayed when edit form
        FieldDisplay(func(model types.FieldModel) interface{} {
            return []string{"0"}
        })
```

## Select

```go
formList.AddField("drink", "drink", db.Int, form.Select).
        // alternative options, field represents the display content, value on behalf of the corresponding value
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
        // This returns []string, the corresponding value is that the value of the drink of this column, the corresponding value is displayed when edit form
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
        // alternative options, field represents the display content, value on behalf of the corresponding value
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
        // This returns []string, the corresponding value is that the value of the fruit of this column, the corresponding value is displayed when edit form
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
        // Radio options, field on behalf of the word, the label on behalf of the display content, value on behalf of the corresponding value
		FieldOptions(types.FieldOptions{ 
            {Text: "man",Value: "0"},
            {Text: "women",Value: "1"},
        }).FieldDefault("0") // Set the default values
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

Custom form content

```go
formList.AddField("content", "content", db.Varchar, form.Custom).
    FieldCustomContent(template.HTML(``)).
    FieldCustomCss(template.CSS(``)).
    FieldCustomJs(template.JS(``))
```

The following form the custom template file structure, setting the ` ` ` CustomContent ` ` `, ` ` ` CustomCss ` ` `, ` ` ` CustomJs ` ` ` will be inserted into the corresponding location.

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