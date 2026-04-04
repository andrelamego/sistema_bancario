<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />
<c:url var="painelUrl" value="/cliente"><c:param name="acao" value="painel" /></c:url>
<c:set var="returnUrl" value="${empty param.returnUrl ? painelUrl : param.returnUrl}" />
<h1 class="h4 mb-3">Atualizar senha do cliente</h1>
<c:if test="${not empty saida}"><div class="alert alert-success">${saida}</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>
<a class="btn btn-outline-secondary btn-sm mb-3" href="${returnUrl}">Voltar</a>
<form action="${pageContext.request.contextPath}/cliente" method="post" class="card soft-panel p-3">
    <input type="hidden" name="returnUrl" value="${returnUrl}">
    <label class="form-label">CPF</label><input class="form-control mb-3" type="text" name="cpf" value="${param.cpf}" required>
    <label class="form-label">Nova senha</label><input class="form-control mb-3" type="password" name="senha" required>
    <button class="btn btn-warning" type="submit" name="button" value="Atualizar">Atualizar</button>
</form>
<jsp:include page="../../includes/footer.jsp" />
