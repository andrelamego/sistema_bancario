CREATE PROCEDURE sp_select_instituicoes_bancarias
AS
BEGIN
	SELECT
		id_instituicao,
		nome
	FROM instituicao_bancaria
	ORDER BY id_instituicao
END