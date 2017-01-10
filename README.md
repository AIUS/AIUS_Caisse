# aius_caisse — Une micro-caisse pour une grande association

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

### `POST /products`

### `GET /product/:id`

### `DELETE /product/:id`

### `PUT /product/:id`

### `GET /categories`

## Développement

XXX: Fill me

## Contributeurs

- Luka Vandervelden
- Marie-France Kommer
- Quentin Gliech

