<%--
  contacto.jsp
  ------------------------------------------------------------------
  NOTA PEDAGOGICA:
  Version "con backend" de portafolio/contacto.html.

  El formulario estatico valida solo en el navegador (atributos
  required/minlength/pattern de HTML5 + script.js). Eso es comodo
  para el usuario pero NUNCA es suficiente: cualquiera puede saltarse
  el navegador y mandar la peticion a mano. Por eso este JSP repite
  la validacion en el servidor antes de tocar la base de datos, y
  usa PreparedStatement (no concatenacion de strings) para evitar
  inyeccion SQL.
  ------------------------------------------------------------------
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
  // Solo se procesa el formulario si la pagina recibio un POST
  // (si alguien entra directo con GET, no hay nada que insertar).
  boolean esEnvio = "POST".equalsIgnoreCase(request.getMethod());

  String nombre  = request.getParameter("nombre");
  String correo  = request.getParameter("correo");
  String motivo  = request.getParameter("motivo");
  String mensaje = request.getParameter("mensaje");

  java.util.List<String> errores = new java.util.ArrayList<>();
  boolean guardadoOk = false;

  if (esEnvio) {
    // 1) VALIDACION EN SERVIDOR
    // Repite, en Java, las mismas reglas que ya declara el HTML5
    // (required, minlength, pattern) porque el servidor no puede
    // confiar en que el navegador las haya aplicado.
    if (nombre == null || nombre.trim().length() < 2) {
      errores.add("El nombre debe tener al menos 2 caracteres.");
    }
    if (correo == null || !Pattern.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", correo)) {
      errores.add("El correo electrónico no es válido.");
    }
    if (motivo == null || motivo.trim().isEmpty()) {
      errores.add("Selecciona un motivo de contacto.");
    }
    if (mensaje == null || mensaje.trim().length() < 10) {
      errores.add("El mensaje debe tener al menos 10 caracteres.");
    }

    // 2) GUARDADO (solo si pasó la validación)
    if (errores.isEmpty()) {
      String jdbcUrl  = "jdbc:mysql://localhost:3306/portafolio_db?useUnicode=true&characterEncoding=UTF-8";
      String jdbcUser = "root";
      String jdbcPass = "";

      // PreparedStatement con "?" en vez de concatenar el texto del
      // usuario dentro del SQL: así un mensaje como
      // "'; DROP TABLE mensajes_contacto; --" se guarda como texto
      // literal y no se ejecuta como comando SQL.
      String sql = "INSERT INTO mensajes_contacto (nombre, correo, motivo, mensaje, fecha_envio) " +
                   "VALUES (?, ?, ?, ?, NOW())";

      try (
        Connection con = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPass);
        PreparedStatement stmt = con.prepareStatement(sql)
      ) {
        stmt.setString(1, nombre.trim());
        stmt.setString(2, correo.trim());
        stmt.setString(3, motivo.trim());
        stmt.setString(4, mensaje.trim());
        stmt.executeUpdate();
        guardadoOk = true;
      } catch (SQLException e) {
        e.printStackTrace();
        errores.add("No fue posible guardar tu mensaje. Intenta nuevamente más tarde.");
      }
    }
  }
%>

<!doctype html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Contacto (JSP) · Sabina Romero Rodríguez</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="../css/style.css">
</head>
<body>
  <main id="main-content" class="section">
    <div class="container">
      <p class="eyebrow">POST /jsp/contacto.jsp</p>
      <h1>Contacto (procesado en servidor con JSP + JDBC)</h1>
      <p>
        Equivalente en servidor de <code>portafolio/contacto.html</code>:
        valida los mismos campos, pero en Java, y guarda el resultado en
        la tabla <code>mensajes_contacto</code> (ver
        <code>sql/schema.sql</code>) en lugar de solo mostrar un aviso
        en pantalla.
      </p>

      <% if (guardadoOk) { %>
        <div class="bg-ink-800 rounded-md p-4 mb-4">
          <p>✓ ¡Gracias, <c:out value="${param.nombre}" />! Tu mensaje quedó guardado.</p>
        </div>
      <% } else if (esEnvio && !errores.isEmpty()) { %>
        <div class="bg-ink-800 rounded-md p-4 mb-4">
          <p class="text-amber">No se pudo enviar el formulario:</p>
          <ul>
            <% for (String error : errores) { %>
              <li><%= error %></li>
            <% } %>
          </ul>
        </div>
      <% } %>

      <%--
        El formulario se reenvía a esta misma página (action=""),
        por eso vuelve a aparecer tras un error: así el usuario no
        pierde el contexto y puede corregir los datos.
      --%>
      <form method="post" action="" class="row g-3">
        <div class="col-md-6">
          <label class="form-label-terminal" for="nombre">nombre completo *</label>
          <input type="text" class="form-control form-control-terminal" id="nombre" name="nombre"
            value="<%= nombre != null ? nombre.replace("\"", "&quot;") : "" %>" required minlength="2" maxlength="80" />
        </div>
        <div class="col-md-6">
          <label class="form-label-terminal" for="correo">correo electrónico *</label>
          <input type="email" class="form-control form-control-terminal" id="correo" name="correo"
            value="<%= correo != null ? correo.replace("\"", "&quot;") : "" %>" required />
        </div>
        <div class="col-md-6">
          <label class="form-label-terminal" for="motivo">motivo *</label>
          <select class="form-select form-control-terminal" id="motivo" name="motivo" required>
            <option value="" disabled <%= motivo == null ? "selected" : "" %>>Selecciona una opción</option>
            <option value="proyecto" <%= "proyecto".equals(motivo) ? "selected" : "" %>>Propuesta de proyecto</option>
            <option value="docencia" <%= "docencia".equals(motivo) ? "selected" : "" %>>Consulta académica / docencia</option>
            <option value="colaboracion" <%= "colaboracion".equals(motivo) ? "selected" : "" %>>Colaboración técnica</option>
            <option value="otro" <%= "otro".equals(motivo) ? "selected" : "" %>>Otro</option>
          </select>
        </div>
        <div class="col-12">
          <label class="form-label-terminal" for="mensaje">mensaje *</label>
          <textarea class="form-control form-control-terminal" id="mensaje" name="mensaje" rows="5"
            required minlength="10" maxlength="600"><%= mensaje != null ? mensaje : "" %></textarea>
        </div>
        <div class="col-12">
          <button type="submit" class="btn-amber">Enviar mensaje</button>
        </div>
      </form>
    </div>
  </main>
</body>
</html>
