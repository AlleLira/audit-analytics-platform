/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 090_create_indexes.sql
Objetivo....: Criar índices adicionais para otimizar consultas analíticas
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

SET NOCOUNT ON;
GO

/*=============================================================================
  dCalendario
=============================================================================*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_dCalendario_AnoMes'
      AND object_id = OBJECT_ID('dbo.dCalendario')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_dCalendario_AnoMes
        ON dbo.dCalendario
        (
            Ano,
            MesNumero
        )
        INCLUDE
        (
            DataCompleta,
            MesNome,
            Trimestre,
            Semestre
        );

    PRINT 'Índice IX_dCalendario_AnoMes criado.';
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_dCalendario_AnoTrimestre'
      AND object_id = OBJECT_ID('dbo.dCalendario')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_dCalendario_AnoTrimestre
        ON dbo.dCalendario
        (
            Ano,
            Trimestre
        )
        INCLUDE
        (
            DataCompleta,
            MesNumero,
            MesNome
        );

    PRINT 'Índice IX_dCalendario_AnoTrimestre criado.';
END;
GO

/*=============================================================================
  dLoja
=============================================================================*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_dLoja_EstadoID'
      AND object_id = OBJECT_ID('dbo.dLoja')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_dLoja_EstadoID
        ON dbo.dLoja (EstadoID)
        INCLUDE
        (
            CodigoLoja,
            NomeLoja,
            Cidade,
            StatusLoja
        );

    PRINT 'Índice IX_dLoja_EstadoID criado.';
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_dLoja_GerenteID'
      AND object_id = OBJECT_ID('dbo.dLoja')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_dLoja_GerenteID
        ON dbo.dLoja (GerenteID)
        INCLUDE
        (
            CodigoLoja,
            NomeLoja,
            EstadoID,
            SupervisorID
        );

    PRINT 'Índice IX_dLoja_GerenteID criado.';
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_dLoja_SupervisorID'
      AND object_id = OBJECT_ID('dbo.dLoja')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_dLoja_SupervisorID
        ON dbo.dLoja (SupervisorID)
        INCLUDE
        (
            CodigoLoja,
            NomeLoja,
            EstadoID,
            GerenteID
        );

    PRINT 'Índice IX_dLoja_SupervisorID criado.';
END;
GO

/*=============================================================================
  dProduto
=============================================================================*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_dProduto_CategoriaID'
      AND object_id = OBJECT_ID('dbo.dProduto')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_dProduto_CategoriaID
        ON dbo.dProduto (CategoriaID)
        INCLUDE
        (
            CodigoProduto,
            NomeProduto,
            ValorVenda,
            Ativo
        );

    PRINT 'Índice IX_dProduto_CategoriaID criado.';
END;
GO

/*=============================================================================
  fPerdas — índices simples
=============================================================================*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fPerdas_DataID'
      AND object_id = OBJECT_ID('dbo.fPerdas')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_fPerdas_DataID
        ON dbo.fPerdas (DataID)
        INCLUDE
        (
            LojaID,
            ProdutoID,
            Quantidade,
            ValorPerda,
            TipoPerda
        );

    PRINT 'Índice IX_fPerdas_DataID criado.';
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fPerdas_LojaID'
      AND object_id = OBJECT_ID('dbo.fPerdas')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_fPerdas_LojaID
        ON dbo.fPerdas (LojaID)
        INCLUDE
        (
            DataID,
            ProdutoID,
            Quantidade,
            ValorPerda,
            TipoPerda
        );

    PRINT 'Índice IX_fPerdas_LojaID criado.';
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fPerdas_ProdutoID'
      AND object_id = OBJECT_ID('dbo.fPerdas')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_fPerdas_ProdutoID
        ON dbo.fPerdas (ProdutoID)
        INCLUDE
        (
            DataID,
            LojaID,
            CategoriaID,
            Quantidade,
            ValorPerda
        );

    PRINT 'Índice IX_fPerdas_ProdutoID criado.';
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fPerdas_CategoriaID'
      AND object_id = OBJECT_ID('dbo.fPerdas')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_fPerdas_CategoriaID
        ON dbo.fPerdas (CategoriaID)
        INCLUDE
        (
            DataID,
            ProdutoID,
            Quantidade,
            ValorPerda,
            TipoPerda
        );

    PRINT 'Índice IX_fPerdas_CategoriaID criado.';
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fPerdas_SupervisorID'
      AND object_id = OBJECT_ID('dbo.fPerdas')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_fPerdas_SupervisorID
        ON dbo.fPerdas (SupervisorID)
        INCLUDE
        (
            DataID,
            LojaID,
            GerenteID,
            Quantidade,
            ValorPerda
        );

    PRINT 'Índice IX_fPerdas_SupervisorID criado.';
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fPerdas_GerenteID'
      AND object_id = OBJECT_ID('dbo.fPerdas')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_fPerdas_GerenteID
        ON dbo.fPerdas (GerenteID)
        INCLUDE
        (
            DataID,
            LojaID,
            SupervisorID,
            Quantidade,
            ValorPerda
        );

    PRINT 'Índice IX_fPerdas_GerenteID criado.';
END;
GO

/*=============================================================================
  fPerdas — índices compostos
=============================================================================*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fPerdas_LojaID_DataID'
      AND object_id = OBJECT_ID('dbo.fPerdas')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_fPerdas_LojaID_DataID
        ON dbo.fPerdas
        (
            LojaID,
            DataID
        )
        INCLUDE
        (
            ProdutoID,
            CategoriaID,
            SupervisorID,
            GerenteID,
            Quantidade,
            ValorPerda,
            TipoPerda
        );

    PRINT 'Índice IX_fPerdas_LojaID_DataID criado.';
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fPerdas_ProdutoID_DataID'
      AND object_id = OBJECT_ID('dbo.fPerdas')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_fPerdas_ProdutoID_DataID
        ON dbo.fPerdas
        (
            ProdutoID,
            DataID
        )
        INCLUDE
        (
            LojaID,
            CategoriaID,
            Quantidade,
            ValorPerda,
            TipoPerda
        );

    PRINT 'Índice IX_fPerdas_ProdutoID_DataID criado.';
END;
GO

PRINT 'Criação dos índices concluída com sucesso.';
GO