/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 005_ranking_gerentes.sql
Objetivo....: Ranking dos gerentes por valor de perdas
Autor.......: Alessandra Lira
Versão......: 1.0
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SELECT

    RANK() OVER
    (
        ORDER BY SUM(f.ValorPerda) DESC
    ) AS Ranking,

    g.GerenteID,

    g.NomeGerente,

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
    ) AS ValorMedioOcorrencia,

    CAST
    (
        SUM(f.ValorPerda)
        /
        NULLIF(SUM(f.Quantidade),0)

        AS DECIMAL(18,2)
    ) AS ValorMedioUnidade,

    CAST
    (
        100.0 *

        SUM(f.ValorPerda)

        /

        NULLIF
        (
            (
                SELECT SUM(ValorPerda)
                FROM dbo.fPerdas
            ),
            0
        )

        AS DECIMAL(10,2)
    ) AS ParticipacaoPercentual

FROM dbo.fPerdas f

INNER JOIN dbo.dGerente g

ON f.GerenteID = g.GerenteID

GROUP BY

    g.GerenteID,
    g.NomeGerente

ORDER BY

    ValorTotalPerdido DESC;

GO