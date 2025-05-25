{
Se dispone de un archivo maestro con información de los alumnos de la Facultad de
Informática. Cada registro del archivo maestro contiene: código de alumno, apellido, nombre,
cantidad de cursadas aprobadas y cantidad de materias con final aprobado. El archivo
maestro está ordenado por código de alumno.

Además, se tienen dos archivos detalle con información sobre el desempeño académico de
los alumnos: un archivo de cursadas y un archivo de exámenes finales. El archivo de
cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa si la
cursada fue aprobada o desaprobada). Por su parte, el archivo de exámenes finales
contiene información sobre los exámenes finales rendidos. Cada registro incluye: código de
alumno, código de materia, fecha del examen y nota obtenida. Ambos archivos detalle
están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o
más registros por alumno en el archivo maestro. Un alumno podría cursar una materia
muchas veces, así como también podría rendir el final de una materia en múltiples
ocasiones.

Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad
de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la
información de los archivos detalle. Las reglas de actualización son las siguientes:

- Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas
aprobadas.

- Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad
de materias con final aprobado.

Notas:

● Los archivos deben procesarse en un único recorrido.

● No es necesario comprobar que no haya inconsistencias en la información de los
archivos detalles. Esto es, no puede suceder que un alumno apruebe más de una
vez la cursada de una misma materia (a lo sumo la aprueba una vez), algo similar
ocurre con los exámenes finales
   
}


program tp2.ejercicio7;
const
	valorAlto = 9999;
type
	//oredenado por codigo
	alumno = record
		codigo:integer;
		apellido:string;
		nombre:string;
		cantCursadasApro:integer;
		cantFinalesApro:integer;
	end;
	
	
	//ordenados por codAlumno y codMateria
	cursada = record
		codAlumno:integer;
		codMateria:integer;
		anoCursada:integer;
		estatus:string;
	end;
	
	final = record
		codAlumno:integer;
		codMateria:integer;
		anoCursada:integer;
		resultado:integer;
	end;
	
	minimoReg = record
		codAlumno:integer;
		codMateria:integer;
		anoCursada:integer;
		estatus:string;
		resultado:integer;
	end;
	
	maestro = file of alumno;
	detalleC = file of cursada;
	detalleF = file of final;

procedure crearArchivoDetalleC(var dc:detalleC);
var
	carga:text;
	c:cursada;
begin
	assign(dc,'detalleC');
	rewrite(dc);
	assign(carga,'detalleC.txt');
	reset(carga);
	while not eof(carga)do
		with c do begin
			readln(carga, codAlumno, codMateria, anoCursada, estatus);
			write(dc, c);
		end;
	close(dc);
	close(carga);
end;

procedure crearArchivoDetalleF(var df:detalleF);
var
	carga:text;
	f:final;
begin
	assign(df,'detalleF');
	rewrite(df);
	assign(carga,'detalleF.txt');
	reset(carga);
	while not eof(carga)do
		with f do begin
			readln(carga, codAlumno, codMateria, anoCursada, resultado);
			write(df, f);
		end;
	close(df);
	close(carga);
end;

procedure crearArchivoMaestro(var mae:maestro);
var
	carga:text;
	a:alumno;
begin
	assign(mae, 'maestro');
	rewrite(mae);
	
	assign(carga, 'maestro.txt');
	reset(carga);
	
	while(not eof(carga)) do begin
		with a do begin
			readln(carga, codigo, cantCursadasApro, cantFinalesApro, nombre);
			readln(carga, apellido);
			write(mae, a);
		end;
	end;
	close(mae);
	close(carga);
end;

procedure imprimirMaestro(var mae: maestro);
var
    a:alumno;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
			with a do begin
				read(mae, a);
				writeln('Codigo= ', codigo, '	cursadasAprobadas= ',cantCursadasApro, '	finalesAprobados= ',cantFinalesApro, '	Nombre= ',nombre, ' ',apellido);
			
			end;
        end;
    close(mae);
end;

procedure leerDetalleC(var dc:detalleC; var c:cursada);
begin
	if(not eof(dc))then
		read(dc, c)
	else
		c.codAlumno:= valorAlto;
end;

procedure leerDetalleF(var df:detalleF; var f:final);
begin
	if(not eof(df))then
		read(df, f)
	else
		f.codAlumno:= valorAlto;
end;

procedure minimo(var dc:detalleC; var df:detalleF; var c:cursada; var f:final;  var min:minimoReg);
begin
	if(f.codAlumno <= c.codAlumno)then begin
		writeln('SE LEE FINAL CON NOTA ',f.resultado);
		min.codAlumno:= f.codAlumno;
		min.codMateria:=f.codMateria;
		min.anoCursada:=f.anoCursada;
		min.resultado:=f.resultado;
		min.estatus:='';
		leerDetalleF(df, f);
	end
	else begin
		writeln('SE LEE CURSADA CON ESTATUS ', c.estatus);
		min.codAlumno:= c.codAlumno;
		min.codMateria:=c.codMateria;
		min.anoCursada:=c.anoCursada;
		min.estatus:=c.estatus;
		min.resultado:=0;
		leerDetalleC(dc, c);
	end;
end;

procedure actualizarMaestro(var mae:maestro; var dc:detalleC; var df:detalleF);
var
	a:alumno;
	c:cursada;
	f:final;
	min:minimoReg;
begin
	reset(mae);
	reset(dc);
	reset(df);
	writeln('==== ACTUALIZANDO ====');
	leerDetalleC(dc, c);
	leerDetalleF(df, f);
	minimo(dc,df,c,f,min);
	while(min.codAlumno <> valorAlto) do begin
		read(mae, a);
		while(a.codigo <> min.codAlumno) do
			read(mae,a);
		while(a.codigo = min.codAlumno) do begin
			writeln('del alumno: ',min.codAlumno);
			
			if(min.estatus = ' A') then begin
				a.cantCursadasApro:= a.cantCursadasApro + 1;
				writeln(min.estatus);
			end;
			if(min.resultado >= 4)then
				a.cantFinalesApro:= a.cantFinalesApro + 1;
			minimo(dc,df,c,f,min);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, a);
	end;
	
	close(df);
	close(dc);
	close(mae);
end;

var
	arcDetalleCursada:detalleC;
	arcDetalleFinal:detalleF;
	arcMaestro:maestro;
BEGIN
	crearArchivoDetalleC(arcDetalleCursada);
	crearArchivoDetalleF(arcDetalleFinal);
	crearArchivoMaestro(arcMaestro);
	imprimirMaestro(arcMaestro);
	actualizarMaestro(arcMaestro, arcDetalleCursada, arcDetalleFinal);
	imprimirMaestro(arcMaestro);
	
END.

