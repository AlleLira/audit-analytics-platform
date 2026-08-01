/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 007_evolucao_mensal.sql
Objetivo....: Evolução mensal das perdas com comparação ao mês anterior
Autor.......: Alessandra Lira
Versão......: 1.0
===============================================================================
*/

USE AuditAnalyticsDW;
GO

WITH Evolucao AS
(
    SELECT

        c.Ano,
        c.MesNumero,
        c.MesNome,
        c.AnoMes,

        COUNT_BIG(f.PerdaID) AS TotalOcorrencias,

        SUM(f.Quantidade) AS QuantidadePerdida,

        CAST
        (
            SUM(f.ValorPerda)
            AS DECIMAL(18,2)
        ) AS ValorTotalPerdido

    FROM dbo.fPerdas f

    INNER JOIN dbo.dCalendario c

        ON f.DataID = c.DataID

    GROUP BY

        c.Ano,
        c.MesNumero,
        c.MesNome,
        c.AnoMes
)

SELECT

    Ano,
    MesNumero,
    MesNome,
    AnoMes,

    TotalOcorrencias,
    QuantidadePerdida,
    ValorTotalPerdido,

    LAG(ValorTotalPerdido)
        OVER
        (
            ORDER BY Ano, MesNumero
        ) AS ValorMesAnterior,

    CAST
    (
        ValorTotalPerdido

        -

        LAG(ValorTotalPerdido)
        OVER
        (
            ORDER BY Ano, MesNumero
        )

        AS DECIMAL(18,2)
    ) AS VariacaoValor,

    CAST
    (
        (
            ValorTotalPerdido

            -

            LAG(ValorTotalPerdido)
            OVER
            (
                ORDER BY Ano, MesNumero
            )

        )

        /

        NULLIF
        (
            LAG(ValorTotalPerdido)
            OVER
            (
                ORDER BY Ano, MesNumero
            ),
            0
        )

        *100

        AS DECIMAL(10,2)
    ) AS VariacaoPercentual

FROM Evolucao

ORDER BY

    Ano,
    MesNumero;

GO