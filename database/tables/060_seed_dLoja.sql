/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 060_seed_dLoja.sql
Objetivo....: Popular a dimensão dLoja com 128 lojas em 18 estados
Autor.......: Alessandra Lira
Versão......: 1.1
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

DECLARE @Localidades TABLE
(
    Ordem       INT         NOT NULL PRIMARY KEY,
    UF          CHAR(2)     NOT NULL,
    Cidade      VARCHAR(100) NOT NULL
);

INSERT INTO @Localidades
(
    Ordem,
    UF,
    Cidade
)
VALUES
    (1,  'ES', 'Vitória'),
    (2,  'RJ', 'Rio de Janeiro'),
    (3,  'SP', 'São Paulo'),
    (4,  'MG', 'Belo Horizonte'),
    (5,  'PR', 'Curitiba'),
    (6,  'SC', 'Florianópolis'),
    (7,  'RS', 'Porto Alegre'),
    (8,  'BA', 'Salvador'),
    (9,  'PE', 'Recife'),
    (10, 'CE', 'Fortaleza'),
    (11, 'GO', 'Goiânia'),
    (12, 'DF', 'Brasília'),
    (13, 'PA', 'Belém'),
    (14, 'AM', 'Manaus'),
    (15, 'MA', 'São Luís'),
    (16, 'PB', 'João Pessoa'),
    (17, 'RN', 'Natal'),
    (18, 'AL', 'Maceió');

;WITH Numeros AS
(
    SELECT 1 AS Numero

    UNION ALL

    SELECT Numero + 1
    FROM Numeros
    WHERE Numero < 128
),
LojasGeradas AS
(
    SELECT
        n.Numero,

        CONCAT(
            'L',
            RIGHT(
                '000' + CAST(n.Numero AS VARCHAR(3)),
                3
            )
        ) AS CodigoLoja,

        loc.Cidade,

        loc.UF,

        CONCAT(
            'Nexus ',
            loc.Cidade,
            ' ',
            RIGHT(
                '00' +
                CAST(
                    (
                        (n.Numero - 1) / 18
                    ) + 1
                    AS VARCHAR(2)
                ),
                2
            )
        ) AS NomeLoja,

        ((n.Numero - 1) % 16) + 1 AS OrdemGerente,

        ((n.Numero - 1) % 32) + 1 AS OrdemSupervisor,

        DATEADD
        (
            DAY,
            (n.Numero - 1) * 29,
            CAST('2010-01-01' AS DATE)
        ) AS DataAbertura
    FROM Numeros AS n
    INNER JOIN @Localidades AS loc
        ON loc.Ordem = ((n.Numero - 1) % 18) + 1
),
Gerentes AS
(
    SELECT
        GerenteID,
        NomeGerente,
        ROW_NUMBER() OVER
        (
            ORDER BY GerenteID
        ) AS OrdemGerente
    FROM dbo.dGerente
    WHERE StatusGerente = 'Ativo'
),
Supervisores AS
(
    SELECT
        SupervisorID,
        NomeSupervisor,
        ROW_NUMBER() OVER
        (
            ORDER BY SupervisorID
        ) AS OrdemSupervisor
    FROM dbo.dSupervisor
    WHERE StatusSupervisor = 'Ativo'
)
INSERT INTO dbo.dLoja
(
    CodigoLoja,
    NomeLoja,
    Cidade,
    EstadoID,
    GerenteID,
    SupervisorID,
    DataAbertura,
    StatusLoja
)
SELECT
    lg.CodigoLoja,
    lg.NomeLoja,
    lg.Cidade,
    e.EstadoID,
    g.GerenteID,
    s.SupervisorID,
    lg.DataAbertura,
    'Ativa'
FROM LojasGeradas AS lg
INNER JOIN dbo.dEstado AS e
    ON e.UF = lg.UF
INNER JOIN Gerentes AS g
    ON g.OrdemGerente = lg.OrdemGerente
INNER JOIN Supervisores AS s
    ON s.OrdemSupervisor = lg.OrdemSupervisor
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.dLoja AS Destino
    WHERE Destino.CodigoLoja = lg.CodigoLoja
)
OPTION (MAXRECURSION 128);
GO

PRINT 'Carga de 128 lojas concluída com sucesso.';
GO