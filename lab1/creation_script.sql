-- enter code for sql database here
CREATE TABLE Products (
    barcode CHAR(15) PRIMARY KEY,
    product_name CHAR(50) UNIQUE,
    coffea_species CHAR(20),
    varietal CHAR(30),
    origin CHAR(15),
    roasting_type CHAR(10),
    decaf CHAR(12),
    packaging CHAR(15),
    retail_price NUMBER(8, 2),
    stock_amount NUMBER(5),
    min_stock NUMBER(5) DEFAULT 5,
    max_stock NUMBER(5) DEFAULT 10
);

CREATE TABLE Suppliers (
    supplier_id NUMBER PRIMARY KEY,
    name CHAR(50),
    CIF CHAR(15) UNIQUE,
    salesperson_name CHAR(50),
    email CHAR(50) UNIQUE,
    phone CHAR(15) UNIQUE,
    address CHAR(100)
);

CREATE TABLE Clients (
    client_id NUMBER PRIMARY KEY,
    name CHAR(50),
    surname CHAR(50),
    email CHAR(50) UNIQUE,
    phone CHAR(15) UNIQUE,
    address CHAR(100),
    username CHAR(30) UNIQUE,
    password CHAR(30),
    registration_date DATE
);

CREATE TABLE Orders (
    order_id NUMBER PRIMARY KEY,
    client_id NUMBER,
    order_date DATE,
    order_time TIMESTAMP,
    delivery_date DATE,
    delivery_address CHAR(100),
    payment_type CHAR(20),
    payment_date DATE,
    CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

CREATE TABLE Comments (
    comment_id NUMBER PRIMARY KEY,
    client_id NUMBER,
    barcode CHAR(15),
    post_date DATE,
    post_time TIMESTAMP,
    title CHAR(50),
    text VARCHAR2(2000),
    score NUMBER(1),
    likes NUMBER(9),
    CONSTRAINT fk_comment_client FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    CONSTRAINT fk_comment_product FOREIGN KEY (barcode) REFERENCES Products(barcode)
);