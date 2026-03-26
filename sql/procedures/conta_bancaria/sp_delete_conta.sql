CREATE PROCEDURE sp_delete_conta
    @codigo_conta VARCHAR(20)
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM conta_bancaria
        WHERE codigo_conta = @codigo_conta
    )
    BEGIN
        RAISERROR('Conta não encontrada.',16,1)
        RETURN
    END

    DELETE FROM titularidade
    WHERE codigo_conta = @codigo_conta

    DELETE FROM conta_corrente
    WHERE codigo_conta = @codigo_conta

    DELETE FROM conta_poupanca
    WHERE codigo_conta = @codigo_conta

    DELETE FROM conta_bancaria
    WHERE codigo_conta = @codigo_conta

END
GO