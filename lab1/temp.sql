-- enter code for sql database here
--skipped retail_price CHAR(12)
CREATE TABLE Orders (
    reference VARCHAR(255) NOT NULL,
    customer_order VARCHAR(255) NOT NULL,
    orders_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(reference, '-', customer_order)) STORED,
    quantity NUMBER NOT NULL,
    unit_retail_price NUMBER NOT NULL,
    total NUMBER NOT NULL,
    CONSTRAINT fk_reference FOREIGN KEY (reference) REFERENCES `References`(references_key),
    CONSTRAINT fk_customer_order FOREIGN KEY (customer_order) REFERENCES `References`(customer_order_key),
    PRIMARY KEY (orders_key)
);

CREATE TABLE Products (
    --product CHAR(50) PRIMARY KEY NOT NULL,
);
--     --product CHAR(50) PRIMARY KEY NOT NULL,
--     --coffea CHAR(20) NOT NULL,
--     --varietal CHAR(30) NOT NULL,
--     --origin CHAR(15) NOT NULL,
--     --roasting CHAR(10) NOT NULL,
--     --decaf CHAR(12) NOT NULL,
--     --format CHAR(20) NOT NULL,
--     CONSTRAINT fk_format FOREIGN KEY (format) REFERENCES Formats(id)
-- );

CREATE TABLE Formats(
    format_id NUMBER PRIMARY KEY NOT NULL,
    --roasting CHAR(10) NOT NULL,
    is_prepared BOOLEAN NOT NULL, --capsules or prepared
    is_volume BOOLEAN NOT NULL, --weight or volume
    --packaging CHAR(15) NOT NULL, --'each format in turn can be packaged differing amounts' == 'packaging description (amount of product)
);

CREATE TABLE `References` ( --references is a keyword so the backticks are necessary
    --barcode CHAR(15) NOT NULL,
    --packaging CHAR(15) NOT NULL,
    --retail_price CHAR(14) NOT NULL,
    references_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(barcode, '-', packaging_description, '-', retail_price)) STORED,
    --cur_stock CHAR(5) NOT NULL,
    --min_stock CHAR(5) DEFAULT 5 NOT NULL, 
    --max_stock CHAR(5) DEFAULT 10 NOT NULL,
    product CHAR(50) NOT NULL,
    CONSTRAINT fk_product FOREIGN KEY (product) REFERENCES Products(product_name),
    PRIMARY KEY (references_key)
);

CREATE TABLE Replacement_Orders (
    `state` CHAR(50) NOT NULL, --can be draft, placed, or fulfilled  
    reference VARCHAR(255) NOT NULL,
    replacement_orders_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(`state`, '-', reference)) STORED,
    rep_order_date DATE NOT NULL,
    units NUMBER NOT NULL,
    receiving_date DATE NOT NULL, 
    payment NUMBER NOT NULL, --total cost of replacement (no need to connect to cc's because the db owner will be paying)
    --supplier CHAR(35) NOT NULL, --point to suppliers
    CONSTRAINT fk_reference FOREIGN KEY (reference) REFERENCES `References`(references_key),
    CONSTRAINT fk_supplier FOREIGN KEY (supplier) REFERENCES Suppliers(supplier_name),
    PRIMARY KEY (replacement_orders_key)
)

CREATE TABLE Suppliers (
    supplier_name CHAR(35) PRIMARY KEY,
    CIF CHAR(10) UNIQUE NOT NULL,
    salesperson_fullname CHAR(90) NOT NULL,
    email CHAR(60) UNIQUE NOT NULL,
    phone CHAR(9) UNIQUE NOT NULL,
    address VARCHAR(255) NOT NULL,
    CONSTRAINT fk_address FOREIGN KEY (address) REFERENCES Addresses(addresses_key),
);

CREATE TABLE Customer_Orders(
    contact CHAR(50) NOT NULL, --will either be a phone number or email
    is_email BOOLEAN NOT NULL,
    order_date DATE NOT NULL,
    delivery VARCHAR(255) NOT NULL, --point to deliveries
    customer_orders_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(contact, '-', order_date, '-', delivery)) STORED,
    payment_type BOOLEAN NOT NULL, --true if paying with credit card
    billing_address VARCHAR(255) NOT NULL, --may or may not be the same as the address associated witht he delivery
    payment_date DATE NOT NULL,
    total NUMBER NOT NULL,
    credit_card NUMBER(16), --points to credit cards
    client CHAR(30),
    CONSTRAINT fk_client FOREIGN KEY (client) REFERENCES Clients(username),
    CONSTRAINT fk_delivery FOREIGN KEY (delivery) REFERENCES Deliveries(deliveries_key),
    CONSTRAINT fk_billing_address FOREIGN KEY (billing_address) REFERENCES Addresses(addresses_key),
    CONSTRAINT fk_credit_card FOREIGN KEY (credit_card) REFERENCES Credit_Cards(card_number),
    PRIMARY KEY (customer_orders_key)
);

CREATE TABLE Deliveries(
    address VARCHAR(255) NOT NULL, --point to addresses
    dliv_date CHAR(14) NOT NULL,
    customer_orders_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(address, '-', delivery_date)) STORED,
    CONSTRAINT fk_address FOREIGN KEY (address) REFERENCES Addresses(addresses_key),
    PRIMARY KEY (deliveries_key)
);

CREATE TABLE Addresses(
    street_address CHAR(120) NOT NULL,
    thoroughfare_type CHAR(15) NOT NULL, --pl, st, ave, etc.
    zip CHAR(5) NOT NULL,
    city VARCHAR(45) NOT NULL, --accounting for long city names
    country CHAR(45) NOT NULL,
    addresses_key VARCHAR(255) GENERATED ALWAYS AS (CONCAT(street_num, '-', thoroughfare_type, '-', zip, '-', city, '-', country)) STORED,
    gateway CHAR(3),
    block CHAR(1),
    stairs_id CHAR(2),
    floor NUMBER(7),
    door CHAR(1),
    client CHAR(50),
    CONSTRAINT fk_client FOREIGN KEY (client) REFERENCES CLIENTS(username),
    PRIMARY KEY (addresses_key)
);

CREATE TABLE Comments (
    comment_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    --client_id CHAR(30),
    --product CHAR(50) NOT NULL,
    --barcode CHAR(15),
    --post_date CHAR(14),
    --post_time CHAR(14),

    format NUMBER,
    --title CHAR(50) NOT NULL,
    --text CHAR(2000) NOT NULL,
    --score CHAR(1) NOT NULL,
    --likes CHAR(9) NOT NULL,
    --endorsed CHAR(50),
    CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES Clients(username),
    CONSTRAINT fk_product FOREIGN KEY (product) REFERENCES Products(product_name),
    CONSTRAINT fk_format FOREIGN KEY (format) REFERENCES Formats(format_id)
);

CREATE TABLE Credit_Cards(
    --card_number CHAR(20) PRIMARY KEY NOT NULL,
    --card_company CHAR(15) NOT NULL,
    --card_holder CHAR(30) NOT NULL,
    --card_expiratn CHAR(7) NOT NULL, --char max 5 char because its month/year
    address VARCHAR(255) NOT NULL,
    client CHAR(30),
    CONSTRAINT fk_address FOREIGN KEY (address) REFERENCES Addresses(addresses_key),
    CONSTRAINT fk_client FOREIGN KEY (client) REFERENCES Clients(username)
);

CREATE TABLE Clients (
    --username CHAR(30) PRIMARY KEY NOT NULL,
    --user_passw CHAR(15) NOT NULL,
    name CHAR(50) NOT NULL,
    surname CHAR(50) NOT NULL,
    surname2 CHAR(50),
    email CHAR(50) UNIQUE,
    phone NUMBER(15) UNIQUE,
    contact_preference CHAR(50), --email, sms, whatsapp, etc.
    registration_date DATE NOT NULL,
    voucher NUMBER CHECK (stock >= 0 AND stock <= 10),
    voucher_exp_date DATE
);
