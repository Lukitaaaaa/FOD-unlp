{
Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.

}


program tp3.ejercicio1;

type

	empleado = record
		num:integer;
		apellido:string;
		nombre:string;
		edad:integer;
		dni:integer;
	end;
	
	archivo = file of empleado;
procedure mostrarMenu;
begin
	writeln('=== MENU ===');
	writeln('1. Crear archivo');
	writeln('2. Listar empleados con un nombre determinado');
	writeln('3. Listar empleados');
	writeln('4. Listar empleados mayores a 70 anos');
	writeln('5. Agregar empleados');
	writeln('6. Modificar edad a un empleado');
	writeln('7. Exportar archivo');
	writeln('8. Exportar empleados con DNI igual a 00');
	writeln('9. Cerrar');
end;

procedure leerEmpleado(var e:empleado);
begin
	writeln('Ingrese un empleado...');
	writeln('apellido: ');
	readln(e.apellido); // Usar readln aquí
	if (e.apellido <> 'fin') then begin
		writeln('nombre: ');
		readln(e.nombre); // Usar readln aquí
		writeln('numero: ');
		readln(e.num); // Usar readln aquí
		writeln('edad: ');
		readln(e.edad); // Usar readln aquí
		writeln('dni: ');
		readln(e.dni); // Usar readln aquí
	end;
end;

procedure imprimirEmpleado(e:empleado);
begin
	writeln(' - apellido: ', e.apellido,' nombre: ',e.nombre,' dni: ',e.dni,' numero de empleado: ',e.num,' edad: ',e.edad);	
end;
procedure listarEmpleadoDeterminado(var a:archivo);
var
	emp:empleado;
	nombre: string;
begin
	writeln('ingrese un apellido o nombre determinado');
	readln(nombre);
	reset(a);
	while not eof(a) do begin
		read(a, emp);
		if((emp.nombre = nombre)or(emp.apellido = nombre)) then
			imprimirEmpleado(emp);
	end;
	close(a);
end;

procedure listarEmpleados(var a:archivo);
var
	emp:empleado;
begin
	writeln('Lista de empleados');
	reset(a);
	while not eof(a) do begin
		read(a, emp);
		imprimirEmpleado(emp);
	end;
	close(a);
end;

procedure empleadosMayores(var a:archivo);
var
	emp:empleado;
begin
	writeln('Lista de empleados mayores a 70 anos');
	reset(a);
	while not eof(a) do begin
		read(a, emp);
		if(emp.edad>70)then
			imprimirEmpleado(emp);
	end;
	close(a);
end;

function existeNumero(var a:archivo; n:integer):boolean;
var
	emp:empleado;
	esta:boolean;
begin
	esta:=false;
	Seek(a, 0);
	while ((not eof(a)) and (not esta)) do begin
		read(a, emp);
		if(emp.num = n) then
			esta:= true; 
	end;
	existeNumero:= esta;
end;

procedure agregarEmpleados(var a:archivo);
var
	e:empleado;
begin
	reset(a);
	leerEmpleado(e);
	while(e.apellido <> 'fin') do begin
		if(existeNumero(a, e.num)) then
			writeln('Ya existe este numero de empleado')
		else begin
			Seek(a, filesize(a));
			write(a, e);
		end; 
		leerEmpleado(e);
	end;
	
	close(a);
end;

procedure crearArchivo(var a:archivo; var nombre:string);
var 
	e:empleado;
begin
	writeln('Ingrese nombre del archivo');
	readln(nombre); // SE LE PONE NOMBRE AL ARCHIVO
	assign(a, nombre); // SE RELACIONA arc_log y arc_fis
	rewrite(a); // SE CREA EL ARCHIVO
	leerEmpleado(e);
	while (e.apellido <> 'fin') do begin
		write(a, e);
		leerEmpleado(e);
	end;
	close(a);
end;

procedure modificarEdad(var a:archivo);
var
	n,edad:integer;
	emp:empleado;
begin
	reset(a);
	writeln('Ingrese un numero de empleado para modificar su edad');
	readln(n);
	if(existeNumero(a, n)) then begin
		Seek(a,0);
		writeln('Ingrese la nueva edad del empleado ', n);
		readln(edad);
		while not eof(a) do begin
			read(a, emp);
			if(emp.num = n) then begin
				Seek(a, filepos(a)-1);
				emp.edad := edad;
				write(a, emp);
				writeln('se modifico la edad del empleado ',emp.num, ' con ', edad, ' anos');
			end;
		end;
	end
	else writeln('El numero igresado no existe');
	close(a);
end;

procedure exportarArchivo(var a:archivo);
var
	e:empleado;
	nom:string;
	archTxt:text;
begin
	reset(a);
	nom:='todos_empleados';
	Assign(archTxt,nom);
	rewrite(archTxt);
	while(not eof(a))do begin
		read(a,e);
		writeln(archTxt,'numero: ',e.num,' nombre: ',e.nombre,' apellido: ',e.apellido,' dni: ',e.dni,' edad: ',e.edad);
	end;
	close(a);
	close(archTxt);
end;

procedure exportarEmpleadosSinDNI(var a:archivo);
var
	nombre:string;
	e:empleado;
	archDNI:text;
begin
	nombre:='faltaDNIEmpleado.txt';
	reset(a);
	Assign(archDNI, nombre);
	rewrite(archDNI);
	while(not eof(a)) do begin
		read(a, e);
		if(e.dni = 00) then
			writeln(archDNI,'numero: ',e.num,' nombre: ',e.nombre,' apellido: ',e.apellido,' dni: ',e.dni,' edad: ',e.edad);
	end;
	close(a);
	close(archDNI);
end;

var
	arc_log: archivo;
	arc_fis:string;
	opcion: integer;
BEGIN
	mostrarMenu;
	readln(opcion);
	while(opcion<>9) do begin
		case opcion of
			1:crearArchivo(arc_log, arc_fis);
			2:listarEmpleadoDeterminado(arc_log);
			3:listarEmpleados(arc_log);
			4:empleadosMayores(arc_log);
			5:agregarEmpleados(arc_log);
			6:modificarEdad(arc_log);
			7:exportarArchivo(arc_log);
			8:exportarEmpleadosSinDNI(arc_log);
		else writeln('Opcion invalida');
		end;
		mostrarMenu;
		readln(opcion);
	end;
END.
