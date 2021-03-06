USE [master]
GO
/****** Object:  Database [RetailPOC]    Script Date: 05/04/2021 14:16:02 ******/
CREATE DATABASE [RetailPOC]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RetailPOC', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\RetailPOC.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'RetailPOC_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\RetailPOC_log.ldf' , SIZE = 401408KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [RetailPOC] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RetailPOC].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [RetailPOC] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [RetailPOC] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [RetailPOC] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [RetailPOC] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [RetailPOC] SET ARITHABORT OFF 
GO
ALTER DATABASE [RetailPOC] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [RetailPOC] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [RetailPOC] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [RetailPOC] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [RetailPOC] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [RetailPOC] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [RetailPOC] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [RetailPOC] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [RetailPOC] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [RetailPOC] SET  DISABLE_BROKER 
GO
ALTER DATABASE [RetailPOC] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [RetailPOC] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [RetailPOC] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [RetailPOC] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [RetailPOC] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [RetailPOC] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [RetailPOC] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [RetailPOC] SET RECOVERY FULL 
GO
ALTER DATABASE [RetailPOC] SET  MULTI_USER 
GO
ALTER DATABASE [RetailPOC] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [RetailPOC] SET DB_CHAINING OFF 
GO
ALTER DATABASE [RetailPOC] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [RetailPOC] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [RetailPOC] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'RetailPOC', N'ON'
GO
ALTER DATABASE [RetailPOC] SET QUERY_STORE = OFF
GO
USE [RetailPOC]
GO
/****** Object:  User [RetailPOCUser]    Script Date: 05/04/2021 14:16:02 ******/
CREATE USER [RetailPOCUser] FOR LOGIN [RetailPOCUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [RetailPOCUser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [RetailPOCUser]
GO
/****** Object:  Table [dbo].[tbproduct]    Script Date: 05/04/2021 14:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbproduct](
	[ProductCode] [int] NOT NULL,
	[ProductName] [varchar](45) NULL,
	[ProductSelling] [decimal](10, 2) NULL,
	[ProductCost] [decimal](10, 2) NULL,
	[MinStockLevel] [int] NULL,
	[OrderQuantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbProductSale]    Script Date: 05/04/2021 14:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbProductSale](
	[ProductSaleKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductCode] [int] NULL,
	[Quantity] [int] NULL,
	[Cost] [decimal](10, 2) NULL,
	[SaleDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbproduct] ADD  DEFAULT (NULL) FOR [ProductName]
GO
ALTER TABLE [dbo].[tbproduct] ADD  DEFAULT (NULL) FOR [ProductSelling]
GO
ALTER TABLE [dbo].[tbproduct] ADD  DEFAULT (NULL) FOR [ProductCost]
GO
ALTER TABLE [dbo].[tbproduct] ADD  DEFAULT (NULL) FOR [MinStockLevel]
GO
ALTER TABLE [dbo].[tbproduct] ADD  DEFAULT (NULL) FOR [OrderQuantity]
GO
ALTER TABLE [dbo].[tbProductSale] ADD  CONSTRAINT [DF_tbProductSale_SaleDate]  DEFAULT (getdate()) FOR [SaleDate]
GO
/****** Object:  StoredProcedure [dbo].[uspInsertProductSale]    Script Date: 05/04/2021 14:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspInsertProductSale] (
			@parmProductCode INT,
			@parmQuantity INT,
			@parmCost DECIMAL(10,2),
			@Result INT OUTPUT)
AS

BEGIN TRY
INSERT INTO [dbo].[tbProductSale]
           ([ProductCode]
           ,[Quantity]
           ,[Cost])
     VALUES
           (@parmProductCode,
		   @parmQuantity,
		   @parmCost)

SELECT @Result = 1
END TRY
BEGIN CATCH
SELECT @Result = 0
END CATCH
		   
GO
/****** Object:  StoredProcedure [dbo].[uspSalesCostByProduct]    Script Date: 05/04/2021 14:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
Create Procedure [dbo].[uspSalesCostByProduct] As

SELECT ProductCode, Sum(Quantity) Tot, Max(Cost) MaxCost, Min(Cost) MinCost, Convert(Decimal(10,2),Avg(Cost)) AvgCost
  FROM [RetailPOC].[dbo].[tbProductSale]
  Group By ProductCode
  Order By ProductCode

GO
USE [master]
GO
ALTER DATABASE [RetailPOC] SET  READ_WRITE 
GO
