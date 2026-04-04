<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />
<c:url var="painelUrl" value="/cliente"><c:param name="acao" value="painel" /></c:url>
<c:set var="returnUrl" value="${empty param.returnUrl ? painelUrl : param.returnUrl}" />
<h1 class="h4 mb-3">Adicionar segundo titular</h1>
<c:if test="${not empty saida}"><div class="alert alert-success">${saida}</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>
<a class="btn btn-outline-secondary btn-sm mb-3" href="${returnUrl}">Voltar</a>
<form action="${pageContext.request.contextPath}/conta" method="post" class="card soft-panel p-3">
    <input type="hidden" name="returnUrl" value="${returnUrl}">
    <label class="form-label">Codigo da conta</label><input class="form-control mb-3" type="text" name="codigoConta" value="${param.codigoConta}" required>
    <label class="form-label">CPF titular atual</label><input class="form-control mb-3" type="text" name="cpfTitularAtual" required>
    <label class="form-label">Senha titular atual</label><input class="form-control mb-3" type="password" name="senhaTitularAtual" required>
    <label class="form-label">CPF novo titular</label><input class="form-control mb-3" type="text" name="cpfNovoTitular" required>
    <button class="btn btn-info text-white" type="submit" name="button" value="Adicionar Segundo Titular">Adicionar Segundo Titular</button>
</form>
<jsp:include page="../../includes/footer.jsp" />
