{
13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
mismo (información guardada acerca de los movimientos que ocurren en el server) que se
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.

a. Realice el procedimiento necesario para actualizar la información del log en un
día particular. Defina las estructuras de datos que utilice su procedimiento.
b. Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:

nro_usuarioX…………..cantidadMensajesEnviados
………….

nro_usuarioX+n………..cantidadMensajesEnviados

Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema. Considere la implementación de esta opción de las
siguientes maneras:

i- Como un procedimiento separado del punto a).

ii- En el mismo procedimiento de actualización del punto a). Qué cambios
se requieren en el procedimiento del punto a) para realizar el informe en
el mismo recorrido?
   
}


program tp2.ejercicio13;
const
	valorAlto=9999;
type
	regm = record
		nro_usuario:integer;
		nombreUsuario: string;
		nombre:string;
		apellido:string;
		cantidadMailsEnviados:integer;
	end;
	
	regd = record
		nro_usuario:integer;
		cuentaDestino: string;
		cuerpoMensaje:string;
	end;
	
	maestro = file of regm;
	detalle = file of regd;

procedure crearArchivoMaestro(var mae:maestro);
var
	rm:regm;
	carga:text;
begin
	assign(mae, 'var/log/logmail');
	rewrite(mae);
	assign(carga, 'maestro.txt');
	reset(carga);
	while not eof(carga) do
		with rm do begin
			readln(carga, nro_usuario, nombreUsuario);
			readln(carga, cantidadMailsEnviados, nombre);
			readln(carga, apellido);
			write(mae, rm);
		end;
	close(mae);
	close(carga);
end;

procedure crearArchivoDetalle(var ad:detalle);
var
	rd:regd;
	carga:text;
begin
	assign(ad, 'detalle');
	rewrite(ad);
	assign(carga, 'detalle.txt');
	reset(carga);
	while not eof(carga) do
		with rd do begin
			readln(carga, nro_usuario, cuentaDestino);
			readln(carga, cuerpoMensaje);
			write(ad, rd);
		end;
	close(ad);
	close(carga);
end;

procedure leerDetalle(var ad:detalle; var rd:regd);
begin
	if(not eof(ad))then
		read(ad, rd)
	else
		rd.nro_usuario := valorAlto;
end;

procedure actualizarMaestro(var mae:maestro; var ad:detalle);
var
	rm:regm;
	rd:regd;
	punto2:text;
begin
	reset(mae);
	reset(ad);
	
	assign(punto2, 'punto2.txt');
	rewrite(punto2);
	
	leerDetalle(ad, rd);
	while(rd.nro_usuario <> valorAlto) do begin
		read(mae, rm);
		while(rm.nro_usuario <> rd.nro_usuario)do
			read(mae, rm);
		while(rd.nro_usuario = rm.nro_usuario)do begin
			rm.cantidadMailsEnviados:= rm.cantidadMailsEnviados + 1;
			leerDetalle(ad, rd);
		end;
		write(punto2, rm.nro_usuario, ' ', rm.cantidadMailsEnviados, '//');
		seek(mae, filepos(mae)-1);
		write(mae, rm);
	end;
	close(punto2);
	close(mae);
	close(ad);
end;

procedure exportar(var mae:maestro);
var
	rm:regm;
	punto1:text;
begin
	assign(punto1, 'punto1.txt');
	rewrite(punto1);
	
	reset(mae);
	while(not eof(mae))do
		with rm do begin
			read(mae, rm);
			write(punto1, nro_usuario, ' ', cantidadMailsEnviados,'//');
		end;
	close(mae);
	close(punto1);
end;

var
	mae:maestro;
	ad:detalle;
BEGIN
	crearArchivoMaestro(mae);
	crearArchivoDetalle(ad);
	actualizarMaestro(mae, ad);
	exportar(mae);
END.

