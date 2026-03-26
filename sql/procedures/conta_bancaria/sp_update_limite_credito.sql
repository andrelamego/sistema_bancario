CREATE PROCEDURE sp_update_limite_credito
    @codigo_conta VARCHAR(20),
    @novo_limite DECIMAL(10,2)
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM conta_corrente
        WHERE codigo_conta = @codigo_conta
    )
    BEGIN
        RAISERROR('Conta corrente não encontrada.',16,1)
        RETURN
    END

    IF @novo_limite < 0
    BEGIN
        RAISERROR('O limite de crédito não pode ser negativo.',16,1)
        RETURN
    END

    UPDATE conta_corrente
    SET limite_credito = @novo_limite
    WHERE codigo_conta = @codigo_conta
END
GO