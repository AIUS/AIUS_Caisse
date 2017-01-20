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
* Sorties :
 - si l'id correspond à celui d'un produit existant dans la liste des produits mis en ventes
```json
{
	"id": "<Int32>",
	"name": "<String>",
	"category"?: "<Int32> | Nil"
	"price": "<Float64>"
}
```
 - si l'id ne correspond à celui d'un produit existant dans la liste des produits mis en ventes
```json
{
	"status": "error",
	"message": "product not found"}
```

### `DELETE /product/:id`
* Supprime le produit, dont l'id correspond, de la liste des produits mis en vente (si ce produit existe dans cette liste).
* Sorties :
 - si l'id correspond à celui d'un produit existant dans la liste des produits mis en ventes
```json
{
	"status": ok
}
```
 - si l'id ne correspond à celui d'un produit existant dans la liste des produits mis en ventes
```json
{
	"status": "error",
	"message": "product not found"
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
* Sorties :
 - si l'id correspond à celui d'une catégorie existante dans la liste des catégories des produits mis en ventes et services proposés

```json
{
	"id": "<Int32>",
	"name": "<String>"
}
```
 - si l'id ne correspond pas à celui d'une catégorie existante dans la liste des catégories des produits mis en ventes et services proposés
 ```json
{
	"status": "error",
	"message": "category not found"
}
 ```

### `DELETE /category/:id`
* Supprime la catégorie, dont l'id correspond, de la liste des catégories des produits mis en vente et services proposés (si ce produit/service existe dans cette liste).
* Sorties :
 - si l'id correspond à celui d'une catégorie existante dans la liste des catégories des produits mis en ventes et services proposés
 ```json
{
	"status": "ok"
}
 ```
 - si l'id ne correspond pas à celui d'une catégorie existante dans la liste des catégories des produits mis en ventes et services proposés
 ```json
{
	"status": "error",
	"message": "category not found"
}
 ```

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

### `GET /sale?begin="%Y-%m-%d"&end="%Y-%m-%d"`

Renvoie la liste des vente entre deux date.

Entrée :
* begin	: Date du debut de l'intervalle. Defaut : "1995-04-24"
* end 	: Date de fin de l'intervalle Defaut : Time.now()

Sortie :
```json
[
	{
		id: "<id>"
		seller: "<uuid>"
		sale_products: [
				{
					product: "<id>"
					quantity: "<Int32>"
				},
				...
			]
		date: "<date>"
	},
	...
]
```

### `POST /sale`

Enregistre une vente dans la base de donnée.

Entrée :
```json
{
	data :
		[
			{
				"id": "<id>",
				"quantity": "<Int32>"
			},
		...
		]
}
```

Sortie
```json
{
	id: "<id>"
	seller: "<uuid>"
	sale_products: []
	date: "<date>"
}
```

### `DELETE /sale/:id`

Supprime une vente.

Sortie :
```json
{ status: "OK" }
ou si il y a une erreur
{ 
	status: "error",
	message: "No row affected" 
}
```

## Développement

XXX: Fill me

## Contributeurs

- Luka Vandervelden
- Marie-France Kommer
- Quentin Gliech

