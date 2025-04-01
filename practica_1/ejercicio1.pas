{
   
1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.
   
}


program tp1.ejercicio1;

type
	archivo = file of integer;
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
	
END.

