/****** Object: Table [dbo].[Turns] Script Date: 22.07.2020 15:32:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Turns] (
    [Id]                   INT           IDENTITY (1, 1) NOT NULL,
    [MatchId]              NVARCHAR (50) NULL,  
    [WhenUtc]              DATETIME      NULL,
    [TurnNumber]           NVARCHAR (50) NULL,
    [Player1Name]          NVARCHAR (50) NULL,
    [Player2Name]          NVARCHAR (50) NULL,
    [Player1Move]          NVARCHAR (50) NULL,
    [Player2Move]          NVARCHAR (50) NULL
);
