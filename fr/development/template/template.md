# Template Introducation
---

The theme template is an abstract representation of ui, including a collection of components and static resources that are called in the plugin. The type in go-admin is ```Template```, as follows:

```go
type Template interface {
	// Components
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

	// Builder methods
	GetTmplList() map[string]string
	GetAssetList() []string
	GetAsset(string) ([]byte, error)
	GetTemplate(bool) (*template.Template, string)
}
```

To develop a ui theme template, you need to implement the above ```Template``` interface.