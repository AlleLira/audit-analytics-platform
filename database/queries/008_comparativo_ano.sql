/*
===============================================================================
Projeto.....: Audit Analytics Platform
Arquivo.....: 008_comparativo_ano.sql
Objetivo....: Comparativo anual das perdas
Autor.......: Alessandra Lira
Versão......: 1.0
===============================================================================
*/

USE AuditAnalyticsDW;
GO

WITH ComparativoAnual AS
(
    SELECT

        c.Ano,

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

        c.Ano
)

SELECT

    Ano,

    TotalOcorrencias,

    QuantidadePerdida,

    ValorTotalPerdido,

    LAG(ValorTotalPerdido)
        OVER
        (
            ORDER BY Ano
        ) AS ValorAnoAnterior,

    CAST
    (
        ValorTotalPerdido

        -

        LAG(ValorTotalPerdido)
        OVER
        (
            ORDER BY Ano
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
                ORDER BY Ano
            )

        )

        /

        NULLIF
        (
            LAG(ValorTotalPerdido)
            OVER
            (
                ORDER BY Ano
            ),
            0
        )

        *100

        AS DECIMAL(10,2)
    ) AS VariacaoPercentual

FROM ComparativoAnual

ORDER BY

    Ano;

GO