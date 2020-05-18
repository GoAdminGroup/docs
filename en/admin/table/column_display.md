# Column Display
---

## Bool

Display bool type field value. The first parameter stands for true, the second is false.

```go
info.AddField("Pass", "pass", db.Tinyint).FieldBool("1", "0")
```

## Copyable

Display a copy button.

```go
info.AddField("UUID", "uuid", db.Varchar).FieldCopyable()
```

## Carousel

```go
info.AddField("Photos", "photos", db.Varchar).FieldCarousel(func(value string) []string {
    return strings.Split(value, ",")
}, 150, 100)
```

## Dot

```go
info.AddField("State", "finish_state", db.Tinyint).
FieldDisplay(func(value types.FieldModel) interface{} {
    if value.Value == "0" {
        return "Step 1"
    }
    if value.Value == "1" {
        return "Step 2"
    }
    if value.Value == "2" {
        return "Step 3"
    }
    return "unknown"
}).
FieldDot(map[string]types.FieldDotColor{
    "Step 1": types.FieldDotColorDanger,
    "Step 2": types.FieldDotColorInfo,
    "Step 3": types.FieldDotColorPrimary,
}, types.FieldDotColorDanger)
```

## Progress Bar

Display as a progress bar. Optional parameter is types.FieldProgressBarData

```go
info.AddField("完成进度", "finish_progress", db.Int).FieldProgressBar()

type FieldProgressBarData struct {
	Style string  // style
	Size  string  // size
	Max   int     // max
}
```

## Downloadable Link

Display as a file downloadable link when field is an url. Optional parameter is url prefix string.

```go
info.AddField("Resume", "resume", db.Varchar).
    FieldDisplay(func(value types.FieldModel) interface{} {
        return filepath.Base(value.Value)
    }).
    FieldDownLoadable("http://yinyanghu.github.io/files/")
```

## Filesize

If the field is byte int type, display as human-readable format string.

```go
info.AddField("FileSize", "resume_size", db.Int).FieldFileSize()
```

## Loading

When state is 0/1/2, display as a loading gif.

```go
info.AddField("State", "state", db.Int).FieldLoading([]string{"0", "1", "2"})
```

## Label

Display as a label, optional parameter is types.FieldLabelParam

```go
info.AddField("Label", "label", db.Varchar).FieldLabel(types.FieldLabelParam{})

type FieldLabelParam struct {
	Color template.HTML  
	Type  string    
}
```

## Image

If field `avatar` is full path, it will show as a image 

```go
info.AddField("Avatar", "avatar", db.Varchar).FieldImage("50", "50")  
```

You can custom the prefix.

```go
info.AddField("Avatar", "avatar", db.Varchar).FieldImage("50", "50", "https://prefix.com")
```