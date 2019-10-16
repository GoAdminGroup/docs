# 文件上传
---

GoAdmin默认支持是的文件上传到本地。需要在全局配置中设置上传的目录，以及上传文件访问的前缀。

```go
package config

// 存储目录：存储头像等上传文件
type Store struct {
	Path   string // 相对或绝对路径，文件会存储到这里
	Prefix string // 访问前缀
}

type Config struct {
    
    ...

	// 上传文件存储的位置
	Store Store `json:"store"`

	// 文件上传引擎
    FileUploadEngine FileUploadEngine `json:"file_upload_engine"`
    
    ...
}

type FileUploadEngine struct {
	Name   string
	Config map[string]interface{}
}
```

如果你想要自定义上传位置，比如上传到又拍云，七牛云等云平台，那么你需要自己写一个上传引擎。下面介绍如何自己写引擎：

引擎的类型为：

```go
package file

// 上传引擎
type Uploader interface {
	Upload(*multipart.Form) error
}

// 上传引擎生成函数
type UploaderGenerator func() Uploader

func AddUploader(name string, up UploaderGenerator) {
	upMu.Lock()
	defer upMu.Unlock()
	if up == nil {
		panic("uploader generator is nil")
	}
	if _, dup := uploaderList[name]; dup {
		panic("add uploader generator twice " + name)
	}
	uploaderList[name] = up
}
```

我们需要调用**AddUploader**方法来增加一个上传引擎，第一个参数是引擎的名字（将在全局配置中用到），第二参数就是引擎生成函数。

假设我们要增加一个七牛云上传引擎，那么可以类似这样：

```go
package main

import (
    ...
    "github.com/GoAdminGroup/go-admin/modules/file"
    ...
)

type QiNiuUploader struct {
    Bucket    string
    Region    string
    SecretId  string
    SecretKey string
}

func (q QiNiu) Upload(*multipart.Form) error {
    // 接收一个表单类型，这里实现上传逻辑
}

func main() {

    ...

    file.AddUploader("qiniu", func() file.Uploader {
        return &QiNiuUploader{
			Bucket:     config.Get().FileUploadEngine.Config["bucket"].(string),
			Region:     config.Get().FileUploadEngine.Config["region"].(string),
			SecretId:   config.Get().FileUploadEngine.Config["secret_id"].(string),
			SecretKey:  config.Get().FileUploadEngine.Config["secret_key"].(string),
		}
    })

    cfg := config.Config{
        ...

        FileUploadEngine: config.FileUploadEngine{
            Name: "qiniu",
            Config: map[string]interface{}{
                "bucket": "xxx",
                "region": "xxx",
                "secret_id": "xxx",
                "secret_key": "xxx",
            },
        }

        ...
    }

    ...
}
```