/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 060_create_dLoja.sql
Objetivo....: Criar a dimensão de lojas do Data Warehouse
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

IF OBJECT_ID('dbo.dLoja', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dLoja
    (
        LojaID        INT IDENTITY(1,1) NOT NULL,
        CodigoLoja    VARCHAR(10)       NOT NULL,
        NomeLoja      VARCHAR(150)      NOT NULL,
        Cidade        VARCHAR(100)      NOT NULL,
        EstadoID      INT               NOT NULL,
        GerenteID     INT               NOT NULL,
        SupervisorID  INT               NOT NULL,
        DataAbertura  DATE              NULL,
        StatusLoja    VARCHAR(20)       NOT NULL
            CONSTRAINT DF_dLoja_Status
            DEFAULT ('Ativa'),

        CONSTRAINT PK_dLoja
            PRIMARY KEY CLUSTERED (LojaID),

        CONSTRAINT UQ_dLoja_Codigo
            UNIQUE (CodigoLoja),

        CONSTRAINT FK_dLoja_Estado
            FOREIGN KEY (EstadoID)
            REFERENCES dbo.dEstado(EstadoID),

        CONSTRAINT FK_dLoja_Gerente
            FOREIGN KEY (GerenteID)
            REFERENCES dbo.dGerente(GerenteID),

        CONSTRAINT FK_dLoja_Supervisor
            FOREIGN KEY (SupervisorID)
            REFERENCES dbo.dSupervisor(SupervisorID),

        CONSTRAINT CK_dLoja_Status
            CHECK (StatusLoja IN ('Ativa', 'Inativa')),

        CONSTRAINT CK_dLoja_Codigo
            CHECK (LEN(LTRIM(RTRIM(CodigoLoja))) > 0),

        CONSTRAINT CK_dLoja_Nome
            CHECK (LEN(LTRIM(RTRIM(NomeLoja))) > 0),

        CONSTRAINT CK_dLoja_Cidade
            CHECK (LEN(LTRIM(RTRIM(Cidade))) > 0)
    );

    PRINT 'Tabela dbo.dLoja criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'A tabela dbo.dLoja já existe.';
END;
GO