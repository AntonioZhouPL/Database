
-- Query 1
SELECT o.ProductName FROM Orders o JOIN [Order Details] od on od.OrderID = o.OrderID 
JOIN Products p on p.ProductID = od.ProductID where p.ProductName LIKE '%o%' 
or  p.ProductName LIKE '%b'  order by p.ProductName ASC;


-- Query 2(I chose to use multiple query for this quesiton)
-- Find the products that is most popular
select COUNT(ProductID) AS sales, ProductID  
FROM [Order Details] 
group by ProductID;
-- we found the most popular products' ID = 59

-- And now we are finding the employee who sold the most popular products at least once
SELECT distinct e.FirstName, p.ProductName FROM Employees e, Products p 
JOIN  [Order Details] od on od.ProductID = p.ProductID
WHERE od.ProductID = '59';


-- Query 3

-- we have to use Month(o.OrderDate) function for this task

--List of products's orderdate that is from May-October
SELECT SUM(od.Quantity) AS TotalQuantity, od.ProductID
FROM [Order Details] od
JOIN Orders o ON o.OrderID = od.OrderID
WHERE  Month(o.OrderDate) >= 5 and Month(o.OrderDate) <= 10
group by od.ProductID

--List of products's orderdate that is from November-April

SELECT SUM(od.Quantity) AS TotalQuantity, od.ProductID
FROM [Order Details] od
JOIN Orders o ON o.OrderID = od.OrderID
WHERE  Month(o.OrderDate) >= 11 and Month(o.OrderDate) <= 4
group by od.ProductID

-- I am trying to use Having function, but don't know how to use properly

-- Query 4
--Find the orders orderID containing at least 5 different 
--products that have never been delivered to Germany
select COUNT(od.OrderID) AS sales, od.OrderID  
FROM [Order Details] od
JOIN Orders o ON o.OrderID = od.OrderID
WHERE o.ShipCountry != 'Germany'  
group by od.OrderID
Having COUNT(od.OrderID) >= 5;


SELECT * FROM Orders
WHERE OrderID = '10294' or OrderID = '10309'
or OrderID = '10324' or OrderID = '10360'
or OrderID = '10382' or OrderID = '10393'
or OrderID = '10406' or OrderID = '10458'
or OrderID = '10465' or OrderID = '10514'
or OrderID = '10537' or OrderID = '10553'
or OrderID = '10555' or OrderID = '10558'
or OrderID = '10607' or OrderID = '10612'
or OrderID = '10657' or OrderID = '10698'
or OrderID = '10714' or OrderID = '10836'
or OrderID = '10847' or OrderID = '10861'
or OrderID = '10979' or OrderID = '11031'
or OrderID = '11064' or OrderID = '11077'




-- Query 5


SELECT p.ProductName, SUM(od.Quantity) AS Feburary From Products p
JOIN [Order Details] od ON od.ProductID = P.ProductID
JOIN Orders o ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997