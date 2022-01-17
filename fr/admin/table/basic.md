# Usage basique

Utilisez cette ligne de commande pour générer un table de données:

```sql
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` tinyint(4) DEFAULT NULL,
  `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

Généré:

```go
package datamodel

import (
    ...
)

func GetUserTable(ctx *context.Context) (userTable table.Table) {

    // configuration du modèle de la table.
    userTable = table.NewDefaultTable(table.Config{...})

    info := userTable.GetInfo()

    // id est triable.
    info.AddField("ID", "id", db.Int).FieldSortable(true)
    info.AddField("Name", "name", db.Varchar)

    ...

    // on donne le titre et la déscription de la page de la table.
    info.SetTable("users").SetTitle("Users").SetDescription("Users").
        SetAction(template.HTML(`<a href="http://google.com"><i class="fa fa-google"></i></a>`))  // bouton personnalisé

    ...
}
```

### Ajout d'un champ

```go
// Ajout d'un champ avec son titre (ID), son nom (id) et son type (int)
info.AddField("ID", "id", db.Int)

// Ajout d'un second champ avec son titre (Name), son nom (name) et son type (varchar)
info.AddField("Name", "name", db.Varchar)

// Ajout d'un troisième champ, qui n'existe cependant pas dans la table sql
info.AddField("Custom", "custom", db.Varchar)
```

### Modifications visuelles

```go
// La sortie correspond à la valeur du champ
info.AddField("Gender", "gender", db.Tinyint).FieldDisplay(func(model types.FieldModel) interface{} {
    if model.Value == "0" {
        return "men"
    }
    if model.Value == "1" {
        return "women"
    }
    return "unknown"
})

// Sortie html
info.AddField("Name", "name", db.Varchar).FieldDisplay(func(model types.FieldModel) interface{} {    
    return "<span class='label'>" +  model.Value + "</span>"
})
```

La sortie inconnue reçue par **FieldDisplay** connecte les données de la ligne actuelle et peut appeler d'autres données en elle. 

```go
info.AddField("First Name", "first_name", db.Varchar).FieldHide()
info.AddField("Last Name", "last_name", db.Varchar).FieldHide()

// Colonne du champ non-existante
info.AddField("Full Name", "full_name", db.Varchar).FieldDisplay(func(model types.FieldModel) interface{} {    
    return model.Row["first_name"].(string) + " " + model.Row["last_name"].(string)
})
```

### Cacher le bouton créer

```go
info.HideNewButton()
```

### Cacher le bouton éditer

```go
info.HideEditButton()
```

### Cacher le bouton exporter

```go
info.HideExportButton()
```

### Cacher le bouton supprimer

```go
info.HideDeleteButton()
```

### Cacher le bouton de détails

```go
info.HideDetailButton()
```

### Cacher le filtre par défault

```go
info.HideFilterArea()
```

### Pré requête

```go
// field, operator, argument
info.Where("type", "=", 0)
```

## Modifier la disposition du filtre

```go
info.SetFilterFormLayout(layout form.Layout)
```

## Changer l'ordre par défault

```go
// monter
info.SetSortAsc()
// descendre
info.SetSortDesc()
```

## Joindre une table

La table doit avoir un nom et un champ

```go
info.AddField("Role Name", "role_name", db.Varchar).FieldJoin(types.Join{
    Table: "role",         // nom de la table que l'on veut joindre
    Field: "id",           // nom du champ à joindre
    JoinField: "user_id",  // champ de la table que l'on veut joindre
})
```

Cela va générer une commande sql comme celle-ci:

```sql
select ..., role.`role_name` from users left join role on users.`id` = role.`user_id` where ...
```

## Configurer la page des détails

Vous pouvez personnaliser l'affichage de la page des détails. Si ce n'est pas fait, les règlages par défaults seront choisis

```go
package datamodel

import (
	...
)

func GetUserTable(ctx *context.Context) (userTable table.Table) {

	userTable = table.NewDefaultTable(table.Config{...})

	detail := userTable.GetDetail()

	detail.AddField("ID", "id", db.Int)
	detail.AddField("Name", "name", db.Varchar)
    
    ...
}
```
