#  Proyecto Base de Datos – Colegio (PostgreSQL + Docker)

## Autor primera parte Fabian David Torres Fandiño

##  1. Diseño Conceptual y Lógico

El modelo se basa en un sistema escolar que gestiona estudiantes, acudientes, profesores, asignaturas, cursos, matrículas y notas.  
El **diagrama entidad-relación (E-R)** refleja las relaciones entre estas entidades principales:

- **Acudiente** → tiene muchos estudiantes.  
- **Estudiante** → pertenece a un acudiente y puede estar matriculado en varios cursos.  
- **Profesor** → dicta varios cursos.  
- **Asignatura** → se enseña en varios cursos.  
- **Curso** → combina profesor, asignatura y año.  
- **Matrícula** → relaciona estudiantes con cursos.  
- **Nota** → pertenece a una matrícula.

 **Evidencia:** diagrama E-R incluido en el archivo  
![entidad relacion](diagrama%20entidad%20relacion%201.png)
![powershell](powershell.png)
![docker](base%20de%20postgres%20en%20docker.png)
![docker2](postgres%20docker.png)
---

##  2. Construcción Física

La base de datos fue implementada en **PostgreSQL** utilizando **Docker**.  
El contenedor se crea con el siguiente comando:

```bash
docker run --name postgres_colegio -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=admin123 -e POSTGRES_DB=colegio_simple -p 5432:5432 -d postgres
```

Posteriormente, se copia y ejecuta el script SQL dentro del contenedor:

```bash
docker cp "colegio_postgres.sql" postgres_colegio:/colegio_postgres.sql
docker exec -it postgres_colegio bash
psql -U admin -d colegio_simple -f /colegio_postgres.sql
```

 El script `colegio_postgres.sql` incluye:
- **DDL (CREATE, ALTER, DROP):** creación de tablas, claves primarias y foráneas, restricciones y reglas de negocio.  
- **Relaciones:** todas las referencias usan claves foráneas con `ON DELETE CASCADE` o `ON DELETE SET NULL`.  

Ejemplo de definición de tabla:
```sql
CREATE TABLE estudiante (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  fecha_nacimiento DATE,
  acudiente_id INT REFERENCES acudiente(id) ON DELETE SET NULL
);
```

---

##  3. Carga de Datos de Ejemplo

El script también contiene **sentencias DML (INSERT)** para probar la estructura:

```sql
INSERT INTO acudiente (nombre, telefono) VALUES
('Laura Martínez', '3001234567'),
('Pedro Rojas', '3017654321');

INSERT INTO estudiante (nombre, fecha_nacimiento, acudiente_id) VALUES
('Juan Pérez', '2010-05-12', 1),
('Ana Rojas', '2011-09-22', 2);
```

 Esto permite validar que las relaciones entre tablas funcionan correctamente (por ejemplo, matrícula y notas vinculadas con claves foráneas).

---

##  4. Conceptos Técnicos Aplicados

- **Normalización:** hasta tercera forma normal (3FN) para evitar redundancias.  
- **Integridad referencial:** mediante claves foráneas y restricciones `ON DELETE`.  
- **Restricciones de dominio:** tipo `CHECK` en notas para limitar valores entre 0 y 100.  
- **Unicidad:** índices únicos en combinaciones como `(profesor_id, asignatura_id, anio)` y `(estudiante_id, curso_id)`.  
- **Dockerización:** despliegue aislado y reproducible del entorno PostgreSQL.

---

##  5. Evidencia del Proyecto

- `base de postgres en docker.png` → Docker Desktop con contenedor activo.  
- `postgres docker.png` → Configuración del contenedor.  
- `powershell.png` → Ejecución de comandos y carga del script.  
- `diagrama entidad relacion 1.png` → Diagrama E-R de la base de datos.


---

##  6. Conclusión

Este proyecto demuestra el proceso completo de diseño e implementación de una base de datos relacional en PostgreSQL usando Docker.  
Incluye diseño conceptual, construcción física, inserción de datos y documentación técnica.

---

#  Proyecto Base de Datos – Colegio (MYSQL + Docker)

## Autor segunda parte Maikoll Daniel Torres Fandiño

El ejercicio se basa en una base de datos de una bilioteca en la que se encuentras las tablas Categoria, Autor, Libro, LibroAutor, Usuario y Prestamo.
El **diagrama entidad-relación (E-R)** refleja las relaciones entre estas entidades principales:

 **Evidencia:** diagrama E-R incluido en el archivo

 ![E-R](7.png)
 Este proyecto muestra la creación, conexión y manipulación de una base de datos llamada **biblioteca** utilizando **MySQL** dentro de un contenedor **Docker**, gestionada mediante la herramienta **HeidiSQL**.


---

### Imagen 1– Ejecución del contenedor MySQL en Docker
 ![imagen1](1.png)

Se muestra la ejecución del siguiente comando en la terminal:

```bash
docker run -d --name mysql-container -e MYSQL_ROOT_PASSWORD=1234 -e MYSQL_DATABASE=biblioteca -e MYSQL_USER=bibliotecario -e MYSQL_PASSWORD=1234 -p 3306:3306 mysql:latest
```

**Descripción:**  
Aquí se levanta un contenedor con la imagen oficial de **MySQL**, exponiendo el puerto 3306 y creando automáticamente la base de datos `biblioteca` junto con el usuario `bibliotecario`.  
Esto permite que HeidiSQL pueda conectarse al servicio de base de datos ejecutándose en Docker.

---
###  Imagen 2 – Configuración de conexión en HeidiSQL
![imagen2](2.png)
En esta imagen se evidencia la ventana del **Administrador de sesiones de HeidiSQL**, configurada para conectarse al servidor MySQL local:

- Host: `127.0.0.1`
- Usuario: `bibliotecario`
- Contraseña: `1234`
- Puerto: `3306`
- Base de datos: `biblioteca`

 **Descripción:**  
Se crea y guarda una sesión para conectar de manera sencilla al contenedor MySQL levantado en Docker, utilizando las credenciales configuradas previamente.

---

###  Imagen 3 – Creación de tablas `Categoria`, `Autor`, `Libro` y `LibroAutor`
![imagen3](3.png)
Aquí se observa la definición de las tablas principales de la base de datos:

- `Categoria`: clasifica los libros.  
- `Autor`: almacena datos de los autores.  
- `Libro`: incluye información bibliográfica y relación con la categoría.  
- `LibroAutor`: tabla intermedia que implementa una **relación muchos a muchos** entre libros y autores.

 **Descripción:**  
Esta estructura refleja un diseño **relacional normalizado**, donde cada entidad se maneja en una tabla independiente y se vincula mediante **foreign keys** para mantener consistencia.

---

### Imagen 4 – Creación de tablas `Usuario` y `Prestamo`
![imagen4](4.png)

En esta captura se muestran las estructuras SQL de las tablas:

- `Usuario`: contiene campos como `nombre`, `apellido`, `correo_electronico` (único) y un campo `tipo_usuario` con valores definidos por un **ENUM**.  
- `Prestamo`: almacena información sobre los préstamos de libros, incluyendo fechas y estado del préstamo, con llaves foráneas que referencian a `Usuario` y `Libro`.

**Descripción:**  
Esta parte del script garantiza la **integridad referencial** entre usuarios y préstamos, además de definir las restricciones necesarias para mantener coherencia en los datos.

---

###  Imagen 5 – Inserción de datos en la tabla `Autor`
![imagen5](5.png)
En esta imagen se observa una sentencia SQL ejecutada en HeidiSQL:

```sql
INSERT INTO Autor(nombre, nacionalidad)
VALUES ("Mario Mendoza", "Colombiano");
```
 **Descripción:**  
Se realiza la inserción de un nuevo registro en la tabla `Autor`, añadiendo un autor con su respectiva nacionalidad. Esto demuestra que la base de datos y las tablas están creadas correctamente y permiten operaciones **INSERT**.

---
###  Imagen 6 – Inserción de datos en la tabla `Autor`
![imagen6](6.png)
En esta imagen se observa el resultado de la sentencia anterior y como los datos fueron ingresados

---
##  Tecnologías utilizadas

- **Docker** – para la gestión del contenedor de MySQL.  
- **MySQL**  – como sistema de gestión de bases de datos relacional.  
- **HeidiSQL**– como cliente gráfico para crear y consultar la base de datos. 





