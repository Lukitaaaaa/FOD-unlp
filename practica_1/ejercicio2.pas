{
2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.
   
}


program tp1.ejercicio2;

type
	archivo = file of integer;
procedure informarMenores(var a:archivo);
var
	num, cant, cantTotal, suma:integer;
	prom: real;
begin
	writeln('=== Lista de numeros en el archivo ===');
	reset(a);
	cant:=0;
	cantTotal:=0;
	suma:=0;
	while not eof(a) do begin
		read(a, num);
		if( num < 1500 )then
			cant:= cant + 1;
		cantTotal := cantTotal + 1;
		suma:= suma + num;
		writeln(num);
	end;
	prom:= suma / cantTotal;
	writeln('El promedio de la suma de los numeros es de: ', prom);
	writeln('La cantidad de numeros menores a 1500 son: ', cant);
	close(a);
end;

var
	arc_log: archivo;
	arc_fis:string;
	num:integer;
BEGIN
	writeln('Ingrese nombre del archivo');
	read(arc_fis); // SE LE PONE NOMBRE AL ARCHIVO
	assign(arc_log, arc_fis); // SE RELACIONA arc_log y arc_fis
	
	rewrite(arc_log); // SE CREA EL ARCHIVO
	writeln('Ingrese un numero');
	read(num);
	while(num <> 30000) do begin
		writeln('Ingrese un numero');
		write(arc_log, num); //SE ESCRIBE EN EL ARCHIVO UN NUMERO
		read(num);
	end;
	
	close(arc_log);
	informarMenores(arc_log);
END.

