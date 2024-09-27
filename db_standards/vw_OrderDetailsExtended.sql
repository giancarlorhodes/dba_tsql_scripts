USE [MdcStandard]
GO

/****** Object:  View [dbo].[vw_OrderDetailsExtended]    Script Date: 9/27/2024 9:19:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
	OR

ALTER VIEW [dbo].[vw_OrderDetailsExtended]
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
SELECT "tblOrderDetails".OrderID,
	"tblOrderDetails".ProductID,
	tblkProducts.ProductName,
	"tblOrderDetails".UnitPrice,
	"tblOrderDetails".Quantity,
	"tblOrderDetails".Discount,
	(CONVERT(MONEY, ("tblOrderDetails".UnitPrice * Quantity * (1 - Discount) / 100)) * 100) AS ExtendedPrice
FROM tblkProducts
INNER JOIN "tblOrderDetails" ON tblkProducts.ProductID = "tblOrderDetails".ProductID
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


