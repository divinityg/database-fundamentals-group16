--insertion script for lab 1
INSERT INTO Products (product, coffea, varietal, origin, roasting, decaf)
SELECT DISTINCT PRODUCT, COFFEA, VARIETAL, ORIGIN, ROASTING, DECAF
FROM dbf16.catalogue;

INSERT INTO Formats (format_id, roasting, is_prepared, is_volume, packaging)
SELECT DISTINCT ROWNUM, ROASTING, 'FALSE' as is_prepared, 'TRUE' as is_volume, PACKAGING
FROM dbf10.catalogue;

INSERT INTO `References` (barcode, packaging, retail_price, cur_stock, min_stock, max_stock, product)
SELECT BARCODE, PACKAGING, RETAIL_PRICE, CUR_STOCK, MIN_STOCK, MAX_STOCK, PRODUCT
FROM dbf10.catalogue;

INSERT INTO Suppliers (supplier_name, CIF, salesperson_fullname, email, phone, address)
SELECT DISTINCT SUPPLIER, PROV_TAXID, PROV_PERSON, PROV_EMAIL, PROV_MOBILE, PROV_ADDRESS
FROM dbf10.catalogue;

INSERT INTO Customer_Orders (contact, is_email, order_date, delivery, customer_orders_key, payment_type, billing_address, payment_date, total, credit_card, client)
SELECT USERNAME, 
       CASE WHEN INSTR(USERNAME, '@') > 0 THEN 'TRUE' ELSE 'FALSE' END AS is_email,
       TO_DATE(ORDERDATE, 'YYYYMMDD'), 
       CONCAT(DLIV_WAYNAME, ' ', DLIV_WAYTYPE, ', ', DLIV_TOWN) AS delivery,
       CONCAT(USERNAME, '-', ORDERDATE, '-', CONCAT(DLIV_WAYNAME, ' ', DLIV_WAYTYPE, ', ', DLIV_TOWN)) AS customer_orders_key,
       CASE WHEN PAYMENT_TYPE = 'Credit Card' THEN 'TRUE' ELSE 'FALSE' END AS payment_type,
       CONCAT(BILL_WAYNAME, ' ', BILL_WAYTYPE, ', ', BILL_TOWN) AS billing_address,
       TO_DATE(PAYMENT_DATE, 'YYYYMMDD'),
       BASE_PRICE * QUANTITY AS total,
       CARD_NUMBER,
       USERNAME AS client
FROM dbf10.trolley;

INSERT INTO Credit_Cards (card_number, card_company, card_holder, card_expiratn, address, client)
SELECT DISTINCT CARD_NUMBER, CARD_COMPANY, CARD_HOLDER, CARD_EXPIRATN,
       CONCAT(BILL_WAYNAME, ' ', BILL_WAYTYPE, ', ', BILL_TOWN) AS address, 
       USERNAME AS client
FROM dbf10.trolley;

INSERT INTO Comments (client_id, product, barcode, post_date, post_time, title, text, score, likes, endorsed)
SELECT USERNAME, PRODUCT, BARCODE, POST_DATE, POST_TIME, TITLE, TEXT, SCORE, LIKES, ENDORSED
FROM dbf10.posts;

INSERT INTO Addresses (street_num, thoroughfare_type, zip, city, country, gateway, block, stairs_id, floor, door, client)
SELECT DISTINCT BILL_GATE, BILL_WAYTYPE, BILL_ZIP, BILL_TOWN, BILL_COUNTRY, 
       NULL AS gateway, BILL_BLOCK, BILL_STAIRW, BILL_FLOOR, BILL_DOOR, USERNAME AS client
FROM dbf10.trolley;
