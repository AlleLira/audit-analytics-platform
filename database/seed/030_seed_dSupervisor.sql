/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 030_seed_dSupervisor.sql
Objetivo....: Popular a dimensão dSupervisor com 32 supervisores fictícios
Autor.......: Alessandra Lira
Versão......: 1.1
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
        ('Carlos Eduardo Martins',  'Ativo'),
        ('Juliana Ferreira',        'Ativo'),
        ('André Luiz Souza',        'Ativo'),
        ('Mariana Costa',           'Ativo'),
        ('Rafael Oliveira',         'Ativo'),
        ('Patrícia Mendes',         'Ativo'),
        ('Bruno Almeida',           'Ativo'),
        ('Fernanda Lima',           'Ativo'),
        ('Alexandre Ribeiro',       'Ativo'),
        ('Bianca Carvalho',         'Ativo'),
        ('Caio Fernandes',          'Ativo'),
        ('Débora Santos',           'Ativo'),
        ('Everton Rodrigues',       'Ativo'),
        ('Flávia Barbosa',          'Ativo'),
        ('Gabriel Moreira',         'Ativo'),
        ('Helena Nascimento',       'Ativo'),
        ('Igor Araújo',             'Ativo'),
        ('Jéssica Teixeira',        'Ativo'),
        ('Kleber Correia',          'Ativo'),
        ('Larissa Gomes',           'Ativo'),
        ('Maurício Cardoso',        'Ativo'),
        ('Natália Freitas',         'Ativo'),
        ('Otávio Castro',           'Ativo'),
        ('Priscila Rocha',          'Ativo'),
        ('Renan Monteiro',          'Ativo'),
        ('Sabrina Lopes',           'Ativo'),
        ('Tiago Cunha',             'Ativo'),
        ('Valéria Duarte',          'Ativo'),
        ('William Pires',           'Ativo'),
        ('Yasmin Martins',          'Ativo'),
        ('Adriana Moraes',          'Ativo'),
        ('Fábio Rezende',           'Ativo')
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
