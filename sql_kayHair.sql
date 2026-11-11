/*====================================================
    KAY HAIR DATABASE PROJECT
    Author: Kateko Cossa
    Platform: Microsoft SQL Server (T-SQL)
=====================================================*/




CREATE DATABASE KayHair;
GO

USE KayHair;
GO


-- Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR(100),
    RegistrationDate DATE
);

-- Products
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    StockQuantity INT
);

-- Employees
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    PositionTitle VARCHAR(50),
    MonthlySalary DECIMAL(10,2)
);

-- Vendors
CREATE TABLE Vendors (
    VendorID INT IDENTITY(1,1) PRIMARY KEY,
    VendorName VARCHAR(100),
    ContactNumber VARCHAR(20),
    EmailAddress VARCHAR(100)
);

-- Purchase Orders
CREATE TABLE PurchaseOrders (
    PurchaseOrderID INT IDENTITY(1,1) PRIMARY KEY,
    VendorID INT,
    ProductID INT,
    QuantityPurchased INT,
    PurchaseDate DATE,

    FOREIGN KEY (VendorID)
    REFERENCES Vendors(VendorID),

    FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID)
);

-- Sales Orders
CREATE TABLE SalesOrders (
    SalesOrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    TotalAmount DECIMAL(10,2),
    OrderDate DATE,

    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID),

    FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID)
);



/*====================================================
    SAMPLE DATA
=====================================================*/

INSERT INTO Customers
(FirstName, LastName, PhoneNumber, EmailAddress, RegistrationDate)
VALUES
('Ayanda','Mokoena','0821234567','ayanda@gmail.com','2026-01-10'),
('Lerato','Nkosi','0839876543','lerato@gmail.com','2026-01-15'),
('Thabo','Dlamini','0816547890','thabo@gmail.com','2026-02-01'),
('Naledi','Molefe','0843331111','naledi@gmail.com','2026-02-20'),
('Sipho','Zulu','0827891234','sipho@gmail.com','2026-03-05');


INSERT INTO Products
(ProductName, Category, Price, StockQuantity)
VALUES
('Brazilian Wig','Wigs',2500,20),
('Peruvian Wig','Wigs',2800,15),
('Hair Oil','Treatment',150,100),
('Shampoo','Hair Care',120,150),
('Conditioner','Hair Care',180,120);


INSERT INTO Employees
(FirstName, LastName, PositionTitle, MonthlySalary)
VALUES
('Kateko','Cossa','Manager',25000),
('Nomsa','Mabena','Sales Consultant',12000),
('John','Moyo','Stock Controller',10000);


INSERT INTO Vendors
(VendorName, ContactNumber, EmailAddress)
VALUES
('Beauty Suppliers Ltd','0112345678','sales@beautysuppliers.co.za'),
('Hair Direct','0113456789','info@hairdirect.co.za');


INSERT INTO PurchaseOrders
(VendorID, ProductID, QuantityPurchased, PurchaseDate)
VALUES
(1,1,10,'2026-01-05'),
(1,3,50,'2026-01-08'),
(2,2,15,'2026-01-10'),
(2,4,100,'2026-01-15');


INSERT INTO SalesOrders
(CustomerID, ProductID, Quantity, TotalAmount, OrderDate)
VALUES
(1,1,1,2500,'2026-01-20'),
(2,3,2,300,'2026-01-22'),
(3,2,1,2800,'2026-02-03'),
(1,4,3,360,'2026-02-04'),
(4,1,1,2500,'2026-02-10'),
(5,3,4,600,'2026-03-02'),
(3,5,2,360,'2026-03-10');


/*====================================================
    INDEXES
=====================================================*/

CREATE INDEX IX_Customers_LastName
ON Customers(LastName);

CREATE INDEX IX_Products_ProductName
ON Products(ProductName);

CREATE INDEX IX_SalesOrders_OrderDate
ON SalesOrders(OrderDate);



/*====================================================
    STORED PROCEDURES
=====================================================*/

GO

CREATE PROCEDURE GetCustomerOrders
    @CustomerID INT
AS
BEGIN

    SELECT
        C.FirstName,
        C.LastName,
        P.ProductName,
        S.Quantity,
        S.TotalAmount,
        S.OrderDate

    FROM SalesOrders S
        INNER JOIN Customers C
            ON S.CustomerID = C.CustomerID
        INNER JOIN Products P
            ON S.ProductID = P.ProductID

    WHERE S.CustomerID = @CustomerID

END
GO



/*====================================================
    CUSTOMER CLASSIFICATION
=====================================================*/

SELECT
    CustomerID,

    COUNT(*) AS TotalPurchases,

    CASE
        WHEN COUNT(*) >= 3 THEN 'Frequent Buyer'
        WHEN COUNT(*) = 2 THEN 'Returning Customer'
        ELSE 'New Customer'
    END AS CustomerType

FROM SalesOrders
GROUP BY CustomerID;



/*====================================================
    TOP CUSTOMERS
=====================================================*/

SELECT
    TOP 5
    C.FirstName,
    C.LastName,
    SUM(S.TotalAmount) AS TotalSpent

FROM Customers C
INNER JOIN SalesOrders S
ON C.CustomerID = S.CustomerID

GROUP BY
    C.FirstName,
    C.LastName

ORDER BY TotalSpent DESC;



/*====================================================
    BEST SELLING PRODUCTS
=====================================================*/

SELECT
    P.ProductName,
    SUM(S.Quantity) AS TotalSold

FROM Products P
INNER JOIN SalesOrders S
ON P.ProductID = S.ProductID

GROUP BY P.ProductName

ORDER BY TotalSold DESC;



/*====================================================
    MONTHLY SALES REPORT
=====================================================*/

SELECT
    DATENAME(MONTH, OrderDate) AS SalesMonth,
    SUM(TotalAmount) AS Revenue

FROM SalesOrders

GROUP BY DATENAME(MONTH, OrderDate)

ORDER BY Revenue DESC;



/*====================================================
    WINDOW FUNCTION
=====================================================*/

SELECT
    ProductName,
    Price,

    RANK() OVER(
        ORDER BY Price DESC
    ) AS PriceRank

FROM Products;

/*=========================
   The end of the code
===========================*/
