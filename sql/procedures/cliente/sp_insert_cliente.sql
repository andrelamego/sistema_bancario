CREATE PROCEDURE sp_insert_cliente
	@cpf					CHAR(11),
	@nome					VARCHAR(100),
	@senha					CHAR(8)
AS
BEGIN
	DECLARE @quantidade_numeros INT;

	IF @cpf IS NULL OR LEN(@cpf) <> 11 OR @cpf LIKE '%[^0-9]%'
    BEGIN
        RAISERROR('CPF inválido. Deve conter exatamente 11 dígitos numéricos.', 16, 1);
        RETURN
    END

	IF @nome IS NULL OR LTRIM(RTRIM(@nome)) = ''
    BEGIN
        RAISERROR('Nome do cliente é obrigatório.', 16, 1);
        RETURN
    END

	IF @senha IS NULL OR LEN(@senha) <> 8
    BEGIN
        RAISERROR('A senha deve conter exatamente 8 caracteres.', 16, 1);
        RETURN
    END

	SET @quantidade_numeros =
        CASE WHEN SUBSTRING(@senha,1,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,2,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,3,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,4,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,5,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,6,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,7,1) LIKE '[0-9]' THEN 1 ELSE 0 END +
        CASE WHEN SUBSTRING(@senha,8,1) LIKE '[0-9]' THEN 1 ELSE 0 END

	IF @quantidade_numeros < 3
    BEGIN
        RAISERROR('A senha deve possuir pelo menos 3 caracteres numéricos.', 16, 1);
        RETURN
    END

	IF EXISTS (
        SELECT 1
        FROM cliente
        WHERE cpf = @cpf
    )
    BEGIN
        RAISERROR('Já existe um cliente cadastrado com esse CPF.', 16, 1);
        RETURN
    END

	INSERT INTO cliente (cpf, nome, data_primeira_conta, senha)
    VALUES (@cpf, @nome, NULL, @senha)
END