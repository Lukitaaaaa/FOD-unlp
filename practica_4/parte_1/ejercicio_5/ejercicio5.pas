{
5. Defina los siguientes conceptos:
● Overflow
● Underflow
● Redistribución
● Fusión o concatenación

En los dos últimos casos, ¿cuándo se aplica cada uno?

El overflow ocurre cuando, al insertar una nueva clave en un nodo del árbol, el nodo excede la 
cantidad máxima permitida de claves (M-1 claves para un árbol B de orden M). Cuando hay overflow, 
es necesario dividir el nodo (split), moviendo una clave al nodo padre y creando un nuevo nodo 
para mantener las propiedades del árbol.

El underflow ocurre al eliminar una clave de un nodo y que este quede con menos claves de las 
mínimas permitidas (menos de (M-1)/2 claves en un árbol B de orden M). Cuando hay underflow, se 
debe reorganizar el árbol para que todos los nodos cumplan con la cantidad mínima de claves.

La redistribución (o préstamo) es un proceso que se aplica cuando un nodo tiene underflow 
después de una eliminación, pero uno de sus nodos hermanos adyacentes tiene más claves que el 
mínimo requerido. En este caso, se transfiere una clave del hermano al nodo con underflow, y se 
ajustan las claves en el nodo padre para mantener el orden y las propiedades del árbol.

¿Cuándo se aplica?
Se aplica cuando, tras un underflow, existe un hermano adyacente con más claves que el mínimo.

La fusión (o concatenación) es un proceso que se aplica cuando un nodo tiene underflow y sus 
hermanos adyacentes también tienen el mínimo número de claves. En este caso, se combinan 
(fusionan) el nodo con underflow, uno de sus hermanos y una clave del nodo padre, formando 
un solo nodo. Esto puede provocar que el nodo padre pierda una clave, lo que puede a su vez 
generar un underflow en el padre y requerir que el proceso se repita hacia arriba en el árbol.

¿Cuándo se aplica?
Se aplica cuando, tras un underflow, ningún hermano tiene claves suficientes para redistribuir, 
es decir, todos los hermanos tienen el mínimo permitido.
}



