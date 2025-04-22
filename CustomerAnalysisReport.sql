---Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)---
---Code 1 : Table orders_1---
SELECT
    SUM(quantity) AS total_penjualan,
    SUM(quantity * priceeach) AS revenue
FROM 
    orders_1
WHERE
    status = 'Shipped'

---Code 2 : Table orders_2---
SELECT
    SUM(quantity) AS total_penjualan,
    SUM(quantity * priceeach) AS revenue
FROM 
    orders_2
WHERE
    status = 'Shipped'

---Menghitung persentasi keseluruhan penjualan---
SELECT
    quarter,
    SUM(quantity) AS total_penjualan,
    SUM(quantity * priceeach) AS revenue
FROM
(
    SELECT
        orderNumber,
        status,
        quantity,
        priceeach,
        1 AS quarter
    FROM
        orders_1
    WHERE
        status = 'Shipped'
    
    UNION ALL

    SELECT
        orderNumber,
        status,
        quantity,
        priceeach,
        2 AS quarter
    FROM
        orders_2
    WHERE
        status = 'Shipped'
) AS table_a
GROUP BY
    1

---Menghitung penambahan jumlah customers xyz.com---
SELECT
    quarter,
    COUNT(DISTINCT customerID) AS total_customers
FROM
(
    SELECT
        customerID,
        QUARTER(createDate) AS quarter
    FROM
        customer
    WHERE
        createDate
    BETWEEN
    '2004-01-01' AND '2004-06-30'
) as table_b
GROUP BY
1

--Mnghitung banyak customers yang sudah melakukan transaksi---
SELECT
    quarter,
    COUNT(DISTINCT customerID) AS total_customers
FROM
(
    SELECT
        customerID,
        QUARTER(createDate) as quarter
    FROM
        customer
    WHERE
        createDate
    BETWEEN
        '2004-01-01' AND '2004-06-30'
) AS table_b
WHERE 
    customerID 
IN 
(
    SELECT 
        DISTINCT customerID 
    FROM
        orders_1

    UNION

    SELECT
        DISTINCT customerID
    FROM
        orders_2
)
GROUP BY
1;

---Menghitung Category produk yang paling banyak di-order oleh customers di Quarter-2----
SELECT
    categoryID,
    COUNT(DISTINCT orderNumber) AS total_order,
    SUM(quantity) AS total_penjualan
FROM
(
    SELECT DISTINCT 
        productCode,
        orderNumber,
        quantity,
        status,
        LEFT(productCode, 3) AS categoryID
    FROM
        orders_2
    WHERE
        status = 'Shipped'
) AS table_c
GROUP BY
    1
ORDER BY
    2 DESC;

---Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya----
SELECT
    1 AS quarter,
    ROUND(
        COUNT(
            DISTINCT customerID
        ) * 100 / 25 , 4
    ) AS Q2
FROM
    orders_1
WHERE 
    customerID
IN
(
    SELECT DISTINCT
        customerID
    FROM
        orders_2
)
