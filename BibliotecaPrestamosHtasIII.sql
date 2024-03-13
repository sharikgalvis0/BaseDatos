CREATE DATABASE Biblioteca
USE Biblioteca

CREATE TABLE Autores ( 
id INT PRIMARY KEY, 
nombre VARCHAR(100) NOT NULL, 
nacionalidad VARCHAR(100), 
fechaNacimiento DATE 
); 

CREATE TABLE Usuarios ( 
id INT PRIMARY KEY, 
nombre VARCHAR(100) NOT NULL, 
email VARCHAR(255), 
fechaNacimiento DATE 
); 
 
CREATE TABLE Editoriales ( 
id INT PRIMARY KEY, 
nombre VARCHAR(100) NOT NULL, 
direccion VARCHAR(255), 
fundacion DATE 
);
 
CREATE TABLE Categorias ( 
id INT PRIMARY KEY, 
nombre VARCHAR(100) NOT NULL, 
descripcion VARCHAR(255) 
); 

CREATE TABLE Libros ( 
id INT PRIMARY KEY, 
titulo VARCHAR(255) NOT NULL, 
autorId INT, 
editorialId INT, 
categoriaId INT, 
fechaPublicacion DATE,
estado varchar (30),
FOREIGN KEY (autorId) REFERENCES Autores(id), 
FOREIGN KEY (editorialId) REFERENCES Editoriales(id), FOREIGN KEY (categoriaId) REFERENCES Categorias(id) ); 
 
CREATE TABLE Biblioteca ( 
id INT PRIMARY KEY, 
nombre VARCHAR(100) NOT NULL, 
direccion VARCHAR(255), 
telefono VARCHAR(20), 
fundacion DATE
);

-- Insertar datos en la tabla Biblioteca 
INSERT INTO Biblioteca (id, nombre, direccion, telefono, fundacion) VALUES 
(1, 'Biblioteca Central', 'Calle Principal 123', '123-456-7890', '1990-01-01'), 
(2, 'Biblioteca Municipal', 'Avenida Central 456', '098-765-4321', '1985-05-15'); 

-- Insertar datos en la tabla Autores 
INSERT INTO Autores (id, nombre, nacionalidad, fechaNacimiento) VALUES 
(1, 'Gabriel Garc�a M�rquez', 'Colombiano', '1927-03-06'), (2, 'J.K. Rowling', 'Brit�nica', '1965-07-31'), 
(3, 'Stephen King', 'Estadounidense', '1947-09-21');

-- Insertar datos en la tabla Editoriales 
INSERT INTO Editoriales (id, nombre, direccion, fundacion) VALUES 
(1, 'Salamandra', 'Barcelona, Espa�a', '1994-01-01'), (2, 'Penguin Random House', 'New York, USA', '2013-07-01');

-- Insertar datos en la tabla Categorias 
INSERT INTO Categorias (id, nombre, descripcion) 
VALUES 
(1, 'Ficci�n', 'Libros de ficci�n'), 
(2, 'No ficci�n', 'Libros de no ficci�n'), 
(3, 'Fantas�a', 'Libros de fantas�a'), 
(4, 'Terror', 'Libros de terror'), 
(5, 'Drama', 'Libros de drama'); 

-- Insertar datos en la tabla Libros 
INSERT INTO Libros (id, titulo, autorId, editorialId, categoriaId, fechaPublicacion, estado) 
VALUES 
(1, 'Cien a�os de soledad', 1, 1, 1, '1967-05-30', 'disponible'), 
(2, 'Harry Potter y la piedra filosofal', 2, 1, 3, '1997-06-26','disponible'),
(3, 'It', 3, 2, 4, '1986-09-15','no disponible'),
(4, 'Cr�nica de una muerte anunciada', 1, 1, 1, '1981-01-01','disponible'),
(5, 'Harry Potter y la c�mara secreta', 2, 1, 3, '1998-07-02', 'disponible'), 
(6, 'Harry Potter y el prisionero de Azkaban', 2, 1, 3, '1999-07-08', 'no disponible'), 
(7, 'Carrie', 3, 2, 4, '1974-04-05', 'no disponible'), 
(8, 'The Shining', 3, 2, 4, '1977-01-28','no disponible'), 
(9, 'La torre oscura', 3, 2, 4, '1982-06-10','disponible'), 
(10, 'Noticias del imperio', 1, 1, 1, '1986-01-01', 'disponible'), 
(11, 'La hojarasca', 1, 1, 1, '1955-01-01', 'disponible'), 
(12, 'El amor en los tiempos del c�lera', 1, 1, 1, '1985-01-01', 'disponible'),
(13, 'Harry Potter y el c�liz de fuego', 2, 1, 3, '2000-07-08', 'no disponible'), 
(14, 'Harry Potter y la Orden del F�nix', 2, 1, 3, '2003-06-21', 'no disponible'),
(15, 'Harry Potter y el misterio del pr�ncipe', 2, 1, 3, '2005-07-16','disponible');

/*						CONSULTAS

1. Consulta para obtener todos los libros de un autor espec�fico. Para esto, deber�
declarar una variable asociada al autor, para que la consulta sea m�s din�mica.*/

DECLARE @autor VARCHAR(100) = 'Gabriel Garc�a M�rquez';
SELECT Libros.titulo
FROM Libros
JOIN Autores ON Libros.autorId = Autores.id
WHERE Autores.nombre = @autor;


/* 2. Consulta para obtener todos los libros de una categor�a determinada. Para esto,
deber� declarar una variable asociada a la categor�a, para que la consulta sea m�s
din�mica. NOTA: busque c�mo declarar una variable en Sql Server.*/

DECLARE @categoria VARCHAR(100) = 'Terror';
SELECT *
FROM Libros
INNER JOIN Categorias ON Libros.categoriaId = Categorias.id
WHERE Categorias.nombre = @categoria;


/* 3. Consulta para obtener todos los libros de Gabriel Garc�a M�rquez, y que hayan
sido publicados despu�s de 1970.*/

SELECT *
FROM Libros
INNER JOIN Autores ON Libros.autorId = Autores.id
WHERE Autores.nombre = 'Gabriel Garc�a M�rquez' AND Libros.fechaPublicacion > '1970-01-01';

/* 4. Consulta para obtener todos los libros de la categor�a Terror y publicados despu�s
de 1976.*/

SELECT libros.*
FROM Libros
INNER JOIN Categorias ON libros.categoriaId = categorias.id
WHERE categorias.nombre = 'Terror' AND libros.fechaPublicacion > '1976-01-01';


/*5. Consulta para obtener todos los libros cuyo t�tulo contenga la palabra Harry.*/
SELECT libros.*
FROM Libros
WHERE libros.titulo LIKE 'Harry';

/*6. Crea un procedimiento almacenado que calcule la cantidad de libros publicados por
una editorial espec�fica. El procedimiento debe tomar el nombre de la editorial como
par�metro de entrada y devolver el n�mero total de libros publicados por esa
editorial.*/

CREATE PROCEDURE SP_LibrosPorEditorial
@nombreEditorial VARCHAR(100)
AS
SELECT COUNT(*) AS CantidadLibros
FROM Libros L
INNER JOIN Editoriales E ON L.editorialId = E.id
WHERE E.nombre = @nombreEditorial;

/* 7. Crea un procedimiento almacenado que devuelva la lista de los libros m�s recientes
por categor�a. El procedimiento debe tomar la categor�a como par�metro de entrada
y devolver una lista de libros ordenados por fecha de publicaci�n, de manera que se
muestre el libro m�s reciente de cada categor�a.*/

CREATE PROCEDURE SP_LibrosMasRecientesPorCategoria
    @nombreCategoria VARCHAR(100)
AS
SELECT *
FROM Libros
WHERE id IN (
    SELECT id
    FROM Libros
    INNER JOIN Categorias ON Libros.categoriaId = Categorias.id
    WHERE Categorias.nombre = @nombreCategoria
    ORDER BY Libros.fechaPublicacion DESC
);

