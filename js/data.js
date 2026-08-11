/**
 * data.js
 * ------------------------------------------------------------------
 * Fuente de datos de los proyectos, mostrada como un arreglo JS.
 *
 * NOTA PEDAGÓGICA:
 * En este entregable estático, los proyectos se renderizan con JS
 * en el navegador. En la versión con JavaServer Pages (ver /jsp),
 * este mismo arreglo vive en una tabla `proyectos` de la base de
 * datos y es JSP + JSTL + JDBC quien genera el HTML en el servidor
 * (ver jsp/proyectos.jsp para el ejemplo comentado).
 * ------------------------------------------------------------------
 */

const PROYECTOS = [
  {
    id: 1,
    nombre: "SIGVET — Clínica Veterinaria",
    ruta: "/sigvet",
    descripcion:
      "Sistema de gestión de fichas clínicas, agenda de horas y control de vacunas para clínicas veterinarias pequeñas.",
    stack: ["PHP", "MySQL", "Bootstrap"],
    anio: 2025,
    repo: "https://github.com/Sakhura/sigvet-clinica",
  },
  {
    id: 2,
    nombre: "RiskGrader — Corrección Automatizada",
    ruta: "/riskgrader",
    descripcion:
      "Pipeline que evalúa entregas de estudiantes contra una rúbrica y genera reportes Word individuales con retroalimentación.",
    stack: ["Python", "Docx", "IA"],
    anio: 2026,
    repo: "https://github.com/Sakhura/riskgrader",
  },
  {
    id: 3,
    nombre: "ConsorcioCore — Módulo Bancario",
    ruta: "/consorciocore",
    descripcion:
      "Optimización de procedimientos almacenados para un sistema de transacciones financieras: paginación, índices y filtros sargables.",
    stack: ["SQL Server", "T-SQL", ".NET"],
    anio: 2025,
    repo: "https://github.com/Sakhura",
  },
  {
    id: 4,
    nombre: "EduTrack — Panel Docente",
    ruta: "/edutrack",
    descripcion:
      "Panel para seguimiento de más de 1.000 estudiantes en distintas instituciones, con métricas de avance por curso.",
    stack: ["Java", "Spring Boot", "JSP"],
    anio: 2024,
    repo: "https://github.com/Sakhura/edutrack",
  },
];

const HABILIDADES = [
  { nombre: "JavaScript / TypeScript", nivel: 92 },
  { nombre: "Java / Spring Boot", nivel: 88 },
  { nombre: "PHP", nivel: 85 },
  { nombre: "Python", nivel: 83 },
  { nombre: "SQL Server / T-SQL", nivel: 90 },
  { nombre: "Bootstrap / CSS responsivo", nivel: 87 },
  { nombre: "Git / GitHub", nivel: 95 },
  { nombre: "Ciberseguridad aplicada", nivel: 80 },
];

const EXPERIENCIA = [
  {
    hash: "a1c5e9f",
    branch: "main",
    fecha: "2023 — actualidad",
    titulo: "Full-Stack Senior Developer",
    empresa: "Banco Consorcio",
    detalle:
      "Desarrollo y mantención de sistemas para clientes de banca corporativa; optimización de procedimientos almacenados y APIs internas.",
  },
  {
    hash: "9b21f3d",
    branch: "docencia",
    fecha: "2022 — actualidad",
    titulo: "Docente universitaria",
    empresa: "UNAB Online · IPChile · AIEP · ESUCOMEX",
    detalle:
      "Cursos de desarrollo web, ciencia de datos, ciberseguridad y desarrollo de videojuegos. Más de 1.000 estudiantes formados.",
  },
  {
    hash: "6e07ab2",
    branch: "consultoria",
    fecha: "2020 — 2023",
    titulo: "Desarrolladora Full-Stack",
    empresa: "S&M Consulting",
    detalle:
      "Implementación de soluciones a medida para múltiples empresas cliente, desde el levantamiento hasta el despliegue.",
  },
  {
    hash: "3f88c10",
    branch: "formacion",
    fecha: "2021 — actualidad",
    titulo: "Estudiante de Ingeniería en Ciencia de Datos",
    empresa: "Universidad Andrés Bello",
    detalle:
      "Profundización en estadística, machine learning y diseño experimental aplicados a proyectos reales.",
  },
];