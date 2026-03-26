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