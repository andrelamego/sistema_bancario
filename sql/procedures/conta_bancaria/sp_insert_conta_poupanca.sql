CREATE PROCEDURE sp_insert_conta_poupanca
    @cpf_cliente CHAR(11),
    @id_agencia BIGINT
AS
BEGIN
    DECLARE @codigo_agencia VARCHAR(6)
    DECLARE @ultimos_cpf VARCHAR(3)
    DECLARE @codigo_parcial VARCHAR(20)
    DECLARE @codigo_conta VARCHAR(20)
    DECLARE @soma INT = 0
    DECLARE @i INT = 1
    DECLARE @digito INT

    IF NOT EXISTS (
        SELECT 1 FROM cliente
        WHERE cpf = @cpf_cliente
    )
    BEGIN
        RAISERROR('Cliente não encontrado.',16,1)
        RETURN
    END

    IF NOT EXISTS (
        SELECT 1 FROM agencia
        WHERE id_agencia = @id_agencia
    )
    BEGIN
        RAISERROR('Agência não encontrada.',16,1)
        RETURN
    END

    SELECT @codigo_agencia = codigo
    FROM agencia
    WHERE id_agencia = @id_agencia

    SET @ultimos_cpf = RIGHT(@cpf_cliente,3)

    SET @codigo_parcial = @codigo_agencia + @ultimos_cpf

    WHILE @i <= LEN(@codigo_parcial)
    BEGIN
        SET @soma = @soma + CAST(SUBSTRING(@codigo_parcial,@i,1) AS INT)
        SET @i = @i + 1
    END

    SET @digito = @soma % 5

    SET @codigo_conta = @codigo_parcial + CAST(@digito AS VARCHAR)

    INSERT INTO conta_bancaria
    VALUES(
        @codigo_conta,
        GETDATE(),
        0,
        @id_agencia
    )

    INSERT INTO conta_poupanca
    VALUES(
        @codigo_conta,
        1,
        10
    )

    INSERT INTO titularidade
    VALUES(
        @codigo_conta,
        @cpf_cliente,
        1
    )

    UPDATE cliente
    SET data_primeira_conta = GETDATE()
    WHERE cpf = @cpf_cliente
    AND data_primeira_conta IS NULL

    SELECT @codigo_conta AS codigo_conta

END
GO