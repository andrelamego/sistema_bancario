CREATE PROCEDURE sp_delete_cliente
    @cpf CHAR(11)
AS
BEGIN
    DECLARE @contas_cliente TABLE (
        codigo_conta VARCHAR(20)
    );

    IF NOT EXISTS (
        SELECT 1
        FROM cliente
        WHERE cpf = @cpf
    )
    BEGIN
        RAISERROR('Cliente não encontrado.', 16, 1);
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM titularidade t
        WHERE t.cpf_cliente = @cpf
          AND t.codigo_conta IN (
              SELECT codigo_conta
              FROM titularidade
              GROUP BY codigo_conta
              HAVING COUNT(*) > 1
          )
    )
    BEGIN
        RAISERROR('Não é permitido excluir cliente com conta conjunta.', 16, 1);
        RETURN;
    END

    INSERT INTO @contas_cliente (codigo_conta)
    SELECT codigo_conta
    FROM titularidade
    WHERE cpf_cliente = @cpf;

    DELETE FROM conta_corrente
    WHERE codigo_conta IN (
        SELECT codigo_conta
        FROM @contas_cliente
    );

    DELETE FROM conta_poupanca
    WHERE codigo_conta IN (
        SELECT codigo_conta
        FROM @contas_cliente
    );

    DELETE FROM titularidade
    WHERE cpf_cliente = @cpf;

    DELETE FROM conta_bancaria
    WHERE codigo_conta IN (
        SELECT codigo_conta
        FROM @contas_cliente
    );

    DELETE FROM cliente
    WHERE cpf = @cpf;
END
GO