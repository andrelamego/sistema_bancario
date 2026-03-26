CREATE PROCEDURE sp_select_conta
    @codigo_conta VARCHAR(20)
AS
BEGIN
    SELECT
        cb.codigo_conta,
        cb.data_abertura,
        cb.saldo,
        a.codigo AS codigo_agencia,
        a.cidade,
        cc.limite_credito,
        cp.percentual_rendimento,
        cp.dia_aniversario
    FROM conta_bancaria cb
    INNER JOIN agencia a
        ON cb.id_agencia = a.id_agencia
    LEFT JOIN conta_corrente cc
        ON cb.codigo_conta = cc.codigo_conta
    LEFT JOIN conta_poupanca cp
        ON cb.codigo_conta = cp.codigo_conta
    WHERE cb.codigo_conta = @codigo_conta;

END
GO