# Portafolio Sabina Romero Rodríguez

Portafolio personal construido como sitio estático (HTML + CSS + JavaScript + Bootstrap 5), con una versión paralela "con backend" en JSP + JDBC sobre MySQL. Este README funciona como **guía paso a paso** para que puedas construir un portafolio similar desde cero, usando este repo como referencia.

## Demo

- Código fuente: `portafolio/` (sitio estático que consume `js/data.js`)
- Versión con backend: `jsp/` (mismo contenido, pero armado en el servidor desde MySQL)

## Estructura del repositorio

```
├── portafolio/        # Páginas HTML (el sitio en sí)
│   ├── index.html
│   ├── proyectos.html
│   ├── habilidades.html
│   ├── experiencia.html
│   └── contacto.html
├── css/
│   └── style.css      # Reset + tokens + componentes + utilidades
├── js/
│   ├── data.js         # "Base de datos" en JS: proyectos, habilidades, experiencia
│   └── script.js       # Toda la lógica: render, filtros, validación, animaciones
├── jsp/                # Misma información, pero generada en servidor
│   ├── proyectos.jsp
│   └── contacto.jsp
├── sql/
│   └── schema.sql      # Esquema MySQL que alimenta la versión JSP
└── netlify.toml        # Configuración de despliegue
```

La idea pedagógica: **el mismo contenido se puede servir de dos formas** — renderizado en el navegador (JS + un arreglo de datos) o renderizado en el servidor (JSP + JDBC + MySQL). Comparar ambas versiones ayuda a entender qué hace exactamente un backend que un sitio estático no puede hacer por sí solo.

---

## Paso a paso: cómo construir un portafolio así

### 1. Define el contenido antes que el diseño

Antes de escribir una sola línea de HTML, decide qué secciones necesitas. Este portafolio usa cinco:

- **Inicio** — presentación + resumen en cifras
- **Proyectos** — trabajos destacados, filtrables por tecnología
- **Habilidades** — nivel de dominio por tecnología
- **Experiencia** — trayectoria laboral/académica
- **Contacto** — formulario + newsletter

Escribe primero el contenido real (o de ejemplo) en un archivo de texto o directamente como un arreglo de datos. Aquí ese arreglo vive en [`js/data.js`](js/data.js):

```js
const PROYECTOS = [
  {
    id: 1,
    nombre: "SIGVET — Clínica Veterinaria",
    ruta: "/sigvet",
    descripcion: "Sistema de gestión de fichas clínicas...",
    stack: ["PHP", "MySQL", "Bootstrap"],
    anio: 2025,
    repo: "https://github.com/tu-usuario/tu-proyecto",
  },
  // ...
];
```

Separar los **datos** del **HTML** es la decisión más importante del proyecto: te permite agregar o editar un proyecto sin tocar ninguna página, y es el mismo principio que después vas a replicar con una tabla de base de datos.

### 2. Arma el esqueleto HTML con Bootstrap

Cada página comparte la misma estructura: `<head>` con metadatos, navbar fija, `<main>`, `<footer>`, y al final los `<script>`. Usa Bootstrap 5 vía CDN para no reinventar la grilla ni el navbar responsivo:

```html
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
...
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
```

Duplica esa estructura en cada `.html` (`index.html`, `proyectos.html`, etc.) y deja **contenedores vacíos** donde el contenido dinámico se va a inyectar con JavaScript, por ejemplo:

```html
<div id="lista-proyectos" class="row g-4" aria-live="polite"></div>
```

> ⚠️ Error común (y uno que corregimos en este repo): si tus páginas viven en una subcarpeta como `portafolio/`, las rutas a `css/` y `js/` deben subir un nivel: `../css/style.css`, no `css/style.css`. Pruébalo siempre abriendo el HTML directo en el navegador antes de seguir.

### 3. Escribe el CSS: reset primero, luego tokens, luego componentes

En [`css/style.css`](css/style.css) el archivo sigue un orden fijo que te recomendamos copiar:

1. **CSS Reset** — normaliza márgenes, `box-sizing`, listas, etc. entre navegadores.
2. **Variables / design tokens** (`:root { --ink-900: ...; }`) — define tu paleta y espaciados una sola vez y reutilízalos con `var(--nombre)`.
3. **Base** — tipografía y estilos globales (`body`, `h1`-`h4`, `p`).
4. **Layout** — `.container`, `.section`, grillas propias.
5. **Componentes** — navbar, tarjetas, formularios, cada uno en su propio bloque comentado.
6. **Utilidades** — clases sueltas reutilizables (`.text-amber`, `.rounded-md`).
7. **Media queries** — al final, para que sea fácil encontrar los ajustes responsivos.

Trabajar con variables CSS (`--amber-500`, `--teal-500`, etc.) en vez de colores sueltos hace que cambiar la paleta completa sea cuestión de editar unas 10 líneas en `:root`.

### 4. Genera el contenido dinámico con JavaScript

En [`js/script.js`](js/script.js), cada función revisa si el contenedor que necesita existe antes de actuar — así **un solo archivo sirve para las cinco páginas** sin duplicar lógica:

```js
function renderizarProyectos() {
  const contenedor = document.querySelector("#lista-proyectos");
  if (!contenedor || typeof PROYECTOS === "undefined") return; // no estamos en proyectos.html, no hacer nada

  contenedor.innerHTML = PROYECTOS.map((p) => `...`).join("");
}
```

Patrones que vale la pena aprender de este archivo:

- **Template literals + `.map().join("")`** para convertir un arreglo de datos en HTML.
- **`IntersectionObserver`** para animar elementos (`.reveal`, barras de habilidades) solo cuando entran en pantalla, sin librerías externas.
- **Delegación por atributos `data-*`** (`data-filtro`, `data-typing`) para conectar HTML y JS sin IDs mágicos por todos lados.
- **Un solo `DOMContentLoaded`** al inicio del archivo que llama a todas las funciones; cada función decide si le corresponde ejecutarse.

### 5. Valida los formularios en el navegador

El formulario de contacto usa atributos nativos de HTML5 (`required`, `minlength`, `pattern`, `type="email"`) más una capa de JavaScript que añade una regla que HTML5 no puede expresar (mínimo de palabras):

```js
if (!form.checkValidity()) {
  form.classList.add("was-validated"); // activa los estilos :invalid de Bootstrap
  return;
}
```

Esto es válido para practicar, pero **la validación del navegador nunca es suficiente por sí sola**: cualquiera puede mandar una petición sin pasar por tu formulario. Por eso el siguiente paso es tener también validación en el servidor.

### 6. Agrega una versión con backend (JSP + JDBC)

Para simular un backend real sin salir del proyecto, [`sql/schema.sql`](sql/schema.sql) define dos tablas MySQL:

```sql
CREATE TABLE proyectos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  ...
);

CREATE TABLE mensajes_contacto (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL,
  ...
);
```

Y [`jsp/proyectos.jsp`](jsp/proyectos.jsp) / [`jsp/contacto.jsp`](jsp/contacto.jsp) muestran el mismo contenido pero armado en el servidor:

- **`proyectos.jsp`** hace un `SELECT` con `PreparedStatement`, vuelca el resultado a una lista, y usa JSTL (`<c:forEach>`, `<c:out>`) para pintar el HTML — sin mezclar Java y HTML directamente en el `<c:forEach>`.
- **`contacto.jsp`** repite en Java las mismas validaciones que ya hace el HTML5 (porque el servidor no puede confiar en el navegador) y guarda el mensaje con `PreparedStatement` en vez de concatenar strings, para evitar inyección SQL.

Esta es la lección central de tener ambas versiones: **JS en el navegador puede mostrar datos, pero no puede guardarlos de forma confiable ni segura** — para eso necesitas un servidor con acceso controlado a la base de datos.

Para correr la versión JSP necesitas un servidor con soporte Servlet/JSP (Tomcat) y JSTL en el classpath; crea la base con `sql/schema.sql` y ajusta `jdbcUrl`/`jdbcUser`/`jdbcPass` en los `.jsp` a tu entorno.

### 7. Prueba el sitio localmente

Como es HTML estático, basta con abrir `portafolio/index.html` en el navegador, o levantar un servidor simple:

```bash
npx serve portafolio
```

Revisa en cada página: que cargue el CSS, que el menú marque la página activa, que los formularios validen y que el filtro de proyectos funcione.

### 8. Publica el sitio

Este repo soporta dos formas de publicarlo:

**GitHub Pages** — actívalo en *Settings → Pages*. Como `index.html` no está en la raíz del repo sino en `portafolio/`, la URL principal no mostrará el sitio directamente; tendrás que enlazar a `/portafolio/index.html` o mover los archivos a la raíz.

**Netlify** — más simple gracias a [`netlify.toml`](netlify.toml), que ya deja resuelto el mismo problema:

```toml
[build]
  publish = "."

[[redirects]]
  from = "/"
  to = "/portafolio/index.html"
  status = 200
```

Con esto, conectar el repo en Netlify (*Add new site → Import an existing project*) alcanza para que el dominio raíz muestre el portafolio, sin mover ningún archivo.

---

## Checklist para tu propio portafolio

- [ ] Contenido real (o de ejemplo) definido antes de tocar HTML
- [ ] Datos separados del HTML (un `data.js` o similar)
- [ ] CSS reset + variables de diseño antes que estilos de componentes
- [ ] Un único `script.js` reutilizado en todas las páginas
- [ ] Formularios con validación HTML5 + JS
- [ ] (Opcional) versión con backend real para entender la diferencia
- [ ] Sitio probado localmente antes de publicar
- [ ] Publicado en GitHub Pages y/o Netlify

## Stack usado

`HTML5` · `CSS3` (custom properties, sin preprocesador) · `Bootstrap 5` · `JavaScript` (vanilla, sin frameworks) · `JSP` + `JSTL` + `JDBC` · `MySQL`
