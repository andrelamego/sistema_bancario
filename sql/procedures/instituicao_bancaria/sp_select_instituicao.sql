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