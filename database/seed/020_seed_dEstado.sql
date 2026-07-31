/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 020_seed_dEstado.sql
Objetivo....: Popular a dimensão dEstado com os estados brasileiros
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SET NOCOUNT ON;
GO

INSERT INTO dbo.dEstado
(
    UF,
    Estado,
    Regiao
)
SELECT
    Origem.UF,
    Origem.Estado,
    Origem.Regiao
FROM
(
    VALUES
        ('AC', 'Acre', 'Norte'),
        ('AL', 'Alagoas', 'Nordeste'),
        ('AP', 'Amapá', 'Norte'),
        ('AM', 'Amazonas', 'Norte'),
        ('BA', 'Bahia', 'Nordeste'),
        ('CE', 'Ceará', 'Nordeste'),
        ('DF', 'Distrito Federal', 'Centro-Oeste'),
        ('ES', 'Espírito Santo', 'Sudeste'),
        ('GO', 'Goiás', 'Centro-Oeste'),
        ('MA', 'Maranhão', 'Nordeste'),
        ('MT', 'Mato Grosso', 'Centro-Oeste'),
        ('MS', 'Mato Grosso do Sul', 'Centro-Oeste'),
        ('MG', 'Minas Gerais', 'Sudeste'),
        ('PA', 'Pará', 'Norte'),
        ('PB', 'Paraíba', 'Nordeste'),
        ('PR', 'Paraná', 'Sul'),
        ('PE', 'Pernambuco', 'Nordeste'),
        ('PI', 'Piauí', 'Nordeste'),
        ('RJ', 'Rio de Janeiro', 'Sudeste'),
        ('RN', 'Rio Grande do Norte', 'Nordeste'),
        ('RS', 'Rio Grande do Sul', 'Sul'),
        ('RO', 'Rondônia', 'Norte'),
        ('RR', 'Roraima', 'Norte'),
        ('SC', 'Santa Catarina', 'Sul'),
        ('SP', 'São Paulo', 'Sudeste'),
        ('SE', 'Sergipe', 'Nordeste'),
        ('TO', 'Tocantins', 'Norte')
) AS Origem
(
    UF,
    Estado,
    Regiao
)
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.dEstado AS Destino
    WHERE Destino.UF = Origem.UF
);
GO

PRINT 'Carga da dimensão dEstado concluída com sucesso.';
GO