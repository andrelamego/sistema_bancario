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