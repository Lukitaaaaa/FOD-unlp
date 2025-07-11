{

Parte 1: Archivos de datos, índices y árboles B

1. Considere que desea almacenar en un archivo la información correspondiente a los alumnos de la
Facultad de Informática de la UNLP. De los mismos deberá guardarse nombre y apellido, DNI, legajo
y año de ingreso. Suponga que dicho archivo se organiza como un árbol B de orden M.
a. Defina en Pascal las estructuras de datos necesarias para organizar el archivo de alumnos
como un árbol B de orden M.
b. Suponga que la estructura de datos que representa una persona (registro de persona)
ocupa 64 bytes, que cada nodo del árbol B tiene un tamaño de 512 bytes y que los números
enteros ocupan 4 bytes, ¿cuántos registros de persona entrarían en un nodo del árbol B?
¿Cuál sería el orden del árbol B en este caso (el valor de M)? Para resolver este inciso, puede
utilizar la fórmula N = (M-1) * A + M * B + C, donde N es el tamaño del nodo (en bytes), A es el
tamaño de un registro (en bytes), B es el tamaño de cada enlace a un hijo y C es el tamaño
que ocupa el campo referido a la cantidad de claves. El objetivo es reemplazar estas
variables con los valores dados y obtener el valor de M (M debe ser un número entero,
ignorar la parte decimal).
c. ¿Qué impacto tiene sobre el valor de M organizar el archivo con toda la información de los
alumnos como un árbol B?
d. ¿Qué dato seleccionaría como clave de identificación para organizar los elementos
(alumnos) en el árbol B? ¿Hay más de una opción?
e. Describa el proceso de búsqueda de un alumno por el criterio de ordenamiento
especificado en el punto previo. ¿Cuántas lecturas de nodos se necesitan para encontrar un
alumno por su clave de identificación en el peor y en el mejor de los casos? ¿Cuáles serían
estos casos?
f. ¿Qué ocurre si desea buscar un alumno por un criterio diferente? ¿Cuántas lecturas serían
necesarias en el peor de los casos?
   
}


program untitled;
const 
	m = 4;
type
	alumno = record;
		nombre:string[40];
		apellido:string[40];
		dni:integer;
		legajo:integer;
		anioIngreso:integer;
	end;
	
	nodo = record
		cantClaves:integer;
		clave: array[1..m-1] of alumno;
		hijos: array[1..m] of integer;
	end;
	
	arbol = file of nodo;
BEGIN
	{
	A: regPersona = 64 bytes
	N: nodo = 512 bytes
	B y C: integer = 4 bytes
	
	formula 
	N = (M-1) * A + M * B + C
	512 = (M-1) * 64 + M * 4 + 4
	508 = 64M - 64 + 4M
	572 = 68M
	572/68 = M
	8.4 = M
	}
	
END.
{

c. Cuanto más información guarde por alumno, menor será M y, por lo tanto, el árbol será más alto (más niveles).

d. Se pueden usar el DNI o el legajo ya que son unicos.

e. En el mejor caso se hara 1 lectura por se encontro en la raiz. En el peor caso, la cantidad de lecturas seria igual a la altura(h) del arbol

f. Si se busca por un campo que no es la clave de ordenamiento (por ejemplo, por apellido), No se podria aprovechar la estructura de busqueda eficiente
y habria que recorrer todo el arbol. En el peor de los casos se leen todos los nodos

}


