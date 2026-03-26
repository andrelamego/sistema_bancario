-- INSERT VALIDO
EXEC sp_insert_instituicao_bancaria
    @id_instituicao = 1,
    @nome = 'Banco FATEC'
GO

EXEC sp_insert_instituicao_bancaria
    @id_instituicao = 2,
    @nome = 'Banco Melbi'
GO

-- INSERT DUPLICADO
EXEC sp_insert_instituicao_bancaria
    @id_instituicao = 1,
    @nome = 'Banco Duplicado'
GO

-- SELECTS
EXEC sp_select_instituicao_bancaria
    @id_instituicao = 2;
GO

EXEC sp_select_instituicoes_bancarias;
GO

-- UPDATE
EXEC sp_update_instituicao_bancaria
    @id_instituicao = 1,
    @nome = 'Banco FATEC Atualizado'
GO

-- DELETE
EXEC sp_delete_instituicao_bancaria
    @id_instituicao = 1;
GO