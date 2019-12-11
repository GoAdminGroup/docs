# Components

Component development, taking the image component as an example.

## New types and methods of upper interface

* Create a new `ImgAttribute` type

```go
type ImgAttribute interface {
    SetWidth(value string) ImgAttribute
    SetHeight(value string) ImgAttribute
    SetSrc(value string) ImgAttribute
    GetContent() template.HTML
}
```

* In the `Template` interface, add a method:

```go
type Template interface {
    ...
    Image() types.ImgAttribute
    ...
}
```

## Specific implementation, with `adminlte` as an example

* `ImgAttribute`

Create a new `image.go` file under `./template/adminlte/components`, as follows:

```go
package components

import (
    "github.com/GoAdminGroup/go-admin/template/types"
    "html/template"
)

type ImgAttribute struct {
    Name   string
    Witdh  string
    Height string
    Src    string
}

func (compo *ImgAttribute) SetWidth(value string) types.ImgAttribute {
    compo.Witdh = value
    return compo
}

func (compo *ImgAttribute) SetHeight(value string) types.ImgAttribute {
    compo.Height = value
    return compo
}

func (compo *ImgAttribute) SetSrc(value string) types.ImgAttribute {
    compo.Src = value
    return compo
}

func (compo *ImgAttribute) GetContent() template.HTML {
    return ComposeHtml(compo.TemplateList, *compo, "image")
}
```

* `Image()`

In `.template/adminlte/adminlte.go`, add a function:

```go
func (*Theme) Image() types.ImgAttribute {
    return &components.ImgAttribute{
        Name:   "image",
        Witdh:  "50",
        Height: "50",
        Src:    "",
    }
}
```

Still not completed here, you need to add static resource files.

* Add the static resource file

Add `image.tmpl` file to `.template/adminlte/resource/pages/components`

Annoying, and the last step

* Execute in the root directory:

```text
adm assets
```

