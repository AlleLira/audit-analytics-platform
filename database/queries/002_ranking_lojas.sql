/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 002_ranking_lojas.sql
Objetivo....: Identificar as lojas com maior impacto financeiro em perdas
Autor.......: Alessandra Lira
Versão......: 1.0
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SELECT TOP (10)
    l.LojaID,
    l.CodigoLoja,
    l.NomeLoja,
    l.Cidade,
    e.UF,
    e.Estado,
    e.Regiao,
    g.NomeGerente,
    s.NomeSupervisor,

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
        100.0 * SUM(f.ValorPerda)
        / NULLIF
        (
            (
                SELECT SUM(ValorPerda)
                FROM dbo.fPerdas
            ),
            0
        )
        AS DECIMAL(10,2)
    ) AS ParticipacaoPercentual
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
    e.UF,
    e.Estado,
    e.Regiao,
    g.NomeGerente,
    s.NomeSupervisor
ORDER BY
    ValorTotalPerdido DESC;
GO