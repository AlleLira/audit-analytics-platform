/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 080_seed_fPerdas.sql
Objetivo....: Popular a tabela fato fPerdas com 25.000 ocorrências fictícias
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.dCalendario)
    THROW 50001, 'A dimensão dCalendario está vazia.', 1;

IF NOT EXISTS (SELECT 1 FROM dbo.dLoja)
    THROW 50002, 'A dimensão dLoja está vazia.', 1;

IF NOT EXISTS (SELECT 1 FROM dbo.dProduto)
    THROW 50003, 'A dimensão dProduto está vazia.', 1;
GO

;WITH Numeros AS
(
    SELECT 1 AS Numero

    UNION ALL

    SELECT Numero + 1
    FROM Numeros
    WHERE Numero < 25000
),
BaseGerada AS
(
    SELECT
        n.Numero,

        DATEADD
        (
            DAY,
            (n.Numero * 17) % 1096,
            CAST('2024-01-01' AS DATE)
        ) AS DataOcorrencia,

        ((n.Numero * 13) % 128) + 1 AS OrdemLoja,

        ((n.Numero * 29) % 200) + 1 AS OrdemProduto,

        ((n.Numero * 7) % 5) + 1 AS Quantidade,

        CASE (n.Numero % 7)
            WHEN 0 THEN 'Furto'
            WHEN 1 THEN 'Avaria'
            WHEN 2 THEN 'Quebra'
            WHEN 3 THEN 'Divergência de Estoque'
            WHEN 4 THEN 'Erro Operacional'
            WHEN 5 THEN 'Produto Vencido'
            ELSE 'Extravio'
        END AS TipoPerda
    FROM Numeros AS n
),
LojasOrdenadas AS
(
    SELECT
        LojaID,
        SupervisorID,
        GerenteID,
        ROW_NUMBER() OVER (ORDER BY LojaID) AS OrdemLoja
    FROM dbo.dLoja
    WHERE StatusLoja = 'Ativa'
),
ProdutosOrdenados AS
(
    SELECT
        ProdutoID,
        CategoriaID,
        ValorVenda,
        ROW_NUMBER() OVER (ORDER BY ProdutoID) AS OrdemProduto
    FROM dbo.dProduto
    WHERE Ativo = 1
)
INSERT INTO dbo.fPerdas
(
    DataID,
    LojaID,
    ProdutoID,
    CategoriaID,
    SupervisorID,
    GerenteID,
    Quantidade,
    ValorPerda,
    TipoPerda
)
SELECT
    c.DataID,
    l.LojaID,
    p.ProdutoID,
    p.CategoriaID,
    l.SupervisorID,
    l.GerenteID,
    bg.Quantidade,

    CAST
    (
        bg.Quantidade
        * p.ValorVenda
        * CASE
            WHEN bg.TipoPerda IN ('Furto', 'Extravio')
                THEN 1.00

            WHEN bg.TipoPerda IN ('Avaria', 'Quebra')
                THEN 0.65

            WHEN bg.TipoPerda = 'Produto Vencido'
                THEN 0.80

            ELSE 0.50
          END
        AS DECIMAL(18,2)
    ) AS ValorPerda,

    bg.TipoPerda
FROM BaseGerada AS bg
INNER JOIN dbo.dCalendario AS c
    ON c.DataCompleta = bg.DataOcorrencia
INNER JOIN LojasOrdenadas AS l
    ON l.OrdemLoja = bg.OrdemLoja
INNER JOIN ProdutosOrdenados AS p
    ON p.OrdemProduto = bg.OrdemProduto
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.fPerdas
)
OPTION (MAXRECURSION 25000);
GO

PRINT 'Carga de 25.000 ocorrências concluída com sucesso.';
GO