/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 120_create_vw_PerdasPorProduto.sql
Objetivo....: Criar uma visão consolidada das perdas por produto e categoria
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

CREATE OR ALTER VIEW dbo.vw_PerdasPorProduto
AS
SELECT
    p.ProdutoID,
    p.CodigoProduto,
    p.NomeProduto,
    p.ValorVenda,
    p.Ativo AS ProdutoAtivo,

    c.CategoriaID,
    c.NomeCategoria,
    c.Ativo AS CategoriaAtiva,

    COUNT_BIG(f.PerdaID) AS TotalOcorrencias,

    SUM(CAST(f.Quantidade AS BIGINT)) AS QuantidadePerdida,

    CAST(
        SUM(f.ValorPerda)
        AS DECIMAL(18,2)
    ) AS ValorTotalPerdido,

    CAST(
        AVG(f.ValorPerda)
        AS DECIMAL(18,2)
    ) AS ValorMedioPorOcorrencia,

    CAST(
        SUM(f.ValorPerda)
        / NULLIF(SUM(CAST(f.Quantidade AS DECIMAL(18,2))), 0)
        AS DECIMAL(18,2)
    ) AS ValorMedioPorUnidade

FROM dbo.fPerdas AS f

INNER JOIN dbo.dProduto AS p
    ON f.ProdutoID = p.ProdutoID

INNER JOIN dbo.dCategoria AS c
    ON p.CategoriaID = c.CategoriaID

GROUP BY
    p.ProdutoID,
    p.CodigoProduto,
    p.NomeProduto,
    p.ValorVenda,
    p.Ativo,
    c.CategoriaID,
    c.NomeCategoria,
    c.Ativo;
GO
