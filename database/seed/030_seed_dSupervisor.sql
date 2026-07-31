/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 030_seed_dSupervisor.sql
Objetivo....: Popular a dimensão dSupervisor com dados fictícios
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SET NOCOUNT ON;
GO

INSERT INTO dbo.dSupervisor
(
    NomeSupervisor,
    StatusSupervisor
)
SELECT
    Origem.NomeSupervisor,
    Origem.StatusSupervisor
FROM
(
    VALUES
        ('Carlos Eduardo Martins', 'Ativo'),
        ('Juliana Ferreira', 'Ativo'),
        ('André Luiz Souza', 'Ativo'),
        ('Mariana Costa', 'Ativo'),
        ('Rafael Oliveira', 'Ativo'),
        ('Patrícia Mendes', 'Ativo'),
        ('Bruno Almeida', 'Ativo'),
        ('Fernanda Lima', 'Ativo')
) AS Origem
(
    NomeSupervisor,
    StatusSupervisor
)
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.dSupervisor AS Destino
    WHERE Destino.NomeSupervisor = Origem.NomeSupervisor
);
GO

PRINT 'Carga da dimensão dSupervisor concluída com sucesso.';
GO