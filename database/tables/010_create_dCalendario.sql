/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 010_create_dCalendario.sql
Objetivo....: Criar a dimensão de calendário do Data Warehouse
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

IF OBJECT_ID('dbo.dCalendario', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dCalendario
    (
        DataID              INT         NOT NULL,
        DataCompleta        DATE        NOT NULL,
        Dia                 TINYINT     NOT NULL,
        DiaSemanaNumero     TINYINT     NOT NULL,
        DiaSemanaNome       VARCHAR(20) NOT NULL,
        SemanaAno           TINYINT     NOT NULL,
        MesNumero           TINYINT     NOT NULL,
        MesNome             VARCHAR(20) NOT NULL,
        MesAbreviado        CHAR(3)     NOT NULL,
        AnoMes              CHAR(7)     NOT NULL,
        Trimestre           TINYINT     NOT NULL,
        Semestre            TINYINT     NOT NULL,
        Ano                 SMALLINT    NOT NULL,
        EhFimDeSemana       BIT         NOT NULL,

        CONSTRAINT PK_dCalendario
            PRIMARY KEY CLUSTERED (DataID),

        CONSTRAINT UQ_dCalendario_DataCompleta
            UNIQUE (DataCompleta),

        CONSTRAINT CK_dCalendario_Dia
            CHECK (Dia BETWEEN 1 AND 31),

        CONSTRAINT CK_dCalendario_DiaSemanaNumero
            CHECK (DiaSemanaNumero BETWEEN 1 AND 7),

        CONSTRAINT CK_dCalendario_SemanaAno
            CHECK (SemanaAno BETWEEN 1 AND 53),

        CONSTRAINT CK_dCalendario_MesNumero
            CHECK (MesNumero BETWEEN 1 AND 12),

        CONSTRAINT CK_dCalendario_Trimestre
            CHECK (Trimestre BETWEEN 1 AND 4),

        CONSTRAINT CK_dCalendario_Semestre
            CHECK (Semestre BETWEEN 1 AND 2)
    );

    PRINT 'Tabela dbo.dCalendario criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'A tabela dbo.dCalendario já existe.';
END;
GO