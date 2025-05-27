{
9. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.

El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.

Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.
}



program tp2.ejercicio9;
const
	valorALto = 9999;	
type
	venta = record
		codCliente:integer;
		nombre:string;
		apellido:string;
		mes:integer;
		ano:integer;
		dia:integer;
		montoVenta:real;
	end;

	archivo = file of venta;

procedure crearArchivoMaestro(var mae:archivo);
var
	v:venta;
	carga:text;
begin
	assign(mae, 'maestro');
	rewrite(mae);
	assign(carga, 'maestro.txt');
	reset(carga);
	while not eof(carga) do
		with v do begin
			readln(carga, codCliente, dia, mes, ano, montoVenta, nombre);
			readln(carga, apellido);
			write(mae, v);
		end;
	close(mae);
	close(carga);
end;

procedure leerRegistro(var mae:archivo; var v:venta);
begin
	if(not eof(mae))then
		read(mae, v)
	else
		v.codCliente := valorAlto;
end;

procedure recorrerArchivoMaestro(var mae:archivo);
var
	v:venta;
	codActual, mesActual, anoActual:integer;
	montoTotal, montoMes, montoAno:real;
begin
	reset(mae);
	montoTotal:=0;
	leerRegistro(mae, v);
	while(v.codCliente <> valorAlto) do begin
		writeln('cliente: ', v.codCliente,' ', v.nombre,' ',v.apellido);
		montoAno :=0;
		anoActual:= v.ano;
		codActual:= v.codCliente;
		while((v.codCliente = codActual)and(v.ano = anoActual))do begin
			montoMes:=0;
			mesActual:=v.mes;
			while((v.codCliente = codActual)and(v.ano = anoActual)and(v.mes = mesActual))do begin
				montoMes:=montoMes + v.montoVenta;
				leerRegistro(mae, v);
			end;
			writeln('monto mensual comprado del mes ',mesActual, ': ', montoMes:0:2 );
			montoAno := montoAno + montoMes;
		end;
		writeln('monto mensual comprado del ano ',anoActual, ': ', montoAno:0:2 );
		montoTotal := montoTotal + montoAno;
	end;
	writeln('monto total de ventas obtenido por la empresa: ', montoTotal:0:2);
	close(mae);
end;

var
	mae: archivo;
BEGIN
	crearArchivoMaestro(mae);
	recorrerArchivoMaestro(mae);
END.


