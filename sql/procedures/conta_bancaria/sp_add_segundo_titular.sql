CREATE PROCEDURE sp_add_segundo_titular
    @codigo_conta VARCHAR(20),
    @cpf_titular_atual CHAR(11),
    @senha_titular_atual CHAR(8),
    @cpf_novo_titular CHAR(11)
AS
BEGIN
    DECLARE @quantidade_titulares INT
    DECLARE @saldo DECIMAL(10,2)
    DECLARE @data_abertura DATE
    DECLARE @hoje DATE

    SET @hoje = CAST(GETDATE() AS DATE)

    IF NOT EXISTS (
        SELECT 1
        FROM conta_bancaria
        WHERE codigo_conta = @codigo_conta
    )
    BEGIN
        RAISERROR('Conta não encontrada.',16,1)
        RETURN
    END

    IF NOT EXISTS (
        SELECT 1
        FROM cliente
        WHERE cpf = @cpf_titular_atual
    )
    BEGIN
        RAISERROR('Titular atual não encontrado.',16,1)
        RETURN
    END

    IF NOT EXISTS (
        SELECT 1
        FROM cliente
        WHERE cpf = @cpf_titular_atual
          AND senha = @senha_titular_atual
    )
    BEGIN
        RAISERROR('Login ou senha do titular atual inválidos.',16,1)
        RETURN
    END

    IF NOT EXISTS (
        SELECT 1
        FROM titularidade
        WHERE codigo_conta = @codigo_conta
          AND cpf_cliente = @cpf_titular_atual
    )
    BEGIN
        RAISERROR('O titular informado não pertence a esta conta.',16,1)
        RETURN
    END

    IF NOT EXISTS (
        SELECT 1
        FROM cliente
        WHERE cpf = @cpf_novo_titular
    )
    BEGIN
        RAISERROR('Novo titular não encontrado.',16,1)
        RETURN
    END

    IF EXISTS (
        SELECT 1
        FROM titularidade
        WHERE codigo_conta = @codigo_conta
          AND cpf_cliente = @cpf_novo_titular
    )
    BEGIN
        RAISERROR('Esse cliente já é titular da conta.',16,1)
        RETURN
    END

    SELECT @quantidade_titulares = COUNT(*)
    FROM titularidade
    WHERE codigo_conta = @codigo_conta

    IF @quantidade_titulares = 0
    BEGIN
        RAISERROR('A conta não possui titular cadastrado.',16,1)
        RETURN
    END

    IF @quantidade_titulares >= 2
    BEGIN
        RAISERROR('A conta já possui dois titulares.',16,1)
        RETURN
    END

    SELECT
        @saldo = saldo,
        @data_abertura = data_abertura
    FROM conta_bancaria
    WHERE codigo_conta = @codigo_conta

    IF @saldo <= 0 AND @data_abertura <> @hoje
    BEGIN
        RAISERROR('Não é permitido incluir segundo titular em conta com saldo menor ou igual a zero, salvo conta criada no mesmo dia.',16,1)
        RETURN
    END

    INSERT INTO titularidade (
        codigo_conta,
        cpf_cliente,
        ordem_titular
    )
    VALUES (
        @codigo_conta,
        @cpf_novo_titular,
        2
    )
END
GO