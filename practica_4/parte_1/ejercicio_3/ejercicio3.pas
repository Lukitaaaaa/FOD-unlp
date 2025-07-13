{
3. Los árboles B+ representan una mejora sobre los árboles B dado que conservan la propiedad de
acceso indexado a los registros del archivo de datos por alguna clave, pero permiten además un
recorrido secuencial rápido. Al igual que en el ejercicio 2, considere que por un lado se tiene el
archivo que contiene la información de los alumnos de la Facultad de Informática (archivo de
datos no ordenado) y por otro lado se tiene un índice al archivo de datos, pero en este caso el
índice se estructura como un árbol B+ que ofrece acceso indizado por DNI al archivo de alumnos.
Resuelva los siguientes incisos:
a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se encuentran
en los nodos internos y que elementos se encuentran en los nodos hojas?
b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por qué?
c. Defina en Pascal las estructuras de datos correspondientes para el archivo de alumnos y su
índice (árbol B+). Por simplicidad, suponga que todos los nodos del árbol B+ (nodos internos y
nodos hojas) tienen el mismo tamaño
d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI específico
haciendo uso de la estructura auxiliar (índice) que se organiza como un árbol B+. ¿Qué
diferencia encuentra respecto a la búsqueda en un índice estructurado como un árbol B?
e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI en el
rango entre 40000000 y 45000000, apoyando la búsqueda en un índice organizado como un
árbol B+. ¿Qué ventajas encuentra respecto a este tipo de búsquedas en un árbol B?

   
}


program untitled;

type
	alumno = record
        nombre: string[40];
        apellido: string[40];
        dni: integer;
        legajo: integer;
        anioIngreso: integer;
    end;
    lista = ^nodo;
    TArchivoDatos = file of alumno;
    nodo = record
        cant_claves: integer;
        claves: array[1..M-1] of longint;
        enlaces: array[1..M-1] of integer;
        hijos: array[1..M] of integer;
        sig: lista;
    end;
	
	arbolB = file of nodo;

BEGIN

	
	
END.
{
a. Nodos internos: Solo contienen las claves (valores de búsqueda, por ejemplo, DNIs) y los punteros a hijos.
NO almacenan datos reales ni punteros directos a los registros del archivo de datos.

Nodos hoja: Contienen las claves y los punteros (o direcciones) a los registros del archivo de datos.
Todas las claves reales y referencias a los datos están en las hojas

b. Las hojas están enlazadas entre sí (mediante punteros o referencias a la hoja siguiente).
Esto permite un recorrido secuencial eficiente y rápido de todos los registros ordenados por la clave, 
útil para búsquedas por rango (por ejemplo, todos los DNIs entre 40.000.000 y 45.000.000).

d. El proceso de busqueda de un alumno con un DNI haciendo uso del árbol B+, consiste en aprovechar el criterio de orden y los 
separadores de los nodos internos, hasta encontrar el dato en una hoja. La diferencia con respecto a un árbol B, es que la búsqueda
siempre termina en un nodo hoja (terminal), y no en los nodos internos, al ser copias.

e. En un árbol B tradicional, no hay enlaces directos entre hojas, por lo que recorrer un rango puede requerir lógica extra y más accesos a disco.
En el árbol B+, el enlace entre hojas permite un recorrido secuencial rápido y directo, optimizando las búsquedas por rango y operaciones que requieren leer datos ordenados.
}
