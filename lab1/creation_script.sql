-- enter code for sql database here
CREATE TABLE Products (
    barcode CHAR(15) PRIMARY KEY,
    product_name CHAR(50) UNIQUE,
    coffea_species CHAR(20),
    varietal CHAR(30),
    origin CHAR(15),
    roasting_type CHAR(10),
    is_decaf BOOLEAN,
    format --how do you point to formats
);

CREATE TABLE Formats(
    product_name CHAR(50) UNIQUE,
    composition CHAR(25),
    is_prepared BOOLEAN, --capsules or prepared
    is_volume BOOLEAN, --weight or volume
    packaging_description NUMBER, --'each format in turn can be packaged differing amounts' == 'packaging description (amount of product)
);

CREATE TABLE References (
    barcode CHAR(15) PRIMARY KEY,
    packaging_description NUMBER, --connects to Format
    retail_price NUMBER(8,2), --connects to Products
    cur_stock NUMBER,
    min_stock NUMBER(5) DEFAULT 5, 
    max_stock NUMBER(5) DEFAULT 10
    product  --how do you point to products
);

CREATE TABLE Replacement_Orders (
    state --what is this, need to replace name since its a command
    reference --again still don't know how to point to references
    order_date CHAR(14),
    units NUMBER,
    receiving_date CHAR(14), 
    payment, --what is this, would it need to connect to cc? 
    supplier --point to suppliers
)

CREATE TABLE Suppliers (
    supplier_name CHAR(50) PRIMARY KEY,
    CIF CHAR(15) UNIQUE,
    salesperson_fullname CHAR(50),
    email CHAR(50) UNIQUE,
    phone CHAR(15) UNIQUE,
    address CHAR(100)
);

CREATE TABLE Customer_Orders(

);

CREATE TABLE Deliveries(

);

CREATE TABLE Addresses(

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

CREATE TABLE Credit_Cards(

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