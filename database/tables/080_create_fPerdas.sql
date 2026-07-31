/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 080_create_fPerdas.sql
Objetivo....: Criar a tabela fato de perdas do Data Warehouse
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

IF OBJECT_ID('dbo.fPerdas', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.fPerdas
    (
        PerdaID        BIGINT IDENTITY(1,1) NOT NULL,
        DataID         INT                  NOT NULL,
        LojaID         INT                  NOT NULL,
        ProdutoID      INT                  NOT NULL,
        CategoriaID    INT                  NOT NULL,
        SupervisorID   INT                  NOT NULL,
        GerenteID      INT                  NOT NULL,
        Quantidade     INT                  NOT NULL,
        ValorPerda     DECIMAL(18,2)        NOT NULL,
        TipoPerda      VARCHAR(50)          NOT NULL,

        CONSTRAINT PK_fPerdas
            PRIMARY KEY CLUSTERED (PerdaID),

        CONSTRAINT FK_fPerdas_Calendario
            FOREIGN KEY (DataID)
            REFERENCES dbo.dCalendario(DataID),

        CONSTRAINT FK_fPerdas_Loja
            FOREIGN KEY (LojaID)
            REFERENCES dbo.dLoja(LojaID),

        CONSTRAINT FK_fPerdas_Produto
            FOREIGN KEY (ProdutoID)
            REFERENCES dbo.dProduto(ProdutoID),

        CONSTRAINT FK_fPerdas_Categoria
            FOREIGN KEY (CategoriaID)
            REFERENCES dbo.dCategoria(CategoriaID),

        CONSTRAINT FK_fPerdas_Supervisor
            FOREIGN KEY (SupervisorID)
            REFERENCES dbo.dSupervisor(SupervisorID),

        CONSTRAINT FK_fPerdas_Gerente
            FOREIGN KEY (GerenteID)
            REFERENCES dbo.dGerente(GerenteID),

        CONSTRAINT CK_fPerdas_Quantidade
            CHECK (Quantidade > 0),

        CONSTRAINT CK_fPerdas_ValorPerda
            CHECK (ValorPerda >= 0),

        CONSTRAINT CK_fPerdas_TipoPerda
            CHECK (LEN(LTRIM(RTRIM(TipoPerda))) > 0)
    );

    PRINT 'Tabela dbo.fPerdas criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'A tabela dbo.fPerdas já existe.';
END;
GO