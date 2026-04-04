<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../../includes/header.jsp" />
<c:url var="inicioUrl" value="/index.jsp" />
<h1 class="h4 mb-3">Cadastrar agencia</h1>
<c:if test="${not empty saida}"><div class="alert alert-success">${saida}</div></c:if>
<c:if test="${not empty erro}"><div class="alert alert-danger">${erro}</div></c:if>
<a class="btn btn-outline-secondary btn-sm mb-3" href="${inicioUrl}">Voltar</a>
<form action="${pageContext.request.contextPath}/agencia" method="post" class="card soft-panel p-3">
    <label class="form-label">ID</label><input class="form-control mb-3" type="number" name="id" required>
    <label class="form-label">Codigo</label><input class="form-control mb-3" type="text" name="codigo" required>
    <label class="form-label">CEP</label><input class="form-control mb-3" type="text" name="cep" required>
    <label class="form-label">Cidade</label><input class="form-control mb-3" type="text" name="cidade" required>
    <label class="form-label">ID instituicao</label><input class="form-control mb-3" type="number" name="idInstituicao" required>
    <button class="btn btn-primary" type="submit" name="button" value="Cadastrar">Cadastrar</button>
</form>
<jsp:include page="../../includes/footer.jsp" />
