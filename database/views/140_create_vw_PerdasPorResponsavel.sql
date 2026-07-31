/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 140_create_vw_PerdasPorResponsavel.sql
Objetivo....: Criar uma visão consolidada das perdas por gerente e supervisor
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

CREATE OR ALTER VIEW dbo.vw_PerdasPorResponsavel
AS
SELECT
    g.GerenteID,
    g.NomeGerente,
    g.StatusGerente,

    s.SupervisorID,
    s.NomeSupervisor,
    s.StatusSupervisor,

    COUNT(DISTINCT f.LojaID) AS TotalLojas,
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
INNER JOIN dbo.dGerente AS g
    ON f.GerenteID = g.GerenteID
INNER JOIN dbo.dSupervisor AS s
    ON f.SupervisorID = s.SupervisorID
GROUP BY
    g.GerenteID,
    g.NomeGerente,
    g.StatusGerente,
    s.SupervisorID,
    s.NomeSupervisor,
    s.StatusSupervisor;
GO

PRINT 'View dbo.vw_PerdasPorResponsavel criada ou atualizada com sucesso.';
GO