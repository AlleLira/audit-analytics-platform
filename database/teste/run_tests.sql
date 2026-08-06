/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: run_tests.sql
Objetivo....: Executar todos os testes automatizados do banco de dados
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 06/08/2026

IMPORTANTE:
Este arquivo deve ser executado com o SQLCMD Mode ativado no SSMS.
===============================================================================
*/

:ON ERROR EXIT

PRINT '===============================================================';
PRINT 'INICIANDO OS TESTES DO AUDIT ANALYTICS DATA WAREHOUSE';
PRINT '===============================================================';
GO

PRINT '1. Validando os objetos do banco...';
:r .\001_validate_database_objects.sql
GO

PRINT '2. Validando a qualidade dos dados...';
:r .\002_validate_data_quality.sql
GO

PRINT '===============================================================';
PRINT 'TODOS OS TESTES FORAM EXECUTADOS COM SUCESSO';
PRINT '===============================================================';
GO