/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 070_create_dProduto.sql
Objetivo....: Criar a dimensão de produtos do Data Warehouse
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

IF OBJECT_ID('dbo.dProduto', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dProduto
    (
        ProdutoID      INT IDENTITY(1,1) NOT NULL,
        CodigoProduto  VARCHAR(30)       NOT NULL,
        NomeProduto    VARCHAR(150)      NOT NULL,
        CategoriaID    INT               NOT NULL,
        ValorVenda     DECIMAL(18,2)     NOT NULL,
        Ativo          BIT               NOT NULL
            CONSTRAINT DF_dProduto_Ativo
            DEFAULT (1),

        CONSTRAINT PK_dProduto
            PRIMARY KEY CLUSTERED (ProdutoID),

        CONSTRAINT UQ_dProduto_Codigo
            UNIQUE (CodigoProduto),

        CONSTRAINT FK_dProduto_Categoria
            FOREIGN KEY (CategoriaID)
            REFERENCES dbo.dCategoria(CategoriaID),

        CONSTRAINT CK_dProduto_Nome
            CHECK (LEN(LTRIM(RTRIM(NomeProduto))) > 0),

        CONSTRAINT CK_dProduto_ValorVenda
            CHECK (ValorVenda >= 0)
    );

    PRINT 'Tabela dbo.dProduto criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'A tabela dbo.dProduto já existe.';
END;
GO