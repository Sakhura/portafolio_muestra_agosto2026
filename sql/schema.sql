-- ------------------------------------------------------------------
-- schema.sql
-- Base de datos sencilla para el requisito 5 (JSP + BD) del portafolio.
-- Motor: MySQL / MariaDB
-- ------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS portafolio_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE portafolio_db;

CREATE TABLE IF NOT EXISTS proyectos (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(120)  NOT NULL,
  ruta         VARCHAR(120)  NOT NULL,
  descripcion  VARCHAR(400)  NOT NULL,
  stack        VARCHAR(150)  NOT NULL,
  anio         SMALLINT      NOT NULL,
  repo         VARCHAR(255)  NOT NULL
);

CREATE TABLE IF NOT EXISTS mensajes_contacto (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(80)   NOT NULL,
  correo       VARCHAR(120)  NOT NULL,
  motivo       VARCHAR(40)   NOT NULL,
  mensaje      VARCHAR(600)  NOT NULL,
  fecha_envio  DATETIME      NOT NULL
);

-- Datos de ejemplo (los mismos que en js/data.js, para que ambas
-- versiones —estática y con JSP— muestren la misma información)
INSERT INTO proyectos (nombre, ruta, descripcion, stack, anio, repo) VALUES
('SIGVET — Clínica Veterinaria', '/sigvet', 'Sistema de gestión de fichas clínicas, agenda de horas y control de vacunas.', 'PHP, MySQL, Bootstrap', 2025, 'https://github.com/Sakhura/sigvet-clinica'),
('RiskGrader — Corrección Automatizada', '/riskgrader', 'Pipeline que evalúa entregas contra una rúbrica y genera reportes Word.', 'Python, Docx, IA', 2026, 'https://github.com/Sakhura/riskgrader'),
('ConsorcioCore — Módulo Bancario', '/consorciocore', 'Optimización de procedimientos almacenados para transacciones financieras.', 'SQL Server, T-SQL, .NET', 2025, 'https://github.com/Sakhura'),
('EduTrack — Panel Docente', '/edutrack', 'Panel de seguimiento de estudiantes en distintas instituciones.', 'Java, Spring Boot, JSP', 2024, 'https://github.com/Sakhura/edutrack');