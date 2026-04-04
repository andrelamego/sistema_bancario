<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />
<h1 class="h4 mb-3">Login do cliente</h1>
<c:if test="${not empty saida}"><div class="alert alert-success">${saida}</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>
<form action="${pageContext.request.contextPath}/cliente" method="post" class="card soft-panel p-3">
    <label class="form-label">CPF</label><input class="form-control mb-3" type="text" name="cpf" required>
    <label class="form-label">Senha</label><input class="form-control mb-3" type="password" name="senha" required>
    <button class="btn btn-success" type="submit" name="button" value="Login">Entrar</button>
</form>
<jsp:include page="../../includes/footer.jsp" />
