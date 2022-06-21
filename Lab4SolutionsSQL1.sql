



--QUERY #1
select * from Orders;

--QUERY #2
select * from Orders where ShipCountry = 'Brazil' or
ShipCountry='Mexico' or ShipCountry = 'Germany'

select * from Orders where
ShipCountry in ('Brazil','Mexico','Germany')


--QUERY #3
select distinct ShipCity from Orders
where ShipCountry = 'Germany'


--QUERY #4
set dateformat ymd

select * from Orders where OrderDate >= '1996-07-01'
and OrderDate < '1996-08-01'

select * from Orders where month(OrderDate) = 7 and
year(OrderDate) = 1996


--QUERY #5
select upper(substring(CompanyName,1,10)) as
'Company code' from Customers

select upper(left(CompanyName,10))  as
'Company code' from Customers

SELECT
  LEFT(CompanyName,10) as "Company code",
  'something more' as "Something more"
FROM
  Customers;

--QUERY #6
select o.* from Orders o
join Customers c on o.CustomerID = c.CustomerID
where c.Country = 'France'


--QUERY #7
select distinct ShipCountry from Orders o 
join Customers c on o.CustomerID = c.CustomerID 
where c.Country = 'Germany'


--QUERY #8
select o.* from Orders o join Customers c on
o.CustomerID = c.CustomerID where
c.Country != o.ShipCountry


--QUERY #9
select * 
from Customers c 
where not exists (
  select *
  from Orders o 
  where o.CustomerID = c.CustomerID
)

select c.* from Customers c
left outer join Orders o on c.CustomerID = o.CustomerID
where o.CustomerID is null;

with ord_cust as (
  select distinct CustomerID from Orders
)
select * from Customers c 
left outer join ord_cust oc on c.CustomerID = oc.CustomerID
where oc.CustomerID is null;

select * from Customers c left join Orders o on c.CustomerID = o.CustomerID
except
select * from Customers c join Orders o on c.CustomerID = o.CustomerID

--QUERY #10
select * from Customers c 
where not exists (
  select * from Orders o 
  where o.CustomerID = c.CustomerID
  and exists (
    select * from [Order Details] od 
	join Products p on p.ProductID = od.ProductID 
	where od.OrderID = o.OrderID 
	and p.ProductName = 'Chocolade'
  )
)

select * from Customers c where not exists (select *
from Orders o where o.CustomerID = c.CustomerID
and exists (select * from [Order Details] od where
od.OrderID = o.OrderID and od.ProductID = 
(select ProductID from Products p where
p.ProductName = 'Chocolade')))


--QUERY #11
select distinct c.* from Customers c
join Orders o on o.CustomerID = c.CustomerID
join [Order Details] od on od.OrderID = o.OrderID
join Products p on p.ProductID = od.ProductID where
p.ProductName = 'Scottish Longbreads'


--QUERY #12
select * from Orders o where
exists (select * from [Order Details] od join Products p
on p.ProductID = od.ProductID where
ProductName = 'Scottish Longbreads' and
od.OrderID = o.OrderID)
and not exists (select * from [Order Details] od join
Products p on p.ProductID = od.ProductID where
ProductName = 'Chocolade' and od.OrderID = o.OrderID)


--QUERY #13
select distinct e.FirstName, e.LastName 
from Employees e 
join Orders o 
  on e.EmployeeID = o.EmployeeID
  where o.CustomerID = 'ALFKI' 


--QUERY #14
select e.FirstName, e.LastName, c.CompanyName, o.OrderDate,
(case when od.OrderID is null then 0 else 1 end) as 'Status'
from Employees e
left join Orders o on o.EmployeeID = e.EmployeeID
left join [Order Details] od on o.OrderID = od.OrderID and
od.ProductID in (select ProductID from Products where
ProductName = 'Chocolade')
left join Customers c on c.CustomerID = o.CustomerID


--QUERY #15
SELECT P.ProductName, O.ShipCountry, O.OrderId, YEAR(orderdate) as oyear,
MONTH(orderdate) as omonth, orderDate 
from Customers c join orders o on o.customerid=c.customerid
join [order details] od on od.orderid=o.orderid 
join products p on od.productid=p.productid
where c.country='Germany' and p.productname like '[c-s]%' order by orderdate desc