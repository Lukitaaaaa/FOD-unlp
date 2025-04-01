{
3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.
   
}


program tp1.ejercicio3;


type

	empleado = record
		num:integer;
		apellido:string;
		nombre:string;
		edad:integer;
		dni:integer;
	end;
	
	archivo = file of empleado;
	
procedure leerEmpleado(var e:empleado);
begin
	writeln('apellido: ');
	readln(e.apellido);
	if(e.apellido <> 'fin') then begin
		writeln('numero: ');
		readln(e.num);
		writeln('nombre: ');
		readln(e.nombre);
		writeln('edad: ');
		readln(e.edad);
		writeln('dni: ');
		readln(e.dni);
	end;
end;
procedure imprimirEmpleado(e:empleado);
begin
	writeln('datos de ', e.apellido);
	write('nombre: ',e.nombre);
	write('apellido: ',e.apellido);
	write('dni: ',e.dni);
	write('numero de empleado: ',e.num);
	write('edad: ',e.edad);
	
end;
procedure listarEmpleadoDeterminado(var a:archivo);
var
	emp:empleado;
	nombre: string;
begin
	writeln('ingrese un apellido o nombre determinado');
	read(nombre);
	reset(a);
	while not eof(a) do begin
		read(a, emp);
		if((emp.nombre = nombre)or(emp.apellido = nombre)) then
			imprimirEmpleado(emp);
	end;
	close(a);
end;
var
	arc_log: archivo;
	arc_fis:string;
	e:empleado;
BEGIN
	writeln('Ingrese nombre del archivo');
	read(arc_fis); // SE LE PONE NOMBRE AL ARCHIVO
	assign(arc_log, arc_fis); // SE RELACIONA arc_log y arc_fis
	
	rewrite(arc_log); // SE CREA EL ARCHIVO
	writeln('Ingrese un empleado');
	leerEmpleado(e);
	while(e.apellido <> 'fin') do begin
		writeln('Ingrese un empleado');
		write(arc_log, e); //SE ESCRIBE EN EL ARCHIVO UN NUMERO
		leerEmpleado(e);
	end;
	
	close(arc_log);
	listarEmpleadoDeterminado(arc_log);
END.

