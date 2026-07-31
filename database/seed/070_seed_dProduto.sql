/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 070_seed_dProduto.sql
Objetivo....: Popular a dimensão dProduto com 200 produtos fictícios
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

IF (SELECT COUNT(*) FROM dbo.dCategoria WHERE Ativo = 1) < 10
BEGIN
    THROW 50001,
          'A dCategoria deve possuir pelo menos 10 categorias ativas.',
          1;
END;
GO

;WITH Numeros AS
(
    SELECT 1 AS Numero

    UNION ALL

    SELECT Numero + 1
    FROM Numeros
    WHERE Numero < 200
),
CategoriasOrdenadas AS
(
    SELECT
        CategoriaID,
        NomeCategoria,
        ROW_NUMBER() OVER
        (
            ORDER BY CategoriaID
        ) AS OrdemCategoria
    FROM dbo.dCategoria
    WHERE Ativo = 1
),
ProdutosGerados AS
(
    SELECT
        n.Numero,

        CONCAT(
            'PRD',
            RIGHT(
                '0000' + CAST(n.Numero AS VARCHAR(4)),
                4
            )
        ) AS CodigoProduto,

        c.CategoriaID,
        c.NomeCategoria,

        CONCAT(
            c.NomeCategoria,
            ' Modelo ',
            RIGHT(
                '000' + CAST(n.Numero AS VARCHAR(3)),
                3
            )
        ) AS NomeProduto,

        CAST
        (
            CASE c.NomeCategoria
                WHEN 'Smartphones'
                    THEN 899 + ((n.Numero * 137) % 5100)

                WHEN 'Tablets'
                    THEN 699 + ((n.Numero * 89) % 2800)

                WHEN 'Notebooks'
                    THEN 1999 + ((n.Numero * 173) % 7000)

                WHEN 'Monitores'
                    THEN 599 + ((n.Numero * 97) % 2400)

                WHEN 'Áudio'
                    THEN 79 + ((n.Numero * 43) % 1400)

                WHEN 'Games'
                    THEN 149 + ((n.Numero * 151) % 4300)

                WHEN 'Acessórios'
                    THEN 19 + ((n.Numero * 17) % 780)

                WHEN 'Periféricos'
                    THEN 39 + ((n.Numero * 29) % 1600)

                WHEN 'Armazenamento'
                    THEN 99 + ((n.Numero * 61) % 2100)

                WHEN 'Redes'
                    THEN 89 + ((n.Numero * 47) % 1900)

                ELSE
                    100 + ((n.Numero * 37) % 900)
            END
            +
            CASE
                WHEN n.Numero % 4 = 0 THEN 0.90
                WHEN n.Numero % 4 = 1 THEN 0.99
                WHEN n.Numero % 4 = 2 THEN 0.50
                ELSE 0.00
            END
            AS DECIMAL(18,2)
        ) AS ValorVenda
    FROM Numeros AS n
    INNER JOIN CategoriasOrdenadas AS c
        ON c.OrdemCategoria = ((n.Numero - 1) % 10) + 1
)
INSERT INTO dbo.dProduto
(
    CodigoProduto,
    NomeProduto,
    CategoriaID,
    ValorVenda,
    Ativo
)
SELECT
    pg.CodigoProduto,
    pg.NomeProduto,
    pg.CategoriaID,
    pg.ValorVenda,
    1
FROM ProdutosGerados AS pg
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.dProduto AS Destino
    WHERE Destino.CodigoProduto = pg.CodigoProduto
)
OPTION (MAXRECURSION 200);
GO

PRINT 'Carga de 200 produtos concluída com sucesso.';
GO