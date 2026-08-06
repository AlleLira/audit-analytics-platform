/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 002_validate_data_quality.sql
Objetivo....: Validar integridade, consistência e qualidade dos dados
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 06/08/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SET NOCOUNT ON;

DECLARE @Falhas INT = 0;

DECLARE @Resultados TABLE
(
    Teste       VARCHAR(150),
    Ocorrencias BIGINT
);

PRINT '===============================================================';
PRINT 'INICIANDO VALIDACAO DA QUALIDADE DOS DADOS';
PRINT '===============================================================';


/* =============================================================
   1. REGISTROS ÓRFÃOS
   ============================================================= */

INSERT INTO @Resultados
SELECT
    'Perdas sem data correspondente',
    COUNT_BIG(*)
FROM dbo.fPerdas AS f
LEFT JOIN dbo.dCalendario AS c
    ON f.DataID = c.DataID
WHERE c.DataID IS NULL;

INSERT INTO @Resultados
SELECT
    'Perdas sem loja correspondente',
    COUNT_BIG(*)
FROM dbo.fPerdas AS f
LEFT JOIN dbo.dLoja AS l
    ON f.LojaID = l.LojaID
WHERE l.LojaID IS NULL;

INSERT INTO @Resultados
SELECT
    'Perdas sem produto correspondente',
    COUNT_BIG(*)
FROM dbo.fPerdas AS f
LEFT JOIN dbo.dProduto AS p
    ON f.ProdutoID = p.ProdutoID
WHERE p.ProdutoID IS NULL;

INSERT INTO @Resultados
SELECT
    'Perdas sem categoria correspondente',
    COUNT_BIG(*)
FROM dbo.fPerdas AS f
LEFT JOIN dbo.dCategoria AS c
    ON f.CategoriaID = c.CategoriaID
WHERE c.CategoriaID IS NULL;

INSERT INTO @Resultados
SELECT
    'Perdas sem supervisor correspondente',
    COUNT_BIG(*)
FROM dbo.fPerdas AS f
LEFT JOIN dbo.dSupervisor AS s
    ON f.SupervisorID = s.SupervisorID
WHERE s.SupervisorID IS NULL;

INSERT INTO @Resultados
SELECT
    'Perdas sem gerente correspondente',
    COUNT_BIG(*)
FROM dbo.fPerdas AS f
LEFT JOIN dbo.dGerente AS g
    ON f.GerenteID = g.GerenteID
WHERE g.GerenteID IS NULL;


/* =============================================================
   2. CONSISTÊNCIA ENTRE AS DIMENSÕES E A TABELA FATO
   ============================================================= */

INSERT INTO @Resultados
SELECT
    'Categoria da perda diferente da categoria do produto',
    COUNT_BIG(*)
FROM dbo.fPerdas AS f
INNER JOIN dbo.dProduto AS p
    ON f.ProdutoID = p.ProdutoID
WHERE f.CategoriaID <> p.CategoriaID;

INSERT INTO @Resultados
SELECT
    'Gerente da perda diferente do gerente da loja',
    COUNT_BIG(*)
FROM dbo.fPerdas AS f
INNER JOIN dbo.dLoja AS l
    ON f.LojaID = l.LojaID
WHERE f.GerenteID <> l.GerenteID;

INSERT INTO @Resultados
SELECT
    'Supervisor da perda diferente do supervisor da loja',
    COUNT_BIG(*)
FROM dbo.fPerdas AS f
INNER JOIN dbo.dLoja AS l
    ON f.LojaID = l.LojaID
WHERE f.SupervisorID <> l.SupervisorID;


/* =============================================================
   3. VALORES INVÁLIDOS
   ============================================================= */

INSERT INTO @Resultados
SELECT
    'Perdas com quantidade menor ou igual a zero',
    COUNT_BIG(*)
FROM dbo.fPerdas
WHERE Quantidade <= 0;

INSERT INTO @Resultados
SELECT
    'Perdas com valor negativo',
    COUNT_BIG(*)
FROM dbo.fPerdas
WHERE ValorPerda < 0;

INSERT INTO @Resultados
SELECT
    'Produtos com valor de venda negativo',
    COUNT_BIG(*)
FROM dbo.dProduto
WHERE ValorVenda < 0;


/* =============================================================
   4. CAMPOS DE TEXTO VAZIOS
   ============================================================= */

INSERT INTO @Resultados
SELECT
    'Perdas com tipo de perda vazio',
    COUNT_BIG(*)
FROM dbo.fPerdas
WHERE NULLIF(LTRIM(RTRIM(TipoPerda)), '') IS NULL;

INSERT INTO @Resultados
SELECT
    'Produtos com código vazio',
    COUNT_BIG(*)
FROM dbo.dProduto
WHERE NULLIF(LTRIM(RTRIM(CodigoProduto)), '') IS NULL;

INSERT INTO @Resultados
SELECT
    'Produtos com nome vazio',
    COUNT_BIG(*)
FROM dbo.dProduto
WHERE NULLIF(LTRIM(RTRIM(NomeProduto)), '') IS NULL;

INSERT INTO @Resultados
SELECT
    'Lojas com código vazio',
    COUNT_BIG(*)
FROM dbo.dLoja
WHERE NULLIF(LTRIM(RTRIM(CodigoLoja)), '') IS NULL;

INSERT INTO @Resultados
SELECT
    'Lojas com nome vazio',
    COUNT_BIG(*)
FROM dbo.dLoja
WHERE NULLIF(LTRIM(RTRIM(NomeLoja)), '') IS NULL;


/* =============================================================
   5. DUPLICIDADES
   ============================================================= */

INSERT INTO @Resultados
SELECT
    'Códigos de produto duplicados',
    COUNT_BIG(*)
FROM
(
    SELECT CodigoProduto
    FROM dbo.dProduto
    GROUP BY CodigoProduto
    HAVING COUNT(*) > 1
) AS duplicados;

INSERT INTO @Resultados
SELECT
    'Códigos de loja duplicados',
    COUNT_BIG(*)
FROM
(
    SELECT CodigoLoja
    FROM dbo.dLoja
    GROUP BY CodigoLoja
    HAVING COUNT(*) > 1
) AS duplicados;

INSERT INTO @Resultados
SELECT
    'Datas duplicadas no calendário',
    COUNT_BIG(*)
FROM
(
    SELECT DataCompleta
    FROM dbo.dCalendario
    GROUP BY DataCompleta
    HAVING COUNT(*) > 1
) AS duplicados;


/* =============================================================
   6. CONSISTÊNCIA DO CALENDÁRIO
   ============================================================= */

INSERT INTO @Resultados
SELECT
    'DataID diferente do formato AAAAMMDD',
    COUNT_BIG(*)
FROM dbo.dCalendario
WHERE DataID <>
      (YEAR(DataCompleta) * 10000)
      + (MONTH(DataCompleta) * 100)
      + DAY(DataCompleta);

INSERT INTO @Resultados
SELECT
    'Ano do calendário inconsistente',
    COUNT_BIG(*)
FROM dbo.dCalendario
WHERE Ano <> YEAR(DataCompleta);

INSERT INTO @Resultados
SELECT
    'Mês do calendário inconsistente',
    COUNT_BIG(*)
FROM dbo.dCalendario
WHERE MesNumero <> MONTH(DataCompleta);

INSERT INTO @Resultados
SELECT
    'Dia do calendário inconsistente',
    COUNT_BIG(*)
FROM dbo.dCalendario
WHERE Dia <> DAY(DataCompleta);

INSERT INTO @Resultados
SELECT
    'Trimestre do calendário inconsistente',
    COUNT_BIG(*)
FROM dbo.dCalendario
WHERE Trimestre <> DATEPART(QUARTER, DataCompleta);


/* =============================================================
   7. EXIBIÇÃO DOS RESULTADOS
   ============================================================= */

DECLARE
    @Teste       VARCHAR(150),
    @Ocorrencias BIGINT;

DECLARE cursor_resultados CURSOR LOCAL FAST_FORWARD FOR
    SELECT Teste, Ocorrencias
    FROM @Resultados
    ORDER BY Teste;

OPEN cursor_resultados;

FETCH NEXT FROM cursor_resultados
INTO @Teste, @Ocorrencias;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @Ocorrencias = 0
    BEGIN
        PRINT '[OK] ' + @Teste;
    END
    ELSE
    BEGIN
        PRINT
            '[FALHA] '
            + @Teste
            + ': '
            + CAST(@Ocorrencias AS VARCHAR(20))
            + ' ocorrência(s).';

        SET @Falhas += 1;
    END;

    FETCH NEXT FROM cursor_resultados
    INTO @Teste, @Ocorrencias;
END;

CLOSE cursor_resultados;
DEALLOCATE cursor_resultados;


/* =============================================================
   8. RESULTADO FINAL
   ============================================================= */

PRINT '===============================================================';

IF @Falhas = 0
BEGIN
    PRINT 'TODOS OS TESTES DE QUALIDADE FORAM CONCLUIDOS COM SUCESSO.';
END
ELSE
BEGIN
    DECLARE @MensagemErro NVARCHAR(200);

    SET @MensagemErro = CONCAT(
        'A validacao de qualidade encontrou falhas em ',
        @Falhas,
        ' teste(s).'
    );

    THROW 51001, @MensagemErro, 1;
END;
GO