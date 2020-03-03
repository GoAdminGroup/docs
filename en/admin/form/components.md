# Usage Of Form Components

---

## Text type

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

## Selection type

### SelectSingle

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

### Select

### SelectSingle

```go
formList.AddField("sex", "sex", db.Int, form.SelectSingle).
        // Options, Text is the display content, Value is the corresponding value.
		FieldOptions(types.FieldOptions{
            {Text: "man",Value: "0"},
            {Text: "women",Value: "1"},
        }).
        // Default option.
        FieldDefault("0")
```

### Select

```go
formList.AddField("drink", "drink", db.Int, form.Select).
        // Options, Text is the display content, Value is the corresponding value.
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
        })
```

### Radio

```go
formList.AddField("gender", "gender", db.Int, form.Radio).
        // Options, Text is the display content, Value is the corresponding value.
		FieldOptions(types.FieldOptions{
            {Text: "male",Value: "0"},
            {Text: "female",Value: "1"},
        }).
        FieldDefault("0")
```

### SelectBox

```go
formList.AddField("fruit", "fruit", db.Int, form.SelectBox).
        // Options, Text is the display content, Value is the corresponding value.
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
        })
```

### Dynamic loading

Throught the ajax request:

```go

import "github.com/GoAdminGroup/go-admin/template/types/form/select"

formList.AddField("City", "city", db.Int, form.SelectSingle).
        // First parameter is ajax url
        // Second parameter is the corresponding handler, will be inject into the web framework
        // Third parameter is delay time, unit is millisecond, can be empty, default value is 500
		FieldOnSearch("/search/city", func(ctx *context.Context) (success bool, msg string, data interface{}, 1000) {
            return true, "ok", selection.Data{
                Results: selection.Options{
                    {Text: "GuangZhou", ID: "0"},
                    {Text: "ShenZhen", ID: "1"},
                    {Text: "BeiJing", ID: "2"},
                    {Text: "ShangHai", ID: "3"},
                }
            }
        }).
        FieldOptionInitFn(func(val types.FieldModel) types.FieldOptions {
            // When edit, this callback function will be called if it is not NULL. Here return the options.
            return types.FieldOptions{
                {Text: val.Value, ID: "0"}
            }
        }).
        FieldDefault("0")
```

Form linkage API statement:

```go
// Custom js, trigger the js content after selected
func (f *FormPanel) FieldOnChooseCustom(js template.HTML) *FormPanel

// Selected triggered after the content, to map, the format is:
// map[string]types.LinkField{
//		"men": {Field: "ip", Value:"127.0.0.1"},
//		"women": {Field: "ip", Hide: true},
//		"other": {Field: "ip", Disable: true}
// }
// Means the value of the selected to men, then the set IP this form item to 127.0.0.1
// The selected values for women, IP will be set to hide the form item
// Selected value to other, then the set IP this form item to input is prohibited
func (f *FormPanel) FieldOnChooseMap(m map[string]LinkField) *FormPanel

// Selected after the trigger, if selected value of val, will this form item is set to a value field
func (f *FormPanel) FieldOnChoose(val, field string, value template.HTML) *FormPanel

//Selected triggered after the Ajax, after selected values through Ajax will be selected via the url sent to a handler, return (data) will be assigned to the content of the field, the form,
// If the string is returned will direct assignment, if return the object will be assigned to the drop-down form options. Object format is:
// [{"id":0, "text":"men"}, {"id":1, "text":"women"}]
func (f *FormPanel) FieldOnChooseAjax(field, url string, handler Handler) *FormPanel

// Selected after the trigger, if selected value of val, will this form item hidden field
func (f *FormPanel) FieldOnChooseHide(value string, field ...string) *FormPanel

// Selected after the trigger, if selected value of val, will field the prohibited item form
func (f *FormPanel) FieldOnChooseDisable(value string, field ...string) *FormPanel
```

## Custom type

### Custom

Custom form content

```go
formList.AddField("content", "content", db.Varchar, form.Custom).
    FieldCustomContent(template.HTML(``)).
    FieldCustomCss(template.CSS(``)).
    FieldCustomJs(template.JS(``))
```

The following form the custom template file structure, setting the `` `CustomContent` ``, `` `CustomCss` ``, `` `CustomJs` `` will be inserted into the corresponding location.

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
