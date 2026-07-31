# Database

Esta pasta contém os scripts SQL utilizados na implementação do banco de dados da Audit Analytics Platform.

## Banco de dados

- **Nome:** AuditAnalyticsDW
- **SGBD:** Microsoft SQL Server
- **Linguagem:** T-SQL
- **Modelo:** Data Warehouse dimensional
- **Arquitetura:** Star Schema

## Estrutura

- `01_database`: criação e configuração inicial do banco.
- `02_tables`: criação das dimensões e da tabela fato.
- `03_constraints`: restrições adicionais de integridade.
- `04_indexes`: índices para otimização das consultas.
- `05_views`: views analíticas.
- `06_procedures`: stored procedures.
- `07_seed`: carga de dados fictícios para demonstração.
- `08_tests`: consultas e testes de validação.

## Ordem de execução

1. Scripts de `01_database`
2. Scripts de `02_tables`
3. Scripts de `03_constraints`
4. Scripts de `04_indexes`
5. Scripts de `05_views`
6. Scripts de `06_procedures`
7. Scripts de `07_seed`
8. Scripts de `08_tests`

> A Nexus Retail e os dados utilizados neste projeto são fictícios e foram criados exclusivamente para fins educacionais e de portfólio.
