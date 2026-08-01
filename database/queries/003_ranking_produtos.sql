/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 003_ranking_produtos.sql
Objetivo....: Identificar os produtos com maior impacto financeiro em perdas
Autor.......: Alessandra Lira
Versão......: 1.0
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SELECT TOP (20)
    p.ProdutoID,
    p.CodigoProduto,
    p.NomeProduto,
    c.CategoriaID,
    c.NomeCategoria,

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
    ) AS ValorMedioPorUnidade,

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
INNER JOIN dbo.dProduto AS p
    ON f.ProdutoID = p.ProdutoID
INNER JOIN dbo.dCategoria AS c
    ON f.CategoriaID = c.CategoriaID
GROUP BY
    p.ProdutoID,
    p.CodigoProduto,
    p.NomeProduto,
    c.CategoriaID,
    c.NomeCategoria
ORDER BY
    ValorTotalPerdido DESC,
    QuantidadePerdida DESC;
GO