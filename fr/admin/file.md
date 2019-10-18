# File Upload Engine
---

By default, GoAdmin provides a local file upload engine that supports uploading files to the server. Use the directory that needs to be set up in the global configuration and the prefix for uploading file access.

```go
package config

// Storage directory: store avatar and other uploaded files
type Store struct {
	Path   string // relative or absolute path, the file will be stored here
	Prefix string // access url prefix
}

type Config struct {
    
    ...

	// Upload file storage location
	Store Store `json:"store"`

	// File upload engine
    FileUploadEngine FileUploadEngine `json:"file_upload_engine"`
    
    ...
}

type FileUploadEngine struct {
	Name   string
	Config map[string]interface{}
}
```

If you want to customize the upload location, such as uploading to cloud, aws cloud and other cloud platforms, then you need to write an upload engine yourself. Here's how to write your own engine:

### Type of engine

```go
package file

type Uploader interface {
	Upload(*multipart.Form) error
}

type UploaderGenerator func() Uploader

func AddUploader(name string, up UploaderGenerator) {
	...
}
```

### How to

We need to call the **AddUploader** method to add an upload engine. The first parameter is the name of the engine (which will be used in the global configuration) and the second parameter is the engine generation function.

Suppose we want to add a aws cloud upload engine, then it can be similar like this:

```go
package main

import (
    ...
    "github.com/GoAdminGroup/go-admin/modules/file"
    ...
)

type AwsUploader struct {
    Bucket    string
    Region    string
    SecretId  string
    SecretKey string

    Prefix string
    Path   string
}

func (q AwsUploader) Upload(*multipart.Form) error {
    // 接收一个表单类型，这里实现上传逻辑
}

func main() {

    ...

    file.AddUploader("aws", func() file.Uploader {
        return &AwsUploader{
			Bucket:     config.Get().FileUploadEngine.Config["bucket"].(string),
			Region:     config.Get().FileUploadEngine.Config["region"].(string),
			SecretId:   config.Get().FileUploadEngine.Config["secret_id"].(string),
            SecretKey:  config.Get().FileUploadEngine.Config["secret_key"].(string),
            Prefix:     config.Get().FileUploadEngine.Config["prefix"].(string),
            Path:       config.Get().FileUploadEngine.Config["path"].(string),
		}
    })

    cfg := config.Config{
        ...

        FileUploadEngine: config.FileUploadEngine{
            Name: "aws",
            Config: map[string]interface{}{
                "bucket": "xxx",
                "region": "xxx",
                "secret_id": "xxx",
                "secret_key": "xxx",
                "prefix": "xxx",
                "path": "xxx",
            },
        }

        ...
    }

    ...
}
```

Finish a aws cloud upload file engine!🍺🍺