# 列的显示
---

## Bool

显示bool类型的值，第一个参数代表为true的值，第二个参数为false的值。

```go
info.AddField("通关", "pass", db.Tinyint).FieldBool("1", "0")
```

## 复制

显示一个copy按钮。

```go
info.AddField("UUID", "uuid", db.Varchar).FieldCopyable()
```

## 轮播

```go
info.AddField("照片", "photos", db.Varchar).FieldCarousel(func(value string) []string {
    return strings.Split(value, ",")
}, 150, 100)
```

## Dot

```go
info.AddField("完成状态", "finish_state", db.Tinyint).
FieldDisplay(func(value types.FieldModel) interface{} {
    if value.Value == "0" {
        return "第一步"
    }
    if value.Value == "1" {
        return "第二步"
    }
    if value.Value == "2" {
        return "第三步"
    }
    return "未知"
}).
FieldDot(map[string]types.FieldDotColor{
    "第一步": types.FieldDotColorDanger,
    "第二步": types.FieldDotColorInfo,
    "第三步": types.FieldDotColorPrimary,
}, types.FieldDotColorDanger)
```

## 进度条

显示字段为一个进度条。可选参数：types.FieldProgressBarData

```go
info.AddField("完成进度", "finish_progress", db.Int).FieldProgressBar()

type FieldProgressBarData struct {
	Style string  // 类型
	Size  string  // 大小
	Max   int     // 最大值
}
```

## 下载链接

如果字段为文件下载链接URL，可以显示成一个下载链接，参数为前缀，可不传。

```go
info.AddField("简历", "resume", db.Varchar).
    FieldDisplay(func(value types.FieldModel) interface{} {
        return filepath.Base(value.Value)
    }).
    FieldDownLoadable("http://yinyanghu.github.io/files/")
```

## 文件大小

如果字段为字节大小的整数类型，可以转为kb/mb/gb等易理解的单位显示。

```go
info.AddField("简历大小", "resume_size", db.Int).FieldFileSize()
```

## Loading

参数的意思为：当状态为0，1，2时，显示为loading。

```go
info.AddField("状态", "state", db.Int).FieldLoading([]string{"0", "1", "2"})
```

## 标签

显示字段为标签，可选参数为：types.FieldLabelParam

```go
info.AddField("标签", "label", db.Varchar).FieldLabel(types.FieldLabelParam{})

type FieldLabelParam struct {
	Color template.HTML  // 颜色
	Type  string    // 类型
}
```

## 图片

如果`avatar`字段保存的是图片的完整地址，或者路径，可以通过下面的方式将该列渲染为图片显示

```go
info.AddField("头像", "avatar", db.Varchar).FieldImage("50", "50")  
```

当然也可以为图片增加访问前缀

```go
info.AddField("头像", "avatar", db.Varchar).FieldImage("50", "50", "https://prefix.com")
```