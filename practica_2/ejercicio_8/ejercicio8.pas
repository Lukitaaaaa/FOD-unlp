{
8. Se quiere optimizar la gestión del consumo de yerba mate en distintas provincias de
Argentina. Para ello, se cuenta con un archivo maestro que contiene la siguiente
información: código de provincia, nombre de la provincia, cantidad de habitantes y cantidad
total de kilos de yerba consumidos históricamente.

Cada mes, se reciben 16 archivos de relevamiento con información sobre el consumo de
yerba en los distintos puntos del país. Cada archivo contiene: código de provincia y cantidad
de kilos de yerba consumidos en ese relevamiento. Un archivo de relevamiento puede
contener información de una o varias provincias, y una misma provincia puede aparecer
cero, una o más veces en distintos archivos de relevamiento.
Tanto el archivo maestro como los archivos de relevamiento están ordenados por código de
provincia.

Se desea realizar un programa que actualice el archivo maestro en base a la nueva
información de consumo de yerba. Además, se debe informar en pantalla aquellas
provincias (código y nombre) donde la cantidad total de yerba consumida supere los 10.000
kilos históricamente, junto con el promedio consumido de yerba por habitante. Es importante
tener en cuenta tanto las provincias actualizadas como las que no fueron actualizadas.
Nota: cada archivo debe recorrerse una única vez.

   
}


program tp2.ejercicio8;
const
	valorAlto = 9999;
	DF = 3; //16
type
	subrango = 1..DF;
	regmaestro = record
		codProvincia: integer;
		nombreProvincia:string;
		habitantes:integer;
		kilosConsumidos:integer;
	end;
	
	regdetalle = record
		codProvincia:integer;
		kilosConsumidos:integer
	end;
	
	maestro = file of regmaestro;
	detalle = file of regdetalle;
	vecRegistro = array[subrango]of regdetalle;
	vecDetalle = array[subrango] of detalle;

procedure crearArchivoDetalle(var ad:detalle);
var
	nombre:string;
	carga:text;
	r:regdetalle;
begin
	rewrite(ad);
	
	writeln('Ingrese el nombre del archivo de carga');
	readln(nombre);
	assign(carga,nombre);
	reset(carga);
	while(not eof(carga))do
		with r do begin
			readln(carga, codProvincia, kilosConsumidos);
			write(ad, r);
		end;
	close(carga);
	close(ad);
end;

procedure crearDetalles(var v:vecDetalle);
var
	i:subrango;
begin
	assign(v[1], 'detalle1');
	assign(v[2], 'detalle2');
	assign(v[3], 'detalle3');
	for i:= 1 to DF do
		crearArchivoDetalle(v[i]);
end;

procedure crearArchivoMaestro(var mae: maestro);
var
	carga:text;
	r:regmaestro;
begin
	assign(mae, 'maestro');
	rewrite(mae);
	assign(carga, 'maestro.txt');
	reset(carga);
	while(not eof(carga))do
		with r do begin
			readln(carga, codProvincia, habitantes, kilosConsumidos, nombreProvincia);
			write(mae, r);
		end;
	close(carga);
	close(mae);
end;

procedure imprimirMaestro(var mae:maestro);
var
	r:regmaestro;
begin
	reset(mae);
    while(not eof(mae)) do
        begin
			with r do begin
				read(mae, r);
				writeln('nombre provincia= ', nombreProvincia, ';	Codigo provincia= ', codProvincia, ';	habitantes= ',habitantes, '; kilos consumidos= ', kilosConsumidos);
				
			end;
        end;
    close(mae);
end;

procedure leerDetalle(var ad:detalle; var regm:regdetalle);
begin
	if(not eof(ad))then
		read(ad, regm)
	else
		regm.codProvincia:=valorAlto;
end;

procedure minimo(var vr:vecRegistro; var min:regdetalle; var v:vecDetalle);
var
	pos,i:subrango;
begin
	min.codProvincia:=valorAlto;
	for i:=1 to DF do begin
		if(vr[i].codProvincia <= min.codProvincia)then begin
			min:=vr[i];
			pos:=i;
		end;
	end;
	if(min.codProvincia<>valorAlto)then 
		leerDetalle(v[pos],vr[pos]);
end;

procedure actualizarMaestro(var mae:maestro; var v:vecDetalle);
var
	min:regdetalle;
	regm:regmaestro;
	i:subrango;
	vr:vecRegistro;
	yerbaConsumida:integer;
	promedio:real;
begin
	writeln('ACTUALIZANDO');
	reset(mae);
	for i:=1 to DF do begin
		reset(v[i]);
		leerDetalle(v[i], vr[i]);
	end;
	
	minimo(vr, min, v);
	while(min.codProvincia <> valorAlto)do begin
		read(mae, regm);
		while(regm.codProvincia <> min.codProvincia)do
			read(mae, regm);
		yerbaConsumida:=0;
		while(regm.codProvincia = min.codProvincia)do begin
			regm.kilosConsumidos:= min.kilosConsumidos;
			yerbaConsumida:=yerbaConsumida+ min.kilosConsumidos;
			minimo(vr,min,v);
		end;
		if(regm.kilosConsumidos >= 10000)then begin
			promedio:= yerbaConsumida / regm.habitantes;
			writeln('La provincia', regm.nombreProvincia,' con el codigo ', regm.codProvincia, ', supera los 10000 kilos de yerba consumido con un promedio de ',promedio:0:2, 'kilos por habitante');
		end;
		
		seek(mae, filepos(mae)-1);
		write(mae, regm);
	end;
end;

var
	v:vecDetalle;
	mae:maestro;
BEGIN
	crearDetalles(v);
	crearArchivoMaestro(mae);
	imprimirMaestro(mae);
	actualizarMaestro(mae, v);
	imprimirMaestro(mae);
END.

