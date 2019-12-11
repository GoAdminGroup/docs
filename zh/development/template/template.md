# 模板介绍
---

主题模板是ui的抽象表示，包括一系列组件和静态资源的集合，会在插件中被调用。在GoAdmin中的定义如下：

```go
type Template interface {
	
	Form() types.FormAttribute
	Col() types.ColAttribute
	Table() types.TableAttribute
	DataTable() types.DataTableAttribute
	Row() types.RowAttribute
	Tree() types.TreeAttribute
	Paginator() types.PaginatorAttribute
	Label() types.LabelAttribute
	Image() types.ImgAttribute
	Alert() types.AlertAttribute
	Tabs() types.TabsAttribute
	Popup() types.PopupAttribute

	// 资源函数
	GetTmplList() map[string]string
	GetAssetList() []string
	GetAsset(string) ([]byte, error)
	GetTemplate(bool) (*template.Template, string)
}
```

如果需要开发一个ui主题模板，需要实现以上的```Template```接口。cli工具会帮助你开发一个模板。