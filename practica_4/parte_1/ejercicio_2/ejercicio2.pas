{
2. Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un lado el archivo
que contiene la información de los alumnos de la Facultad de Informática (archivo de datos no
ordenado) y por otro lado mantener un índice al archivo de datos que se estructura como un árbol
B que ofrece acceso indizado por DNI de los alumnos.
a. Defina en Pascal las estructuras de datos correspondientes para el archivo de alumnos y su
índice.
b. Suponga que cada nodo del árbol B cuenta con un tamaño de 512 bytes. ¿Cuál sería el
orden del árbol B (valor de M) que se emplea como índice? Asuma que los números enteros
ocupan 4 bytes. Para este inciso puede emplear una fórmula similar al punto 1b, pero
considere además que en cada nodo se deben almacenar los M-1 enlaces a los registros
correspondientes en el archivo de datos.
c. ¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?
d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678 usando el
índice definido en este punto.
e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido usar el
índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo haría para brindar
acceso indizado al archivo de alumnos por número de legajo?
f. Suponga que desea buscar los alumnas que tiene
}


program untitled;
const 
	m = 3;
type
	alumno = record
		nombre:string[40];
		apellido:string[40];
		dni:integer;
		legajo:integer;
		anioIngreso:integer;
	end;
	
	nodo = record
		cant_claces: integer;
		claves: array[1..m-1] of longint;
		enlaces: array[1..M-1] of integer;
        hijos: array[1..M] of integer;
	end;
	
	archivoAlumn = file of alumno;
	arbolB = file of nodol;
var
	arc: archivoAlumn;
	indices: arbolB;
BEGIN
	
	
END.
{
Cada registro ocupa A = 4 (DNI) + 4 (puntero) = 8 bytes.

Cada enlace a un hijo: 4 bytes.

Tamaño del nodo: 512 bytes.

Campo nClaves (cantidad de claves): 4 bytes.

N = (M-1) * A + (M-1) * A + M * B + C
512 = (M-1) * 4 + (M-1) * 4 + M * 4 + 4
512 = 4M - 4 + 4M - 4 + 4M + 4
512 = 12M - 4
512 + 4 = 12M
516 / 12 = M
M = 43
	
b. el orden del arbol es 43


c. Al almacenar solo la clave y el puntero (en vez de todos los datos), cada registro ocupa mucho menos espacio.
Por lo tanto, M aumenta significativamente (pueden entrar muchas más claves en cada nodo).
Esto hace que el árbol sea más bajo (menos niveles), mejorando la eficiencia de búsquedas e inserciones.

d. Se busca en el árbol la clave con DNI 12345678, aprovechando el criterio de orden, moviéndonos a la izquierda 
si es menor o igual, y en caso contrario, a la derecha. Una vez hallada la clave, uso el NRR guardado en el enlace 
para buscar el registro en el archivo de datos.

e. Si se deseara buscar un alumno por su numero de legajo se deberia realizar una búsqueda secuencial hasta encontrar el alumno con el legajo
solicitado. No tendría sentido en este caso, usar el índice que organiza el acceso al archivo de alumnos por DNI. Para brindar acceso indizado
al archivo de alumnos por número de legajos, lo más conveniente sería armar un nuevo árbol B pero con criterio de orden en base al legajo.

f. La búsqueda por rango en un árbol B indizado solo por DNI es posible, pero no es tan eficiente como la búsqueda exacta, 
ya que una vez encontrado el primer elemento del rango, es necesario recorrer secuencialmente los nodos hoja para obtener 
todos los elementos dentro del rango. Este problema es menos severo en un árbol B+ (donde las hojas suelen estar enlazadas),
pero en un árbol B tradicional requiere más lógica y puede ser más costoso en cuanto a lecturas.
}
