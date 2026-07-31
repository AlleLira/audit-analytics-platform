/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 010_seed_dCalendario.sql
Objetivo....: Popular a dimensão dCalendario com datas de 2020 a 2035
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SET NOCOUNT ON;
SET DATEFIRST 1;
SET LANGUAGE Portuguese;
GO

DECLARE @DataInicial DATE = '2020-01-01';
DECLARE @DataFinal   DATE = '2035-12-31';
DECLARE @DataAtual   DATE = @DataInicial;

WHILE @DataAtual <= @DataFinal
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.dCalendario
        WHERE DataCompleta = @DataAtual
    )
    BEGIN
        INSERT INTO dbo.dCalendario
        (
            DataID,
            DataCompleta,
            Dia,
            DiaSemanaNumero,
            DiaSemanaNome,
            SemanaAno,
            MesNumero,
            MesNome,
            MesAbreviado,
            AnoMes,
            Trimestre,
            Semestre,
            Ano,
            EhFimDeSemana
        )
        VALUES
        (
            CONVERT(INT, CONVERT(CHAR(8), @DataAtual, 112)),
            @DataAtual,
            DAY(@DataAtual),
            DATEPART(WEEKDAY, @DataAtual),
            DATENAME(WEEKDAY, @DataAtual),
            DATEPART(ISO_WEEK, @DataAtual),
            MONTH(@DataAtual),
            DATENAME(MONTH, @DataAtual),
            LEFT(DATENAME(MONTH, @DataAtual), 3),
            CONVERT(CHAR(7), @DataAtual, 126),
            DATEPART(QUARTER, @DataAtual),
            CASE
                WHEN MONTH(@DataAtual) <= 6 THEN 1
                ELSE 2
            END,
            YEAR(@DataAtual),
            CASE
                WHEN DATEPART(WEEKDAY, @DataAtual) IN (6, 7) THEN 1
                ELSE 0
            END
        );
    END;

    SET @DataAtual = DATEADD(DAY, 1, @DataAtual);
END;
GO

PRINT 'Carga da dimensão dCalendario concluída com sucesso.';
GO