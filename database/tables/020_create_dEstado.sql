/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 020_create_dEstado.sql
Objetivo....: Criar a dimensão de estados do Data Warehouse
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

IF OBJECT_ID('dbo.dEstado', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dEstado
    (
        EstadoID INT IDENTITY(1,1) NOT NULL,
        UF       CHAR(2)           NOT NULL,
        Estado   VARCHAR(50)       NOT NULL,
        Regiao   VARCHAR(20)       NOT NULL,

        CONSTRAINT PK_dEstado
            PRIMARY KEY CLUSTERED (EstadoID),

        CONSTRAINT UQ_dEstado_UF
            UNIQUE (UF),

        CONSTRAINT UQ_dEstado_Estado
            UNIQUE (Estado),

        CONSTRAINT CK_dEstado_Regiao
            CHECK
            (
                Regiao IN
                (
                    'Norte',
                    'Nordeste',
                    'Centro-Oeste',
                    'Sudeste',
                    'Sul'
                )
            ),

        CONSTRAINT CK_dEstado_UF
            CHECK
            (
                LEN(LTRIM(RTRIM(UF))) = 2
            )
    );

    PRINT 'Tabela dbo.dEstado criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'A tabela dbo.dEstado já existe.';
END;
GO
