# chartjs
---

使用例子：

```go

import "github.com/GoAdminGroup/go-admin/template/chartjs"

func xxx() {

	...

	lineChart := chartjs.Line().
		SetID("salechart").
		SetHeight(180).
		SetTitle("Sales: 1 Jan, 2019 - 30 Jul, 2019").
		SetLabels([]string{"January", "February", "March", "April", "May", "June", "July"}).

		AddDataSet("Electronics"). // 增加第一条数据
		DSData([]float64{65, 59, 80, 81, 56, 55, 40}). // 设置数据内容
		DSFill(false). // 是否填充颜色
		DSBorderColor("rgb(210, 214, 222)"). // 线边框颜色
		DSLineTension(0.1). // 设置压力度

		AddDataSet("Digital Goods"). // 增加第二条数据
		DSData([]float64{28, 48, 40, 19, 86, 27, 90}).
		DSFill(false).
		DSBorderColor("rgba(60,141,188,1)").
		DSLineTension(0.1).
		GetContent()

	...

}

```

具体api请见：[https://www.chartjs.org/docs/latest/](https://www.chartjs.org/docs/latest/)