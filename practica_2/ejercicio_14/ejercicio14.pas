{
14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:

a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.

b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.

NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.

   
}


program tp2.ejercicio14;
const
	valorAlto= 'ZZZZ';
type
	horas = 1..24;
	regm = record
		destino: string;
		fecha: string;
		horaSalida: string;
		cantAsientosDis:integer;
	end;
	
	regd = record
		destino: string;
		fecha: string;
		horaSalida: string;
		cantAsientosCom: integer;
	end;
	
	maestro = file of regm;
	detalle = file of regd;
	
procedure crearArchivoMaestro(var mae:maestro);
var
	rm:regm;
	carga:text;
begin
	assign(mae, 'maestro');
	rewrite(mae);
	
	assign(carga, 'maestro.txt');
	reset(carga);
	while(not eof(carga)) do 
		with rm do begin
			readln(carga, cantAsientosDis, destino);
			readln(carga, fecha);
			readln(carga, horaSalida);
			write(mae, rm);
		end;
	close(carga);
	close(mae);
end;

procedure crearArchivosDetalles(var ad1,ad2:detalle);
var
	carga1,carga2:text;
	rd1,rd2: regd;

begin
	
	assign(ad1, 'detalle1');
	assign(ad2, 'detalle2');
	rewrite(ad1);
	rewrite(ad2);
	
	
	assign(carga1, 'detalle1.txt');
	reset(carga1);
	while(not eof(carga1)) do
		with rd1 do begin
			readln(carga1, cantAsientosCom, destino);
			readln(carga1, fecha);
			readln(carga1, horaSalida);
			write(ad1, rd1);
		end;
	close(carga1);
	
	
	assign(carga2, 'detalle2.txt');
	reset(carga2);
	while(not eof(carga2)) do
		with rd2 do begin
			readln(carga2, cantAsientosCom, destino);
			readln(carga2, fecha);
			readln(carga2, horaSalida);
			write(ad2, rd2);
		end;
	
	close(carga2);
	close(ad1);
	close(ad2);
end;

procedure leerDetalle(var ad:detalle; var rd:regd);
begin
	if(not eof(ad))then
		read(ad, rd)
	else
		rd.destino := valorAlto;
end;

procedure minimo(var ad1,ad2:detalle; var min,rd1,rd2:regd);
begin
	if(rd1.destino < rd2.destino)then begin
		min:=rd1;
		leerDetalle(ad1, rd1)
	end
	else begin
		min:=rd2;
		leerDetalle(ad2, rd2);
	end;
	
end;

procedure actualizarMaestro(var mae:maestro; var ad1,ad2:detalle);
var
	rm: regm;
	min,rd1, rd2:regd;
	cantDis:integer;
	lista:text;
begin
	reset(mae);
	reset(ad1);
	reset(ad2);
	
	writeln('Ingrese una cantidad');
	readln(cantDis);
	assign(lista, 'lista.txt');
	rewrite(lista);
	
	leerDetalle(ad1, rd1);
	leerDetalle(ad2, rd2);
	minimo(ad1, ad2, min, rd1, rd2);
	while(min.destino <> valorAlto) do begin
		read(mae, rm);
		while(rm.destino <> min.destino)do
			read(mae, rm);
			
		while(rm.destino = min.destino)do begin
			while(rm.fecha <> min.fecha)do
				read(mae, rm);
		
			while((rm.destino = min.destino)and(rm.fecha = min.fecha)) do begin
				while(rm.horaSalida<>min.horaSalida)do 
					read(mae, rm);
				while((rm.destino = min.destino)and(rm.fecha = min.fecha)and (rm.horaSalida = min.horaSalida)) do begin
					rm.cantAsientosDis := rm.cantAsientosDis - min.cantAsientosCom;
					minimo(ad1, ad2, min, rd1, rd2);
				end;
				if(rm.cantAsientosDis < cantDis)then
					writeln(lista, rm.destino, ' ', rm.fecha, ' ', rm.horaSalida);
				seek(mae, filepos(mae)-1);
				write(mae, rm);
			end;
		end;
	end;
	
	close(ad1);
	close(ad2);
	close(mae);
	close(lista);
end;

var
	mae:maestro;
	ad1:detalle;
	ad2:detalle;
BEGIN
	crearArchivoMaestro(mae);
	crearArchivosDetalles(ad1, ad2);
	actualizarMaestro(mae, ad1, ad2);
	
	
END.

