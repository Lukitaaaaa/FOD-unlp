{
Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
   
}


program tp2.ejercicio3;
const 
	valorAlto = 9999;
type
	producto = record
		codigo:integer;
		nombre:string;
		descripcion:string;
		stockDis:integer;
		stockMin:integer;
		precio:real;
	end;
	
	infoSucursal =record
		codigo:integer;
		cv:integer;
	end;
	
	maestro = file of producto;
	detalle = file of infoSucursal;
	
procedure leerDetalle(var ad:detalle; var dato:infoSucursal);
begin
	if(not eof(ad)) then
		read(ad, dato)
	else
		dato.codigo:= valorAlto;
end;

procedure actualizarMaestro(var am:maestro; var ad:detalle);
var
	i:infoSucursal;
	p:producto;
begin
	
	reset(am);
	reset(ad);

	
	leerDetalle(ad, i);
	
	while(i.codigo <> valorAlto)do begin
		read(am, p);
		while(i.codigo <> p.codigo ) do
			read(am, p);
		while(i.codigo = p.codigo) do begin
			writeln('Actualizan el codigo: ',i.codigo);
			p.stockDis:= p.stockDis - i.cv;
			leerDetalle(ad, i);
		end;
		seek(am, filepos(am)-1);
		write(am, p);
	end;
	
	close(am);
	close(ad);
end;

procedure productosConBajoStock(var m:maestro);
var
	p:producto;
	arch:text;
begin
	reset(m);
	assign(arch, 'productosConBajoStock.txt');
	rewrite(arch);
	
	while(not eof(m)) do begin
		read(m, p);
		if(p.stockDis<p.stockMin) then begin
			writeln(arch, p.codigo, ' ', p.precio:0:2, p.descripcion);
			writeln(arch, p.stockDis,' ', p.stockMin, p.nombre);
		end;
	end;
	writeln('EXPORTANDO');
	close(m);
	close(arch);
end;

procedure crearArchivoMaestro(var arch:maestro);
var
	p:producto;
	carga:text;
begin
	assign(carga, 'maestro.txt');
	assign(arch, 'maestro');
	rewrite(arch);
	reset(carga);
	while(not eof(carga))do begin
		with p do begin
			readln(carga, codigo, precio, descripcion);
			readln(carga, stockDis, stockMin, nombre);
			write(arch, p);
		end;
	end;
	
	close(arch);
	close(carga);
	writeln('ARCHIVO MAESTRO CREADO');
end;

procedure crearArchivoDetalle(var arch:detalle);
var
	i:infoSucursal;
	carga:text;
begin
	assign(carga, 'detalle.txt');
	assign(arch, 'detalle');
	rewrite(arch);
	reset(carga);
	while(not eof(carga))do begin
		with i do begin
			readln(carga, codigo, cv); // no se pueden leer los booleanos
			write(arch, i);
		end;
	end;
	
	close(arch);
	close(carga);
	writeln('ARCHIVO DETALLE CREADO');
end;

var
	arch_maestro: maestro;
	arch_detalle: detalle;
BEGIN
	crearArchivoMaestro(arch_maestro);
	crearArchivoDetalle(arch_detalle);
	actualizarMaestro(arch_maestro, arch_detalle);
	productosConBajoStock(arch_maestro);
END.

