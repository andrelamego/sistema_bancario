<div align="center">

# Sistema Bancário - Java Web

![Java](https://img.shields.io/badge/Java-17-orange)
![SQL Server](https://img.shields.io/badge/SQL%20Server-Database-red)
![Maven](https://img.shields.io/badge/Maven-Build-blue)
![Architecture](https://img.shields.io/badge/Architecture-MVC-green)
![SOLID](https://img.shields.io/badge/Design-SOLID-purple)
![Status](https://img.shields.io/badge/Status-Academic%20Project-yellow)
![License](https://img.shields.io/badge/License-Academic-lightgrey)

</div>

Sistema bancário desenvolvido para a disciplina **Laboratório de Banco de Dados** da **FATEC Zona Leste**.

O projeto implementa um ambiente completo para gerenciamento de:

- Instituições Bancárias
- Agências
- Clientes
- Contas Correntes
- Contas Poupança
- Contas Conjuntas

A aplicação foi desenvolvida utilizando **Java Web**, com **Stored Procedures** no banco de dados e aplicação organizada em **camadas seguindo princípios SOLID**.

---

# Tecnologias Utilizadas

![Java](https://img.shields.io/badge/Java-17-orange)
![JDBC](https://img.shields.io/badge/JDBC-Database-blue)
![SQL Server](https://img.shields.io/badge/SQL%20Server-Database-red)
![Bootstrap](https://img.shields.io/badge/Bootstrap-UI-purple)
![HTML](https://img.shields.io/badge/HTML-Frontend-orange)
![CSS](https://img.shields.io/badge/CSS-Style-blue)
![Maven](https://img.shields.io/badge/Maven-Build-green)

- Java
- Java Web (Servlet / JSP)
- JDBC
- SQL Server
- Stored Procedures
- HTML
- CSS
- Bootstrap
- Maven

---

# Arquitetura do Projeto

O projeto foi estruturado em camadas:

- Model → Entidades do sistema
- Controller → Servlets
- Service → Regras de negócio
- Persistence → DAO / JDBC
- View → JSP / HTML

Seguindo princípios:

- SOLID
- MVC
- Clean Code

---

# Funcionalidades

## Instituições Bancárias

- Cadastro
- Consulta
- Atualização
- Exclusão

## Agências

- Cadastro
- Consulta
- Atualização
- Exclusão

## Clientes

- Cadastro
- Login
- Alteração de senha
- Exclusão com regras de negócio

## Contas Bancárias

- Conta Corrente
- Conta Poupança
- Conta Conjunta

## Regras de Negócio

- Conta conjunta com até 2 titulares
- Código da conta gerado automaticamente
- Validação de senha
- Controle de exclusão de cliente com conta conjunta
- Criação automática de contas

---

# Modelagem

O projeto contém:

- Diagrama ER

![](doc/entityRelationshipDiagram/entityRelationshipDiagram.png)

- Diagrama de Classes:

![](doc/classDiagram/classDiagram.png)

---

# Desenvolvedor


![Developer](https://img.shields.io/badge/Developer-Andr%C3%A9%20Lamego-blue)

**André Lamego**

Estudante de Análise e Desenvolvimento de Sistemas  
FATEC Zona Leste
---

# Disciplina

Laboratório de Banco de Dados  
Prof. Leandro Colevati

---

# Observações

Este projeto foi desenvolvido exclusivamente para fins acadêmicos.