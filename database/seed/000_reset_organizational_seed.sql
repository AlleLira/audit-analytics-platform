/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 000_reset_organizational_seed.sql
Objetivo....: Remover a carga fictícia inicial de lojas, gerentes e supervisores
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    -- dLoja depende de dGerente e dSupervisor.
    DELETE FROM dbo.dLoja;

    DELETE FROM dbo.dGerente;

    DELETE FROM dbo.dSupervisor;

    DBCC CHECKIDENT ('dbo.dLoja', RESEED, 0);
    DBCC CHECKIDENT ('dbo.dGerente', RESEED, 0);
    DBCC CHECKIDENT ('dbo.dSupervisor', RESEED, 0);

    COMMIT TRANSACTION;

    PRINT 'Carga organizacional anterior removida com sucesso.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO