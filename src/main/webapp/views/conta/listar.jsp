<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />
<h1 class="h4 mb-3">Listar contas por cliente</h1>
<c:if test="${not empty saida}"><div class="alert alert-success">${saida}</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>
<form action="${pageContext.request.contextPath}/conta" method="post" class="card soft-panel p-3 mb-3">
    <label class="form-label">CPF do cliente</label><input class="form-control mb-3" type="text" name="cpfCliente" value="${sessionScope.clienteLogado.cpf}" required>
    <button class="btn btn-outline-primary" type="submit" name="button" value="Listar Contas">Listar Contas</button>
</form>
<div class="card soft-panel p-3">
    <div class="table-responsive">
        <table class="table table-striped mb-0">
            <thead><tr><th>Codigo</th><th>Data abertura</th><th>Saldo</th><th>Agencia</th><th>Cidade</th><th>Acoes</th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${contas}">
                <tr>
                    <td>${item.codigo}</td>
                    <td>${item.dataAbertura}</td>
                    <td>${item.saldo}</td>
                    <td>${item.agencia.codigo}</td>
                    <td>${item.agencia.cidade}</td>
                    <td>
                        <div class="d-flex gap-1 flex-wrap">
                            <a class="btn btn-sm btn-outline-warning" href="${pageContext.request.contextPath}/conta?acao=atualizarConta&codigoConta=${item.codigo}">Atualizar</a>
                            <a class="btn btn-sm btn-outline-danger" href="${pageContext.request.contextPath}/conta?acao=excluir&codigoConta=${item.codigo}">Excluir</a>
                            <a class="btn btn-sm btn-outline-info" href="${pageContext.request.contextPath}/conta?acao=segundoTitular&codigoConta=${item.codigo}">Segundo titular</a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty contas}">
                <tr><td colspan="6" class="text-center text-muted">Nenhuma conta encontrada.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
<jsp:include page="../../includes/footer.jsp" />
