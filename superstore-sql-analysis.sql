CREATE DATABASE superstore;

CREATE TABLE superstore.products (
    Product            VARCHAR(50) PRIMARY KEY,
    ProductCategory    VARCHAR(50),
    UnitPrice          DECIMAL(10,2),
    TotalQuantitySold  INT,
    AvgDiscountPct     DECIMAL(5,2),
    TotalSales         DECIMAL(12,2),
    TotalProfit        DECIMAL(12,2),
    NumOrders          INT
);

CREATE TABLE superstore.orders (
    OrderID              VARCHAR(20) PRIMARY KEY,
    Region               VARCHAR(50),
    Product              VARCHAR(50),
    ProductCategory      VARCHAR(50),
    UnitPrice            DECIMAL(10,2),
    Quantity             INT,
    DiscountPct          DECIMAL(5,2),
    TotalSales           DECIMAL(12,2),
    Profit               DECIMAL(12,2),
    Season               VARCHAR(20),
    OrderDate            DATE,
    CustomerSegment      VARCHAR(50),
    ProfitMargin         DECIMAL(5,2)
);

-- Adding a foreign key constraint for matching product in both tables
ALTER TABLE superstore.orders
ADD CONSTRAINT fk_orders_products
FOREIGN KEY (Product)
REFERENCES superstore.products(Product);

-- Creating a separate date dimension table to store each order date and its season once
CREATE TABLE superstore.dim_date (
    OrderDate DATE PRIMARY KEY,
    Season    VARCHAR(20)
);

INSERT INTO superstore.dim_date (OrderDate, Season)
SELECT DISTINCT
    OrderDate,
    Season
FROM superstore.orders;

-- Linking each order to its corresponding date row
ALTER TABLE superstore.orders
ADD CONSTRAINT fk_orders_date
FOREIGN KEY (OrderDate)
REFERENCES superstore.dim_date(OrderDate);

-- Removing the Season column from the orders table
ALTER TABLE superstore.orders
DROP COLUMN Season;
