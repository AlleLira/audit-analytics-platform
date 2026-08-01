/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 010_curva_abc.sql
Objetivo....: Classificar os produtos conforme a Curva ABC das perdas
Autor.......: Alessandra Lira
Versão......: 1.0
===============================================================================
*/

USE AuditAnalyticsDW;
GO

WITH Base AS
(
    SELECT
        p.ProdutoID,
        p.CodigoProduto,
        p.NomeProduto,
        c.NomeCategoria,
        SUM(f.ValorPerda) AS ValorTotalPerdido
    FROM dbo.fPerdas AS f
    INNER JOIN dbo.dProduto AS p
        ON f.ProdutoID = p.ProdutoID
    INNER JOIN dbo.dCategoria AS c
        ON p.CategoriaID = c.CategoriaID
    GROUP BY
        p.ProdutoID,
        p.CodigoProduto,
        p.NomeProduto,
        c.NomeCategoria
),
CurvaABC AS
(
    SELECT
        ProdutoID,
        CodigoProduto,
        NomeProduto,
        NomeCategoria,
        ValorTotalPerdido,

        SUM(ValorTotalPerdido)
            OVER
            (
                ORDER BY
                    ValorTotalPerdido DESC,
                    ProdutoID
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS ValorAcumulado,

        SUM(ValorTotalPerdido)
            OVER () AS ValorTotal
    FROM Base
)
SELECT
    ProdutoID,
    CodigoProduto,
    NomeProduto,
    NomeCategoria,

    CAST
    (
        ValorTotalPerdido
        AS DECIMAL(18,2)
    ) AS ValorTotalPerdido,

    CAST
    (
        ValorAcumulado
        AS DECIMAL(18,2)
    ) AS ValorAcumulado,

    CAST
    (
        100.0 * ValorAcumulado
        / NULLIF(ValorTotal, 0)
        AS DECIMAL(10,2)
    ) AS PercentualAcumulado,

    CASE
        WHEN ValorAcumulado / NULLIF(ValorTotal, 0) <= 0.80
            THEN 'Classe A'

        WHEN ValorAcumulado / NULLIF(ValorTotal, 0) <= 0.95
            THEN 'Classe B'

        ELSE 'Classe C'
    END AS ClassificacaoABC
FROM CurvaABC
ORDER BY
    ValorTotalPerdido DESC,
    ProdutoID;
GO