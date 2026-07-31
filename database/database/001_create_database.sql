/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 001_create_database.sql
Objetivo....: Criação do banco de dados AuditAnalyticsDW
Autor.......: Alessandra Lira
Versão......: 1.0
Data.........: 31/07/2026
===============================================================================
*/

IF DB_ID('AuditAnalyticsDW') IS NULL
BEGIN
    CREATE DATABASE AuditAnalyticsDW;
END;
GO

USE AuditAnalyticsDW;
GO

SELECT DB_NAME() AS BancoAtual;