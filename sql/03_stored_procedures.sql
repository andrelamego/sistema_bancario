USE bd_sistema_bancario
GO

/* ===========================
   instituicao_bancaria
   =========================== */

CREATE PROCEDURE sp_delete_instituicao_bancaria
	@id_instituicao BIGINT
AS
BEGIN
	IF @id_instituicao IS NULL OR @id_instituicao <= 0
	BEGIN
		RAISERROR('ID da instituição inválido.', 16, 1)
		RETURN
	END

	IF NOT EXISTS(
		SELECT 1
		FROM instituicao_bancaria
		WHERE id_instituicao = @id_instituicao
	)
	BEGIN
		RAISERROR('Instituição bancária não encontrada.', 16, 1)
		RETURN
	END

	IF EXISTS (
		SELECT 1
		FROM agencia
		WHERE id_instituicao = @id_instituicao
	)
	BEGIN
        RAISERROR('Não é possível excluir a instituição. Existem agências vinculadas.',16,1);
        RETURN;
    END

	DELETE FROM instituicao_bancaria
	WHERE id_instituicao = @id_instituicao
END
GO

CREATE PROCEDURE sp_insert_instituicao_bancaria
	@id_instituicao	BIGINT,
	@nome			VARCHAR(100)
AS
BEGIN
	IF @id_instituicao IS NULL OR @id_instituicao <= 0
	BEGIN
		RAISERROR('ID da instituição inválido.', 16, 1)
		RETURN
	END

	IF @nome IS NULL OR LTRIM(RTRIM(@nome)) = ''
	BEGIN
		RAISERROR('O nome da instituição é obrigatório.', 16, 1)
		RETURN
	END

	IF EXISTS(
		SELECT 1
		FROM instituicao_bancaria
		WHERE id_instituicao = @id_instituicao
	)
	BEGIN
		RAISERROR('Já existe uma instituição bancária com esse ID.', 16, 1)
		RETURN
	END

	IF EXISTS(
		SELECT 1
		FROM instituicao_bancaria
		WHERE nome = @nome
	)
	BEGIN
		RAISERROR('Já existe uma instituição bancária com esse nome.', 16, 1)
		RETURN
	END

	INSERT INTO instituicao_bancaria (id_instituicao, nome)
	VALUES (@id_instituicao, @nome)
END
GO

CREATE PROCEDURE sp_select_instituicao_bancaria
	@id_instituicao BIGINT
AS
BEGIN
	SELECT
		id_instituicao,
		nome
	FROM instituicao_bancaria
	WHERE id_instituicao = @id_instituicao
END
GO

CREATE PROCEDURE sp_select_instituicoes_bancarias
AS
BEGIN
	SELECT
		id_instituicao,
		nome
	FROM instituicao_bancaria
	ORDER BY id_instituicao
END
GO

CREATE PROCEDURE sp_update_instituicao_bancaria
	@id_instituicao BIGINT,
	@nome			VARCHAR(100)
AS
BEGIN
	IF @id_instituicao IS NULL OR @id_instituicao <= 0
	BEGIN
		RAISERROR('ID da instituição inválido.', 16, 1)
		RETURN
	END

	IF NOT EXISTS(
		SELECT 1
		FROM instituicao_bancaria
		WHERE id_instituicao = @id_instituicao
	)
	BEGIN
		RAISERROR('Instituição bancária não encontrada.', 16, 1)
		RETURN
	END

	IF @nome IS NULL OR LTRIM(RTRIM(@nome)) = ''
	BEGIN
		RAISERROR('O nome da instituição é obrigatório.', 16, 1)
		RETURN
	END

	IF NOT EXISTS (
		SELECT 1
		FROM instituicao_bancaria
		WHERE id_instituicao = @id_instituicao
	)
	BEGIN
		RAISERROR('Instituição bancária não existe.', 16, 1)
		RETURN
	END

	IF EXISTS(
		SELECT 1
		FROM instituicao_bancaria
		WHERE nome = @nome
	)
	BEGIN
		RAISERROR('Já existe uma instituição bancária com esse nome.', 16, 1)
		RETURN
	END

	UPDATE instituicao_bancaria
	SET nome = @nome
	WHERE id_instituicao = @id_instituicao;
END
GO

/* ===========================
   agencia
   =========================== */

CREATE PROCEDURE sp_delete_agencia
	@id_agencia BIGINT
AS
BEGIN
	IF NOT EXISTS (
        SELECT 1
        FROM agencia
        WHERE id_agencia = @id_agencia
    )
    BEGIN
        RAISERROR('Agência não encontrada.',16,1);
        RETURN;
    END

	IF EXISTS (
        SELECT 1
        FROM conta_bancaria
        WHERE id_agencia = @id_agencia
    )
    BEGIN
        RAISERROR('Não é possível excluir a agência. Existem contas vinculadas.',16,1);
        RETURN;
    END

	DELETE FROM agencia
    WHERE id_agencia = @id_agencia;
END
GO

CREATE PROCEDURE sp_insert_agencia
	@id_agencia			BIGINT,
	@codigo				VARCHAR(6),
	@cep				VARCHAR(8),
	@cidade				VARCHAR(100),
	@id_instituicao		BIGINT
AS
BEGIN
	IF @id_agencia IS NULL OR @id_agencia <= 0
	BEGIN
		RAISERROR('ID da agência inválido.', 16, 1)
		RETURN
	END

	IF @codigo IS NULL OR LTRIM(RTRIM(@codigo)) = ''
	BEGIN
		RAISERROR('Código da agência inválido.', 16, 1)
		RETURN
	END

	IF @cep IS NULL OR LEN(@cep) <> 8
	BEGIN
		RAISERROR('CEP inválido.', 16, 1)
		RETURN
	END

	IF @cidade IS NULL OR LTRIM(RTRIM(@cidade)) = ''
	BEGIN
		RAISERROR('A cidade é obrigatória.', 16, 1)
		RETURN
	END

	IF NOT EXISTS (
		SELECT 1
		FROM instituicao_bancaria
		WHERE id_instituicao = @id_instituicao
	)
	BEGIN
		RAISERROR('Instituição bancária não encontrada.', 16, 1)
		RETURN
	END

	IF EXISTS (
		SELECT 1
		FROM agencia
		WHERE id_agencia = @id_agencia
	)
	BEGIN
		RAISERROR('Já existe uma agência com esse ID.', 16, 1)
		RETURN
	END

	IF EXISTS (
		SELECT 1
		FROM agencia
		WHERE codigo = @codigo
	)
	BEGIN
		RAISERROR('Já existe uma agência com esse código.', 16, 1)
		RETURN
	END

	INSERT INTO agencia (id_agencia, codigo, cep, cidade, id_instituicao)
	VALUES (@id_agencia, @codigo, @cep, @cidade, @id_instituicao)
END
GO

CREATE PROCEDURE sp_select_agencia
	@id_agencia BIGINT
AS
BEGIN
	SELECT
		id_agencia,
		codigo,
		cep,
		cidade
	FROM agencia
	WHERE id_agencia = @id_agencia
END
GO

CREATE PROCEDURE sp_select_agencias
AS
BEGIN
	SELECT
		id_agencia,
		codigo,
		cep,
		cidade
	FROM agencia
	ORDER BY id_agencia
END
GO

CREATE PROCEDURE sp_update_agencia
	@id_agencia		BIGINT,
	@codigo			VARCHAR(6),
	@cep			VARCHAR(8),
	@cidade			VARCHAR(100),
	@id_instituicao	BIGINT
AS
BEGIN
	IF @id_agencia IS NULL OR @id_agencia <= 0
	BEGIN
		RAISERROR('ID da agência inválido.', 16, 1)
		RETURN
	END

	IF NOT EXISTS (
		SELECT 1
		FROM agencia
		WHERE id_agencia = @id_agencia
	)
	BEGIN
		RAISERROR('Agência não encontrada.', 16, 1)
		RETURN
	END

	IF @codigo IS NULL OR LTRIM(RTRIM(@codigo)) = ''
	BEGIN
		RAISERROR('Código da agência inválido.', 16, 1)
		RETURN
	END

	IF @cep IS NULL OR LEN(@cep) <> 8
	BEGIN
		RAISERROR('CEP inválido.', 16, 1)
		RETURN
	END

	IF @cidade IS NULL OR LTRIM(RTRIM(@cidade)) = ''
	BEGIN
		RAISERROR('A cidade é obrigatória.', 16, 1)
		RETURN
	END

	IF NOT EXISTS (
		SELECT 1
		FROM instituicao_bancaria
		WHERE id_instituicao = @id_instituicao
	)
	BEGIN
		RAISERROR('Instituição bancária não encontrada.', 16, 1)
		RETURN
	END

	UPDATE agencia
	SET
		codigo = @codigo,
		cep = @cep,
		cidade = @cidade,
		id_instituicao = @id_instituicao
	WHERE id_agencia = @id_agencia;

END
GO

/* ===========================
   cliente
   =========================== */

CREATE PROCEDURE sp_delete_cliente
    @cpf CHAR(11)
AS
BEGIN
    DECLARE @contas_cliente TABLE (
        codigo_conta VARCHAR(20)
    );

    IF NOT EXISTS (
        SELECT 1
        FROM cliente
        WHERE cpf = @cpf
    )
    BEGIN
        RAISERROR('Cliente não encontrado.', 16, 1);
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM titularidade t
        WHERE t.cpf_cliente = @cpf
          AND t.codigo_conta IN (
              SELECT codigo_conta
              FROM titularidade
              GROUP BY codigo_conta
              HAVING COUNT(*) > 1
          )
    )
    BEGIN
        RAISERROR('Não é permitido excluir cliente com conta conjunta.', 16, 1);
        RETURN;
    END

    INSERT INTO @contas_cliente (codigo_conta)
    SELECT codigo_conta
    FROM titularidade
    WHERE cpf_cliente = @cpf;

    DELETE FROM conta_corrente
    WHERE codigo_conta IN (
        SELECT codigo_conta
        FROM @contas_cliente
    );

    DELETE FROM conta_poupanca
    WHERE codigo_conta IN (
        SELECT codigo_conta
        FROM @contas_cliente
    );

    DELETE FROM titularidade
    WHERE cpf_cliente = @cpf;

    DELETE FROM conta_bancaria
    WHERE codigo_conta IN (
        SELECT codigo_conta
        FROM @contas_cliente
    );

    DELETE FROM cliente
    WHERE cpf = @cpf;
END
GO

CREATE PROCEDURE sp_insert_cliente
	@cpf					CHAR(11),
	@nome					VARCHAR(100),
	@senha					CHAR(8)
AS
BEGIN
	DECLARE @quantidade_numeros INT;

	IF @cpf IS NULL OR LEN(@cpf) <> 11 OR @cpf LIKE '%[^0-9]%'
    BEGIN
        RAISERROR('CPF inválido. Deve conter exatamente 11 dígitos numéricos.', 16, 1);
        RETURN
    END

	IF @nome IS NULL OR LTRIM(RTRIM(@nome)) = ''
    BEGIN
        RAISERROR('Nome do cliente é obrigatório.', 16, 1);
        RETURN
    END

	IF @senha IS NULL OR LEN(@senha) <> 8
    BEGIN
        RAISERROR('A senha deve conter exatamente 8 caracteres.', 16, 1);
        RETURN
    END

	SET @quantidade_numeros =
        CASE WHEN SUBSTRING(@senha,1,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,2,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,3,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,4,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,5,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,6,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,7,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,8,1) LIKE '[0-9]' THEN 1 ELSE 0 END

	IF @quantidade_numeros < 3
    BEGIN
        RAISERROR('A senha deve possuir pelo menos 3 caracteres numéricos.', 16, 1);
        RETURN
    END

	IF EXISTS (
        SELECT 1
        FROM cliente
        WHERE cpf = @cpf
    )
    BEGIN
        RAISERROR('Já existe um cliente cadastrado com esse CPF.', 16, 1);
        RETURN
    END

	INSERT INTO cliente (cpf, nome, data_primeira_conta, senha)
    VALUES (@cpf, @nome, NULL, @senha)
END
GO

CREATE PROCEDURE sp_login_cliente
    @cpf CHAR(11),
    @senha CHAR(8)
AS
BEGIN
    SELECT
        cpf,
        nome,
        data_primeira_conta
    FROM cliente
    WHERE cpf = @cpf
      AND senha = @senha
END
GO

CREATE PROCEDURE sp_select_cliente
    @cpf CHAR(11)
AS
BEGIN
    SELECT
        cpf,
        nome,
        data_primeira_conta,
        senha
    FROM cliente
    WHERE cpf = @cpf
END
GO

CREATE PROCEDURE sp_select_clientes
AS
BEGIN
    SELECT
        cpf,
        nome,
        data_primeira_conta,
        senha
    FROM cliente
    ORDER BY nome
END
GO

CREATE PROCEDURE sp_update_senha_cliente
    @cpf CHAR(11),
    @nova_senha CHAR(8)
AS
BEGIN
    DECLARE @quantidade_numeros INT

    IF NOT EXISTS (
        SELECT 1
        FROM cliente
        WHERE cpf = @cpf
    )
    BEGIN
        RAISERROR('Cliente não encontrado.', 16, 1)
        RETURN
    END

    IF @nova_senha IS NULL OR LEN(@nova_senha) <> 8
    BEGIN
        RAISERROR('A senha deve conter exatamente 8 caracteres.', 16, 1)
        RETURN
    END

    SET @quantidade_numeros =
        CASE WHEN SUBSTRING(@nova_senha,1,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,2,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,3,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,4,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,5,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,6,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,7,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,8,1) LIKE '[0-9]' THEN 1 ELSE 0 END

    IF @quantidade_numeros < 3
    BEGIN
        RAISERROR('A senha deve possuir pelo menos 3 caracteres numéricos.', 16, 1)
        RETURN
    END

    UPDATE cliente
    SET senha = @nova_senha
    WHERE cpf = @cpf;
END
GO

/* ===========================
   conta_bancaria
   =========================== */

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

CREATE PROCEDURE sp_insert_conta_corrente
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

    INSERT INTO conta_corrente
    VALUES(
        @codigo_conta,
        500
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
        a.cidade,
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
