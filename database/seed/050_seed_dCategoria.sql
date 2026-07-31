/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 050_seed_dCategoria.sql
Objetivo....: Popular a dimensão dCategoria com dados fictícios
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SET NOCOUNT ON;
GO

INSERT INTO dbo.dCategoria
(
    NomeCategoria,
    Ativo
)
SELECT
    Origem.NomeCategoria,
    Origem.Ativo
FROM
(
    VALUES
        ('Smartphones', 1),
        ('Tablets', 1),
        ('Notebooks', 1),
        ('Monitores', 1),
        ('Áudio', 1),
        ('Games', 1),
        ('Acessórios', 1),
        ('Periféricos', 1),
        ('Armazenamento', 1),
        ('Redes', 1)
) AS Origem
(
    NomeCategoria,
    Ativo
)
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.dCategoria AS Destino
    WHERE Destino.NomeCategoria = Origem.NomeCategoria
);
GO

PRINT 'Carga da dimensão dCategoria concluída com sucesso.';
GO