# Utilisation d'une table
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
        // Une option possibles, le champ représente le contenu et sa valeur correspond à l'option choisie
		FieldOptions(types.FieldOptions{ 
            {Text: "man",Value: "0"},
            {Text: "women",Value: "1"},
        }).
        // Ceci retourne []string, la valeur de la chaine de caractère est le texte correspondant, la valeur est donnée lors de l'édition de la table.
        FieldDisplay(func(model types.FieldModel) interface{} {
            return []string{"0"}
        })
```

## Select

```go
formList.AddField("drink", "drink", db.Int, form.Select).
        // plusieurs options possibles, le champ représente le contenu et sa valeur correspond à l'option choisie
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
        // Ceci retourne []string, la valeur de la chaine de caractère est le texte correspondant, la valeur est donnée lors de l'édition de la table.
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
        // plusieurs options possibles, le champ représente le contenu et sa valeur correspond à l'option choisie
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
        // Ceci retourne []string, la valeur de la chaine de caractère est le texte correspondant, la valeur est donnée lors de l'édition de la table.
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
        // Options radio, le champ représente le contenu et sa valeur correspond à l'option choisie
		FieldOptions(types.FieldOptions{ 
            {Text: "man",Value: "0"},
            {Text: "women",Value: "1"},
        }).FieldDefault("0") // Donne la valeur par défault
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

## Personnalisée

Table personnalisée

```go
formList.AddField("content", "content", db.Varchar, form.Custom).
    FieldCustomContent(template.HTML(``)).
    FieldCustomCss(template.CSS(``)).
    FieldCustomJs(template.JS(``))
```

Ce qui suit forme le modèle de la structure de fichier personnalisée. 
En ajustant les options ` ` ` CustomContent ` ` `, ` ` ` CustomCss ` ` `, ` ` ` CustomJs ` ` `, les paramètres seront insérés dans leurs endroits respectifs.

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
