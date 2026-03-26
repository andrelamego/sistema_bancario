CREATE PROCEDURE sp_update_dia_aniversario_poupanca
    @codigo_conta VARCHAR(20),
    @novo_dia INT
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

    -- valida dia
    IF @novo_dia < 1 OR @novo_dia > 31
    BEGIN
        RAISERROR('Dia de aniversário inválido. Deve estar entre 1 e 31.',16,1)
        RETURN
    END

    UPDATE conta_poupanca
    SET dia_aniversario = @novo_dia
    WHERE codigo_conta = @codigo_conta
END
GO