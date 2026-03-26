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