<%--
  proyectos.jsp
  ------------------------------------------------------------------
  NOTA PEDAGOGICA:
  Esta es la version "con backend" de portafolio/proyectos.html.
  En la version estatica, el arreglo PROYECTOS vive en js/data.js y
  script.js lo recorre en el navegador para pintar las tarjetas.

  Aqui el mismo listado vive en la tabla `proyectos` de la base de
  datos (ver sql/schema.sql) y es este JSP, con JSTL + JDBC, quien
  arma el HTML en el servidor antes de enviarlo al navegador.
  ------------------------------------------------------------------
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%--
  1) CONEXION Y CONSULTA (JDBC)
  ------------------------------------------------------------------
  Se abre la conexion, se ejecuta un SELECT sobre `proyectos` y el
  resultado se deja en un scriptlet solo para volcarlo a un
  ArrayList<Map<String,Object>> que despues recorre JSTL. En un
  proyecto real esta logica NO iria en el JSP: viviria en un
  Servlet o en una clase DAO, y el JSP solo recibiria los datos
  listos como un atributo de request. Se deja aqui, dentro de un
  scriptlet, unicamente con fines didacticos (mostrar el camino
  completo JDBC -> JSTL -> HTML en un solo archivo).
--%>
<%
  // Datos de conexion. En produccion NUNCA se dejan hardcodeados:
  // se leen desde variables de entorno o un archivo de configuracion
  // fuera del control de versiones.
  String jdbcUrl  = "jdbc:mysql://localhost:3306/portafolio_db?useUnicode=true&characterEncoding=UTF-8";
  String jdbcUser = "root";
  String jdbcPass = "";

  java.util.List<java.util.Map<String, Object>> proyectos = new java.util.ArrayList<>();

  // try-with-resources cierra Connection, Statement y ResultSet
  // automaticamente aunque se produzca una excepcion.
  try (
    Connection con = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPass);
    PreparedStatement stmt = con.prepareStatement(
      "SELECT nombre, ruta, descripcion, stack, anio, repo " +
      "FROM proyectos ORDER BY anio DESC"
    );
    ResultSet rs = stmt.executeQuery()
  ) {
    while (rs.next()) {
      java.util.Map<String, Object> fila = new java.util.HashMap<>();
      fila.put("nombre", rs.getString("nombre"));
      fila.put("ruta", rs.getString("ruta"));
      fila.put("descripcion", rs.getString("descripcion"));
      // stack se guarda como texto separado por comas (ver schema.sql);
      // se parte aqui en una lista para poder pintar un <span class="tag">
      // por tecnologia, igual que hace script.js con p.stack.map(...).
      fila.put("stack", java.util.Arrays.asList(rs.getString("stack").split("\\s*,\\s*")));
      fila.put("anio", rs.getInt("anio"));
      fila.put("repo", rs.getString("repo"));
      proyectos.add(fila);
    }
  } catch (SQLException e) {
    // No se detiene la pagina: se registra el error y se deja la
    // lista vacia, para que el JSTL de abajo muestre el mensaje de
    // "sin proyectos" en vez de una pantalla en blanco o un 500.
    e.printStackTrace();
  }

  request.setAttribute("proyectos", proyectos);
%>

<!doctype html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Proyectos (JSP) · Sabina Romero Rodríguez</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="../css/style.css">
</head>
<body>
  <main id="main-content" class="section">
    <div class="container">
      <p class="eyebrow">SELECT * FROM proyectos</p>
      <h1>Proyectos (renderizados desde MySQL vía JSTL + JDBC)</h1>
      <p>
        Este listado es el equivalente en servidor de
        <code>portafolio/proyectos.html</code>: en vez de leer
        <code>js/data.js</code> en el navegador, cada fila viene de la
        tabla <code>proyectos</code> definida en
        <code>sql/schema.sql</code>.
      </p>

      <%--
        2) RENDER CON JSTL (sin scriptlets)
        ------------------------------------------------------------
        <c:forEach> recorre la lista igual que PROYECTOS.map(...) en
        script.js. Es la forma "correcta" de generar HTML dinámico en
        JSP moderno: separa la lógica de datos (arriba, en el
        scriptlet/DAO) de la vista (aquí, declarativa).
      --%>
      <c:choose>
        <c:when test="${empty proyectos}">
          <p>No hay proyectos para mostrar (o no fue posible conectar a la base de datos).</p>
        </c:when>
        <c:otherwise>
          <div class="row g-4">
            <c:forEach var="p" items="${proyectos}">
              <div class="col-md-6 col-lg-4">
                <article class="project-card">
                  <div class="card-body">
                    <p class="file-path">~/proyectos${p.ruta}</p>
                    <h3 class="mt-1"><c:out value="${p.nombre}" /></h3>
                    <p class="mt-2"><c:out value="${p.descripcion}" /></p>
                    <div class="mt-2">
                      <c:forEach var="tech" items="${p.stack}">
                        <span class="tag"><c:out value="${tech}" /></span>
                      </c:forEach>
                    </div>
                    <a class="btn-outline-teal d-inline-block mt-3"
                       href="${p.repo}" target="_blank" rel="noopener">
                      Ver repositorio →
                    </a>
                  </div>
                </article>
              </div>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </main>
</body>
</html>
