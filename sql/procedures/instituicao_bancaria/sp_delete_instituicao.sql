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