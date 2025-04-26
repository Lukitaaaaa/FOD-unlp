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
		personasAlfa:integer;
		encuestados:integer;
	end;
	
	infoAgencias = record
		nombre = string;
		codigo:integer;
		personasAlfa:integer;
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
			readln(carga, personasAlfa, encuestados, nombre);
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
begin
	assign(carga, 'detalle.txt');
	assign(arch, 'detalle');
	rewrite(arch);
	reset(carga);
	while(not eof(carga))do begin
		with i do begin
			readln(carga, codigo, personasAlfa, encuestados, nombre); // no se pueden leer los booleanos
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

procedure actualizarMaestro(var am:maestro; var ad:detalle);
var
	i:infoAgencias;
	p:producto;
begin
	
	reset(am);
	reset(ad);

	
	leerDetalle(ad, i);
	
	while(i.nombre <> fin)do begin
		read(am, p);
		while(i.nombre <> p.nombre ) do
			read(am, p);
		while(i.nombre = p.nombre) do begin
			writeln('Actualizan el codigo: ',i.nombre);
			p.stockDis:= p.stockDis - i.cv;
			leerDetalle(ad, i);
		end;
		seek(am, filepos(am)-1);
		write(am, p);
	end;
	
	close(am);
	close(ad);
end;

BEGIN
	
	
END.

