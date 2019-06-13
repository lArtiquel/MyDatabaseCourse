USE [Склад214]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Клиент](
	[КодКлиента] [int] IDENTITY(1,1) NOT NULL,
	[ИмяКлиента] [nvarchar](40) NOT NULL,
	[ФИОРуководителя] [nvarchar](60) NULL,
	[КодРегиона] [int] NULL,
 CONSTRAINT [PK_Клиент] PRIMARY KEY CLUSTERED 
(
	[КодКлиента] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


