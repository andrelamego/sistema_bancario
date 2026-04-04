<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />
<h1 class="h4 mb-3">Buscar conta</h1>
<c:if test="${not empty saida}"><div class="alert alert-success">${saida}</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>
<form action="${pageContext.request.contextPath}/conta" method="post" class="card soft-panel p-3 mb-3">
    <label class="form-label">Codigo da conta</label><input class="form-control mb-3" type="text" name="codigoConta" required>
    <button class="btn btn-outline-primary" type="submit" name="button" value="Buscar">Buscar</button>
</form>
<c:if test="${not empty conta}">
    <div class="card soft-panel p-3">
        <div><strong>Codigo:</strong> ${conta.codigo}</div>
        <div><strong>Saldo:</strong> ${conta.saldo}</div>
        <div><strong>Agencia:</strong> ${conta.agencia.id}</div>
        <div><strong>Titularidade:</strong> ${conta.titularidade}</div>
    </div>
</c:if>
<jsp:include page="../../includes/footer.jsp" />
