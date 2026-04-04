CREATE PROCEDURE sp_add_segundo_titular
    @codigo_conta VARCHAR(20),
    @cpf_titular_atual CHAR(11),
    @senha_titular_atual CHAR(8),
    @cpf_novo_titular CHAR(11)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @quantidade_titulares INT
    DECLARE @saldo DECIMAL(12,2)
    DECLARE @data_abertura DATE
    DECLARE @hoje DATE
    DECLARE @id_agencia BIGINT
    DECLARE @codigo_agencia VARCHAR(6)
    DECLARE @cpf_titular_1 CHAR(11)
    DECLARE @cpf_titular_2 CHAR(11)
    DECLARE @codigo_parcial VARCHAR(20)
    DECLARE @novo_codigo_conta VARCHAR(20)
    DECLARE @soma INT
    DECLARE @i INT
    DECLARE @digito INT

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

    BEGIN TRY
        BEGIN TRANSACTION

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

        SELECT
            @id_agencia = cb.id_agencia,
            @codigo_agencia = a.codigo
        FROM conta_bancaria cb
        INNER JOIN agencia a
            ON cb.id_agencia = a.id_agencia
        WHERE cb.codigo_conta = @codigo_conta

        SELECT @cpf_titular_1 = cpf_cliente
        FROM titularidade
        WHERE codigo_conta = @codigo_conta
          AND ordem_titular = 1

        SELECT @cpf_titular_2 = cpf_cliente
        FROM titularidade
        WHERE codigo_conta = @codigo_conta
          AND ordem_titular = 2

        SET @codigo_parcial = @codigo_agencia + RIGHT(@cpf_titular_1, 3) + RIGHT(@cpf_titular_2, 3)
        SET @soma = 0
        SET @i = 1

        WHILE @i <= LEN(@codigo_parcial)
        BEGIN
            SET @soma = @soma + CAST(SUBSTRING(@codigo_parcial, @i, 1) AS INT)
            SET @i = @i + 1
        END

        SET @digito = @soma % 5
        SET @novo_codigo_conta = @codigo_parcial + CAST(@digito AS VARCHAR)

        IF EXISTS (
            SELECT 1
            FROM conta_bancaria
            WHERE codigo_conta = @novo_codigo_conta
              AND codigo_conta <> @codigo_conta
        )
        BEGIN
            RAISERROR('Codigo de conta gerado para conta conjunta ja existe.',16,1)
        END

        IF @novo_codigo_conta <> @codigo_conta
        BEGIN
            INSERT INTO conta_bancaria (codigo_conta, data_abertura, saldo, id_agencia)
            SELECT @novo_codigo_conta, data_abertura, saldo, id_agencia
            FROM conta_bancaria
            WHERE codigo_conta = @codigo_conta

            IF EXISTS (SELECT 1 FROM conta_corrente WHERE codigo_conta = @codigo_conta)
            BEGIN
                INSERT INTO conta_corrente (codigo_conta, limite_credito)
                SELECT @novo_codigo_conta, limite_credito
                FROM conta_corrente
                WHERE codigo_conta = @codigo_conta
            END

            IF EXISTS (SELECT 1 FROM conta_poupanca WHERE codigo_conta = @codigo_conta)
            BEGIN
                INSERT INTO conta_poupanca (codigo_conta, percentual_rendimento, dia_aniversario)
                SELECT @novo_codigo_conta, percentual_rendimento, dia_aniversario
                FROM conta_poupanca
                WHERE codigo_conta = @codigo_conta
            END

            UPDATE titularidade
            SET codigo_conta = @novo_codigo_conta
            WHERE codigo_conta = @codigo_conta

            DELETE FROM conta_corrente
            WHERE codigo_conta = @codigo_conta

            DELETE FROM conta_poupanca
            WHERE codigo_conta = @codigo_conta

            DELETE FROM conta_bancaria
            WHERE codigo_conta = @codigo_conta
        END

        COMMIT TRANSACTION

        SELECT @novo_codigo_conta AS codigo_conta
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        THROW
    END CATCH
END
GO
