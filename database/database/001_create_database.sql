/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 001_create_database.sql
Objetivo....: Criar o banco de dados AuditAnalyticsDW
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE master;
GO

IF DB_ID('AuditAnalyticsDW') IS NULL
BEGIN
    CREATE DATABASE AuditAnalyticsDW;
    PRINT 'Banco AuditAnalyticsDW criado com sucesso.';
END
ELSE
BEGIN
    PRINT 'O banco AuditAnalyticsDW já existe.';
END;
GO

USE AuditAnalyticsDW;
GO

SELECT
    DB_NAME() AS BancoAtual;
GO
