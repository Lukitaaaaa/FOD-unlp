{
2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’. 
}


program tp3.ejercicio2;
type
	asistente = record
		nro_asistente: integer;
		apellido: string;
		nombre: string;
		email: string;
		telefono: integer;
		dni:integer;
	end;
	archivo = file of asistente;

procedure leerRegistro(var a:asistente);
begin
	write('numero: ');
	readln(a.nro_asistente);
	if(a.nro_asistente <> -1) then begin
		write('apellido: ');
		readln(a.apellido);
		write('nombre: ');
		readln(a.nombre);
		write('email: ');
		readln(a.email);
		write('telefono: ');
		readln(a.telefono);
		write('dni: ');
		readln(a.dni);
	end;
end;

procedure crearArchivo(var arc:archivo);
var
	a:asistente;
begin
	assign(arc, 'asistencias');
	rewrite(arc);
	writeln('Ingrese un asistente');
	leerRegistro(a);
	while(a.nro_asistente <> -1) do begin
		write(arc, a);
		leerRegistro(a);
	end;
	close(arc);
end;

procedure imprimirArchivo(var arc:archivo);
var
	a:asistente;
begin
	reset(arc);
	while(not eof(arc))do begin
		read(arc, a);
		writeln('numero: ', a.nro_asistente, '	apellido: ', a.apellido);
	end;
	close(arc);
end;

procedure eliminarAsistentes(var arc:archivo);
var
	a:asistente;
begin
	reset(arc);
	while(not eof(arc)) do begin
		read(arc, a);
		if(a.nro_asistente < 1000)then begin
			a.apellido := '@' + a.apellido;
			seek(arc, filepos(arc)-1);
			write(arc, a);
		end;
	end;
	close(arc);
end;

var
	arc_log:archivo;
BEGIN
	crearArchivo(arc_log);
	imprimirArchivo(arc_log);
	eliminarAsistentes(arc_log);
	imprimirArchivo(arc_log);
END.

