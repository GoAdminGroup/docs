# Usage de colonnes
---

**InfoPanel** a beaucoup d'éléments qui permettent de manipuler les données des colonnes de façon très flexible.

### Changer la largeur

```go
info.SetTableFixed()
info.AddField("Name", "name", db.Varchar).FieldWidth(100)
```

### Cacher

```go
info.AddField("Name", "name", db.Varchar).FieldHide()
```

### Pouvoir être ordonné

```go
info.AddField("Name", "name", db.Varchar).FieldSortable()
```

### Est fixe

```go
info.AddField("Name", "name", db.Varchar).FieldFixed()
```

### Peut-être filtrable

```go
info.AddField("Name", "name", db.Varchar).FieldFilterable()
```

## Aide

### Manipulation de chaînes de caractères

Limiter la taille du champ

```go
info.AddField("Name", "name", db.Varchar).FieldLimit(10)
```

Titre

```go
info.AddField("Name", "name", db.Varchar).FieldToTitle()
```

Modifier l'espace

```go
info.AddField("Name", "name", db.Varchar).FieldTrimSpace()
```

Concaténation

```go
info.AddField("Name", "name", db.Varchar).FieldSubstr(0, 3)
```

Chaîne de caractères en majuscules

```go
info.AddField("Name", "name", db.Varchar).FieldToUpper()
```

Chaîne de caractères en minuscules

```go
info.AddField("Name", "name", db.Varchar).FieldToLower()
```


**Si vous voulez ajouter des filtres globaux**

Alors vous pourrez le faire comme ceci:

```go
adminPlugin := admin.NewAdmin(...)

// limiter la sortie
adminPlugin.AddDisplayFilterLimit(limit int)

// Modifier l'espace
adminPlugin.AddDisplayFilterTrimSpace()

// Concaténation
adminPlugin.AddDisplayFilterSubstr(start int, end int)

// Titre
adminPlugin.AddDisplayFilterToTitle()

// Majuscules
adminPlugin.AddDisplayFilterToUpper()

// Minuscules
adminPlugin.AddDisplayFilterToLower()

// Filtre xss
adminPlugin.AddDisplayFilterXssFilter()

// Filtre JavaScript
adminPlugin.AddDisplayFilterXssJsFilter()

```

**Si vous voulez ajouter un filtre pour une table ou un tableau**

```go
info := table.NewDefaultTable(...).GetInfo()

info.AddLimitFilter(limit int)
info.AddTrimSpaceFilter()
info.AddSubstrFilter(start int, end int)
info.AddToTitleFilter()
info.AddToUpperFilter()
info.AddToLowerFilter()
info.AddXssFilter()
info.AddXssJsFilter()

form := table.NewDefaultTable(...).GetForm()

form.AddLimitFilter(limit int)
form.AddTrimSpaceFilter()
form.AddSubstrFilter(start int, end int)
form.AddToTitleFilter()
form.AddToUpperFilter()
form.AddToLowerFilter()
form.AddXssFilter()
form.AddXssJsFilter()
```
