{
5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.

6. Agregar al menú del programa del ejercicio 5, opciones para:

a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.

b. Modificar el stock de un celular dado.

c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.
}


program tp1.ejercicio5y6;

type
	
	celular = record
		codigo: integer;
		nombre: string;
		descripcion: string;
		marca: string;
		precio: real;
		stockMin: integer;
		stockDis:integer;
	end;
	
	archivo = file of celular;
	
procedure mostrarMenu;
begin
	writeln('=== MENU ===');
	writeln('1. Crear archivo');
	writeln('2. Listar celulares con un stock menor al minimo');
	writeln('3. Listar celulares que coinciden la descripcion y un texto');
	writeln('4. Exportar archivo a celulares.txt');
	writeln('5. Agregar celulares al final');
	writeln('6. Modificar el stock de un celular dado');
	writeln('7. Exportar celulares sin stock');
	writeln('9. terminar');
end;
procedure crearArchivo(var a:archivo);
var
	c:celular;
	nombre, nombreCarga:string;
	archivoCarga:text;
begin
	writeln('Ingrese el nombre para el nuevo archivo');
	readln(nombre);
	Assign(a, nombre);
	rewrite(a);
	
	writeln('Ingrese el nombre del archivo de carga');
	readln(nombreCarga);
	Assign(archivoCarga, nombreCarga);
	
	reset(archivoCarga);
	
	while not eof(archivoCarga) do begin
		with c do 
		begin
			
			Readln(archivoCarga, codigo, precio, marca); //aqui me tira error
			//writeln('creando..');
			Readln(archivoCarga, stockMin, stockDis, descripcion);
			Readln(archivoCarga, nombre);
			
			write(a, c);
		end;
		
	end;
	
	close(a);
	close(archivoCarga);
	
end;

procedure imprimirCelular(c:celular);
begin
	writeln('- marca: ', c.marca,' descripcion: ',c.descripcion,' precio: ',c.precio:0:2,' stock disponible: ',c.stockDis, ' stock minimo: ',c.stockMin);
end;

procedure listarCelularesStock(var a:archivo);
var
	c:celular;
begin
	reset(a);
	writeln('listado de celulares con menos stock al minimo');
	while(not eof(a)) do begin
		read(a, c);
		if(c.stockDis < c.stockMin) then
			imprimirCelular(c);
	end;
	close(a);
end;

procedure listarCelularesDescripcion(var a:archivo);
var
	c:celular;
	cadena:string;
begin
	reset(a);
	writeln('Ingrese una cadena de texto');
	readln(cadena);
	while(not eof(a)) do begin
		read(a, c);
		
		//if(cadena = c.descripcion) then // Funciona pero si hay un espacion al comienzo
		//	imprimirCelular(c);
		if(Pos(LowerCase(cadena), LowerCase(c.descripcion)) > 0) then
			imprimirCelular(c);
	end;
	close(a);
end;

procedure exportarArchivo(var a:archivo);
var
	c:celular;
	arch:text;
begin
	
	reset(a);
	Assign(arch, 'celulares2.txt');
	rewrite(arch);
	writeln('exportando celulares');
	
	
	while(not eof(a)) do begin
		read(a, c);
		writeln(arch, c.codigo,' ', c.precio:0:2, c.marca); // IMPORTANTE PONER ESPACIOS ENTRE LOS VALORES NUMERICOS
		writeln(arch, c.stockDis, ' ',c.stockMin, c.descripcion);
		writeln(arch, c.nombre);
	end;
	close(a);
	close(arch);
end;

procedure leerCelular(var c:celular);
begin
	writeln('Ingrese un codigo');
	readln(c.codigo);
	writeln('Ingrese un precio');
	readln(c.precio);
	writeln('Ingrese una marca');
	readln(c.marca);
	writeln('Ingrese un stock minimo');
	readln(c.stockMin);
	writeln('Ingrese el stock diponible');
	readln(c.stockDis);
	writeln('Ingrese una descripcion');
	readln(c.descripcion);
	writeln('Ingrese un nombre');
	readln(c.nombre);
end;

procedure agregarCelular(var a:archivo);
var
	c:celular;
begin
	reset(a);
	leerCelular(c);
	Seek(a, filesize(a));
	write(a, c);
	close(a);
end;

procedure modificarStock(var a:archivo);
var
	c:celular;
	nombre:string;
	stock: integer;
	esta:boolean;
begin
	esta:=false;
	reset(a);
	writeln('Ingrese el nombre de un celular');
	readln(nombre);
	Seek(a, 0); // chequear si es necesario
	while ((not eof(a))and(not esta)) do begin
		read(a, c);
		if(c.nombre = nombre)then begin
			writeln('ingrese el nuevo stock');
			readln(stock);
			c.stockDis := stock;
			Seek(a, filepos(a)-1);
			write(a, c);
			esta:=true
		end;
	end;
	if(not esta) then
		writeln('No se encontro un celular con ese nombre');
	close(a);
end;

procedure exportarCelularesSinStock(var a:archivo);
var
	c:celular;
	arch:text;
begin
	reset(a);
	Assign(arch, 'SinStock.txt');
	rewrite(arch);
	writeln('exportando celulares');
	
	
	while(not eof(a)) do begin
		
		read(a, c);
		if(c.stockDis = 0) then begin
			writeln(arch, c.codigo,' ', c.precio:0:2, c.marca); // IMPORTANTE PONER ESPACIOS ENTRE LOS VALORES NUMERICOS
			writeln(arch, c.stockDis, ' ',c.stockMin, c.descripcion);
			writeln(arch, c.nombre);
		end;
	end;
	close(a);
	close(arch);
end;

var
	opcion:integer;
	arc_log:archivo;
BEGIN
	mostrarMenu;
	readln(opcion);
	while(opcion<>9) do begin
		case opcion of
			1:crearArchivo(arc_log);
			2:listarCelularesStock(arc_log);
			3:listarCelularesDescripcion(arc_log);
			4:exportarArchivo(arc_log);
			5:agregarCelular(arc_log);
			6:modificarStock(arc_log);
			7:exportarCelularesSinStock(arc_log);
		else writeln('Opcion invalida');
		end;
		mostrarMenu;
		readln(opcion);
	end;
	
	
END.

