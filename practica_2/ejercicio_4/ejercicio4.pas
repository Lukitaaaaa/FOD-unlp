{
A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un 
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas 
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos 
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de 
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos 
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle. 

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle      
pueden venir 0, 1 ó más registros por cada provincia.
}


program tp2.ejercicio4;
const
	fin = 'fin';
type
	provincia = record
		nombre:string;
		alfabetizados:integer;
		encuestados:integer;
	end;
	
	infoAgencias = record
		nombre: string;
		codigo:integer;
		alfabetizados:integer;
		encuestados:integer;
	end;
	
	maestro = file of provincia;
	detalle = file of infoAgencias;
	
procedure crearArchivoMaestro(var arch:maestro);
var
	p:provincia;
	carga:text;
begin
	assign(carga, 'maestro.txt');
	assign(arch, 'maestro');
	rewrite(arch);
	reset(carga);
	while(not eof(carga))do begin
		with p do begin
			readln(carga, alfabetizados, encuestados, nombre);
			write(arch, p);
		end;
	end;
	
	close(arch);
	close(carga);
	writeln('ARCHIVO MAESTRO CREADO');
end;

procedure crearArchivoDetalle(var arch:detalle);
var
	i:infoAgencias;
	carga:text;
	nombre:string;
begin
	writeln('Ingrese un nombre de un archivo de carga.txt');
	readln(nombre);
	assign(carga, nombre);
	rewrite(arch);
	reset(carga);
	while(not eof(carga))do begin
		with i do begin
			readln(carga, codigo, alfabetizados, encuestados, nombre); // no se pueden leer los booleanos
			write(arch, i);
		end;
	end;
	
	close(arch);
	close(carga);
	writeln('ARCHIVO DETALLE CREADO');
end;

procedure leerDetalle(var ad:detalle; var dato:infoAgencias);
begin
	if(not eof(ad)) then
		read(ad, dato)
	else
		dato.nombre:= fin;
end;

procedure minimo(var ad1,ad2:detalle;var r1,r2,min:infoAgencias);
begin
	if(r1.nombre <= r2.nombre) then begin
		min:= r1;
		leerDetalle(ad1,r1);
	end
	else begin
		min:= r2;
		leerDetalle(ad2,r2);
	end;
end;

procedure actualizarMaestro(var ad1:detalle; var ad2:detalle; var am:maestro );
var
	r1,r2,min:infoAgencias;
	
	p:provincia;
begin
	
	reset(am);
	reset(ad1);
	reset(ad2);

	
	leerDetalle(ad1, r1);
	leerDetalle(ad2, r2);
	minimo(ad1,ad2,r1,r2,min);
	while(min.nombre <> fin)do begin
		read(am, p);
		while(p.nombre <> min.nombre) do
			read(am, p);
		while(p.nombre = min.nombre) do begin
			p.alfabetizados:= p.alfabetizados + min.alfabetizados;
			p.encuestados:= p.encuestados + min.encuestados; 
			minimo(ad1,ad2,r1,r2,min);
		end;
		seek(am, filepos(am)-1);
		write(am, p);
	end;
	
	close(am);
	close(ad1);
	close(ad2);
end;

procedure imprimirMaestro(var mae: maestro);
var
    s: provincia;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, s);
            writeln('nombre= ', s.nombre, '	alfabetizados= ',s.alfabetizados,'	encuestados= ', s.encuestados );
        end;
    close(mae);
end;

var
	d1,d2:detalle;
	mae:maestro;
BEGIN
	assign(d1, 'detalle1');
	assign(d2, 'detalle2');
	crearArchivoDetalle(d1);
	
	crearArchivoDetalle(d2);
	crearArchivoMaestro(mae);
	
	actualizarMaestro(d1,d2,mae);
	imprimirMaestro(mae);
END.

