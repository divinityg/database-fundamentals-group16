-- enter code for sql database here
CREATE TABLE Orders (
    reference VARCHAR(255),
    customer_order VARCHAR(255),
    orderss_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(reference, '-', customer_order)) STORED,
    quantity NUMBER,
    unit_retail_price NUMBER,
    total NUMBER,
    PRIMARY KEY (reference, customer_order),
    CONSTRAINT fk_reference FOREIGN KEY (reference) REFERENCES `References`(references_key),
    CONSTRAINT fk_customer_order FOREIGN KEY (customer_order) REFERENCES `References`(customer_order_key)
);

CREATE TABLE Products (
    product_name CHAR(50) PRIMARY KEY,
    coffea_species CHAR(20),
    varietal CHAR(30),
    origin CHAR(15),
    roasting_type CHAR(10),
    is_decaf BOOLEAN,
    format NUMBER,
    CONSTRAINT fk_format FOREIGN KEY (format) REFERENCES Formats(id)
);

CREATE TABLE Formats(
    id NUMBER,
    composition CHAR(25),
    is_prepared BOOLEAN, --capsules or prepared
    is_volume BOOLEAN, --weight or volume
    amount NUMBER, --'each format in turn can be packaged differing amounts' == 'packaging description (amount of product)
);

CREATE TABLE `References` ( --references is a keyword so the backticks are necessary
    barcode CHAR(15),
    packaging_description NUMBER,
    retail_price NUMBER,
    references_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(barcode, '-', packaging_description, '-', retail_price)) STORED,
    cur_stock NUMBER,
    min_stock NUMBER DEFAULT 5, 
    max_stock NUMBER DEFAULT 10
    product CHAR(50),
    CONSTRAINT fk_product FOREIGN KEY (product) REFERENCES Products(product_name),
    PRIMARY KEY (barcode, packaging_description, retail_price)
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
