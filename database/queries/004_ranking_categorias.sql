/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 004_ranking_categorias.sql
Objetivo....: Ranking das categorias com maior valor de perdas
Autor.......: Alessandra Lira
Versão......: 1.0
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SELECT

    c.CategoriaID,
    c.NomeCategoria,

    COUNT(DISTINCT p.ProdutoID) AS TotalProdutos,

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
        /
        NULLIF(SUM(f.Quantidade),0)

        AS DECIMAL(18,2)
    ) AS ValorMedioPorUnidade,

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

INNER JOIN dbo.dCategoria c

ON f.CategoriaID = c.CategoriaID

INNER JOIN dbo.dProduto p

ON f.ProdutoID = p.ProdutoID

GROUP BY

    c.CategoriaID,
    c.NomeCategoria

ORDER BY

    ValorTotalPerdido DESC;

GO