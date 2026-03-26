CREATE PROCEDURE sp_select_contas_cliente
    @cpf_cliente CHAR(11)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        cb.codigo_conta,
        cb.data_abertura,
        cb.saldo,
        a.codigo AS codigo_agencia,
        CASE 
            WHEN cc.codigo_conta IS NOT NULL THEN 'CORRENTE'
            WHEN cp.codigo_conta IS NOT NULL THEN 'POUPANCA'
        END AS tipo_conta,
        cc.limite_credito,
        cp.percentual_rendimento,
        cp.dia_aniversario,
        t.ordem_titular
    FROM titularidade t
    INNER JOIN conta_bancaria cb
        ON t.codigo_conta = cb.codigo_conta
    INNER JOIN agencia a
        ON cb.id_agencia = a.id_agencia
    LEFT JOIN conta_corrente cc
        ON cb.codigo_conta = cc.codigo_conta
    LEFT JOIN conta_poupanca cp
        ON cb.codigo_conta = cp.codigo_conta
    WHERE t.cpf_cliente = @cpf_cliente
    ORDER BY cb.data_abertura
END
GO