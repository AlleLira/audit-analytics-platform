/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 130_create_vw_PerdasMensais.sql
Objetivo....: Criar uma visão consolidada das perdas por mês
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

CREATE OR ALTER VIEW dbo.vw_PerdasMensais
AS
SELECT
    c.Ano,
    c.MesNumero,
    c.MesNome,
    c.MesAbreviado,
    c.AnoMes,
    c.Trimestre,
    c.Semestre,

    COUNT_BIG(f.PerdaID) AS TotalOcorrencias,
    SUM(f.Quantidade) AS QuantidadePerdida,

    CAST
    (
        SUM(f.ValorPerda)
        AS DECIMAL(18,2)
    ) AS ValorTotalPerdido,

    CAST
    (
        AVG(f.ValorPerda)
        AS DECIMAL(18,2)
    ) AS ValorMedioPorOcorrencia,

    CAST
    (
        SUM(f.ValorPerda)
        / NULLIF(SUM(f.Quantidade), 0)
        AS DECIMAL(18,2)
    ) AS ValorMedioPorUnidade
FROM dbo.fPerdas AS f
INNER JOIN dbo.dCalendario AS c
    ON f.DataID = c.DataID
GROUP BY
    c.Ano,
    c.MesNumero,
    c.MesNome,
    c.MesAbreviado,
    c.AnoMes,
    c.Trimestre,
    c.Semestre;
GO

PRINT 'View dbo.vw_PerdasMensais criada ou atualizada com sucesso.';
GO