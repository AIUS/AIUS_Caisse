CREATE TABLE product_category (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL
);

CREATE TABLE product (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	category INTEGER references product_category(id) ON DELETE SET NULL ON UPDATE CASCADE,
	price FLOAT NOT NULL DEFAULT 0 CHECK (price >= 0),
        active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE sale (
	id SERIAL PRIMARY KEY,
	seller UUID,
	date TIMESTAMP DEFAULT CURRENT_DATE
);

CREATE TABLE sale_product (
	sale INTEGER NOT NULL references sale(id),
	product INTEGER NOT NULL references product(id),
	quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
	CONSTRAINT unique_sale_product UNIQUE(sale, product)
);
