/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 110_create_vw_PerdasPorLoja.sql
Objetivo....: Criar uma visão consolidada das perdas por loja
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

CREATE OR ALTER VIEW dbo.vw_PerdasPorLoja
AS
SELECT
    l.LojaID,
    l.CodigoLoja,
    l.NomeLoja,
    l.Cidade,
    l.StatusLoja,

    e.EstadoID,
    e.UF,
    e.Estado,
    e.Regiao,

    g.GerenteID,
    g.NomeGerente,

    s.SupervisorID,
    s.NomeSupervisor,

    COUNT_BIG(f.PerdaID) AS TotalOcorrencias,
    SUM(f.Quantidade) AS QuantidadePerdida,
    CAST(SUM(f.ValorPerda) AS DECIMAL(18,2)) AS ValorTotalPerdido,
    CAST(AVG(f.ValorPerda) AS DECIMAL(18,2)) AS ValorMedioPorOcorrencia,
    CAST(
        SUM(f.ValorPerda) / NULLIF(SUM(f.Quantidade), 0)
        AS DECIMAL(18,2)
    ) AS ValorMedioPorUnidade
FROM dbo.fPerdas AS f
INNER JOIN dbo.dLoja AS l
    ON f.LojaID = l.LojaID
INNER JOIN dbo.dEstado AS e
    ON l.EstadoID = e.EstadoID
INNER JOIN dbo.dGerente AS g
    ON f.GerenteID = g.GerenteID
INNER JOIN dbo.dSupervisor AS s
    ON f.SupervisorID = s.SupervisorID
GROUP BY
    l.LojaID,
    l.CodigoLoja,
    l.NomeLoja,
    l.Cidade,
    l.StatusLoja,
    e.EstadoID,
    e.UF,
    e.Estado,
    e.Regiao,
    g.GerenteID,
    g.NomeGerente,
    s.SupervisorID,
    s.NomeSupervisor;
GO

PRINT 'View dbo.vw_PerdasPorLoja criada ou atualizada com sucesso.';
GO