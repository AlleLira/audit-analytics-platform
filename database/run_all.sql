/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: run_all.sql
Objetivo....: Criar todos os objetos do Data Warehouse na ordem correta
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 06/08/2026

IMPORTANTE:
Este arquivo deve ser executado com o SQLCMD Mode ativado no SSMS.
===============================================================================
*/

:ON ERROR EXIT

PRINT '===============================================================';
PRINT 'INICIANDO A INSTALAÇÃO DO AUDIT ANALYTICS DATA WAREHOUSE';
PRINT '===============================================================';
GO


/* =============================================================
   1. CRIAÇÃO DO BANCO DE DADOS
   ============================================================= */

PRINT '1. Criando banco de dados...';
:r .\database\001_create_database.sql
GO


/* =============================================================
   2. TABELAS DE DIMENSÃO
   ============================================================= */

PRINT '2. Criando tabelas de dimensão...';

:r .\tables\010_create_dCalendario.sql
:r .\tables\020_create_dEstado.sql
:r .\tables\030_create_dSupervisor.sql
:r .\tables\040_create_dGerente.sql
:r .\tables\050_create_dCategoria.sql
:r .\tables\060_create_dLoja.sql
:r .\tables\070_create_dProduto.sql
GO


/* =============================================================
   3. TABELA FATO
   ============================================================= */

PRINT '3. Criando tabela fato...';

:r .\tables\080_create_fPerdas.sql
GO


/* =============================================================
   4. ÍNDICES
   ============================================================= */

PRINT '4. Criando índices...';

:r .\indexes\090_create_indexs.sql
GO


/* =============================================================
   5. VIEWS
   ============================================================= */

PRINT '5. Criando views...';

:r .\views\100_create_vw_PerdasDetalhadas.sql
:r .\views\110_create_vw_PerdasPorLoja.sql
:r .\views\120_create_vw_PerdasPorProduto.sql
:r .\views\130_create_vw_PerdasMensais.sql
:r .\views\140_create_vw_PerdasPorResponsavel.sql
GO


/* =============================================================
   6. STORED PROCEDURES
   ============================================================= */

PRINT '6. Criando stored procedures...';

:r .\procedures\150_create_sp_CarregarCalendario.sql
:r .\procedures\160_create_sp_CarregarProduto.sql
GO


/* =============================================================
   7. DADOS DE DEMONSTRAÇÃO
   ============================================================= */

PRINT '7. Carregando dados de demonstração...';

:r .\seed\010_seed_dCalendario.sql
:r .\seed\020_seed_dEstado.sql
:r .\seed\030_seed_dSupervisor.sql
:r .\seed\040_seed_dGerente.sql
:r .\seed\050_seed_dCategoria.sql
:r .\seed\060_seed_dLoja.sql
:r .\seed\070_seed_dProduto.sql
:r .\seed\080_seed_fPerdas.sql
GO


/* =============================================================
   8. FINALIZAÇÃO
   ============================================================= */

USE AuditAnalyticsDW;
GO

PRINT '===============================================================';
PRINT 'AUDIT ANALYTICS DATA WAREHOUSE INSTALADO COM SUCESSO';
PRINT '===============================================================';
GO