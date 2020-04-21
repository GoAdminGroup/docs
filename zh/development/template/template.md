# 模板介绍
---

主题模板是一套UI的抽象表示，包括一系列组件和静态资源的集合，会在插件中被调用。在GoAdmin中的定义如下：

```go
type Template interface {
	// 主题名
	Name() string

	// 布局
	Col() types.ColAttribute
	Row() types.RowAttribute

	// 表单表格
	Form() types.FormAttribute
	Table() types.TableAttribute
	DataTable() types.DataTableAttribute

	Tree() types.TreeAttribute
	Tabs() types.TabsAttribute
	Alert() types.AlertAttribute
	Link() types.LinkAttribute

	Paginator() types.PaginatorAttribute
	Popup() types.PopupAttribute
	Box() types.BoxAttribute

	Label() types.LabelAttribute
	Image() types.ImgAttribute

	Button() types.ButtonAttribute

	// 构建方法
	GetTmplList() map[string]string
	GetAssetList() []string
	GetAsset(string) ([]byte, error)
	GetTemplate(bool) (*template.Template, string)

	// 版本限制
	GetVersion() string
	GetRequirements() []string
}
```

如果需要开发一个ui主题模板，需要实现以上的```Template```接口。cli工具会帮助你开发一个模板。