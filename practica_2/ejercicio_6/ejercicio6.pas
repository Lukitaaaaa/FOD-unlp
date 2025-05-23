{
6. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.

Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.

El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.

Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:

1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).

}


program tp2.ejercicio6;
const
	valorAlto = 9999;
	DF = 3;
type
	
	subrango = 1..DF;
	infoMunicipio = record
		codigoLocalidad:integer;
		codigoCepa:integer;
		casosActivos:integer;
		casosNuevos:integer;
		recuperados:integer;
		fallecidos:integer;
	end;
	
	infoMini = record
		codigoLocalidad:integer;
		nombreLocalidad:string;
		codigoCepa:integer;
		nombreCepa:string;
		casosActivos:integer;
		casosNuevos:integer;
		recuperados:integer;
		fallecidos:integer;
	end;
	
	detalle = file of infoMunicipio;
	maestro = file of infoMini;
	vecDetalle = array[subrango] of detalle;
	vecRegistro = array[subrango] of infoMunicipio;

procedure crearArchivoDetalle(var a: detalle);
var
	carga:text;
	nombre:string;
	i:infoMunicipio;
begin
	writeln('Ingrese el nombre del nuevo archivo');
	readln(nombre);
	assign(a, nombre);
	rewrite(a);
	writeln('Ingrese el nombre del nuevo archivo');
	readln(nombre);
	assign(carga, nombre);
	reset(carga);
	while not eof(carga) do begin
		with i do begin
			read(carga, codigoLocalidad, codigoCepa, casosActivos, casosNuevos, recuperados, fallecidos);
			write(a, i);
		end;
	end;
	
	close(carga);
	close(a);
end;

procedure crearDetalles(var v:vecDetalle);
var
	i:subrango;
begin
	for i:= 1 to DF do
		crearArchivoDetalle(v[i]);
end;

procedure crearArchivoMaestro(var a:maestro);
var
	nombre:string;
	carga:text;
	i:infoMini;
begin
	writeln('Ingrese un nombre para el archivo maestro');
	readln(nombre);
	assign(a, nombre);
	rewrite(a);
	
	writeln('Ingrese el nombre del archivo de carga');
	readln(nombre);
	assign(carga, nombre);
	reset(carga);
	
	while(not eof(carga)) do begin
		with i do begin
			readln(carga, codigoLocalidad, codigoCepa, casosActivos, casosNuevos, recuperados, fallecidos, nombreCepa);
			readln(carga, nombreLocalidad);
			write(a, i);
		end;
	end;
	close(a);
	close(carga);
end;

procedure leerDetalle(var a:detalle; var i:infoMunicipio);
begin
	if(not eof(a)) then
		read(a, i)
	else
		i.codigoLocalidad := valorAlto;
end;

procedure minimo(var vr: vecRegistro; var min:infoMunicipio; var v:vecDetalle);
var 
	i,pos:subrango;
begin
	min.codigoLocalidad:= valorAlto;
	for i := 1 to DF do begin
		if((vr[i].codigoLocalidad < min.codigoLocalidad)or((vr[i].codigoLocalidad = min.codigoLocalidad)and(vr[i].codigoCepa < min.codigoCepa))) then begin
			min:= vr[i];
			pos:= i;
		end;
	end;
	if(min.codigoLocalidad <> valorAlto) then
		leerDetalle(v[pos], vr[pos]);
end;

procedure actualizarMaestro(var am:maestro; var v:vecDetalle);
var
	min: infoMunicipio;
	actual:infoMini;
	i:subrango;
	vr:vecRegistro;
	cantLocalidades:integer;
begin
	reset(am);
	for i := 1 to DF do begin
		reset(v[i]);
		leerDetalle(v[i], vr[i]);
	end;
	
	cantLocalidades:=0;
	minimo(vr, min, v);
	read(am, actual);
	while(min.codigoLocalidad <> valorAlto) do begin
		while((actual.codigoLocalidad <> min.codigoLocalidad))do
			read(am, actual);
		while(actual.codigoLocalidad = min.codigoLocalidad)do begin
			while(actual.codigoCepa <> min.codigoCepa)do 
				read(am, actual);
			
			while((actual.codigoLocalidad = min.codigoLocalidad) and (actual.codigoCepa = min.codigoCepa))do begin
				writeln('Actual :', min.codigoLocalidad, ' ',min.codigoCepa);
				actual.casosActivos:=min.casosActivos;
				if(actual.casosActivos >= 50)then
					cantLocalidades:=cantLocalidades+1;
				actual.casosNuevos:=min.casosNuevos;
				actual.fallecidos:= actual.fallecidos + min.fallecidos;
				actual.recuperados := actual.recuperados + min.recuperados;
				minimo(vr, min, v);
				
			end;
			seek(am, filepos(am)-1);
			write(am, actual);
		end;	
	end;
	writeln('La cantidad de localidades con mas de 50 casos activos es de: ', cantLocalidades);
	for i:= 1 to DF do
		close(v[i]);
	close(am);
end;

procedure imprimirMaestro(var mae:maestro);
var
	i:infoMini;
begin
	reset(mae);
    while(not eof(mae)) do
        begin
			with i do begin
				read(mae, i);
				writeln('Codigo localidad= ', codigoLocalidad, '	nombre localidad= ', nombreLocalidad, '	codigo cepa= ',codigoCepa, '	ca= ', casosActivos, '	cn= ', casosNuevos, '	recuperados= ',recuperados, '	fallecidos= ', fallecidos);
				
			end;
        end;
    close(mae);
end;

var
	vd: vecDetalle;
	arcMaestro: maestro;
BEGIN
	crearDetalles(vd);
	crearArchivoMaestro(arcMaestro);
	imprimirMaestro(arcMaestro);
	actualizarMaestro(arcMaestro, vd);
	imprimirMaestro(arcMaestro);
END.

