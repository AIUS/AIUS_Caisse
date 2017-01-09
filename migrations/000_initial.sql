CREATE TABLE product_category (
	id INTEGER PRIMARY KEY,
	name VARCHAR(255)
);

CREATE TABLE product (
	id INTEGER PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	category INTEGER references product_category(id),
	price FLOAT NOT NULL CHECK (price >= 0)
);

CREATE TABLE sale (
	id INTEGER PRIMARY KEY,
	seller UUID,
	date TIMESTAMP DEFAULT CURRENT_DATE
);

CREATE TABLE sale_product (
	sale INTEGER references sale(id),
	product INTEGER references product(id),
	quantity INTEGER NOT NULL CHECK (quantity > 0),
	CONSTRAINT unique_sale_product UNIQUE(sale, product)
);
