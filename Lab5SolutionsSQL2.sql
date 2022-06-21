--QUERY #1
select od.ProductID, o.ShipCountry, sum(od.Quantity) TotalQuantity 
from [Order Details] od
join Orders o on od.OrderID = o.OrderID 
where o.EmployeeID = 2
group by od.ProductID, o.ShipCountry

--QUERY #2
select e.FirstName, e.LastName, sum(od.Quantity) as TotalQuantity 
from Employees e 
join Orders o on e.EmployeeID = o.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID 
join Products p on od.ProductID = p.ProductID
where p.ProductName = 'Chocolade' and year(o.OrderDate) = 1997 -- changed from 1998
group by e.EmployeeID, e.FirstName, e.LastName
having sum(od.Quantity) >= 50 -- changed from 100

--QUERY #3
select p.ProductName, MAX(c.CompanyName) CompanyName 
from Products p 
join [Order Details] od on od.ProductID = p.ProductID
join Orders o on od.OrderID = o.OrderID 
join Customers c on o.CustomerID = c.CustomerID
where c.Country = 'Italy'
group by p.ProductID, p.ProductName, c.CustomerID
having avg(od.Quantity) >= 20
order by count(distinct o.OrderID) desc

--QUERY #4
select c.CompanyName, p.ProductName, o.OrderDate, 
od.Quantity from Products p 
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID 
join Customers c on o.CustomerID = c.CustomerID
where c.City = 'Berlin'
order by c.CompanyName, p.ProductName, o.OrderDate

--QUERY #5
select p.ProductName from Products p
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID
where o.ShipCountry = 'France' and year(o.ShippedDate)= 1998
group by p.ProductID, p.ProductName

select distinct p.ProductName from Products p
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID
where o.ShipCountry = 'France' and year(o.ShippedDate)= 1998

--QUERY #6
select c.CompanyName from Customers c 
join Orders o on c.CustomerID = o.CustomerID
where not exists
(select * from Orders oo
join [Order Details] od on oo.OrderID = od.OrderID 
join Products p on od.ProductID = p.ProductID
where p.ProductName like 'Ravioli%' 
and o.CustomerID = oo.CustomerID)
group by c.CustomerID, c.CompanyName
having count(*) >= 2

;with orders_ravioli AS (
  select DISTINCT o.CustomerID from Orders o
  join [Order Details] od on o.OrderID = od.OrderID 
  join Products p on od.ProductID = p.ProductID
  where p.ProductName like 'Ravioli%'
),
orders_gt_two AS (
  select CustomerID 
  from Orders
  group by CustomerID
  having count(*) >= 2
)
select CompanyName
from Customers c
left join orders_ravioli orv
on c.CustomerID = orv.CustomerID
join orders_gt_two ogt
on c.CustomerID = ogt.CustomerID
where orv.CustomerID is null

--QUERY #7
select MAX(CompanyName) CompanyName, o.OrderID, count(*) ProductCount 
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
join Customers c on o.CustomerID = c.CustomerID
where c.Country = 'France'
group by o.OrderID
having count(*) >= 4

--QUERY #8
select c.CompanyName from Customers c 
join Orders o on c.CustomerID = o.CustomerID
where o.ShipCountry = 'France' and not exists
(select * from Customers cc 
join Orders oo on cc.CustomerID = oo.CustomerID
where oo.ShipCountry = 'Belgium' and c.CustomerID = cc.CustomerID
group by cc.CustomerID, cc.CompanyName
having count(*) > 2)
group by c.CustomerID, c.CompanyName
having count(*) >= 5

select c.CompanyName from Orders o 
join Customers c on o.CustomerID = c.CustomerID
group by o.CustomerID, c.CompanyName
having sum(case when o.shipcountry='France'  then 1 else 0 end) >= 5  
   and sum(case when o.shipcountry='Belgium' then 1 else 0 end) <= 2

--QUERY #9
select distinct ProductName, CompanyName, od.Quantity 
from Orders o 
join [Order Details] od on o.OrderID = od.OrderID
join Customers c on c.CustomerID = o.CustomerID
join Products p on p.ProductID = od.ProductID
where od.Quantity = (
  select max(od2.Quantity) 
  from [Order Details] od2
  where od2.ProductID = od.ProductID
)

--QUERY #10
select e.EmployeeID, max(e.FirstName) FirstName, max(e.LastName) LastName , count(*)
from Employees e 
join Orders o on e.EmployeeID = o.EmployeeID
group by e.EmployeeID
having count(*) > 1.2 *
(select avg(tmp.Count) from
(select count(*) as 'Count' 
from Orders o
group by o.EmployeeID) tmp)

;with emp_ordrs as (
  select e.EmployeeID, max(e.FirstName) FirstName, 
  max(e.LastName) LastName, count(*) as ordr_cnt
  from Employees e 
  join Orders o on e.EmployeeID = o.EmployeeID
  group by e.EmployeeID
)
select EmployeeID, FirstName, LastName
from emp_ordrs
where ordr_cnt > (select 1.2 * avg(ordr_cnt) from emp_ordrs);

--QUERY #11
select * from Orders where OrderID in
(select top(5) od.OrderID from [Order Details] od 
group by od.OrderID
order by count(*) desc)

--QUERY #12
select ProductName, 
(select sum(od.Quantity) from [Order Details] od
join Orders o on o.OrderID = od.OrderID 
where od.ProductID = p.ProductID and year(OrderDate) = 1996) as TotalQuantityIn1996,
(select sum(od.Quantity) from [Order Details] od 
join Orders o on o.OrderID = od.OrderID 
where od.ProductID = p.ProductID and year(OrderDate) = 1997) as TotalQuantityIn1997
from Products p
where 
COALESCE((select sum(od.Quantity) from [Order Details] od
join Orders o on od.OrderID = o.OrderID
where od.ProductID = p.ProductID and year(OrderDate) = 1996), 0)
<
COALESCE((select sum(od.Quantity) from [Order Details] od
join Orders o on od.OrderID = o.OrderID
where od.ProductID = p.ProductID and year(OrderDate) = 1997), 0)
order by 1

select ProductName, TotalQuantityIn1996, TotalQuantityIn1997
from (
  select max(p.ProductName) ProductName,
  sum(case when (year(OrderDate) = 1996) then od.Quantity else 0 end) TotalQuantityIn1996,
  sum(case when (year(OrderDate) = 1997) then od.Quantity else 0 end) TotalQuantityIn1997
  from [Order Details] od
  join Orders o on od.OrderID = o.OrderID
  join Products p on od.ProductID = p.ProductID
  group by p.ProductID
) tmp
where TotalQuantityIn1996 < TotalQuantityIn1997
order by 1

--QUERY #13
select ProductName, 
(select count(*) from [Order Details] od
join Orders o on o.OrderID = od.OrderID 
where od.ProductID = p.ProductID and year(OrderDate) = 1996) as NumberOfOrdersIn1996,
(select count(*) from [Order Details] od 
join Orders o on o.OrderID = od.OrderID 
where od.ProductID = p.ProductID and year(OrderDate) = 1997) as NumberOfOrdersIn1997
from Products p
where 
(select count(*) from [Order Details] od
join Orders o on od.OrderID = o.OrderID
where od.ProductID = p.ProductID and year(OrderDate) = 1996) 
<
(select count(*) from [Order Details] od
join Orders o on od.OrderID = o.OrderID
where od.ProductID = p.ProductID and year(OrderDate) = 1997)
order by 1

select ProductName, NumberOfOrdersIn1996, NumberOfOrdersIn1997
from (
  select max(p.ProductName) ProductName,
  sum(case when (year(OrderDate) = 1996) then 1 else 0 end) NumberOfOrdersIn1996,
  sum(case when (year(OrderDate) = 1997) then 1 else 0 end) NumberOfOrdersIn1997
  from [Order Details] od
  join Orders o on od.OrderID = o.OrderID
  join Products p on od.ProductID = p.ProductID
  group by p.ProductID
) pre_calculation
where NumberOfOrdersIn1996 < NumberOfOrdersIn1997
order by 1

--QUERY #14
create view OrdersTotal as (
select
year(OrderDate) as OrderYear, datepart(month, OrderDate) as OrderMonth,
O.OrderId, O.CustomerID, Cust.CompanyName, Cust.Country as CustomerCountry, Cust.City AS
CustomerCity,
O.ShipCountry, O.ShipCity, OD.ProductID, P.ProductName, Cat.CategoryName, OD.UnitPrice,
OD.Quantity, OD.UnitPrice * OD.Quantity as ProductValue
from Orders O
JOIN [Customers] Cust ON O.CustomerID = Cust.CustomerID
JOIN [Order Details] OD ON OD.OrderID = O.OrderID
JOIN [Products] P ON P.ProductID = OD.ProductID
JOIN [Categories] Cat ON Cat.CategoryID = P.CategoryID
) ;

select * from OrdersTotal

--QUERY #15
SELECT OrderId,ProductName,CategoryName, ProductValue,
SUM(ProductValue) OVER (PARTITION BY ProductName) as ProdTotalSale,
SUM(ProductValue) OVER (PARTITION BY CategoryName) as CategoryTotalSale
FROM OrdersTotal order by ProductName

--QUERY #16
SELECT DISTINCT ProductName,CategoryName,
SUM(ProductValue) OVER (PARTITION BY ProductName) as ProdTotalSale,
SUM(ProductValue) OVER (PARTITION BY CategoryName) as CategoryTotalSale,
SUM(ProductValue) OVER () as TotalSale,
SUM(ProductValue) OVER (PARTITION BY ProductName) / SUM(ProductValue) 
OVER (PARTITION BY CategoryName) as ProdCategorySaleShare,
SUM(ProductValue) OVER (PARTITION BY ProductName) / SUM(ProductValue) 
OVER () as ProdTotalShare
FROM OrdersTotal order by ProductName

--QUERY #17
select OrderId, ProductId, ProductValue,
SUM(ProductValue) OVER (ORDER BY OrderId, ProductId ROWS
BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as
ProdTotalSale
from OrdersTotal order by OrderId

--QUERY #18
select OrderId, ProductId, ProductValue,
SUM(ProductValue) OVER (ORDER BY OrderId, ProductId ROWS
BETWEEN 2 PRECEDING AND CURRENT ROW) as ProdTotalSale
from OrdersTotal order by OrderId, ProductId

--QUERY #19
select ProductName, OrderYear, OrderMonth,
OrderTotal ProductMonthSale,
SUM(OrderTotal) OVER (PARTITION BY ProductName,OrderYear ORDER BY
OrderMonth) as ProdUntilMonthSale,
count(*) OVER (PARTITION BY ProductName,OrderYear ORDER BY OrderMonth) as
MonthCount
from (
  select ProductName, OrderYear, OrderMonth, sum(ProductValue) as OrderTotal
  from OrdersTotal
  group by ProductName, OrderYear, OrderMonth
) as OrdersGrouped
order by ProductName,OrderYear,OrderMonth

--*QUERY #20 find rows with top rank
WITH input as (
 SELECT CategoryName, ProductName, 
 SUM(ProductValue) totalSales
 FROM OrdersTotal
 GROUP BY CategoryName, ProductName
),
ranks as (
 SELECT CategoryName, ProductName, 
 totalSales, 
 RANK() OVER (partition by CategoryName order by totalSales desc ) rank 
 FROM input
 ) 
 SELECT * FROM ranks WHERE rank = 1
