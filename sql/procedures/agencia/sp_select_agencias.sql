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