# InfoBox
---

InfoBox 定义如下：

```go
type InfoBox struct {
	components.Base
	Icon       template.HTML
	Text       template.HTML
	Number     template.HTML
	Content    template.HTML
	Color      template.HTML
	IsHexColor bool
	IsSvg      bool
}

func New() InfoBox {}

// 设置icon
func (i InfoBox) SetIcon(value template.HTML) InfoBox {}

// 设置文字
func (i InfoBox) SetText(value template.HTML) InfoBox {}

// 设置数字
func (i InfoBox) SetNumber(value template.HTML) InfoBox {}

// 设置内容
func (i InfoBox) SetContent(value template.HTML) InfoBox {}

// 设置颜色
func (i InfoBox) SetColor(value template.HTML) InfoBox {}
```

使用：

```go

import "github.com/GoAdminGroup/themes/adminlte/components/infobox"

func xxx() {
	...

	content := infobox.New().SetIcon("").SetText().GetContent()

	...
}

```