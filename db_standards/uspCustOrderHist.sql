USE [MdcStandard]
GO

/****** Object:  StoredProcedure [dbo].[uspCustOrderHist]    Script Date: 9/27/2024 1:26:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
	OR

ALTER PROCEDURE [dbo].[uspCustOrderHist] @parmCustomerID NCHAR(5)
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


