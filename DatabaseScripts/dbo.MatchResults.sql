/****** Object: Table [dbo].[MatchResults] Script Date: 22.07.2020 15:33:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MatchResults] (
    [Id]                  INT          IDENTITY (1, 1) NOT NULL,
    [MatchId]             VARCHAR (50) NULL,
    [WhenUtc]             DATETIME     NULL,
    [Player1Name]         VARCHAR (50) NULL,
    [Player2Name]         VARCHAR (50) NULL,
    [MatchOutcome]        VARCHAR (50) NULL
);
