-- 1. Total Sales by Employee: 
-- Write a query to calculate the total sales (in dollars) made by each employee, considering the quantity and unit price of products sold.

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM 
    Employees e
JOIN 
    Orders o ON e.EmployeeID = o.EmployeeID
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
GROUP BY 
    e.EmployeeID, e.FirstName, e.LastName;




-- 2. Top 5 Customers by Sales:
-- Identify the top 5 customers who have generated the most revenue. Show the customer’s name and the total amount they’ve spent.

SELECT 
    c.CustomerName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSpent
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
GROUP BY 
    c.CustomerName
ORDER BY 
    TotalSpent DESC
LIMIT 5;




-- 3. Monthly Sales Trend:
-- Write a query to display the total sales amount for each month in the year 1997.

SELECT 
    MONTH(o.OrderDate) AS Month,
    YEAR(o.OrderDate) AS Year,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM 
    Orders o
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
WHERE 
    YEAR(o.OrderDate) = 1997
GROUP BY 
    YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY 
    Year, Month;
    
    
    
-- 4. Order Fulfilment Time:
-- Calculate the average time (in days) taken to fulfil an order for each employee. Assuming shipping takes 3 or 5 days respectively depending on if the item was ordered in 1996 or 1997.
    
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    AVG(
        CASE 
            WHEN YEAR(o.OrderDate) = 1996 THEN 3
            WHEN YEAR(o.OrderDate) = 1997 THEN 5
            ELSE 0
        END
    ) AS AvgFulfillmentTimeInDays
FROM 
    Employees e
JOIN 
    Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY 
    e.EmployeeID, e.FirstName, e.LastName
ORDER BY 
    AvgFulfillmentTimeInDays;

    
    
    
-- 5. Products by Category with No Sales:
-- List the customers operating in London and total sales for each. 

SELECT 
    c.CustomerName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
WHERE 
    c.City = 'London'
GROUP BY 
    c.CustomerName
ORDER BY 
    TotalSales DESC;
    
    

-- 6. Customers with Multiple Orders on the Same Date:
-- Write a query to find customers who have placed more than one order on the same date.

SELECT 
    c.CustomerName,
    o.OrderDate,
    COUNT(o.OrderID) AS OrderCount
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerName, o.OrderDate
HAVING 
    COUNT(o.OrderID) > 1;
    
    
    
-- 7. Average Discount per Product:
-- Calculate the average discount given per product across all orders. Round to 2 decimal places.

SELECT 
    p.ProductName,
    ROUND(AVG(od.Discount), 2) AS AverageDiscount
FROM 
    OrderDetails od
JOIN 
    Products p ON od.ProductID = p.ProductID
GROUP BY 
    p.ProductName;    



-- 8. Products Ordered by Each Customer:
-- For each customer, list the products they have ordered along with the total quantity of each product ordered.

SELECT 
    c.CustomerName,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantity
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
JOIN 
    Products p ON od.ProductID = p.ProductID
GROUP BY 
    c.CustomerName, p.ProductName;
    
    
    
-- 9. Employee Sales Ranking:
-- Rank employees based on their total sales. Show the employeename, total sales, and their rank.

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales,
    RANK() OVER (ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS SalesRank
FROM 
    Employees e
JOIN 
    Orders o ON e.EmployeeID = o.EmployeeID
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
GROUP BY 
    e.EmployeeID, e.FirstName, e.LastName;



-- 10. Sales by Country and Category:
-- Write a query to display the total sales amount for each product category, grouped by country.

SELECT 
    c.Country,
    cat.CategoryName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
JOIN 
    Products p ON od.ProductID = p.ProductID
JOIN 
    Categories cat ON p.CategoryID = cat.CategoryID
GROUP BY 
    c.Country, cat.CategoryName;



-- 11. Year-over-Year Sales Growth:
-- Calculate the percentage growth in sales from one year to the next for each product.

SELECT 
    p.ProductName,
    YEAR(o.OrderDate) AS Year,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales,
    LAG(SUM(od.Quantity * od.UnitPrice), 1) OVER (PARTITION BY p.ProductID ORDER BY YEAR(o.OrderDate)) AS LastYearSales,
    (SUM(od.Quantity * od.UnitPrice) - 
        LAG(SUM(od.Quantity * od.UnitPrice), 1) OVER (PARTITION BY p.ProductID ORDER BY YEAR(o.OrderDate))) / 
        LAG(SUM(od.Quantity * od.UnitPrice), 1) OVER (PARTITION BY p.ProductID ORDER BY YEAR(o.OrderDate)) * 100 AS SalesGrowthPercentage
FROM 
    Products p
JOIN 
    OrderDetails od ON p.ProductID = od.ProductID
JOIN 
    Orders o ON od.OrderID = o.OrderID
GROUP BY 
    p.ProductID, p.ProductName, YEAR(o.OrderDate)
ORDER BY 
    p.ProductName, YEAR(o.OrderDate);




-- 12. Order Quantity Percentile:
-- Calculate the percentile rank of each order based on the total quantity of products in the order. 

SELECT 
    o.OrderID,
    o.CustomerID,
    SUM(od.Quantity) AS TotalQuantity,
    PERCENT_RANK() OVER (ORDER BY SUM(od.Quantity) DESC) AS QuantityPercentile
FROM 
    Orders o
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
GROUP BY 
    o.OrderID, o.CustomerID
ORDER BY 
    QuantityPercentile DESC;




-- 13. Products Never Reordered:
-- Identify products that have been sold but have never been reordered (ordered only once). 

SELECT 
    p.ProductName,
    COUNT(od.OrderID) AS OrderCount
FROM 
    Products p
JOIN 
    OrderDetails od ON p.ProductID = od.ProductID
GROUP BY 
    p.ProductID, p.ProductName
HAVING 
    COUNT(od.OrderID) = 1;

    
    
    
    

-- 14. Most Valuable Product by Revenue:
-- Write a query to find the product that has generated the most revenue in each category.

SELECT 
    cat.CategoryName,
    p.ProductName,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM 
    Products p
JOIN 
    Categories cat ON p.CategoryID = cat.CategoryID
JOIN 
    OrderDetails od ON p.ProductID = od.ProductID
GROUP BY 
    cat.CategoryName, p.ProductName
ORDER BY 
    cat.CategoryName, TotalRevenue DESC
LIMIT 1;



-- 15. Complex Order Details:
-- Identify orders where the total price of all items exceeds $100 and contains at least one product with a discount of 5% or more.

SELECT 
    o.OrderID,
    SUM(od.Quantity * od.UnitPrice) AS TotalPrice
FROM 
    Orders o
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
GROUP BY 
    o.OrderID
HAVING 
    SUM(od.Quantity * od.UnitPrice) > 100
    AND EXISTS (
        SELECT 1
        FROM OrderDetails od2
        WHERE od2.OrderID = o.OrderID
        AND od2.Discount >= 0.05
    );

