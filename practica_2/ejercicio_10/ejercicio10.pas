{
10. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:

Código de Provincia

Código de Localidad 			 Total de Votos

................................ ......................

................................ ......................

Total de Votos Provincia: ____

Código de Provincia

Código de Localidad 			 Total de Votos

................................ ......................

Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___

NOTA: La información está ordenada por código de provincia y código de localidad.

   
}

program tp2.ejercicio10;
const
	valorAlto=9999;
type
	reg = record
		codProvincia:integer;
		codLocalidad:integer;
		numeroMesa:integer;
		cantVotos:integer;
	end;

	archivo = file of reg;

procedure crearArchivoMaestro(var mae:archivo);
var
	r:reg;
	carga:text;
begin
	assign(mae, 'maestro');
	rewrite(mae);
	assign(carga, 'maestro.txt');
	reset(carga);
	while not eof(carga) do
		with r do begin
			readln(carga, codProvincia, codLocalidad, numeroMesa, cantVotos);
			write(mae, r);
		end;
	close(mae);
	close(carga);
end;

procedure leerRegistro(var mae:archivo; var r:reg);
begin
	if(not eof(mae))then
		read(mae, r)
	else
		r.codProvincia := valorAlto;
end;

procedure recorrerArchivo(var mae:archivo);
var
	r:reg;
	localActual ,provActual:integer;
	totalGeneral, totalVotos, totalVotosProv:integer;
begin
	reset(mae);
	totalGeneral:=0;
	leerRegistro(mae, r);
	while(r.codProvincia <> valorAlto)do begin
		provActual:= r.codProvincia;
		writeln('Codigo de Provincia ', provActual);
		writeln('Codigo de Localidad	Total de Votos');
		totalVotosProv:=0;
		while(r.codProvincia = provActual) do begin
			localActual := r.codLocalidad;
			totalVotos:=0;
			while((r.codProvincia = provActual)and(localActual = r.codLocalidad))do begin
				totalVotos:= totalVotos + r.cantVotos;
				leerRegistro(mae, r);
			end;
			totalVotosProv := totalVotosProv + totalVotos;
			writeln(localActual,'			',totalVotos);
		end;
		writeln('Total de Votos Provincia: ', totalVotosProv);
		totalGeneral := totalGeneral + totalVotosProv;
	end;
	writeln('Total General de Votos: ', totalGeneral);
	close(mae);
end;

var
	mae:archivo;
BEGIN
	crearArchivoMaestro(mae);
	recorrerArchivo(mae);
END.

