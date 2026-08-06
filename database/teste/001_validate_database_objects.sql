/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 001_validate_database_objects.sql
Objetivo....: Validar a criação dos objetos essenciais do Data Warehouse
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 06/08/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SET NOCOUNT ON;

DECLARE @Falhas INT = 0;

PRINT '===============================================================';
PRINT 'INICIANDO VALIDACAO DOS OBJETOS DO BANCO';
PRINT '===============================================================';


/* =============================================================
   1. VALIDAÇÃO DAS TABELAS
   ============================================================= */

DECLARE @TabelasEsperadas TABLE
(
    NomeTabela SYSNAME
);

INSERT INTO @TabelasEsperadas (NomeTabela)
VALUES
    ('dCalendario'),
    ('dEstado'),
    ('dSupervisor'),
    ('dGerente'),
    ('dCategoria'),
    ('dLoja'),
    ('dProduto'),
    ('fPerdas');

DECLARE @NomeTabela SYSNAME;

DECLARE cursor_tabelas CURSOR LOCAL FAST_FORWARD FOR
    SELECT NomeTabela
    FROM @TabelasEsperadas;

OPEN cursor_tabelas;
FETCH NEXT FROM cursor_tabelas INTO @NomeTabela;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF OBJECT_ID('dbo.' + @NomeTabela, 'U') IS NULL
    BEGIN
        PRINT '[FALHA] Tabela dbo.' + @NomeTabela + ' nao encontrada.';
        SET @Falhas += 1;
    END
    ELSE
    BEGIN
        PRINT '[OK] Tabela dbo.' + @NomeTabela + ' encontrada.';
    END;

    FETCH NEXT FROM cursor_tabelas INTO @NomeTabela;
END;

CLOSE cursor_tabelas;
DEALLOCATE cursor_tabelas;


/* =============================================================
   2. VALIDAÇÃO DAS VIEWS
   ============================================================= */

DECLARE @ViewsEsperadas TABLE
(
    NomeView SYSNAME
);

INSERT INTO @ViewsEsperadas (NomeView)
VALUES
    ('vw_PerdasDetalhadas'),
    ('vw_PerdasPorLoja'),
    ('vw_PerdasPorProduto'),
    ('vw_PerdasMensais'),
    ('vw_PerdasPorResponsavel');

DECLARE @NomeView SYSNAME;

DECLARE cursor_views CURSOR LOCAL FAST_FORWARD FOR
    SELECT NomeView
    FROM @ViewsEsperadas;

OPEN cursor_views;
FETCH NEXT FROM cursor_views INTO @NomeView;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF OBJECT_ID('dbo.' + @NomeView, 'V') IS NULL
    BEGIN
        PRINT '[FALHA] View dbo.' + @NomeView + ' nao encontrada.';
        SET @Falhas += 1;
    END
    ELSE
    BEGIN
        PRINT '[OK] View dbo.' + @NomeView + ' encontrada.';
    END;

    FETCH NEXT FROM cursor_views INTO @NomeView;
END;

CLOSE cursor_views;
DEALLOCATE cursor_views;


/* =============================================================
   3. VALIDAÇÃO DAS STORED PROCEDURES
   ============================================================= */

DECLARE @ProceduresEsperadas TABLE
(
    NomeProcedure SYSNAME
);

INSERT INTO @ProceduresEsperadas (NomeProcedure)
VALUES
    ('sp_CarregarCalendario'),
    ('sp_CarregarProduto');

DECLARE @NomeProcedure SYSNAME;

DECLARE cursor_procedures CURSOR LOCAL FAST_FORWARD FOR
    SELECT NomeProcedure
    FROM @ProceduresEsperadas;

OPEN cursor_procedures;
FETCH NEXT FROM cursor_procedures INTO @NomeProcedure;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF OBJECT_ID('dbo.' + @NomeProcedure, 'P') IS NULL
    BEGIN
        PRINT '[FALHA] Procedure dbo.' + @NomeProcedure + ' nao encontrada.';
        SET @Falhas += 1;
    END
    ELSE
    BEGIN
        PRINT '[OK] Procedure dbo.' + @NomeProcedure + ' encontrada.';
    END;

    FETCH NEXT FROM cursor_procedures INTO @NomeProcedure;
END;

CLOSE cursor_procedures;
DEALLOCATE cursor_procedures;


/* =============================================================
   4. RESULTADO FINAL
   ============================================================= */

PRINT '===============================================================';

IF @Falhas = 0
BEGIN
    PRINT 'TODOS OS OBJETOS FORAM VALIDADOS COM SUCESSO.';
END
ELSE
BEGIN
    DECLARE @MensagemErro NVARCHAR(200);

    SET @MensagemErro =
        CONCAT('A validacao encontrou ', @Falhas, ' falha(s).');

    THROW 51000, @MensagemErro, 1;
END;
GO