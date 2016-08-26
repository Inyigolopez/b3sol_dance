# b3sol_dance

Planteamiento del problema:

-Dado que los alumnos no pueden ir vestidos al baile del mismo color que sus rivale, podemos abstraer el problema como un problema de grafos, donde cada alumno es un Nodo y su rivalidad con otro alumno es una arista, de tal forma que tenemos que colorear todos los nodos de grafo sin que coincidan 2 nodos que esten unidos.

Algoritmo:

- Dado que hay infinidad de colores, una posible solución es elegir un color distinto para cada alumno con lo cual hemos solventado el problema. Esta solucion no es única ya que hay millones de colores ( 256³ en RGB ) y mientras el número de bailarines, n, sea menor, siempre podriamos tomar combinaciones de n colores de entre los 256³.
- Si queremos optimizar el número de colores utilizados, entonces podemos utilizar un algoritmos heuristico, aunque la solución tampoco sería unica, ya que según el nodo por el que empecemos a colorear, obtendriamos diferentes soluciones.

-El algoritmo heuristico que he utilizado consiste en crear el grafo ( ayudado por el paquete 'igraph' de R ) con el fichero del problema, del que obtenemos los 'edges'.
Una vez creado el grafo, obtenemos su matriz de adyacencias, que es una matriz simetrica nxn donde en caso de que el nodo n1 este unido al nodo n2, en la celda (n1,n2) de la matriz tenemos un 1, y en caso contrario un 0.

-Una vez creada la matriz de adyacencias recorremos mediante 3 bucles:
	- El bucle 1 va a recorrer cada fila de la matriz, que representa a un nodo, y en cada ejecución de un paso completo del bucle, obtendremos el color con el que colorearemos ese nodo.
	 
	- El segundo bucle recorre el vector de codificación de colores (valores 1,2,3....n ). En caso que ese color no pueda ser utilizado pasaremos al siguiente color y comenzaremos de nuevo.
	 
	- El tercer bucle recorre cada una de las columnas de la matriz, que representan el resto de nodos. Para cada uno, comparamos si hay rivalidad entre los nodos y en caso de haberla, si el color que estamos utilizando esta asignado al nodo rival en el vector de asignación de colores. En caso de ser asi, salimos del bucle, elegimos el siguiente color y volvemos a evaluar a todos los nodos rivales. En caso contrario, continuamos con el siguiente nodo rival. Si acabada la evaluación contra todos los nodos rivales, no encontramos incompatibilidad, asignamos el color del bucle 2 al nodo del bucle 1.

Una vez acabado el proceso, asignamos el vector de colores a nuestro grafo para que coloree los nodos en función del resultado. 
