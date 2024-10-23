--insertion script for lab 1
INSERT INTO Products (product, coffea, varietal, origin, roasting, decaf)
SELECT DISTINCT PRODUCT, COFFEA, VARIETAL, ORIGIN, ROASTING, DECAF
FROM dbf16.catalogue;

