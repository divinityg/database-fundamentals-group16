-- enter code for sql database here
CREATE TABLE Orders (
    reference VARCHAR(255),
    customer_order VARCHAR(255),
    orders_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(reference, '-', customer_order)) STORED,
    quantity NUMBER,
    unit_retail_price NUMBER,
    total NUMBER,
    CONSTRAINT fk_reference FOREIGN KEY (reference) REFERENCES `References`(references_key),
    CONSTRAINT fk_customer_order FOREIGN KEY (customer_order) REFERENCES `References`(customer_order_key),
    PRIMARY KEY (orders_key)
);

CREATE TABLE Products (
    product_name CHAR(50) PRIMARY KEY NOT NULL,
    coffea_species CHAR(20) NOT NULL,
    varietal CHAR(30) NOT NULL,
    origin CHAR(15) NOT NULL,
    roasting_type CHAR(10) NOT NULL,
    is_decaf BOOLEAN NOT NULL,
    format NUMBER,
    CONSTRAINT fk_format FOREIGN KEY (format) REFERENCES Formats(id)
);

CREATE TABLE Formats(
    format_id NUMBER PRIMARY KEY NOT NULL,
    composition CHAR(25) NOT NULL,
    is_prepared BOOLEAN NOT NULL, --capsules or prepared
    is_volume BOOLEAN NOT NULL, --weight or volume
    packaging_description NUMBER NOT NULL, --'each format in turn can be packaged differing amounts' == 'packaging description (amount of product)
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
    PRIMARY KEY (references_key)
);

CREATE TABLE Replacement_Orders (
    `state` CHAR(50), --can be draft, placed, or fulfilled  
    reference VARCHAR(255),
    replacement_orders_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(`state`, '-', reference)) STORED,
    rep_order_date DATE,
    units NUMBER,
    receiving_date DATE, 
    payment NUMBER, --total cost of replacement (no need to connect to cc's because the db owner will be paying)
    supplier CHAR(50), --point to suppliers
    CONSTRAINT fk_reference FOREIGN KEY (reference) REFERENCES `References`(references_key),
    CONSTRAINT fk_supplier FOREIGN KEY (supplier) REFERENCES Suppliers(supplier_name),
    PRIMARY KEY (replacement_orders_key)
)

CREATE TABLE Suppliers (
    supplier_name CHAR(50) PRIMARY KEY,
    CIF CHAR(15) UNIQUE,
    salesperson_fullname CHAR(50),
    email CHAR(50) UNIQUE,
    phone CHAR(15) UNIQUE,
    address CHAR(100),
    CONSTRAINT fk_address FOREIGN KEY (address) REFERENCES Addresses(addresses_key),
);

CREATE TABLE Customer_Orders(
    contact CHAR(50), --will either be a phone number or email
    is_email BOOLEAN,
    order_date DATE,
    delivery VARCHAR(255), --point to deliveries
    customer_orders_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(contact, '-', order_date, '-', delivery)) STORED,
    payment_type BOOLEAN, --true if paying with credit card
    billing_address VARCHAR(255), --may or may not be the same as the address associated witht he delivery
    payment_date DATE,
    total NUMBER,
    credit_card NUMBER(16), --points to credit cards
    CONSTRAINT fk_delivery FOREIGN KEY (delivery) REFERENCES Deliveries(deliveries_key),
    CONSTRAINT fk_billing_address FOREIGN KEY (billing_address) REFERENCES Addresses(addresses_key),
    CONSTRAINT fk_credit_card FOREIGN KEY (credit_card) REFERENCES Credit_Cards(card_number),
    PRIMARY KEY (customer_orders_key)
);

CREATE TABLE Deliveries(
    address VARCHAR(255), --point to addresses
    delivery_date DATE,
    customer_orders_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(address, '-', delivery_date)) STORED,
    CONSTRAINT fk_address FOREIGN KEY (address) REFERENCES Addresses(addresses_key),
    PRIMARY KEY (deliveries_key)
);

CREATE TABLE Addresses(
    street_num NUMBER(16),
    thoroughfare_type CHAR(15), --pl, st, ave, etc.
    zip CHAR(10),
    city VARCHAR(100), --accounting for long city names
    country CHAR(56),
    addresses_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(street_num, '-', thoroughfare_type, '-', zip, '-', city, '-', country)) STORED,
    gateway NUMBER,
    block NUMBER,
    stairs_id NUMBER,
    floor NUMBER(3),
    door CHAR(4),
    client CHAR(50),
    CONSTRAINT fk_client FOREIGN KEY (client) REFERENCES CLIENTS(username),
    PRIMARY KEY (addresses_key)
);

CREATE TABLE Comments (
    comment_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id CHAR(30),
    product CHAR(50),
    format NUMBER,
    text VARCHAR2(2000),
    rating NUMBER(1),
    likes NUMBER(9),
    CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES Clients(username),
    CONSTRAINT fk_product FOREIGN KEY (product) REFERENCES Products(product_name),
    CONSTRAINT fk_format FOREIGN KEY (format) REFERENCES Formats(format_id)
);

CREATE TABLE Credit_Cards(
    card_number NUMBER(16) PRIMARY KEY,
    company CHAR(30),
    cardholder CHAR(30),
    exp_date CHAR(5), --char max 5 char because its month/year
    address VARCHAR(255),
    client CHAR(30),
    CONSTRAINT fk_address FOREIGN KEY (address) REFERENCES Addresses(addresses_key),
    CONSTRAINT fk_client FOREIGN KEY (client) REFERENCES Clients(username)
);

CREATE TABLE Clients (
    username CHAR(30) PRIMARY KEY,
    password CHAR(30),
    name CHAR(50),
    surname CHAR(50),
    surname2 CHAR(50),
    email CHAR(50) UNIQUE,
    phone NUMBER(15) UNIQUE,
    contact_preference CHAR(50), --email, sms, whatsapp, etc.
    registration_date DATE,
    voucher NUMBER CHECK (stock >= 0 AND stock <= 10),
    voucher_exp_date DATE
);
