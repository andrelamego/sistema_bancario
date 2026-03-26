CREATE PROCEDURE sp_login_cliente
    @cpf CHAR(11),
    @senha CHAR(8)
AS
BEGIN
    SELECT
        cpf,
        nome,
        data_primeira_conta
    FROM cliente
    WHERE cpf = @cpf
      AND senha = @senha
END
GO