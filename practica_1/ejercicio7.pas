{
7. Realizar un programa que permita:

a) Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.

b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.

NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.
   
}


program tp1.ejercicio7;

type
	novela = record
		codigo: integer;
		nombre: string;
		genero: string;
		precio: real;
	end;
	
	archivo = file of novela;
procedure mostrarMenu;
begin
	writeln('=== MENU ===');
	writeln('1. Crear archivo');
	writeln('2. Agregar novela al final');
	writeln('3. Modificar novela');
	writeln('9. terminar');
end;

procedure crearArchivo(var a:archivo);
var
	n:novela;
	arch:text;
	nombre, nombreCarga:string;
begin
	writeln('Ingrese un nombre para el nuevo archivo');
	readln(nombre);
	assign(a, nombre);
	rewrite(a);
	
	writeln('Ingrese el nombre del archivo de carga');
	readln(nombreCarga);
	assign(arch, nombreCarga);
	reset(arch);
	
	while(not eof(arch)) do begin
		with n do begin
			readln(arch, codigo, precio, genero);
			readln(arch, nombre);
			write(a, n);
		end;
	end;
	
	close(a);
	close(arch)
end;

procedure leerNovela(var n:novela);
begin
	writeln('Ingrese un codigo');
	readln(n.codigo);
	writeln('Ingrese un precio');
	readln(n.precio);
	writeln('Ingrese un genero');
	readln(n.genero);
	writeln('Ingrese un nombre');
	readln(n.nombre);
end;

procedure agregarNovela(var a:archivo);
var
	n:novela;
begin
	reset(a);
	Seek(a, filesize(a));
	leerNovela(n);
	write(a, n);
	close(a);
end;

procedure modificarNovela(var a:archivo);
var
	n:novela;
	nombre:string;
	esta:boolean;
begin
	writeln('Ingrese el nombre de la novela que desea modificar');
	readln(nombre);
	esta:= false;
	reset(a);
	while ((not eof(a))and(not esta)) do begin
		read(a,n);
		if(n.nombre = nombre) then begin
			leerNovela(n);
			Seek(a, filepos(a)-1);
			write(a, n);
			esta:=true;
		end;
	end;
	if(not esta) then
		writeln('No se encontro una novela con ese nombre');
	close(a);
end;

var
	arc_log: archivo;
	opcion:integer;
BEGIN
	mostrarMenu;
	readln(opcion);
	while(opcion<>9) do begin
		case opcion of
			1:crearArchivo(arc_log);
			2:agregarNovela(arc_log);
			3:modificarNovela(arc_log);
		else writeln('Opcion invalida');
		end;
		mostrarMenu;
		readln(opcion);
	end;
	
END.

