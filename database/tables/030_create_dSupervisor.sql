/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 030_create_dSupervisor.sql
Objetivo....: Criar a dimensão de supervisores do Data Warehouse
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

IF OBJECT_ID('dbo.dSupervisor', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dSupervisor
    (
        SupervisorID     INT IDENTITY(1,1) NOT NULL,
        NomeSupervisor   VARCHAR(120)       NOT NULL,
        StatusSupervisor VARCHAR(20)        NOT NULL
            CONSTRAINT DF_dSupervisor_Status
            DEFAULT ('Ativo'),

        CONSTRAINT PK_dSupervisor
            PRIMARY KEY CLUSTERED (SupervisorID),

        CONSTRAINT UQ_dSupervisor_Nome
            UNIQUE (NomeSupervisor),

        CONSTRAINT CK_dSupervisor_Status
            CHECK (StatusSupervisor IN ('Ativo', 'Inativo'))
    );

    PRINT 'Tabela dbo.dSupervisor criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'A tabela dbo.dSupervisor já existe.';
END;
GO