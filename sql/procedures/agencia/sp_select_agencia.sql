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