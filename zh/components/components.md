# 组件介绍
---

所有主题均配备的UI组件：

- Col           列
- Row           行
- Form          表单
- Table         表格
- DataTable     数据表格
- Tree          树
- Tabs          Tab标签显示框
- Alert         alert弹窗
- Link          链接
- Paginator     分页
- Popup         弹框 
- Box           显示Box
- Label         标签
- Image         图片
- Button        按钮

使用方法：

```golang
import (
    ...
    "github.com/GoAdminGroup/go-admin/template"
    ...
)

func xxxx() {
    // 获取默认主题，再获取Col组件，设置大小后调用GetContent获取组件的html内容
    col := template.Default().Col().SetSize(...).GetContent()
}
```

Adminlte内置了一些ui组件供使用：

- [infobox](components/infobox.md)
- [progress-group](components/progressbar.md)
- productlist
- smallbox
- description
- chart legend

系统提供的额外UI组件：

- [chartjs](components/chartjs.md)