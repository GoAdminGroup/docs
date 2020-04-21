# 组件开发
---

组件是一个页面UI组件的抽象，包括了html以及其他资源。开发一个组件需要实现以下接口：

```go
type Component interface {
	// GetTemplate 返回了一个golang的模板对象，以及模板名
	GetTemplate() (*template.Template, string)

	// GetAssetList 返回了组件中使用的资源列表，为一个数组。
	// 数组中的资源路径与事实应用的路径对应关系如下：
	//
	// {{.UrlPrefix}}/assets/login/css/bootstrap.min.css => login/css/bootstrap.min.css
	//
	// 例子：
	// https://github.com/GoAdminGroup/go-admin/blob/master/template/login/assets_list.go
	GetAssetList() []string

	// GetAsset 根据提供的资源路径返回资源的内容。
	// 比如：参数为 asset/login/dist/all.min.css，返回对应的css内容。
	//
	// See: http://github.com/jteeuwen/go-bindata
	GetAsset(string) ([]byte, error)

	// GetContent 返回组件渲染后的html
	GetContent() template.HTML

	// IsAPage 返回该组件是否为一个页面
	IsAPage() bool

	// GetName 返回组件名字
	GetName() string
}
```

假设我们要开发一个MagicBox组件。我们可以新建一个magic_box文件夹，文件夹下新建以下文件：

```
.
├── assets
│   ├── dist
│   │   └── img
│   └── src
│       ├── img
│       ├── css
│       └── js
├── magic_box.go
└── magic_box.tmpl
```

tmpl文件编写我们的html文件，assets/src下放我们的前端资源文件，我们会使用到```adm```工具，将我们的资源文件首先合并，然后编译成go文件，从而可以给我们的```MagicBox```对象调用。

编写完毕后，我们执行以下命令进行编译：

```bash
# 合并js资源
adm combine js --path=./assets/src/js/ --out=./assets/dist/all.min.js
# 合并css资源
adm combine css --path=./assets/src/css/ --out=./assets/dist/all.min.css
# 将dist目录下静态资源编译为一个go文件与一个资源列表文件
adm compile asset --path=./assets/dist/ --out=./ --pa=magic_box
```

我们在```magic_box.go```中实现一个组件：

```go
package magic_box

type MagicBox struct {
	Name string
}

func Get() *MagicBox {
	return &MagicBox{
		Name: "magic_box",
	}
}

func (l *MagicBox) GetTemplate() (*template.Template, string) {
	tmpl, err := template.New("magic_box").
		Funcs(DefaultFuncMap).
		Parse(List["magic_box"])

	if err != nil {
		logger.Error("magic box get template error: ", err)
	}

	return tmpl, "magic_box"
}

func (l *MagicBox) GetAssetList() []string               { return AssetList }
func (l *MagicBox) GetAsset(name string) ([]byte, error) { return Asset(name[1:]) }
func (l *MagicBox) GetName() string                      { return "magic_box" }
func (l *MagicBox) IsAPage() bool                        { return false }

func (l *MagicBox) GetContent() template.HTML {
	buffer := new(bytes.Buffer)
	tmpl, defineName := l.GetTemplate()
	err := tmpl.ExecuteTemplate(buffer, defineName, l)
	if err != nil {
		logger.Error("magic box component, compose html error:", err)
	}
	return template.HTML(buffer.String())
}
```

这里我们就开发完毕了。

接着我们就可以加载该组件进行使用：

```go
package main

import (
	_ "github.com/GoAdminGroup/go-admin/adapter/gin"	    
    _ "github.com/GoAdminGroup/go-admin/adapter/gin"
    _ "github.com/GoAdminGroup/go-admin/modules/db/drivers/mysql"
	
	"github.com/GoAdminGroup/components/login"
	"github.com/GoAdminGroup/go-admin/engine"
	"github.com/GoAdminGroup/go-admin/examples/datamodel"
	"github.com/GoAdminGroup/go-admin/template"
	"github.com/GoAdminGroup/go-admin/plugins/admin"
	"github.com/gin-gonic/gin"
	"io/ioutil"
)

func main() {
	r := gin.Default()

	gin.SetMode(gin.ReleaseMode)
	gin.DefaultWriter = ioutil.Discard

	eng := engine.Default()
	adminPlugin := admin.NewAdmin(datamodel.Generators)
	adminPlugin.AddGenerator("user", datamodel.GetUserTable)
	
	// 在这里进行加载
	template.AddComp(magic_box.Get())

	if err := eng.AddConfigFromJson("./config.json").
		AddPlugins(adminPlugin).
		Use(r); err != nil {
		panic(err)
	}

	// 加载完后，在你的逻辑函数中使用：magic_box.GetContent() 返回内容使用。

	r.Static("/uploads", "./uploads")

	_ = r.Run(":9033")
}
```