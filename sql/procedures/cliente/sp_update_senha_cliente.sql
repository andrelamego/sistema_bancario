CREATE PROCEDURE sp_update_senha_cliente
    @cpf CHAR(11),
    @nova_senha CHAR(8)
AS
BEGIN
    DECLARE @quantidade_numeros INT

    IF NOT EXISTS (
        SELECT 1
        FROM cliente
        WHERE cpf = @cpf
    )
    BEGIN
        RAISERROR('Cliente não encontrado.', 16, 1)
        RETURN
    END

    IF @nova_senha IS NULL OR LEN(@nova_senha) <> 8
    BEGIN
        RAISERROR('A senha deve conter exatamente 8 caracteres.', 16, 1)
        RETURN
    END

    SET @quantidade_numeros =
        CASE WHEN SUBSTRING(@nova_senha,1,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,2,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,3,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,4,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,5,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,6,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,7,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@nova_senha,8,1) LIKE '[0-9]' THEN 1 ELSE 0 END

    IF @quantidade_numeros < 3
    BEGIN
        RAISERROR('A senha deve possuir pelo menos 3 caracteres numéricos.', 16, 1)
        RETURN
    END

    UPDATE cliente
    SET senha = @nova_senha
    WHERE cpf = @cpf;
END
GO