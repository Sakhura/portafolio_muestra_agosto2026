/**
 * script.js
 * ------------------------------------------------------------------
 * Lógica del sitio: se ejecuta en cada página. Cada bloque revisa si
 * el elemento que necesita existe antes de actuar, así el mismo
 * archivo sirve para las 5 páginas sin duplicar código.
 * ------------------------------------------------------------------
 */

document.addEventListener("DOMContentLoaded", () => {
  marcarEnlaceActivo();
  animarTerminalHero();
  activarRevealAlScroll();
  renderizarProyectos();
  renderizarHabilidades();
  renderizarExperiencia();
  activarFiltroProyectos();
  activarValidacionFormularios();
});

/* -------------------------------------------------------------------
   1) Resalta en el navbar el enlace de la página actual
   ------------------------------------------------------------------- */
function marcarEnlaceActivo() {
  const pagina = window.location.pathname.split("/").pop() || "index.html";
  document.querySelectorAll(".navbar-portfolio .nav-link").forEach((link) => {
    const href = link.getAttribute("href");
    if (href === pagina) {
      link.classList.add("active");
      link.setAttribute("aria-current", "page");
    }
  });
}

/* -------------------------------------------------------------------
   2) Animación de "escritura" en el hero tipo terminal (solo Inicio)
   ------------------------------------------------------------------- */
function animarTerminalHero() {
  const el = document.querySelector("[data-typing]");
  if (!el) return;

  const lineas = JSON.parse(el.getAttribute("data-typing"));
  let lineaActual = 0;
  let charActual = 0;
  const cursor = document.createElement("span");
  cursor.className = "terminal-cursor";

  function escribir() {
    if (lineaActual >= lineas.length) {
      el.appendChild(cursor);
      return;
    }
    const texto = lineas[lineaActual];
    if (charActual <= texto.length) {
      el.textContent = lineas.slice(0, lineaActual).join("\n") +
        (lineaActual > 0 ? "\n" : "") + texto.slice(0, charActual);
      charActual++;
      setTimeout(escribir, 22);
    } else {
      lineaActual++;
      charActual = 0;
      setTimeout(escribir, 350);
    }
  }
  escribir();
}

/* -------------------------------------------------------------------
   3) Revela secciones/tarjetas con una transición suave al hacer scroll
   ------------------------------------------------------------------- */
function activarRevealAlScroll() {
  const elementos = document.querySelectorAll(".reveal");
  if (!("IntersectionObserver" in window) || elementos.length === 0) {
    elementos.forEach((el) => el.classList.add("is-visible"));
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.15 }
  );

  elementos.forEach((el) => observer.observe(el));
}

/* -------------------------------------------------------------------
   4) Renderiza tarjetas de proyecto a partir de PROYECTOS (data.js)
   ------------------------------------------------------------------- */
function renderizarProyectos() {
  const contenedor = document.querySelector("#lista-proyectos");
  if (!contenedor || typeof PROYECTOS === "undefined") return;

  contenedor.innerHTML = PROYECTOS.map(
    (p) => `
    <div class="col-md-6 col-lg-4 reveal" data-stack="${p.stack.join(",")}">
      <article class="project-card">
        <div class="card-body">
          <p class="file-path">~/proyectos${p.ruta}</p>
          <h3 class="mt-1">${p.nombre}</h3>
          <p class="mt-2">${p.descripcion}</p>
          <div class="mt-2">
            ${p.stack.map((t) => `<span class="tag">${t}</span>`).join("")}
          </div>
          <a class="btn-outline-teal d-inline-block mt-3" href="${p.repo}" target="_blank" rel="noopener">
            Ver repositorio →
          </a>
        </div>
      </article>
    </div>`
  ).join("");

  activarRevealAlScroll();
}

/* -------------------------------------------------------------------
   5) Filtro de proyectos por tecnología (interactividad / creatividad)
   ------------------------------------------------------------------- */
function activarFiltroProyectos() {
  const botones = document.querySelectorAll("[data-filtro]");
  if (botones.length === 0) return;

  botones.forEach((btn) => {
    btn.addEventListener("click", () => {
      botones.forEach((b) => b.classList.remove("btn-amber"));
      botones.forEach((b) => b.classList.add("btn-outline-teal"));
      btn.classList.remove("btn-outline-teal");
      btn.classList.add("btn-amber");

      const filtro = btn.getAttribute("data-filtro");
      document.querySelectorAll("#lista-proyectos > div").forEach((tarjeta) => {
        const stack = tarjeta.getAttribute("data-stack") || "";
        const coincide = filtro === "todos" || stack.includes(filtro);
        tarjeta.style.display = coincide ? "" : "none";
      });
    });
  });
}

/* -------------------------------------------------------------------
   6) Renderiza barras de habilidades y anima su ancho al ser visibles
   ------------------------------------------------------------------- */
function renderizarHabilidades() {
  const contenedor = document.querySelector("#lista-habilidades");
  if (!contenedor || typeof HABILIDADES === "undefined") return;

  contenedor.innerHTML = HABILIDADES.map(
    (h) => `
    <div class="skill-row reveal">
      <div class="skill-label">
        <span>${h.nombre}</span>
        <span class="text-amber">${h.nivel}%</span>
      </div>
      <div class="skill-track">
        <div class="skill-fill" data-nivel="${h.nivel}"></div>
      </div>
    </div>`
  ).join("");

  const barras = document.querySelectorAll(".skill-fill");
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.style.width = entry.target.getAttribute("data-nivel") + "%";
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.4 }
  );
  barras.forEach((b) => observer.observe(b));

  activarRevealAlScroll();
}

/* -------------------------------------------------------------------
   7) Renderiza la experiencia como un "git log"
   ------------------------------------------------------------------- */
function renderizarExperiencia() {
  const contenedor = document.querySelector("#git-log");
  if (!contenedor || typeof EXPERIENCIA === "undefined") return;

  contenedor.innerHTML = EXPERIENCIA.map(
    (e) => `
    <div class="commit reveal">
      <p class="commit-hash">commit ${e.hash} <span class="branch-tag">${e.branch}</span></p>
      <p class="commit-meta">${e.fecha}</p>
      <h3 class="mt-1">${e.titulo}</h3>
      <p class="text-teal mb-1">${e.empresa}</p>
      <p>${e.detalle}</p>
    </div>`
  ).join("");

  activarRevealAlScroll();
}

/* -------------------------------------------------------------------
   8) Validación HTML5 + mejoras JS para los formularios
      (contacto, comentarios y newsletter)
   ------------------------------------------------------------------- */
function activarValidacionFormularios() {
  const formularios = document.querySelectorAll("form[data-validar]");

  formularios.forEach((form) => {
    form.addEventListener("submit", (evento) => {
      evento.preventDefault();
      evento.stopPropagation();

      if (!form.checkValidity()) {
        form.classList.add("was-validated");
        const primerInvalido = form.querySelector(":invalid");
        if (primerInvalido) primerInvalido.focus();
        return;
      }

      // Validación adicional a medida (más allá de lo declarativo en HTML5)
      const mensaje = form.querySelector("[name='mensaje']");
      if (mensaje && mensaje.value.trim().split(/\s+/).length < 3) {
        mensaje.setCustomValidity("Cuéntame un poco más (mínimo 3 palabras).");
        form.classList.add("was-validated");
        mensaje.focus();
        return;
      } else if (mensaje) {
        mensaje.setCustomValidity("");
      }

      // En un entorno con backend real, aquí se enviaría el formulario
      // a un endpoint (por ejemplo, el Servlet/JSP de contacto.jsp).
      mostrarToast(form.getAttribute("data-exito") || "¡Listo! Formulario enviado.");
      form.reset();
      form.classList.remove("was-validated");
    });

    // Limpia el mensaje custom apenas el usuario corrige el campo
    form.querySelectorAll("textarea[name='mensaje']").forEach((campo) => {
      campo.addEventListener("input", () => campo.setCustomValidity(""));
    });
  });
}

/* -------------------------------------------------------------------
   9) Pequeño toast de confirmación (sin dependencias externas)
   ------------------------------------------------------------------- */
function mostrarToast(texto) {
  let toast = document.querySelector(".toast-terminal");
  if (!toast) {
    toast = document.createElement("div");
    toast.className = "toast-terminal";
    document.body.appendChild(toast);
  }
  toast.textContent = `✓ ${texto}`;
  toast.classList.add("show");
  clearTimeout(toast._timeout);
  toast._timeout = setTimeout(() => toast.classList.remove("show"), 3200);
}