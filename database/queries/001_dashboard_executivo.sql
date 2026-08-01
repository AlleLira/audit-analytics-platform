/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 001_dashboard_executivo.sql
Objetivo....: KPIs executivos do Data Warehouse
Autor.......: Alessandra Lira
Versão......: 1.0
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SELECT

COUNT(*) AS TotalOcorrencias,

SUM(Quantidade) AS QuantidadePerdida,

SUM(ValorPerda) AS ValorTotalPerdido,

AVG(ValorPerda) AS TicketMedio,

MIN(ValorPerda) AS MenorPerda,

MAX(ValorPerda) AS MaiorPerda

FROM dbo.fPerdas;
GO