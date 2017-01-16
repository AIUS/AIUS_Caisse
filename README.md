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

	^C
	Kemal is going to take a rest!


## API REST

### `GET /products`
* Retourne la liste des produits.
* Chaque produit est sous la forme :
```json
{
	"id": "<Int32>",
	"name": "<String>",
	"price": "<Float64>"
}
```

### `POST /products`
* Entre un nouveau produit dans la liste des produits et retourne les informations de ce produit.
* Entrée :
```json
{
	"id": "<Int32>",
	"name": "<String>",
	"price": "<Float64>"
}
```

### `GET /product/:id`
* Retourne les informations du produit dont on entre l'id.

### `DELETE /product/:id`
* Supprime le produit, dont l'id correspond, de la liste.
* Retourne :
  - si la suppression a réussi :
```json
DB::ExecResult(@rows_affected=1, @last_insert_id=0
```
  - sinon :
```json
	DB::ExecResult(@rows_affected=0, @last_insert_id=0)
```

### `PUT /product/:id`
* Modifie les informations du produit dont l'id correspond.
* Entrée :
```json
{
	"id"?: "<Int32>",
	"name"?: "<String>",
	"price"?: "<Float64>"
}
```

### `GET /categories`
* Retourne la liste des catégories.
* Une catégorie est sous la forme :
```json
{
	"id": "<Int32>",
	"name": "<String>"
}
```

### `GET /category/:id`
* Retourne les informations de la catégorie dont on entre l'id ou une erreure 404 si l'id n'existe pas.

### `POST /categories`
* Entre une nouvelle catégorie dans la liste des catégories et retourne les informations de cettes catégorie.
* Entrée :
```json
{
	"name: "<String>"
}
```

### `DELETE /category/:id`
* Supprime la catégorie, dont l'id correspond, de la liste.
* Retourne : 
  - si la suppression a réussi :
```json
DB::ExecResult(@rows_affected=1, @last_insert_id=0
```
  - sinon :
```json
	DB::ExecResult(@rows_affected=0, @last_insert_id=0)
```

### `PUT /category/:id`
* Modifie les informations de la catégorie dont l'id correspond.
* Entrée :
```json
{
	"name": "<String>",
}
```

### `POST /sale`
```json
{
	data :
		[{
			"id": "<id>",
			"quantity": "<quantity>"
		},
		...
}
```

## Développement

XXX: Fill me

## Contributeurs

- Luka Vandervelden
- Marie-France Kommer
- Quentin Gliech

