CREATE DATABASE colegio_simple;
\c colegio_simple;

CREATE TABLE acudiente (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(30)
);

CREATE TABLE estudiante (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  fecha_nacimiento DATE,
  acudiente_id INT REFERENCES acudiente(id) ON DELETE SET NULL
);

CREATE TABLE profesor (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE
);

CREATE TABLE asignatura (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE curso (
  id SERIAL PRIMARY KEY,
  profesor_id INT NOT NULL REFERENCES profesor(id) ON DELETE CASCADE,
  asignatura_id INT NOT NULL REFERENCES asignatura(id) ON DELETE CASCADE,
  anio INT NOT NULL,
  CONSTRAINT uq_curso UNIQUE (profesor_id, asignatura_id, anio)
);

CREATE TABLE matricula (
  id SERIAL PRIMARY KEY,
  estudiante_id INT NOT NULL REFERENCES estudiante(id) ON DELETE CASCADE,
  curso_id INT NOT NULL REFERENCES curso(id) ON DELETE CASCADE,
  CONSTRAINT uq_matricula UNIQUE (estudiante_id, curso_id)
);

CREATE TABLE nota (
  id SERIAL PRIMARY KEY,
  matricula_id INT NOT NULL REFERENCES matricula(id) ON DELETE CASCADE,
  calificacion NUMERIC(5,2) CHECK (calificacion >= 0 AND calificacion <= 100)
);


INSERT INTO acudiente (nombre, telefono) VALUES
('Laura Martínez', '3001234567'),
('Pedro Rojas', '3017654321');

INSERT INTO estudiante (nombre, fecha_nacimiento, acudiente_id) VALUES
('Juan Pérez', '2010-05-12', 1),
('Ana Rojas', '2011-09-22', 2);

INSERT INTO profesor (nombre, email) VALUES
('Carlos Ramírez', 'carlos@colegio.edu'),
('María Gómez', 'maria@colegio.edu');

INSERT INTO asignatura (nombre) VALUES
('Matemáticas'), ('Ciencias');

INSERT INTO curso (profesor_id, asignatura_id, anio) VALUES
(1,1,2025), (2,2,2025);

INSERT INTO matricula (estudiante_id, curso_id) VALUES
(1,1), (2,2);

INSERT INTO nota (matricula_id, calificacion) VALUES
(1,88.5), (2,95.0);
