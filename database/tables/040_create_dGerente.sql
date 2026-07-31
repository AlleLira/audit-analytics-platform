/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 040_create_dGerente.sql
Objetivo....: Criar a dimensão de gerentes do Data Warehouse
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

IF OBJECT_ID('dbo.dGerente', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dGerente
    (
        GerenteID       INT IDENTITY(1,1) NOT NULL,
        NomeGerente     VARCHAR(120) NOT NULL,
        StatusGerente   VARCHAR(20) NOT NULL
            CONSTRAINT DF_dGerente_Status
            DEFAULT ('Ativo'),

        CONSTRAINT PK_dGerente
            PRIMARY KEY CLUSTERED (GerenteID),

        CONSTRAINT UQ_dGerente_Nome
            UNIQUE (NomeGerente),

        CONSTRAINT CK_dGerente_Status
            CHECK (StatusGerente IN ('Ativo','Inativo'))
    );

    PRINT 'Tabela dbo.dGerente criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'A tabela dbo.dGerente já existe.';
END;
GO