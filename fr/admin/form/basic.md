# Usages basiques
---

Utilisez le terminal pour générer un tableau de données type pour le table sql, comme par exemple:

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

	// configure le modèle de la table.
	userTable = table.NewDefaultTable(...)

  ...

	formList := userTable.GetForm()

	// Le champ id n'est plus éditable.
	formList.AddField("ID", "id", db.Int, form.Default).FieldNotAllowEdit()
	formList.AddField("Ip", "ip", db.Varchar, form.Text)
	formList.AddField("Name", "name", db.Varchar, form.Text)

  ...

	return
}
```

### Ajout de champs

```go

// Ajoute un champ avec son titre ID, son nom id, son type int et son type par défault
formList.AddField("ID", "id", db.Int, form.Default)

// Ajoute un second champ avec son titre Ip, son nom ip, son type varchar et son type Text
formList.AddField("Ip", "ip", db.Varchar, form.Text)

// Ajoute un troisième champ, un champ qui n'existe pas dans la table sql
formList.AddField("Custom", "custom", db.Varchar, form.Text)

```

### Interdire l'édition

```go

formList.AddField("id", "id", db.Int, form.Default).FieldNotAllowEdit()

```

### Interdire l'ajout de nouveaux champs

```go

formList.AddField("id", "id", db.Int, form.Default).FieldNotAllowAdd()

```

## Ajouter un bouton

Si vous voulez ajouter des boutons à la table box header, vous pouvez le faire comme ça:

```go
info.AddButton(title template.HTML, icon string, action Action, color ...template.HTML)
```

```title```est le titre du bouton, ```icon```est l'icône du bouton, ```action```est l'action que produit le bouton et ```color``` est la couleur de fond et la couleur du texte

Par exemple:
```go

import (
    ...
	"github.com/GoAdminGroup/go-admin/template/icon"
	"github.com/GoAdminGroup/go-admin/template/types/action"
    ...
)

info.AddButton("Today Data", icon.Save, action.PopUp("/admin/data/analyze", "Data Analyze"))
```

On a ajouté un bouton qui va ouvrir une fenêtre quand il sera cliqué. Le contenu de la fenêtre est défini par le chemin "/admin/data/analyze" et "Data Analyze" est le titre de la fenêtre.
