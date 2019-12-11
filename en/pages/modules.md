# Page Modules

Page customization needs to call the engine's `Content` method, which needs to return an object `types.Panel`

The following is the definition of `types.Panel`:

```go
type Panel struct {
    Content     template.HTML
    Title       string       
    Description string       
    Url         string
}
```

Corresponding ui, you can see the following picture:

![](http://quizfile.dadadaa.cn/everyday/app/jlds/img/006tNbRwly1fxoz5bm02oj31ek0u0wtz.jpg)

## How to use

```go
package datamodel

import (
    "github.com/GoAdminGroup/go-admin/modules/config"
    template2 "github.com/GoAdminGroup/go-admin/template"
    "github.com/GoAdminGroup/go-admin/template/types"
    "html/template"
)

func GetContent() (types.Panel, error) {

    components := template2.Get(config.Get().THEME)
    colComp := components.Col()

    infobox := components.InfoBox().
        SetText("CPU TRAFFIC").
        SetColor("blue").
        SetNumber("41,410").
        SetIcon("ion-ios-gear-outline").
        GetContent()

    var size = map[string]string{"md": "3", "sm": "6", "xs": "12"}
    infoboxCol1 := colComp.SetSize(size).SetContent(infobox).GetContent()
    row1 := components.Row().SetContent(infoboxCol1).GetContent()

    return types.Panel{
        Content:     row1,
        Title:       "Dashboard",
        Description: "this is a example",
    }, nil
}
```

## Col

A col is type of `ColAttribute`, has three methods:

```go
type ColAttribute interface {
    SetSize(value map[string]string) ColAttribute 
    SetContent(value template.HTML) ColAttribute  
    GetContent() template.HTML                    
}
```

About the `size`，example is `map[string]string{"md": "3", "sm": "6", "xs": "12"}`

## Row

A row is type of `RowAttribute`, has two methods:

```go
type RowAttribute interface {
    SetContent(value template.HTML) RowAttribute
    GetContent() template.HTML                  
}
```

