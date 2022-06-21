-- create ArchivedOrders table with the same starting set of columns as Orders 

select * into ArchivedOrders from Orders where 1 = 0 union all select * from Orders where 1 = 0

-- Primary key and foreign keys pointing to Customers and Employees
alter table ArchivedOrders add constraint PK_OrderID primary key (OrderID)

-- Newly added column named ArchiveDate of datetime type
alter table ArchivedOrders add ArchiveDate datetime not null


--create ArchivedOrderDetails table with the same columns, primary key and (partly updated) foreign keys as [Order Details]
select * into ArchivedOrderDetails from [Order Details] where 1 = 2 -- copy structures
alter table ArchivedOrderDetails add constraint PK_OrderID_ProductID primary key (OrderID, ProductID)
alter table ArchivedOrderDetails add constraint FK_OrderID foreign key (OrderID) references ArchivedOrders(OrderID)
alter table ArchivedOrderDetails add constraint FK_ProductID foreign key (ProductID) references Products(ProductID)


-- --develop a stored procedure that migrates all orders older than N years (N will be the parameter of the procedure), i.e.
if object_id('ArchiveOrders') is null
    exec('create procedure ArchiveOrders as declare @ID int')
go


alter procedure ArchiveOrders @Nyears int as
begin
	begin transaction
	set transaction isolation level serializable
	
--  migrates all orders older than N years

	declare @IDList table (ID int)
	insert into @IDList select OrderID from Orders 
	where datediff(yy,orderDate, getdate()) > @Nyears

   --removes matching records from Orders and [Orders Details]
	delete from [Order Details] where OrderID in (select ID from @IDList)
	delete from Orders where OrderID in (select ID from @IDList)

   --inserts these records into ArchivedOrders and ArchivedOrderDetails
	insert into ArchivedOrders 
	select *, getdate() from Orders where OrderID in (select ID from @ID_List)
	insert into ArchivedOrderDetails select * from [Order Details] 
	where OrderID in (select ID from @ID_List)

	commit
end

execute ArchiveOrders 48

select * from Orders
select * from ArchivedOrders
rollback
