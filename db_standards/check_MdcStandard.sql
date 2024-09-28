USE [master]
GO
/****** Object:  Database [MdcStandard]    Script Date: 9/27/2024 6:35:46 PM ******/
CREATE DATABASE [MdcStandard]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MdcStandard', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER22\MSSQL\DATA\MdcStandard.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MdcStandard_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER22\MSSQL\DATA\MdcStandard_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MdcStandard] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MdcStandard].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MdcStandard] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MdcStandard] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MdcStandard] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MdcStandard] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MdcStandard] SET ARITHABORT OFF 
GO
ALTER DATABASE [MdcStandard] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MdcStandard] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MdcStandard] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MdcStandard] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MdcStandard] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MdcStandard] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MdcStandard] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MdcStandard] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MdcStandard] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MdcStandard] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MdcStandard] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MdcStandard] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MdcStandard] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MdcStandard] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MdcStandard] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MdcStandard] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MdcStandard] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MdcStandard] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MdcStandard] SET  MULTI_USER 
GO
ALTER DATABASE [MdcStandard] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MdcStandard] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MdcStandard] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MdcStandard] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MdcStandard] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MdcStandard] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [MdcStandard] SET QUERY_STORE = OFF
GO
USE [MdcStandard]
GO
/****** Object:  Table [dbo].[tblkProducts]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblkProducts](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](40) NOT NULL,
	[SupplierID] [int] NULL,
	[CategoryID] [int] NULL,
	[QuantityPerUnit] [nvarchar](20) NULL,
	[UnitPrice] [money] NULL,
	[UnitsInStock] [smallint] NULL,
	[UnitsOnOrder] [smallint] NULL,
	[ReorderLevel] [smallint] NULL,
	[Discontinued] [bit] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_CurrentProductList]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   view [dbo].[vw_CurrentProductList] AS


--=======================================================================================
--					D E F I N I T I O N
--=======================================================================================
-- Author:			Giancarlo Rhodes
-- Create Date:		05/24/2024
-- Description:		
--					
-- Integration:		
-- Update History:  Please see comment at bottom for changelog
--=======================================================================================

SELECT Product_List.ProductID, Product_List.ProductName
FROM tblkProducts AS Product_List
WHERE (((Product_List.Discontinued)=0))


--=======================================================================================
--				Change Log
--=======================================================================================
-- Author:			
-- Create Date:		
-- Description:		View was modified			
-- Integration:		
-- Update History:  
--=======================================================================================



GO
/****** Object:  Table [dbo].[tblEmployees]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEmployees](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[Title] [nvarchar](30) NULL,
	[TitleOfCourtesy] [nvarchar](25) NULL,
	[BirthDate] [datetime] NULL,
	[HireDate] [datetime] NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[HomePhone] [nvarchar](24) NULL,
	[Extension] [nvarchar](4) NULL,
	[Photo] [image] NULL,
	[Notes] [ntext] NULL,
	[ReportsTo] [int] NULL,
	[PhotoPath] [nvarchar](255) NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCustomers]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCustomers](
	[CustomerID] [nchar](5) NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblkShippers]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblkShippers](
	[ShipperID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[Phone] [nvarchar](24) NULL,
 CONSTRAINT [PK_Shippers] PRIMARY KEY CLUSTERED 
(
	[ShipperID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblOrders]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOrders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [nchar](5) NULL,
	[EmployeeID] [int] NULL,
	[OrderDate] [datetime] NULL,
	[RequiredDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[ShipVia] [int] NULL,
	[Freight] [money] NULL,
	[ShipName] [nvarchar](40) NULL,
	[ShipAddress] [nvarchar](60) NULL,
	[ShipCity] [nvarchar](15) NULL,
	[ShipRegion] [nvarchar](15) NULL,
	[ShipPostalCode] [nvarchar](10) NULL,
	[ShipCountry] [nvarchar](15) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblOrderDetails]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOrderDetails](
	[OrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[Discount] [real] NOT NULL,
 CONSTRAINT [PK_Order_Details] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_Invoices]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   view [dbo].[vw_Invoices] AS


--=======================================================================================
--					D E F I N I T I O N
--=======================================================================================
-- Author:			Giancarlo Rhodes
-- Create Date:		05/24/2024
-- Description:		
--					
-- Integration:		
-- Update History:  Please see comment at bottom for changelog
--=======================================================================================



SELECT tblOrders.ShipName, tblOrders.ShipAddress, tblOrders.ShipCity, tblOrders.ShipRegion, tblOrders.ShipPostalCode, 
	tblOrders.ShipCountry, tblOrders.CustomerID, tblCustomers.CompanyName AS CustomerName, tblCustomers.Address, tblCustomers.City, 
	tblCustomers.Region, tblCustomers.PostalCode, tblCustomers.Country, 
	(FirstName + ' ' + LastName) AS Salesperson, 
	tblOrders.OrderID, tblOrders.OrderDate, tblOrders.RequiredDate, tblOrders.ShippedDate, tblkShippers.CompanyName As ShipperName, 
	"tblOrderDetails".ProductID, tblkProducts.ProductName, "tblOrderDetails".UnitPrice, "tblOrderDetails".Quantity, 
	"tblOrderDetails".Discount, 
	(CONVERT(money,("tblOrderDetails".UnitPrice*Quantity*(1-Discount)/100))*100) AS ExtendedPrice, tblOrders.Freight
FROM 	tblkShippers INNER JOIN 
		(tblkProducts INNER JOIN 
			(
				(tblEmployees INNER JOIN 
					(tblCustomers INNER JOIN tblOrders ON tblCustomers.CustomerID = tblOrders.CustomerID) 
				ON tblEmployees.EmployeeID = tblOrders.EmployeeID) 
			INNER JOIN "tblOrderDetails" ON tblOrders.OrderID = "tblOrderDetails".OrderID) 
		ON tblkProducts.ProductID = "tblOrderDetails".ProductID) 
	ON tblkShippers.ShipperID = tblOrders.ShipVia


	
--=======================================================================================
--				Change Log
--=======================================================================================
-- Author:			
-- Create Date:		
-- Description:		View was modified			
-- Integration:		
-- Update History:  
--=======================================================================================




GO
/****** Object:  View [dbo].[vw_OrderDetailsExtended]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE
	

 VIEW [dbo].[vw_OrderDetailsExtended]
AS
--=======================================================================================
--					D E F I N I T I O N
--=======================================================================================
-- Author:			Giancarlo Rhodes
-- Create Date:		05/24/2024
-- Description:		
--					
-- Integration:		
-- Update History:  Please see comment at bottom for changelog
--=======================================================================================
SELECT tblOrderDetails.OrderID,
	tblOrderDetails.ProductID,
	tblkProducts.ProductName,
	tblOrderDetails.UnitPrice,
	tblOrderDetails.Quantity,
	tblOrderDetails.Discount,
	(CONVERT(MONEY, (tblOrderDetails.UnitPrice * Quantity * (1 - Discount) / 100)) * 100) AS ExtendedPrice
FROM tblkProducts
INNER JOIN tblOrderDetails ON tblkProducts.ProductID = tblOrderDetails.ProductID
	--=======================================================================================
	--				Change Log
	--=======================================================================================
	-- Author:			
	-- Create Date:		
	-- Description:		View was modified			
	-- Integration:		
	-- Update History:  
	--=======================================================================================
GO
/****** Object:  View [dbo].[vw_OrderSubtotals]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE
	

 VIEW [dbo].[vw_OrderSubtotals]
AS


--=======================================================================================
--					D E F I N I T I O N
--=======================================================================================
-- Author:			Giancarlo Rhodes
-- Create Date:		05/24/2024
-- Description:		
--					
-- Integration:		
-- Update History:  Please see comment at bottom for changelog
--=======================================================================================


SELECT tblOrderDetails.OrderID,
	Sum(CONVERT(MONEY, (tblOrderDetails.UnitPrice * Quantity * (1 - Discount) / 100)) * 100) AS Subtotal
FROM tblOrderDetails
GROUP BY tblOrderDetails.OrderID


--=======================================================================================
--				Change Log
--=======================================================================================
-- Author:			
-- Create Date:		
-- Description:		View was modified			
-- Integration:		
-- Update History:  
--=======================================================================================



GO


--/****** Object:  View [dbo].[Orders Qry]    Script Date: 9/27/2024 6:35:47 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--create view [dbo].[Orders Qry] AS
--SELECT Orders.OrderID, Orders.CustomerID, Orders.EmployeeID, Orders.OrderDate, Orders.RequiredDate, 
--	Orders.ShippedDate, Orders.ShipVia, Orders.Freight, Orders.ShipName, Orders.ShipAddress, Orders.ShipCity, 
--	Orders.ShipRegion, Orders.ShipPostalCode, Orders.ShipCountry, 
--	Customers.CompanyName, Customers.Address, Customers.City, Customers.Region, Customers.PostalCode, Customers.Country
--FROM Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
--GO



--/****** Object:  View [dbo].[Product Sales for 1997]    Script Date: 9/27/2024 6:35:47 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--create view [dbo].[Product Sales for 1997] AS
--SELECT Categories.CategoryName, Products.ProductName, 
--Sum(CONVERT(money,("Order Details".UnitPrice*Quantity*(1-Discount)/100))*100) AS ProductSales
--FROM (Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID) 
--	INNER JOIN (Orders 
--		INNER JOIN "Order Details" ON Orders.OrderID = "Order Details".OrderID) 
--	ON Products.ProductID = "Order Details".ProductID
--WHERE (((Orders.ShippedDate) Between '19970101' And '19971231'))
--GROUP BY Categories.CategoryName, Products.ProductName
--GO




--/****** Object:  View [dbo].[Products Above Average Price]    Script Date: 9/27/2024 6:35:47 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--create view [dbo].[Products Above Average Price] AS
--SELECT Products.ProductName, Products.UnitPrice
--FROM Products
--WHERE Products.UnitPrice>(SELECT AVG(UnitPrice) From Products)
----ORDER BY Products.UnitPrice DESC
--GO




--/****** Object:  View [dbo].[Products by Category]    Script Date: 9/27/2024 6:35:47 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--create view [dbo].[Products by Category] AS
--SELECT Categories.CategoryName, Products.ProductName, Products.QuantityPerUnit, Products.UnitsInStock, Products.Discontinued
--FROM Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
--WHERE Products.Discontinued <> 1
----ORDER BY Categories.CategoryName, Products.ProductName
--GO



/****** Object:  View [dbo].[Quarterly Orders]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Quarterly Orders] AS
SELECT DISTINCT Customers.CustomerID, Customers.CompanyName, Customers.City, Customers.Country
FROM Customers RIGHT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderDate BETWEEN '19970101' And '19971231'
GO





/****** Object:  View [dbo].[Sales by Category]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Sales by Category] AS
SELECT Categories.CategoryID, Categories.CategoryName, Products.ProductName, 
	Sum("Order Details Extended".ExtendedPrice) AS ProductSales
FROM 	Categories INNER JOIN 
		(Products INNER JOIN 
			(Orders INNER JOIN "Order Details Extended" ON Orders.OrderID = "Order Details Extended".OrderID) 
		ON Products.ProductID = "Order Details Extended".ProductID) 
	ON Categories.CategoryID = Products.CategoryID
WHERE Orders.OrderDate BETWEEN '19970101' And '19971231'
GROUP BY Categories.CategoryID, Categories.CategoryName, Products.ProductName
--ORDER BY Products.ProductName
GO




/****** Object:  View [dbo].[Sales Totals by Amount]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Sales Totals by Amount] AS
SELECT "Order Subtotals".Subtotal AS SaleAmount, Orders.OrderID, Customers.CompanyName, Orders.ShippedDate
FROM 	Customers INNER JOIN 
		(Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID) 
	ON Customers.CustomerID = Orders.CustomerID
WHERE ("Order Subtotals".Subtotal >2500) AND (Orders.ShippedDate BETWEEN '19970101' And '19971231')
GO



/****** Object:  View [dbo].[Summary of Sales by Quarter]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Summary of Sales by Quarter] AS
SELECT Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal
FROM Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE Orders.ShippedDate IS NOT NULL
--ORDER BY Orders.ShippedDate
GO




/****** Object:  View [dbo].[Summary of Sales by Year]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Summary of Sales by Year] AS
SELECT Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal
FROM Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE Orders.ShippedDate IS NOT NULL
--ORDER BY Orders.ShippedDate
GO



/****** Object:  View [dbo].[vw_CustomerAndSuppliersByCity]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[vw_CustomerAndSuppliersByCity] AS
SELECT City, CompanyName, ContactName, 'Customers' AS Relationship 
FROM Customers
UNION SELECT City, CompanyName, ContactName, 'Suppliers'
FROM Suppliers
--ORDER BY City, CompanyName
GO



/****** Object:  Table [dbo].[TableTest]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableTest](
	[ID] [uniqueidentifier] NOT NULL,
	[Data] [nvarchar](max) NULL,
 CONSTRAINT [PK_TableTest] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO




/****** Object:  Table [dbo].[tblCategories]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCategories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](15) NOT NULL,
	[Description] [ntext] NULL,
	[Picture] [image] NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tblCustomerCustomerDemo]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCustomerCustomerDemo](
	[CustomerID] [nchar](5) NOT NULL,
	[CustomerTypeID] [nchar](10) NOT NULL,
 CONSTRAINT [PK_CustomerCustomerDemo] PRIMARY KEY NONCLUSTERED 
(
	[CustomerID] ASC,
	[CustomerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tblCustomerDemographics]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCustomerDemographics](
	[CustomerTypeID] [nchar](10) NOT NULL,
	[CustomerDesc] [ntext] NULL,
 CONSTRAINT [PK_CustomerDemographics] PRIMARY KEY NONCLUSTERED 
(
	[CustomerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO




/****** Object:  Table [dbo].[tblEmployeeTerritories]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEmployeeTerritories](
	[EmployeeID] [int] NOT NULL,
	[TerritoryID] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_EmployeeTerritories] PRIMARY KEY NONCLUSTERED 
(
	[EmployeeID] ASC,
	[TerritoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tblkRegion]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblkRegion](
	[RegionID] [int] NOT NULL,
	[RegionDescription] [nchar](50) NOT NULL,
 CONSTRAINT [PK_Region] PRIMARY KEY NONCLUSTERED 
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tblkSuppliers]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblkSuppliers](
	[SupplierID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
	[HomePage] [ntext] NULL,
 CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED 
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tblkTerritories]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblkTerritories](
	[TerritoryID] [nvarchar](20) NOT NULL,
	[TerritoryDescription] [nchar](50) NOT NULL,
	[RegionID] [int] NOT NULL,
 CONSTRAINT [PK_Territories] PRIMARY KEY NONCLUSTERED 
(
	[TerritoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO



/****** Object:  Index [CategoryName]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [CategoryName] ON [dbo].[tblCategories]
(
	[CategoryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [City]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [City] ON [dbo].[tblCustomers]
(
	[City] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [CompanyName]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [CompanyName] ON [dbo].[tblCustomers]
(
	[CompanyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PostalCode]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [PostalCode] ON [dbo].[tblCustomers]
(
	[PostalCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Region]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [Region] ON [dbo].[tblCustomers]
(
	[Region] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NDX_LastName]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [NDX_LastName] ON [dbo].[tblEmployees]
(
	[LastName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NDX_PostalCode]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [NDX_PostalCode] ON [dbo].[tblEmployees]
(
	[PostalCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [CategoriesProducts]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [CategoriesProducts] ON [dbo].[tblkProducts]
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [CategoryID]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [CategoryID] ON [dbo].[tblkProducts]
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ProductName]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [ProductName] ON [dbo].[tblkProducts]
(
	[ProductName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [SupplierID]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [SupplierID] ON [dbo].[tblkProducts]
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [SuppliersProducts]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [SuppliersProducts] ON [dbo].[tblkProducts]
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [CompanyName]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [CompanyName] ON [dbo].[tblkSuppliers]
(
	[CompanyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PostalCode]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [PostalCode] ON [dbo].[tblkSuppliers]
(
	[PostalCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [OrderID]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [OrderID] ON [dbo].[tblOrderDetails]
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [OrdersOrder_Details]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [OrdersOrder_Details] ON [dbo].[tblOrderDetails]
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ProductID]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [ProductID] ON [dbo].[tblOrderDetails]
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ProductsOrder_Details]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [ProductsOrder_Details] ON [dbo].[tblOrderDetails]
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [CustomerID]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [CustomerID] ON [dbo].[tblOrders]
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [CustomersOrders]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [CustomersOrders] ON [dbo].[tblOrders]
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [EmployeeID]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [EmployeeID] ON [dbo].[tblOrders]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [EmployeesOrders]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [EmployeesOrders] ON [dbo].[tblOrders]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [OrderDate]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [OrderDate] ON [dbo].[tblOrders]
(
	[OrderDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ShippedDate]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [ShippedDate] ON [dbo].[tblOrders]
(
	[ShippedDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ShippersOrders]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [ShippersOrders] ON [dbo].[tblOrders]
(
	[ShipVia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ShipPostalCode]    Script Date: 9/27/2024 6:35:47 PM ******/
CREATE NONCLUSTERED INDEX [ShipPostalCode] ON [dbo].[tblOrders]
(
	[ShipPostalCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblkProducts] ADD  CONSTRAINT [DF_Products_UnitPrice]  DEFAULT ((0)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[tblkProducts] ADD  CONSTRAINT [DF_Products_UnitsInStock]  DEFAULT ((0)) FOR [UnitsInStock]
GO
ALTER TABLE [dbo].[tblkProducts] ADD  CONSTRAINT [DF_Products_UnitsOnOrder]  DEFAULT ((0)) FOR [UnitsOnOrder]
GO
ALTER TABLE [dbo].[tblkProducts] ADD  CONSTRAINT [DF_Products_ReorderLevel]  DEFAULT ((0)) FOR [ReorderLevel]
GO
ALTER TABLE [dbo].[tblkProducts] ADD  CONSTRAINT [DF_Products_Discontinued]  DEFAULT ((0)) FOR [Discontinued]
GO
ALTER TABLE [dbo].[tblOrderDetails] ADD  CONSTRAINT [DF_Order_Details_UnitPrice]  DEFAULT ((0)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[tblOrderDetails] ADD  CONSTRAINT [DF_Order_Details_Quantity]  DEFAULT ((1)) FOR [Quantity]
GO
ALTER TABLE [dbo].[tblOrderDetails] ADD  CONSTRAINT [DF_Order_Details_Discount]  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [dbo].[tblOrders] ADD  CONSTRAINT [DF_Orders_Freight]  DEFAULT ((0)) FOR [Freight]
GO
ALTER TABLE [dbo].[tblCustomerCustomerDemo]  WITH CHECK ADD  CONSTRAINT [FK_CustomerCustomerDemo] FOREIGN KEY([CustomerTypeID])
REFERENCES [dbo].[tblCustomerDemographics] ([CustomerTypeID])
GO
ALTER TABLE [dbo].[tblCustomerCustomerDemo] CHECK CONSTRAINT [FK_CustomerCustomerDemo]
GO
ALTER TABLE [dbo].[tblCustomerCustomerDemo]  WITH CHECK ADD  CONSTRAINT [FK_CustomerCustomerDemo_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[tblCustomers] ([CustomerID])
GO
ALTER TABLE [dbo].[tblCustomerCustomerDemo] CHECK CONSTRAINT [FK_CustomerCustomerDemo_Customers]
GO
ALTER TABLE [dbo].[tblEmployees]  WITH NOCHECK ADD  CONSTRAINT [FK_tblEmployeesTerritories_TerritoryID] FOREIGN KEY([ReportsTo])
REFERENCES [dbo].[tblEmployees] ([EmployeeID])
GO
ALTER TABLE [dbo].[tblEmployees] CHECK CONSTRAINT [FK_tblEmployeesTerritories_TerritoryID]
GO
ALTER TABLE [dbo].[tblEmployeeTerritories]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeTerritories_Employees] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[tblEmployees] ([EmployeeID])
GO
ALTER TABLE [dbo].[tblEmployeeTerritories] CHECK CONSTRAINT [FK_EmployeeTerritories_Employees]
GO
ALTER TABLE [dbo].[tblEmployeeTerritories]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeTerritories_Territories] FOREIGN KEY([TerritoryID])
REFERENCES [dbo].[tblkTerritories] ([TerritoryID])
GO
ALTER TABLE [dbo].[tblEmployeeTerritories] CHECK CONSTRAINT [FK_EmployeeTerritories_Territories]
GO
ALTER TABLE [dbo].[tblkProducts]  WITH NOCHECK ADD  CONSTRAINT [FK_Products_Categories] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[tblCategories] ([CategoryID])
GO
ALTER TABLE [dbo].[tblkProducts] CHECK CONSTRAINT [FK_Products_Categories]
GO
ALTER TABLE [dbo].[tblkProducts]  WITH NOCHECK ADD  CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[tblkSuppliers] ([SupplierID])
GO
ALTER TABLE [dbo].[tblkProducts] CHECK CONSTRAINT [FK_Products_Suppliers]
GO
ALTER TABLE [dbo].[tblkTerritories]  WITH CHECK ADD  CONSTRAINT [FK_Territories_Region] FOREIGN KEY([RegionID])
REFERENCES [dbo].[tblkRegion] ([RegionID])
GO
ALTER TABLE [dbo].[tblkTerritories] CHECK CONSTRAINT [FK_Territories_Region]
GO
ALTER TABLE [dbo].[tblOrderDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_Details_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[tblOrders] ([OrderID])
GO
ALTER TABLE [dbo].[tblOrderDetails] CHECK CONSTRAINT [FK_Order_Details_Orders]
GO
ALTER TABLE [dbo].[tblOrderDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_Details_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[tblkProducts] ([ProductID])
GO
ALTER TABLE [dbo].[tblOrderDetails] CHECK CONSTRAINT [FK_Order_Details_Products]
GO
ALTER TABLE [dbo].[tblOrders]  WITH NOCHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[tblCustomers] ([CustomerID])
GO
ALTER TABLE [dbo].[tblOrders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
ALTER TABLE [dbo].[tblOrders]  WITH NOCHECK ADD  CONSTRAINT [FK_Orders_Employees] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[tblEmployees] ([EmployeeID])
GO
ALTER TABLE [dbo].[tblOrders] CHECK CONSTRAINT [FK_Orders_Employees]
GO
ALTER TABLE [dbo].[tblOrders]  WITH NOCHECK ADD  CONSTRAINT [FK_Orders_Shippers] FOREIGN KEY([ShipVia])
REFERENCES [dbo].[tblkShippers] ([ShipperID])
GO
ALTER TABLE [dbo].[tblOrders] CHECK CONSTRAINT [FK_Orders_Shippers]
GO
ALTER TABLE [dbo].[tblEmployees]  WITH NOCHECK ADD  CONSTRAINT [CK_Birthdate] CHECK  (([BirthDate]<getdate()))
GO
ALTER TABLE [dbo].[tblEmployees] CHECK CONSTRAINT [CK_Birthdate]
GO
ALTER TABLE [dbo].[tblkProducts]  WITH NOCHECK ADD  CONSTRAINT [CK_Products_UnitPrice] CHECK  (([UnitPrice]>=(0)))
GO
ALTER TABLE [dbo].[tblkProducts] CHECK CONSTRAINT [CK_Products_UnitPrice]
GO
ALTER TABLE [dbo].[tblkProducts]  WITH NOCHECK ADD  CONSTRAINT [CK_ReorderLevel] CHECK  (([ReorderLevel]>=(0)))
GO
ALTER TABLE [dbo].[tblkProducts] CHECK CONSTRAINT [CK_ReorderLevel]
GO
ALTER TABLE [dbo].[tblkProducts]  WITH NOCHECK ADD  CONSTRAINT [CK_UnitsInStock] CHECK  (([UnitsInStock]>=(0)))
GO
ALTER TABLE [dbo].[tblkProducts] CHECK CONSTRAINT [CK_UnitsInStock]
GO
ALTER TABLE [dbo].[tblkProducts]  WITH NOCHECK ADD  CONSTRAINT [CK_UnitsOnOrder] CHECK  (([UnitsOnOrder]>=(0)))
GO
ALTER TABLE [dbo].[tblkProducts] CHECK CONSTRAINT [CK_UnitsOnOrder]
GO
ALTER TABLE [dbo].[tblOrderDetails]  WITH NOCHECK ADD  CONSTRAINT [CK_Discount] CHECK  (([Discount]>=(0) AND [Discount]<=(1)))
GO
ALTER TABLE [dbo].[tblOrderDetails] CHECK CONSTRAINT [CK_Discount]
GO
ALTER TABLE [dbo].[tblOrderDetails]  WITH NOCHECK ADD  CONSTRAINT [CK_Quantity] CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[tblOrderDetails] CHECK CONSTRAINT [CK_Quantity]
GO
ALTER TABLE [dbo].[tblOrderDetails]  WITH NOCHECK ADD  CONSTRAINT [CK_UnitPrice] CHECK  (([UnitPrice]>=(0)))
GO
ALTER TABLE [dbo].[tblOrderDetails] CHECK CONSTRAINT [CK_UnitPrice]
GO
/****** Object:  StoredProcedure [dbo].[CustOrdersOrders]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CustOrdersOrders] @CustomerID nchar(5)
AS
SELECT OrderID, 
	OrderDate,
	RequiredDate,
	ShippedDate
FROM Orders
WHERE CustomerID = @CustomerID
ORDER BY OrderID
GO
/****** Object:  StoredProcedure [dbo].[Employee Sales by Country]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Employee Sales by Country] 
@Beginning_Date DateTime, @Ending_Date DateTime AS
SELECT Employees.Country, Employees.LastName, Employees.FirstName, Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal AS SaleAmount
FROM Employees INNER JOIN 
	(Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID) 
	ON Employees.EmployeeID = Orders.EmployeeID
WHERE Orders.ShippedDate Between @Beginning_Date And @Ending_Date
GO
/****** Object:  StoredProcedure [dbo].[Sales by Year]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Sales by Year] 
	@Beginning_Date DateTime, @Ending_Date DateTime AS
SELECT Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal, DATENAME(yy,ShippedDate) AS Year
FROM Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE Orders.ShippedDate Between @Beginning_Date And @Ending_Date
GO
/****** Object:  StoredProcedure [dbo].[SalesByCategory]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SalesByCategory]
    @CategoryName nvarchar(15), @OrdYear nvarchar(4) = '1998'
AS
IF @OrdYear != '1996' AND @OrdYear != '1997' AND @OrdYear != '1998' 
BEGIN
	SELECT @OrdYear = '1998'
END

SELECT ProductName,
	TotalPurchase=ROUND(SUM(CONVERT(decimal(14,2), OD.Quantity * (1-OD.Discount) * OD.UnitPrice)), 0)
FROM [Order Details] OD, Orders O, Products P, Categories C
WHERE OD.OrderID = O.OrderID 
	AND OD.ProductID = P.ProductID 
	AND P.CategoryID = C.CategoryID
	AND C.CategoryName = @CategoryName
	AND SUBSTRING(CONVERT(nvarchar(22), O.OrderDate, 111), 1, 4) = @OrdYear
GROUP BY ProductName
ORDER BY ProductName
GO
/****** Object:  StoredProcedure [dbo].[Ten Most Expensive Products]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Ten Most Expensive Products] AS
SET ROWCOUNT 10
SELECT Products.ProductName AS TenMostExpensiveProducts, Products.UnitPrice
FROM Products
ORDER BY Products.UnitPrice DESC
GO
/****** Object:  StoredProcedure [dbo].[uspCustOrderHist]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE
	

 PROCEDURE [dbo].[uspCustOrderHist] @parmCustomerID NCHAR(5)
AS
--=======================================================================================
--					D E F I N I T I O N
--=======================================================================================
-- Author:			Giancarlo Rhodes
-- Create Date:		05/24/2024
-- Description:		
--					
-- Integration:		
-- Update History:  Please see comment at bottom for changelog
--=======================================================================================
SELECT ProductName,
	Total = SUM(Quantity)
FROM Products P,
	[Order Details] OD,
	Orders O,
	Customers C
WHERE C.CustomerID = @parmCustomerID
	AND C.CustomerID = O.CustomerID
	AND O.OrderID = OD.OrderID
	AND OD.ProductID = P.ProductID
GROUP BY ProductName
	--=======================================================================================
	--				Change Log
	--=======================================================================================
	-- Author:			
	-- Create Date:		
	-- Description:		View was modified			
	-- Integration:		
	-- Update History:  
	--=======================================================================================
GO
/****** Object:  StoredProcedure [dbo].[uspCustOrdersDetail]    Script Date: 9/27/2024 6:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspCustOrdersDetail] @parmOrderID int
AS

--=======================================================================================
--					D E F I N I T I O N
--=======================================================================================
-- Author:			Giancarlo Rhodes
-- Create Date:		05/24/2024
-- Description:		
--					
-- Integration:		
-- Update History:  Please see comment at bottom for changelog
--=======================================================================================

SELECT ProductName,
    UnitPrice=ROUND(Od.UnitPrice, 2),
    Quantity,
    Discount=CONVERT(int, Discount * 100), 
    ExtendedPrice=ROUND(CONVERT(money, Quantity * (1 - Discount) * Od.UnitPrice), 2)
FROM Products P, [Order Details] Od
WHERE Od.ProductID = P.ProductID and Od.OrderID = @parmOrderID

--=======================================================================================
--				Change Log
--=======================================================================================
-- Author:			
-- Create Date:		
-- Description:		View was modified			
-- Integration:		
-- Update History:  
--=======================================================================================



GO
USE [master]
GO
ALTER DATABASE [MdcStandard] SET  READ_WRITE 
GO
