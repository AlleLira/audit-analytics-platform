/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 009_pareto_perdas.sql
Objetivo....: Análise de Pareto (80/20) das perdas por produto
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

    FROM dbo.fPerdas f

    INNER JOIN dbo.dProduto p

        ON f.ProdutoID = p.ProdutoID

    INNER JOIN dbo.dCategoria c

        ON p.CategoriaID = c.CategoriaID

    GROUP BY

        p.ProdutoID,
        p.CodigoProduto,
        p.NomeProduto,
        c.NomeCategoria
),

Pareto AS
(
    SELECT

        *,

        SUM(ValorTotalPerdido)
            OVER
            (
                ORDER BY ValorTotalPerdido DESC
            ) AS ValorAcumulado,

        SUM(ValorTotalPerdido)
            OVER() AS ValorTotal

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
        ValorAcumulado
        /
        ValorTotal
        *100

        AS DECIMAL(10,2)
    ) AS PercentualAcumulado

FROM Pareto

ORDER BY

    ValorTotalPerdido DESC;

GO