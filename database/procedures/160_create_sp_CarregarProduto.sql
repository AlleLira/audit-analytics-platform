/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 160_create_sp_CarregarProduto.sql
Objetivo....: Criar procedure para inserir ou atualizar produtos
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 01/08/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CarregarProduto
    @CodigoProduto VARCHAR(30),
    @NomeProduto   VARCHAR(150),
    @CategoriaID   INT,
    @ValorVenda    DECIMAL(18,2),
    @Ativo         BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NULLIF(LTRIM(RTRIM(@CodigoProduto)), '') IS NULL
        THROW 50001, 'O código do produto é obrigatório.', 1;

    IF NULLIF(LTRIM(RTRIM(@NomeProduto)), '') IS NULL
        THROW 50002, 'O nome do produto é obrigatório.', 1;

    IF @ValorVenda < 0
        THROW 50003, 'O valor de venda não pode ser negativo.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.dCategoria
        WHERE CategoriaID = @CategoriaID
          AND Ativo = 1
    )
        THROW 50004, 'A categoria informada não existe ou está inativa.', 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS
        (
            SELECT 1
            FROM dbo.dProduto
            WHERE CodigoProduto = @CodigoProduto
        )
        BEGIN
            UPDATE dbo.dProduto
            SET
                NomeProduto = @NomeProduto,
                CategoriaID = @CategoriaID,
                ValorVenda = @ValorVenda,
                Ativo = @Ativo
            WHERE CodigoProduto = @CodigoProduto;

            COMMIT TRANSACTION;

            SELECT
                ProdutoID,
                CodigoProduto,
                NomeProduto,
                CategoriaID,
                ValorVenda,
                Ativo,
                'Atualizado' AS AcaoExecutada
            FROM dbo.dProduto
            WHERE CodigoProduto = @CodigoProduto;
        END
        ELSE
        BEGIN
            INSERT INTO dbo.dProduto
            (
                CodigoProduto,
                NomeProduto,
                CategoriaID,
                ValorVenda,
                Ativo
            )
            VALUES
            (
                @CodigoProduto,
                @NomeProduto,
                @CategoriaID,
                @ValorVenda,
                @Ativo
            );

            DECLARE @ProdutoID INT = SCOPE_IDENTITY();

            COMMIT TRANSACTION;

            SELECT
                ProdutoID,
                CodigoProduto,
                NomeProduto,
                CategoriaID,
                ValorVenda,
                Ativo,
                'Inserido' AS AcaoExecutada
            FROM dbo.dProduto
            WHERE ProdutoID = @ProdutoID;
        END;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

PRINT 'Procedure dbo.sp_CarregarProduto criada ou atualizada com sucesso.';
GO