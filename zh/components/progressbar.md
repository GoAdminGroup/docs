# Progress Group
---

ProgressGroup 定义如下：

```go
type ProgressGroup struct {
	components.Base
	Title       template.HTML
	Molecular   int
	Denominator int
	Color       template.HTML
	IsHexColor  bool
	Percent     int
}

func New() ProgressGroup {}

// 设置标题
func (p ProgressGroup) SetTitle(value template.HTML) ProgressGroup {}

// 设置颜色
func (p ProgressGroup) SetColor(value template.HTML) ProgressGroup {}

// 设置百分比
func (p ProgressGroup) SetPercent(value int) ProgressGroup {}

// 设置分母
func (p ProgressGroup) SetDenominator(value int) ProgressGroup {}

// 设置分子
func (p ProgressGroup) SetMolecular(value int) ProgressGroup {}
```

使用：

```go

import "github.com/GoAdminGroup/themes/adminlte/components/progress_group"

func xxx() {
	...

	content := progress_group.New().SetDenominator(10).SetMolecular(3).GetContent()

	...
}

```