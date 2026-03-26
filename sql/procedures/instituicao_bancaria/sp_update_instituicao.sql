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