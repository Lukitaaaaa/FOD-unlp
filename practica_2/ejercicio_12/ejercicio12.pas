{
12. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
por los siguientes criterios: año, mes, día e idUsuario.

Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:

Año : ---
	Mes:-- 1
		día:-- 1
			idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
			--------
			idUsuario N Tiempo total de acceso en el dia 1 mes 1
		Tiempo total acceso dia 1 mes 1
	-------------
		día N
			idUsuario 1 Tiempo Total de acceso en el dia N mes 1
			--------
			idUsuario N Tiempo total de acceso en el dia N mes 1
		Tiempo total acceso dia N mes 1
	Total tiempo de acceso mes 1
	------
	Mes 12
		día 1
			idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
			--------
			idUsuario N Tiempo total de acceso en el dia 1 mes 12
		Tiempo total acceso dia 1 mes 12
	-------------
		día N
			idUsuario 1 Tiempo Total de acceso en el dia N mes 12
			--------
			idUsuario N Tiempo total de acceso en el dia N mes 12
		Tiempo total acceso dia N mes 12
	Total tiempo de acceso mes 12
Total tiempo de acceso año
  
Se deberá tener en cuenta las siguientes aclaraciones:

● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
● Debe definir las estructuras de datos necesarias.
● El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria
}


program tp2.ejercicio12;
const
	valorAlto = 9999;
type
	reg = record
		ano:integer;
		mes:integer;
		dia:integer;
		idUsuario:integer;
		tiempoDeAcceso:integer;
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
			readln(carga, ano, mes, dia, idUsuario, tiempoDeAcceso);
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
		r.ano := valorAlto;
end;

procedure recorrerArchivo(var mae:archivo);
var
	r:reg;
	anoB:integer;
	totalAno, totalMes, totalDia, totalTiempo:integer;
	mesActual, diaActual, idActual:integer;
begin
	reset(mae);
	writeln('ingrese un ano');
	readln(anoB);
	
	leerRegistro(mae, r);
	while(r.ano <> valorAlto)do begin
		while((r.ano <> valorAlto)and(r.ano <> anoB))do
			leerRegistro(mae, r);
		if(r.ano <> anoB)then 
			r.ano:= valorAlto
		else begin
			writeln('ano: ', r.ano);
			totalAno:=0;
			while(r.ano = anoB)do begin
				mesActual := r.mes;
				totalMes:=0;
				writeln('	Mes: ', mesActual);
				while((r.ano = anoB)and(r.mes = mesActual))do begin
					diaActual := r.dia;
					totalDia:=0;
					writeln('		Dia: ', diaActual);
					while((r.ano = anoB)and(r.mes = mesActual)and(r.dia = diaActual))do begin
						idActual := r.idUsuario;
						totalTiempo:=0;
						while((r.ano = anoB)and(r.mes = mesActual)and(r.dia = diaActual)and(r.idUsuario = idActual)) do begin
							totalTiempo:=totalTiempo+r.tiempoDeAcceso;
							leerRegistro(mae, r);
						end;
						totalDia:=totalDia+totalTiempo;
						writeln('			idUsuario ',idActual, '   Tiempo Total de acceso en el dia ',diaActual, ' mes ',mesActual);
						writeln('			',totalTiempo);
					end;
					totalMes:= totalMes + totalDia;
					writeln('		Tiempo total acceso dia ',diaActual,' mes ', mesActual,': ',totalDia);
				end;
				totalAno:=totalAno + totalMes;
				writeln('	Total tiempo de acceso mes ',mesActual,': ',totalMes);
			end;
			writeln('Total tiempo de acceso ano: ', totalAno);
		end;
	end;
	close(mae);
end;

var
	mae: archivo;
BEGIN
	crearArchivoMaestro(mae);
	recorrerArchivo(mae);
END.

