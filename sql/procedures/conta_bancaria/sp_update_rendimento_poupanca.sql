CREATE PROCEDURE sp_update_rendimento_poupanca
    @codigo_conta VARCHAR(20),
    @novo_percentual DECIMAL(5,2)
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM conta_poupanca
        WHERE codigo_conta = @codigo_conta
    )
    BEGIN
        RAISERROR('Conta poupança não encontrada.',16,1)
        RETURN
    END

    IF @novo_percentual < 0
    BEGIN
        RAISERROR('O percentual de rendimento não pode ser negativo.',16,1)
        RETURN
    END

    UPDATE conta_poupanca
    SET percentual_rendimento = @novo_percentual
    WHERE codigo_conta = @codigo_conta
END
GO