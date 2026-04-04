<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="h3 mb-0 section-title"><i class="bi bi-people me-2"></i>Modulo de Clientes</h1>
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary btn-sm">Voltar ao inicio</a>
</div>

<div class="row g-3">
    <div class="col-md-4"><a class="btn btn-primary w-100" href="${pageContext.request.contextPath}/cliente?acao=cadastrar">Cadastrar cliente</a></div>
    <div class="col-md-4"><a class="btn btn-outline-primary w-100" href="${pageContext.request.contextPath}/cliente?acao=buscar">Buscar cliente</a></div>
    <div class="col-md-4"><a class="btn btn-outline-success w-100" href="${pageContext.request.contextPath}/cliente?acao=login">Login cliente</a></div>
    <div class="col-md-6"><a class="btn btn-outline-warning w-100" href="${pageContext.request.contextPath}/cliente?acao=atualizar">Atualizar senha</a></div>
    <div class="col-md-6"><a class="btn btn-outline-danger w-100" href="${pageContext.request.contextPath}/cliente?acao=excluir">Excluir cliente</a></div>
</div>

<jsp:include page="../../includes/footer.jsp" />
