{
2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).

Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:

a. Actualizar el archivo maestro de la siguiente manera:

i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
y se decrementa en uno la cantidad de materias sin final aprobado.

ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.

b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los
campos de cada alumno en una sola línea del archivo de texto.

NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}


program untitled;
const
	valorAlto = 999;
type
	alumno = record
		codigo:integer;
		apellido:string;
		nombre:string;
		cursadasAprobadas:integer;
		finalesAprobados:integer;
	end;
	info = record
		codigo:integer;
		cursada:boolean;
		final:boolean;
	end;
	
	maestro = file of alumno;
	detalle = file of info;
	
procedure mostrarMenu;
begin
	writeln('=== MENU ===');
	writeln('1. Crear archivo');
	writeln('2. Actualizar maestro');
	writeln('3. Listar alumnos con mas finales aprobados');
	writeln('9. terminar');
end;

procedure crearArchivoMaestro(var arch:maestro);
var
	a:alumno;
	carga:text;
begin
	rewrite(arch);
	assign(carga, 'alumnos.txt');
	reset(carga);
	while(not eof(carga))do begin
		with a do begin
			readln(carga, codigo, cursadasAprobadas, finalesAprobados, apellido);
			readln(carga, nombre);
			write(arch, a);
		end;
	end;
	
	close(arch);
	close(carga);
end;

procedure crearArchivoDetalle(var arch:detalle);
var
	i:info;
	carga:text;
	nota:integer;
	estado:string;
begin
	rewrite(arch);
	assign(carga, 'materias.txt');
	reset(carga);
	while(not eof(carga))do begin
		with i do begin
			readln(carga, codigo, nota, estado); // no se pueden leer los booleanos
			if(nota>=4) then
				final:=true;
			if(estado = 'aprobada') then
				cursada:=true;
			write(arch, i);
		end;
	end;
	
	close(arch);
	close(carga);
end;

procedure leerDetalle(var arc: detalle; var dato: info);
begin
    if(not(eof(arc))) then
        read(arc, dato)
    else
        dato.codigo := valorAlto;
end;

procedure actualizarMaestro(var am:maestro; var ad:detalle);
var
	a:alumno;
	i:info;
begin
	reset(am);
	reset(ad);
	
	leerDetalle(ad, i);
	while(i.codigo <> valorAlto) do begin
		read(am, a);
		while(i.codigo <> a.codigo ) do
			read(am, a);
		while(i.codigo = a.codigo) do begin
			writeln('ACTUALIZANDO EL: ',a.codigo);
			if(i.cursada)then
				a.cursadasAprobadas := a.cursadasAprobadas + 1;
			if(i.final) then begin
				a.finalesAprobados := a.finalesAprobados + 1; 
				a.cursadasAprobadas := a.cursadasAprobadas - 1;
			end;
			leerDetalle(ad, i);
		end;
		seek(am, filepos(am)-1);
		write(am, a);
	end;
	
	close(am);
	close(ad);
end;

procedure listarAlumnosConMasFinales(var m:maestro);
var
	a:alumno;
	arch:text;
begin
	reset(m);
	assign(arch, 'ConMasFinales.txt');
	rewrite(arch);
	
	while(not eof(m)) do begin
		read(m, a);
		if(a.finalesAprobados > a.cursadasAprobadas) then
			writeln(arch, a.codigo, a.apellido, a.nombre, ' ',a.finalesAprobados, ' ', a.cursadasAprobadas);
	end;
	writeln('exportando');
	close(m);
	close(arch);
end;

var
	opcion:integer;
	arch_detalle: detalle;
	arch_maestro: maestro;
BEGIN
	assign(arch_detalle, 'detalle');
	assign(arch_maestro, 'maestro');
	
	mostrarMenu;
	readln(opcion);
	while(opcion<>9) do begin
		case opcion of
			1:begin 
				crearArchivoMaestro(arch_maestro);
				crearArchivoDetalle(arch_detalle);
			end;
			2:actualizarMaestro(arch_maestro, arch_detalle);
			3:listarAlumnosConMasFinales(arch_maestro);
		else writeln('Opcion invalida');
		end;
		mostrarMenu;
		readln(opcion);
	end;
	
END.

