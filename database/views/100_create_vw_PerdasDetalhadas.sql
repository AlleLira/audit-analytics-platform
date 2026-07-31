/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 100_create_vw_PerdasDetalhadas.sql
Objetivo....: Criar uma visão detalhada das ocorrências de perdas
Autor.......: Alessandra Lira
Versão......: 1.0
Data........: 31/07/2026
===============================================================================
*/

USE AuditAnalyticsDW;
GO

CREATE OR ALTER VIEW dbo.vw_PerdasDetalhadas
AS
SELECT
    f.PerdaID,

    c.DataID,
    c.DataCompleta,
    c.Dia,
    c.DiaSemanaNumero,
    c.DiaSemanaNome,
    c.SemanaAno,
    c.MesNumero,
    c.MesNome,
    c.MesAbreviado,
    c.AnoMes,
    c.Trimestre,
    c.Semestre,
    c.Ano,
    c.EhFimDeSemana,

    l.LojaID,
    l.CodigoLoja,
    l.NomeLoja,
    l.Cidade,
    l.DataAbertura,
    l.StatusLoja,

    e.EstadoID,
    e.UF,
    e.Estado,
    e.Regiao,

    g.GerenteID,
    g.NomeGerente,
    g.StatusGerente,

    s.SupervisorID,
    s.NomeSupervisor,
    s.StatusSupervisor,

    p.ProdutoID,
    p.CodigoProduto,
    p.NomeProduto,
    p.ValorVenda,
    p.Ativo AS ProdutoAtivo,

    cat.CategoriaID,
    cat.NomeCategoria,
    cat.Ativo AS CategoriaAtiva,

    f.Quantidade,
    f.ValorPerda,
    f.TipoPerda
FROM dbo.fPerdas AS f
INNER JOIN dbo.dCalendario AS c
    ON f.DataID = c.DataID
INNER JOIN dbo.dLoja AS l
    ON f.LojaID = l.LojaID
INNER JOIN dbo.dEstado AS e
    ON l.EstadoID = e.EstadoID
INNER JOIN dbo.dGerente AS g
    ON f.GerenteID = g.GerenteID
INNER JOIN dbo.dSupervisor AS s
    ON f.SupervisorID = s.SupervisorID
INNER JOIN dbo.dProduto AS p
    ON f.ProdutoID = p.ProdutoID
INNER JOIN dbo.dCategoria AS cat
    ON f.CategoriaID = cat.CategoriaID;
GO

PRINT 'View dbo.vw_PerdasDetalhadas criada ou atualizada com sucesso.';
GO