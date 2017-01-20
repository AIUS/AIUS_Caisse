# `aius-salesd` — Une micro-caisse pour une grande association

Caisse pour l’AIUS écrite en Crystal.

## Construction

1. Installer le compilateur de [Crystal](https://crystal-lang.org/docs/installation/index.html) ;
2. cloner le dépôt ;
3. `crystal deps build` ;
4. Qapla’.

## Utilisation

Pour compiler :

	crystal deps build

Pour exécuter :

	$ ./bin/aius_caisse --help

	    -b HOST, --bind HOST             Host to bind (defaults to 0.0.0.0)
	    -p PORT, --port PORT             Port to listen for connections (defaults to 3000)
	    -s, --ssl                        Enables SSL
	    --ssl-key-file FILE              SSL key file
	    --ssl-cert-file FILE             SSL certificate file
	    -h, --help                       Shows this help

	$ ./bin/aius_caisse
	[development] Kemal is ready to lead at http://0.0.0.0:3000

	Kemal is going to take a rest!


## API REST

### `POST /products`
* Créé un nouveau produit dans la liste des produits mis en vente.
* Retourne les informations de ce nouveau produit.
* Entrée :
```json
{
	"id": "<Int32>",
	"name": "<String>",
	"category"?: "<Int32> | Nil"
	"price": "<Float64>"
}
```
* Sortie :
```json
{
	"id": "<Int32>",
	"name": "<String>",
	"category"?: "<Int32> | Nil"
	"price": "<Float64>"
}
```

### `GET /products`
* Liste de tous les produits mis en vente.
* Sortie :
```json
[{
	"id": "<Int32>",
	"name": "<String>",
	"category"?: "<Int32> | Nil"
	"price": "<Float64>"
}, 
...
]
```

### `GET /product/:id`
* Retourne les informations du produit dont l'id correspond, de la liste des produits mis en vente (si ce produit existe dans cette liste).
* Sortie :
```json
{
	"id": "<Int32>",
	"name": "<String>",
	"category"?: "<Int32> | Nil"
	"price": "<Float64>"
}
```

### `DELETE /product/:id`
* Supprime le produit, dont l'id correspond, de la liste des produits mis en vente (si ce produit existe dans cette liste).
* Sortie (si l'id correspond à celui d'un produit existant dans la li des produits mis en ventes)
```json
{
	"status": ok
}
```
ou
```json
{
	"status":"error",
	"message":"product not found"
}
```

### `PUT /product/:id`
* Modifie les informations du produit dont l'id correspond.
* Entrée :
```json
{
	"id"?: "<Int32>",
	"name"?: "<String>",
	"category"?: "<Int32> | Nil"
	"price"?: "<Float64>"
}
```
* Sortie :
```json
{
	"id": "<Int32>",
	"name": "<String>",
	"category"?: "<Int32> | Nil"
	"price": "<Float64>"
}
```

### `POST /categories`
* Créé une nouvelle catégorie dans la liste des catégories des produits mis en vente et des services proposés.
* Retourne les informations de cette nouvelle catégorie.
* Entrée :
```json
{
	"name": "<String>"
}
```
* Sortie :
```json
{
	"id": "<Int32>",
	"name": "<String>"
}
```

### `GET /categories`
* Retourne la liste des catégories des produites mis en vente et des services proposés.
* Sortie :
```json
[{
	"id": "<Int32>",
	"name": "<String>"
},
...
]
```

### `GET /category/:id`
* Retourne les informations de la catégorie dont l'id correspond, de la liste des catégorires des produits mis en vente et des services proposés (si ce produit/service existe dans cette liste).
* Sortie :
```json
{
	"id": "<Int32>",
	"name": "<String>"
}
```

### `DELETE /category/:id`
* Supprime la catégorie, dont l'id correspond, de la liste des catégories des produits mis en vente et services proposés (si ce produit/service existe dans cette liste).

### `PUT /category/:id`
* Modifie les informations de la catégorie dont l'id correspond.
* Entrée :
```json
{
	"name": "<String>",
}
```
* Sortie :
```json
{
	"id": "<Int32>",
	"name": "<String>"
}
```

### `POST /sale`
* Enregistre une vente dans la liste des ventes.
* Entrée :
```json
{
	data :
		[
			{
				"id": "<id>",
				"quantity": "<quantity>"
			},
		...
		]
}
```

## Développement

XXX: Fill me

## Contributeurs

- Luka Vandervelden
- Marie-France Kommer
- Quentin Gliech

