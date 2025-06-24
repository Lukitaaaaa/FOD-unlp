{
6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las 
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.

   
}


program tp3.ejercicio6;

type
	prenda = record
		cod_prenda: integer;
		descripcion: string;
		colores: string;
		tipo: string;
		stock: integer;
		precio_unitario: integer;
	end;
	
	maestro = file of prenda;
	detalle = file of integer;
	
procedure crearArchivoDetalle(var ad:detalle);
var
	cod:integer;
	carga:text;
begin
	assign(ad, 'detalle');
	rewrite(ad);
	assign(carga, 'detalle.txt');
	reset(carga);
	while(not eof(carga))do begin
		readln(carga, cod);
		write(ad, cod);
	end;
	
	close(ad);
	close(carga);
end;

procedure crearArchivoMaestro(var am: maestro);
var
	p:prenda;
	carga:text;
begin	

	assign(am, 'maestro');
	rewrite(am);
	assign(carga, 'maestro.txt');
	reset(carga);
	
	while(not eof(carga))do begin
		with p do begin
			readln(carga, cod_prenda, descripcion);
			readln(carga, stock, tipo);
			readln(carga, precio_unitario, colores);
			write(am, p);
		end;
	end;
	
	close(am);
	close(carga);
end;

procedure imprimirArchivo(var am:maestro);
var
	p:prenda;
begin
	writeln('ARCHIVO MAESTRO');
	reset(am);
	
	while(not eof(am)) do begin
		read(am, p);
		writeln('Cod= ',p.cod_prenda, ' desc= ',p.descripcion);
	end;
	
	close(am);
end;

procedure imprimirArchivoD(var ad:detalle);
var
	c:integer;
begin
	writeln('ARCHIVO DETALLE');
	reset(ad);
	
	while(not eof(ad)) do begin
		read(ad, c);
		writeln('Cod= ',c);
	end;
	
	close(ad);
end;

procedure darDeBaja(var mae: maestro; var det:detalle);
var
	p:prenda;
	cod:integer;
begin
	reset(mae);
	reset(det);
	
	while(not eof(det)) do begin
		read(det, cod);
		seek(mae, 0);
		
		read(mae, p);
		while(cod <> p.cod_prenda) do 
			read(mae, p);
		seek(mae, filepos(mae) -1);
		p.stock := p.stock * -1;
		write(mae, p);	
	end;
	
	close(mae);
	close(det)
end;

procedure crearEstructuraAuxiliar(var mae:maestro);
var
	arc_aux: maestro;
	p:prenda;
begin
	assign(arc_aux, 'maestroAux');
	rewrite(arc_aux);
	reset(mae);
	
	while(not eof(mae)) do begin
		read(mae, p);
		if(p.stock > -1) then
			write(arc_aux, p);
	end;
	
	close(mae);
	close(arc_aux);
	
	//rename(mae, 'maestroViejo');
	erase(mae);
	rename(arc_aux, 'maestro');
	
	imprimirArchivo(arc_aux);
end;

var
	mae:maestro;
	det:detalle;
BEGIN
	crearArchivoMaestro(mae);
	crearArchivoDetalle(det);
	imprimirArchivo(mae);
	imprimirArchivoD(det);
	darDeBaja(mae, det);
	crearEstructuraAuxiliar(mae);

END.

