USE [MdcStandard]
GO

/****** Object:  View [dbo].[vw_OrderSubtotals]    Script Date: 9/27/2024 9:30:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
	OR

ALTER VIEW [dbo].[vw_OrderSubtotals]
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


SELECT "Order Details".OrderID,
	Sum(CONVERT(MONEY, ("Order Details".UnitPrice * Quantity * (1 - Discount) / 100)) * 100) AS Subtotal
FROM "Order Details"
GROUP BY "Order Details".OrderID

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


