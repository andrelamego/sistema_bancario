<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />
<c:url var="inicioUrl" value="/index.jsp" />
<h1 class="h4 mb-3">Buscar agencia</h1>
<c:if test="${not empty saida}"><div class="alert alert-success">${saida}</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>
<a class="btn btn-outline-secondary btn-sm mb-3" href="${inicioUrl}">Voltar</a>
<form action="${pageContext.request.contextPath}/agencia" method="post" class="card soft-panel p-3 mb-3">
    <label class="form-label">ID da agencia</label><input class="form-control mb-3" type="number" name="id" required>
    <button class="btn btn-outline-primary" type="submit" name="button" value="Buscar">Buscar</button>
</form>
<c:if test="${not empty agencia}">
    <div class="card soft-panel p-3">
        <div><strong>ID:</strong> ${agencia.id}</div>
        <div><strong>Codigo:</strong> ${agencia.codigo}</div>
        <div><strong>CEP:</strong> ${agencia.cep}</div>
        <div><strong>Cidade:</strong> ${agencia.cidade}</div>
        <div><strong>ID Instituicao:</strong> ${agencia.instituicaoBancaria.id}</div>
    </div>
</c:if>
<jsp:include page="../../includes/footer.jsp" />
