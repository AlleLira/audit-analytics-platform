/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 040_seed_dGerente.sql
Objetivo....: Popular a dimensão dGerente
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SET NOCOUNT ON;
GO

INSERT INTO dbo.dGerente
(
    NomeGerente,
    StatusGerente
)
SELECT
    Origem.NomeGerente,
    Origem.StatusGerente
FROM
(
    VALUES
        ('Ana Paula Ribeiro', 'Ativo'),
        ('Carlos Henrique Alves', 'Ativo'),
        ('Fernanda Souza', 'Ativo'),
        ('Marcelo Oliveira', 'Ativo'),
        ('Juliana Martins', 'Ativo'),
        ('Ricardo Gomes', 'Ativo')
) AS Origem
(
    NomeGerente,
    StatusGerente
)
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.dGerente AS Destino
    WHERE Destino.NomeGerente = Origem.NomeGerente
);

PRINT 'Carga da dimensão dGerente concluída com sucesso.';
GO