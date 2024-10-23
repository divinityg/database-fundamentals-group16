-- enter code for sql database here
CREATE TABLE Products (
    barcode CHAR(15) PRIMARY KEY NOT NULL,
    product_name CHAR(50) UNIQUE NOT NULL,
    coffea_species CHAR(20) NOT NULL,
    varietal CHAR(30) NOT NULL,
    origin CHAR(15) NOT NULL,
    roasting_type CHAR(10) NOT NULL,
    is_decaf BOOLEAN NOT NULL,
    format --how do you point to formats
);

CREATE TABLE Formats(
    format_id NUMBER PRIMARY KEY NOT NULL,
    product_name CHAR(50) UNIQUE NOT NULL,
    composition CHAR(25) NOT NULL,
    is_prepared BOOLEAN NOT NULL, --capsules or prepared
    is_volume BOOLEAN NOT NULL, --weight or volume
    packaging_description NUMBER NOT NULL, --'each format in turn can be packaged differing amounts' == 'packaging description (amount of product)
);

CREATE TABLE References (
    barcode CHAR(15) PRIMARY KEY,
    packaging_description NUMBER, --connects to Format
    retail_price NUMBER(8,2), --connects to Products
    cur_stock NUMBER,
    min_stock NUMBER(5) DEFAULT 5, 
    max_stock NUMBER(5) DEFAULT 10
    product  --how do you point to products
);

CREATE TABLE Replacement_Orders (
    state --what is this, need to replace name since its a command
    reference --again still don't know how to point to references
    rep_order_date DATE,
    units NUMBER,
    receiving_date DATE, 
    payment, --what is this, would it need to connect to cc? 
    supplier --point to suppliers
)

CREATE TABLE Suppliers (
    supplier_name CHAR(50) PRIMARY KEY,
    CIF CHAR(15) UNIQUE,
    salesperson_fullname CHAR(50),
    email CHAR(50) UNIQUE,
    phone CHAR(15) UNIQUE,
    address CHAR(100)
);

CREATE TABLE Customer_Orders(
    contact, --unknown what this is
    cust_order_date DATE,
    delivery, --point to deliveries
    payment_type, --unknown what this is
    billing_address, --is this the same as address? points to it on form
    payment_date DATE,
    total NUMBER, --is the formatting different for doubles?
    credit_card, --points to credit cards
);

CREATE TABLE Deliveries(
    address, --needs to point to addresses
    delivery_date DATE
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
    registration_date DATE
);

CREATE TABLE Addresses(
    stree_num NUMBER(16),
    thoroughfare_type, --i forgot what this is so idk the var type
    zip CHAR(10),
    city CHAR, --idk what the min should be
    country CHAR(56),
    gateway NULL, --forgot var type
    block NULL, --forgot var type and need to change var name
    stairs_id NULL, --is this a number
    floor NUMBER(3) NULL,
    door CHAR(4) NULL,
    client NULL -- need help pointing
);

CREATE TABLE Credit_Cards(
    card_number NUMBER(16),
    company CHAR(30),
    cardholder CHAR(30),
    exp_date CHAR(5), --char max 5 char because its month/year
    address, --pointer help
    client --pointer help
);

CREATE TABLE Orders (
    order_id NUMBER PRIMARY KEY,
    client_id NUMBER,
    order_date DATE,
    order_time TIMESTAMP,
    delivery_date DATE,
    delivery_address CHAR(100),
    payment_type CHAR(20),
    CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

CREATE TABLE Comments (
    comment_id NUMBER PRIMARY KEY,
    client_id NUMBER,
    product, --need help pointing
    format NULL, --need help pointing
    post_date DATE,
    post_time TIMESTAMP,
    title CHAR(50),
    comment_text VARCHAR2(2000),
    score NUMBER(1),
    likes NUMBER(9),
    CONSTRAINT fk_comment_client FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    CONSTRAINT fk_comment_product FOREIGN KEY (barcode) REFERENCES Products(barcode)
);