CREATE PROCEDURE sp_delete_agencia
	@id_agencia BIGINT
AS
BEGIN
	IF NOT EXISTS (
        SELECT 1 
        FROM agencia 
        WHERE id_agencia = @id_agencia
    )
    BEGIN
        RAISERROR('Agência não encontrada.',16,1);
        RETURN;
    END

	IF EXISTS (
        SELECT 1 
        FROM conta_bancaria 
        WHERE id_agencia = @id_agencia
    )
    BEGIN
        RAISERROR('Não é possível excluir a agência. Existem contas vinculadas.',16,1);
        RETURN;
    END

	DELETE FROM agencia
    WHERE id_agencia = @id_agencia;
END