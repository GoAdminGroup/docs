# Introduction à l'interface en ligne de commandes
---

GoAdmin donne accès à une interface en ligne de commandes pour permettre d'augmenter l'efficacité du développement et le normaliser.

## Installation


Téléchargez la version correspondante à votre système d'exploitation:

|  File name   | OS  | Arch  | Size  |
|  ----  | ----  | ----  |----  |
| [adm_darwin_x86_64_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_darwin_x86_64_v1.2.24.zip)  | macOs | x86-64 | 4.77 MB
| [adm_linux_x86_64_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_linux_x86_64_v1.2.24.zip)  | Linux | x86-64   | 6.52 MB
| [adm_linux_armel_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_linux_armel_v1.2.24.zip)  | Linux | x86   | 6.06 MB
| [adm_windows_i386_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_windows_i386_v1.2.24.zip)  | Windows | x86  |6.16 MB
| [adm_windows_x86_64_v1.2.24.zip](http://file.go-admin.cn/go_admin/cli/v1_2_24/adm_windows_x86_64_v1.2.24.zip)  | Windows | x86-64   |6.38 MB


Ou utilisez la commande pour l'installer:

```
go install github.com/GoAdminGroup/adm
```

## Utilisation

Utilisez

```
adm --help
```

Cette commande donner les informations suivantes:

|  Command  |  Subcommand   | Options  | Function  | 
|  ---- | ---- | ----  | ----  |
| generate  |  - | - | génère un modèle de fichier de données.
| compile  | asset| **-s, --src** chemin d'accès des ressources front-end<br>**-d, --dist** chemin du fichier de sortie go | compile toutes les ressources dans un seul fichier go.
| compile  | tpl | **-s, --src** chemin d'accès vers les modèles golang sous forme d'un dossier tmpl<br>**-d, --dist** chemin du fichier go de sortie <br>**-p, --package** nom du fichier de sortie go | compile tous les modèles en seul fichier go.
| combine  | css| **-s, --src** chemin d'accès vers le dossier d'entrée css<br>**-d, --dist** chemin vers le fichier css de sortie<br>**-p, --package** nom du fichier de sortie css | combine tous les fichiers css en un fichier css.
| combine  | js | **-s, --src** chemin d'accès vers le dossier d'entrée js<br>**-d, --dist** chemin vers le fichier js de sortie | combine tous les fichiers js en un seul.
| develop  | tpl | **-m, --module** nom du module golang ou sont chemin d'accès $GOPATH<br>**-n, --name** nom du thème | récupère les modèles et les sauvegardes localement.
