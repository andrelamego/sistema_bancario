CREATE PROCEDURE sp_update_saldo_conta
    @codigo_conta VARCHAR(20),
    @novo_saldo DECIMAL(10,2)
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM conta_bancaria
        WHERE codigo_conta = @codigo_conta
    )
    BEGIN
        RAISERROR('Conta não encontrada.',16,1)
        RETURN;
    END

    IF @novo_saldo < 0
    BEGIN
        RAISERROR('O saldo não pode ser negativo.',16,1)
        RETURN;
    END

    UPDATE conta_bancaria
    SET saldo = @novo_saldo
    WHERE codigo_conta = @codigo_conta
END
GO