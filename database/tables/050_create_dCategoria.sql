/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 050_create_dCategoria.sql
Objetivo....: Criar a dimensão de categorias do Data Warehouse
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

IF OBJECT_ID('dbo.dCategoria', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dCategoria
    (
        CategoriaID    INT IDENTITY(1,1) NOT NULL,
        NomeCategoria  VARCHAR(100)      NOT NULL,
        Ativo          BIT               NOT NULL
            CONSTRAINT DF_dCategoria_Ativo
            DEFAULT (1),

        CONSTRAINT PK_dCategoria
            PRIMARY KEY CLUSTERED (CategoriaID),

        CONSTRAINT UQ_dCategoria_Nome
            UNIQUE (NomeCategoria),

        CONSTRAINT CK_dCategoria_Nome
            CHECK (LEN(LTRIM(RTRIM(NomeCategoria))) > 0)
    );

    PRINT 'Tabela dbo.dCategoria criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'A tabela dbo.dCategoria já existe.';
END;
GO