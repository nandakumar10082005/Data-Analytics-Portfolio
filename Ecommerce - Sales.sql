use ecommerce_project ;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Age INT,
    Gender VARCHAR(20)
);
select * from customers;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Cost DECIMAL(10,2)
);
select*from products;

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Status VARCHAR(30),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
select * from orders;

CREATE TABLE Order_Details (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
select * from order_Details

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    PaymentDate DATE,
    PaymentMethod VARCHAR(50),
    PaymentAmount DECIMAL(12,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
select* from Payments;


use ecommerce_project;



-- ============================================================
-- E-COMMERCE SALES & CUSTOMER ANALYSIS
-- 50 CORPORATE SQL BUSINESS QUESTIONS
-- ============================================================


-- ============================================================
-- SECTION 1: CUSTOMER & BUSINESS OVERVIEW
-- ============================================================


-- Q1. How many total customers are registered on the platform?

SELECT COUNT(*) AS Total_Customers
FROM Customers;


-- Q2. How many total products are available in the product catalog?

SELECT COUNT(*) AS Total_Products
FROM Products;


-- Q3. How many total orders have been placed?

SELECT COUNT(*) AS Total_Orders
FROM Orders;


-- Q4. How many different cities do our customers come from?

SELECT COUNT(DISTINCT City) AS Total_Cities
FROM Customers;


-- Q5. How many customers belong to each gender?

SELECT 
    Gender,
    COUNT(*) AS Customer_Count
FROM Customers
GROUP BY Gender;


-- Q6. Which are the top 10 cities by number of customers?

SELECT 
    City,
    COUNT(*) AS Customer_Count
FROM Customers
GROUP BY City
ORDER BY Customer_Count DESC
LIMIT 10;


-- Q7. What is the average age of our customers?

SELECT 
    ROUND(AVG(Age), 2) AS Average_Customer_Age
FROM Customers;


-- Q8. How many customers are above the age of 30?

SELECT COUNT(*) AS Customers_Above_30
FROM Customers
WHERE Age > 30;


-- Q9. Which customers are located in Chennai?

SELECT 
    CustomerID,
    CustomerName,
    City,
    State
FROM Customers
WHERE City = 'Chennai';


-- Q10. Which customers have never placed an order?

SELECT 
    c.CustomerID,
    c.CustomerName,
    c.City
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;



-- ============================================================
-- SECTION 2: PRODUCT & CATALOG ANALYSIS
-- ============================================================


-- Q11. How many products are available in each category?

SELECT 
    Category,
    COUNT(*) AS Product_Count
FROM Products
GROUP BY Category
ORDER BY Product_Count DESC;


-- Q12. What is the average selling price for each product category?

SELECT 
    Category,
    ROUND(AVG(Price), 2) AS Average_Price
FROM Products
GROUP BY Category
ORDER BY Average_Price DESC;


-- Q13. Which are the 10 most expensive products?

SELECT 
    ProductID,
    ProductName,
    Category,
    Price
FROM Products
ORDER BY Price DESC
LIMIT 10;


-- Q14. Which are the 10 least expensive products?

SELECT 
    ProductID,
    ProductName,
    Category,
    Price
FROM Products
ORDER BY Price ASC
LIMIT 10;


-- Q15. Which products have a selling price greater than ₹10,000?

SELECT 
    ProductID,
    ProductName,
    Category,
    Price
FROM Products
WHERE Price > 10000
ORDER BY Price DESC;


-- Q16. Which products have the highest profit margin?

SELECT 
    ProductID,
    ProductName,
    Category,
    Price,
    Cost,
    ROUND(((Price - Cost) / Price) * 100, 2) AS Profit_Margin_Percentage
FROM Products
ORDER BY Profit_Margin_Percentage DESC;


-- Q17. What is the average profit margin for each product category?

SELECT 
    Category,
    ROUND(AVG(((Price - Cost) / Price) * 100), 2) 
        AS Average_Profit_Margin
FROM Products
GROUP BY Category
ORDER BY Average_Profit_Margin DESC;


-- Q18. Which products have a selling price-to-cost difference greater than ₹5,000?

SELECT 
    ProductID,
    ProductName,
    Category,
    Price,
    Cost,
    (Price - Cost) AS Profit_Per_Unit
FROM Products
WHERE (Price - Cost) > 5000
ORDER BY Profit_Per_Unit DESC;


-- Q19. Which product categories contain the most products?

SELECT 
    Category,
    COUNT(*) AS Product_Count
FROM Products
GROUP BY Category
ORDER BY Product_Count DESC;


-- Q20. Which products have never been sold?

SELECT 
    p.ProductID,
    p.ProductName,
    p.Category
FROM Products p
LEFT JOIN Order_Details od
    ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;



-- ============================================================
-- SECTION 3: SALES & REVENUE ANALYSIS
-- ============================================================


-- Q21. What is the company's total sales revenue?

SELECT 
    SUM(od.Quantity * p.Price) AS Total_Revenue
FROM Order_Details od
JOIN Products p
    ON od.ProductID = p.ProductID;
    


-- Q22. What is the total cost of products sold?

SELECT 
    SUM(od.Quantity * p.Cost) AS Total_Cost
FROM Order_Details od
JOIN Products p
    ON od.ProductID = p.ProductID;


-- Q23. What is the company's total profit?

SELECT 
    SUM(od.Quantity * (p.Price - p.Cost)) AS Total_Profit
FROM Order_Details od
JOIN Products p
    ON od.ProductID = p.ProductID;


-- Q24. What is the overall profit margin percentage?

SELECT 
    ROUND(
        SUM(od.Quantity * (p.Price - p.Cost))
        / SUM(od.Quantity * p.Price) * 100,
        2
    ) AS Overall_Profit_Margin
FROM Order_Details od
JOIN Products p
    ON od.ProductID = p.ProductID;


-- Q25. Which are the top 10 products by sales revenue?

SELECT 
    p.ProductName,
    SUM(od.Quantity * p.Price) AS Revenue
FROM Order_Details od
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Revenue DESC
LIMIT 10;


-- Q26. Which are the top 10 products by quantity sold?

SELECT 
    p.ProductName,
    SUM(od.Quantity) AS Total_Quantity_Sold
FROM Order_Details od
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;


-- Q27. Which product category generates the highest revenue?

SELECT 
    p.Category,
    SUM(od.Quantity * p.Price) AS Revenue
FROM Order_Details od
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;


-- Q28. Which product category generates the highest profit?

SELECT 
    p.Category,
    SUM(od.Quantity * (p.Price - p.Cost)) AS Profit
FROM Order_Details od
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Profit DESC;


-- Q29. Which products have generated more than ₹1,00,000 in revenue?

SELECT 
    p.ProductName,
    SUM(od.Quantity * p.Price) AS Revenue
FROM Order_Details od
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(od.Quantity * p.Price) > 100000
ORDER BY Revenue DESC;


-- Q30. Which products have sold more than 50 units?

SELECT 
    p.ProductName,
    SUM(od.Quantity) AS Total_Quantity_Sold
FROM Order_Details od
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(od.Quantity) > 50
ORDER BY Total_Quantity_Sold DESC;



-- ============================================================
-- SECTION 4: CUSTOMER REVENUE & LOYALTY ANALYSIS
-- ============================================================


-- Q31. How many orders has each customer placed?

SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS Total_Orders
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY Total_Orders DESC;


-- Q32. What is the total revenue generated by each customer?

SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(od.Quantity * p.Price) AS Total_Revenue
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN Order_Details od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY Total_Revenue DESC;


-- Q33. Who are the top 10 customers by total spending?

SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(od.Quantity * p.Price) AS Total_Spending
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN Order_Details od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY Total_Spending DESC
LIMIT 10;


-- Q34. What is the average spending per customer?

SELECT 
    ROUND(AVG(Customer_Spending), 2) AS Average_Customer_Spending
FROM
(
    SELECT 
        c.CustomerID,
        SUM(od.Quantity * p.Price) AS Customer_Spending
    FROM Customers c
    JOIN Orders o
        ON c.CustomerID = o.CustomerID
    JOIN Order_Details od
        ON o.OrderID = od.OrderID
    JOIN Products p
        ON od.ProductID = p.ProductID
    GROUP BY c.CustomerID
) AS CustomerData;


-- Q35. Which customers have placed more than 5 orders?

SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS Total_Orders
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 5
ORDER BY Total_Orders DESC;


-- Q36. Which city generates the highest customer revenue?

SELECT 
    c.City,
    SUM(od.Quantity * p.Price) AS Total_Revenue
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN Order_Details od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY c.City
ORDER BY Total_Revenue DESC;


-- Q37. Which customers have spent more than the average customer spending?


WITH Customer_Spending AS
(
    SELECT 
        c.CustomerID,
        c.CustomerName,
        SUM(od.Quantity * p.Price) AS Total_Spending
    FROM Customers c
    JOIN Orders o
        ON c.CustomerID = o.CustomerID
    JOIN Order_Details od
        ON o.OrderID = od.OrderID
    JOIN Products p
        ON od.ProductID = p.ProductID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *
FROM Customer_Spending
WHERE Total_Spending >
(
    SELECT AVG(Total_Spending)
    FROM Customer_Spending
)
ORDER BY Total_Spending DESC;




-- Q38. Which customers have placed only one order?

SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS Total_Orders
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) = 1;


-- Q39. What percentage of total revenue comes from the top 10 customers?

WITH Customer_Revenue AS
(
    SELECT 
        c.CustomerID,
        c.CustomerName,
        SUM(od.Quantity * p.Price) AS Revenue
    FROM Customers c
    JOIN Orders o
        ON c.CustomerID = o.CustomerID
    JOIN Order_Details od
        ON o.OrderID = od.OrderID
    JOIN Products p
        ON od.ProductID = p.ProductID
    GROUP BY c.CustomerID, c.CustomerName
),
Top10 AS
(
    SELECT Revenue
    FROM Customer_Revenue
    ORDER BY Revenue DESC
    LIMIT 10
)
SELECT 
    ROUND(
        SUM(Revenue) * 100 /
        (SELECT SUM(Revenue) FROM Customer_Revenue),
        2
    ) AS Top10_Revenue_Percentage
FROM Top10;


-- Q40. Create customer segments based on total spending.

WITH Customer_Spending AS
(
    SELECT 
        c.CustomerID,
        c.CustomerName,
        SUM(od.Quantity * p.Price) AS Total_Spending
    FROM Customers c
    JOIN Orders o
        ON c.CustomerID = o.CustomerID
    JOIN Order_Details od
        ON o.OrderID = od.OrderID
    JOIN Products p
        ON od.ProductID = p.ProductID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT 
    CustomerID,
    CustomerName,
    Total_Spending,
    CASE
        WHEN Total_Spending >= 100000 THEN 'High Value'
        WHEN Total_Spending >= 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM Customer_Spending
ORDER BY Total_Spending DESC;



-- ============================================================
-- SECTION 5: ORDER & PAYMENT ANALYSIS
-- ============================================================


-- Q41. How many orders are there in each order status?

SELECT 
    Status,
    COUNT(*) AS Order_Count
FROM Orders
GROUP BY Status
ORDER BY Order_Count DESC;


-- Q42. What percentage of orders have been successfully delivered?

SELECT 
    ROUND(
        SUM(CASE WHEN Status = 'Delivered' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Delivery_Rate
FROM Orders;


-- Q43. What percentage of orders have been cancelled?

SELECT 
    ROUND(
        SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Cancellation_Rate
FROM Orders;


-- Q44. What percentage of orders have been returned?

SELECT 
    ROUND(
        SUM(CASE WHEN Status = 'Returned' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Return_Rate
FROM Orders;


-- Q45. Which payment method is used most frequently?

SELECT 
    PaymentMethod,
    COUNT(*) AS Payment_Count
FROM Payments
GROUP BY PaymentMethod
ORDER BY Payment_Count DESC
LIMIT 1;


-- Q46. What is the total payment amount collected through each payment method?

SELECT 
    PaymentMethod,
    SUM(PaymentAmount) AS Total_Payment
FROM Payments
GROUP BY PaymentMethod
ORDER BY Total_Payment DESC;



-- ============================================================
-- SECTION 6: TIME & ADVANCED ANALYSIS
-- ============================================================


-- Q47. What is the total revenue generated in each month?

SELECT 
    DATE_FORMAT(o.OrderDate, '%Y-%m') AS Sales_Month,
    SUM(od.Quantity * p.Price) AS Monthly_Revenue
FROM Orders o
JOIN Order_Details od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY DATE_FORMAT(o.OrderDate, '%Y-%m')
ORDER BY Sales_Month;


-- Q48. Which month generated the highest revenue?

SELECT 
    DATE_FORMAT(o.OrderDate, '%Y-%m') AS Sales_Month,
    SUM(od.Quantity * p.Price) AS Monthly_Revenue
FROM Orders o
JOIN Order_Details od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY DATE_FORMAT(o.OrderDate, '%Y-%m')
ORDER BY Monthly_Revenue DESC
LIMIT 1;


-- Q49. Rank all products according to their total revenue.

WITH Product_Revenue AS
(
    SELECT 
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity * p.Price) AS Total_Revenue
    FROM Products p
    JOIN Order_Details od
        ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT 
    ProductID,
    ProductName,
    Total_Revenue,
    RANK() OVER (ORDER BY Total_Revenue DESC) AS Revenue_Rank
FROM Product_Revenue
ORDER BY Revenue_Rank;


-- Q50. Which product has the second-highest total revenue?

WITH Product_Revenue AS
(
    SELECT 
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity * p.Price) AS Total_Revenue,
        DENSE_RANK() OVER (
            ORDER BY SUM(od.Quantity * p.Price) DESC
        ) AS Revenue_Rank
    FROM Products p
    JOIN Order_Details od
        ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT 
    ProductID,
    ProductName,
    Total_Revenue
FROM Product_Revenue
WHERE Revenue_Rank = 2;