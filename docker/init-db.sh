#!/usr/bin/env bash
set -euo pipefail

DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-1433}"
DB_NAME="${DB_NAME:-bd_sistema_bancario}"
DB_USER="${DB_USER:-sa}"
DB_PASSWORD="${DB_PASSWORD:-YourStrong!Passw0rd}"

SQLCMD="/opt/mssql-tools18/bin/sqlcmd -S ${DB_HOST},${DB_PORT} -U ${DB_USER} -P ${DB_PASSWORD} -C"

echo "Aguardando SQL Server ficar disponivel..."
until ${SQLCMD} -Q "SELECT 1" > /dev/null 2>&1; do
  sleep 2
done

echo "Criando banco se necessario..."
${SQLCMD} -Q "IF DB_ID(N'${DB_NAME}') IS NULL CREATE DATABASE [${DB_NAME}];"

TABLE_EXISTS="$(${SQLCMD} -d "${DB_NAME}" -h -1 -W -Q "SET NOCOUNT ON; SELECT CASE WHEN OBJECT_ID('dbo.instituicao_bancaria', 'U') IS NULL THEN 0 ELSE 1 END;" | tr -d '[:space:]')"
if [ "${TABLE_EXISTS}" = "1" ]; then
  echo "Banco ja inicializado. Pulando carga de schema/procedures."
  exit 0
fi

echo "Aplicando schema..."
${SQLCMD} -d "${DB_NAME}" -i /sql/02_create_tables.sql

echo "Aplicando stored procedures..."
find /sql/procedures -type f -name "*.sql" ! -name "tests_*" | sort | while read -r file; do
  ${SQLCMD} -d "${DB_NAME}" -i "${file}"
done

echo "Banco inicializado com sucesso."
