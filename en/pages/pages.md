# Customize your page
---

call the method ```Content```of the engine: 

```go
package main

import (
  _ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql"
 	_ "github.com/GoAdminGroup/themes/adminlte"
	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/examples/datamodel"
	"github.com/GoAdminGroup/go-admin/modules/config"
	"github.com/GoAdminGroup/go-admin/plugins/admin"
	"github.com/GoAdminGroup/go-admin/plugins/example"
	"github.com/GoAdminGroup/go-admin/template/types"
  ginAdapter "github.com/GoAdminGroup/go-admin/adapter/gin"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	eng := engine.Default()

	cfg := config.Config{}

	if err := eng.AddConfig(cfg).
		AddGenerators(datamodel.Generators).
		AddPlugins(example.NewExample()).
		Use(r); err != nil {
		panic(err)
	}

	r.Static("/uploads", "./uploads")

	// here to custom a page. 

	r.GET("/"+cfg.PREFIX+"/custom",  ginAdapter.Content(YourPageFunc))

	r.Run(":9033")
}
```

```Content```will write the contents into the ```context``` of the framework.

here is the code of ```GetContent```:

```go

import (
	"github.com/GoAdminGroup/go-admin/modules/config"
	"github.com/GoAdminGroup/go-admin/modules/db"
	"github.com/GoAdminGroup/go-admin/modules/language"
	form2 "github.com/GoAdminGroup/go-admin/plugins/admin/modules/form"
	template2 "github.com/GoAdminGroup/go-admin/template"
	"github.com/GoAdminGroup/go-admin/template/icon"
	"github.com/GoAdminGroup/go-admin/template/types"
	"github.com/GoAdminGroup/go-admin/template/types/form"
	"github.com/gin-gonic/gin"
)

func YourPageFunc(ctx *gin.Context) (types.Panel, error) {

	components := template2.Get(config.Get().Theme)

	col1 := components.Col().GetContent()
	btn1 := components.Button().SetType("submit").
		SetContent(language.GetFromHtml("Save")).
		SetThemePrimary().
		SetOrientationRight().
		SetLoadingText(icon.Icon("fa-spinner fa-spin", 2) + `Save`).
		GetContent()
	btn2 := components.Button().SetType("reset").
		SetContent(language.GetFromHtml("Reset")).
		SetThemeWarning().
		SetOrientationLeft().
		GetContent()
	col2 := components.Col().SetSize(types.SizeMD(8)).
		SetContent(btn1 + btn2).GetContent()

	var panel = types.NewFormPanel()
	panel.AddField("Name", "name", db.Varchar, form.Text)
	panel.AddField("Age", "age", db.Int, form.Number)
	panel.AddField("HomePage", "homepage", db.Varchar, form.Url).FieldDefault("http://google.com")
	panel.AddField("Email", "email", db.Varchar, form.Email).FieldDefault("xxxx@xxx.com")
	panel.AddField("Birthday", "birthday", db.Varchar, form.Datetime).FieldDefault("2010-09-05")
	panel.AddField("Password", "password", db.Varchar, form.Password)
	panel.AddField("IP", "ip", db.Varchar, form.Ip)
	panel.AddField("Certificate", "certificate", db.Varchar, form.Multifile).FieldOptionExt(map[string]interface{}{
		"maxFileCount": 10,
	})
	panel.AddField("Currency", "currency", db.Int, form.Currency)
	panel.AddField("Content", "content", db.Text, form.RichText).
		FieldDefault(`<h1>343434</h1><p>34344433434</p><ol><li>23234</li><li>2342342342</li><li>asdfads</li></ol><ul><li>3434334</li><li>34343343434</li><li>44455</li></ul><p><span style="color: rgb(194, 79, 74);">343434</span></p><p><span style="background-color: rgb(194, 79, 74); color: rgb(0, 0, 0);">434434433434</span></p><table border="0" width="100%" cellpadding="0" cellspacing="0"><tbody><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr></tbody></table><p><br></p><p><span style="color: rgb(194, 79, 74);"><br></span></p>`)

	panel.AddField("Website", "website", db.Tinyint, form.Switch).
		FieldHelpMsg("Help Message").
		FieldOptions(types.FieldOptions{
			{Value: "0"},
			{Value: "1"},
		})
	panel.AddField("fruit", "fruit", db.Varchar, form.SelectBox).
		FieldOptions(types.FieldOptions{
			{Text: "apple", Value: "apple"},
			{Text: "banana", Value: "banana"},
			{Text: "watermelon", Value: "watermelon"},
			{Text: "pear Value: ", Value: "pear"},
		}).
		FieldDisplay(func(value types.FieldModel) interface{} {
			return []string{"梨"}
		})
	panel.AddField("gender", "gender", db.Tinyint, form.Radio).
		FieldOptions(types.FieldOptions{
			{Text: "male", Value: "0"},
			{Text: "female", Value: "1"},
		})
	panel.AddField("饮料", "drink", db.Tinyint, form.Select).
		FieldOptions(types.FieldOptions{
			{Text: "bear", Value: "beer"},
			{Text: "juice", Value: "juice"},
			{Text: "water", Value: "water"},
			{Text: "read bull", Value: "red bull"},
		}).FieldDefault("beer")
	panel.AddField("工作经验", "experience", db.Tinyint, form.SelectSingle).
		FieldOptions(types.FieldOptions{
			{Text: "Zero", Value: "0"},
			{Text: "One year", Value: "1"},
			{Text: "Four years", Value: "2"},
			{Text: "Five years", Value: "3"},
		}).FieldDefault("beer")
	panel.SetTabGroups(types.TabGroups{
		{"name", "age", "homepage", "email", "birthday", "password", "ip", "certificate", "currency", "content"},
		{"website", "fruit", "gender", "drink", "experience"},
	})
	panel.SetTabHeaders("input", "select")

	fields, headers := panel.GroupField()

	aform := components.Form().
		SetTabHeaders(headers).
		SetTabContents(fields).
		SetPrefix(config.Get().PrefixFixSlash()).
		SetUrl("/admin/form/update").
		SetTitle("Form").
		SetHiddenFields(map[string]string{
			form2.PreviousKey: "/admin",
		}).
		SetOperationFooter(col1 + col2)

	return types.Panel{
		Content: components.Box().
			SetHeader(aform.GetDefaultBoxHeader()).
			WithHeadBorder().
			SetBody(aform.GetContent()).
			GetContent(),
		Title:       "Title",
		Description: "Description",
	}, nil
}
```
