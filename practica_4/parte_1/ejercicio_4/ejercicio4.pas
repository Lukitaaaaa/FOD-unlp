{
Dado el siguiente algoritmo de búsqueda en un árbol B:

procedure buscar(NRR, clave, NRR_encontrado, pos_encontrada, resultado)
var 
	clave_encontrada: boolean;
begin
	if (nodo = null)
		resultado := false; //clave no encontrada
	else
		posicionarYLeerNodo(A, nodo, NRR); 
		claveEncontrada(A, nodo, clave, pos, clave_encontrada);
		if (clave_encontrada) then begin
			NRR_encontrado := NRR; // NRR actual
			pos_encontrada := pos; // posicione dentro del array
			resultado := true;
		end
		else
			buscar(nodo.hijos[pos], clave, NRR_encontrado, pos_encontrada, resultado)
end;

Asuma que el archivo se encuentra abierto y que, para la primera llamada, el parámetro NRR
contiene la posición de la raíz del árbol. Responda detalladamente:

a. PosicionarYLeerNodo(): Indique qué hace y la forma en que deben ser enviados los
parámetros (valor o referencia). Implemente este módulo en Pascal.

b. claveEncontrada(): Indique qué hace y la forma en que deben ser enviados los
parámetros (valor o referencia). ¿Cómo lo implementaría?

c. ¿Existe algún error en este código? En caso afirmativo, modifique lo que considere necesario.

d. ¿Qué cambios son necesarios en el procedimiento de búsqueda implementado sobre un
árbol B para que funcione en un árbol B+?
}


program untitled;

{a. Se encarga de posicionar el puntero de archivo en el lugar indicado (NRR, Número de Registro Relativo) y 
leer el nodo del árbol B desde el archivo a una variable en memoria.}

procedure PosicionarYLeerNodo(var A: file of TNodoB; var nodo: TNodoB; NRR: integer);
begin
  Seek(A, NRR);          // Posiciona el puntero de archivo en el NRR-ésimo registro
  Read(A, nodo);         // Lee el nodo a la variable 'nodo'
end;

{b. Busca si la clave existe dentro del nodo cargado en memoria. 
Retorna si la encontró, y en qué posición del array de claves del nodo.}

procedure claveEncontrada(const nodo: TNodoB; clave: longint; var pos: integer; var clave_encontrada: boolean);
var
  i: integer;
begin
  clave_encontrada := false;
  pos := 1;
  // Busca la clave en el array ordenado de claves del nodo B
  while (pos <= nodo.nClaves) and (clave > nodo.claves[pos]) do
    pos := pos + 1;
  if (pos <= nodo.nClaves) and (clave = nodo.claves[pos]) then
    clave_encontrada := true;
  // Si no la encontró, pos queda en la posición donde debería insertarse/buscarse.
end;

BEGIN
	
	
END.

{
c. Se está pasando nodo.hijos[pos], pero si la clave no se encuentra, la posición para el hijo a seguir es pos, 
que asume que el array de hijos está alineado con las claves.
Antes de la llamada recursiva, asegurar que el valor de pos esté entre 1 y nodo.nClaves+1.

d. El procedimiento debe continuar descendiendo hasta hoja, sin retornar como “encontrado” cuando encuentra 
la clave en un nodo interno. Solo debe marcar como "encontrado" si la clave está en un nodo hoja.
}
