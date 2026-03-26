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