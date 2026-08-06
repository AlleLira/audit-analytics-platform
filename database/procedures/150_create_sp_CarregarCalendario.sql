/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 150_create_sp_CarregarCalendario.sql
Objetivo....: Criar procedure para carga incremental da dimensão dCalendario
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 01/08/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CarregarCalendario
    @DataInicial DATE,
    @DataFinal   DATE
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET DATEFIRST 1;
    SET LANGUAGE Portuguese;

    IF @DataInicial IS NULL OR @DataFinal IS NULL
    BEGIN
        THROW 50001,
              'As datas inicial e final são obrigatórias.',
              1;
    END;

    IF @DataInicial > @DataFinal
    BEGIN
        THROW 50002,
              'A data inicial não pode ser superior à data final.',
              1;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @DataAtual DATE = @DataInicial;
        DECLARE @RegistrosInseridos INT = 0;

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
                        WHEN DATEPART(WEEKDAY, @DataAtual) IN (6, 7)
                            THEN 1
                        ELSE 0
                    END
                );

                SET @RegistrosInseridos += 1;
            END;

            SET @DataAtual = DATEADD(DAY, 1, @DataAtual);
        END;

        COMMIT TRANSACTION;

        SELECT
            @RegistrosInseridos AS RegistrosInseridos,
            @DataInicial AS DataInicialProcessada,
            @DataFinal AS DataFinalProcessada,
            'Sucesso' AS StatusExecucao;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

PRINT 'Procedure dbo.sp_CarregarCalendario criada ou atualizada com sucesso.';
GO
