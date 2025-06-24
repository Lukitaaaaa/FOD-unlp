{
3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.

b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a), se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de “enlace” de la lista (utilice el código de
novela como enlace), se debe especificar los números de registro
referenciados con signo negativo, . Una vez abierto el archivo, brindar
operaciones para:


i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.

ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.

iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.

c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.

NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.
}


program tp3.ejercicio3;

type 
	opciones = 1..9;
	novela = record
		codigo:integer;
		genero:string;
		nombre:string;
		duracion:integer;
		director:string;
		precio:real;
	end;
	
	archivo = file of novela;

procedure mostrarMenu;
begin
	writeln('=== MENU ===');
	writeln('1. Crear archivo');
	writeln('2. Dar de alta una novela');
	writeln('3. Modificar una novela');
	writeln('4. Dar de baja una novela');
	writeln('5. Exportar todas las novelas(incluso las borradas)');
	writeln('9. Cerrar');
end;

procedure leerRegistro(var n:novela);
begin
	write('codigo: ');
	readln(n.codigo);
	if(n.codigo <> -1) then begin
		write('genero: ');
		readln(n.genero);
		write('nombre: ');
		readln(n.nombre);
		write('duracion: ');
		readln(n.duracion);
		write('director: ');
		readln(n.director);
		write('precio: ');
		readln(n.precio);
	end;
end;

procedure crearArchivo(var arc:archivo);
var
	n:novela;
	nombre:string;
begin
	writeln('Ingrese un nombre para el nuevo archivo');
	readln(nombre);
	assign(arc, nombre);
	rewrite(arc);
	n.codigo := 0;
	n.genero:= '';
	n.nombre:='';
	n.duracion:= 0;
	n.director:='';
	n.precio:=0.0;
	
	write(arc, n);
	writeln('Ingrese un novela');
	leerRegistro(n);
	while(n.codigo <> -1) do begin
		write(arc, n);
		leerRegistro(n);
	end;
	close(arc);
end;

procedure darDeAlta(var arc:archivo);
var
	n,npos:novela;
begin
	reset(arc);
	writeln('dar de alta una novela');
	leerRegistro(n);
	read(arc, npos);
	if(npos.codigo = 0)then begin
		seek(arc, filesize(arc));
		write(arc, n)
	end
	else begin
		seek(arc, npos.codigo * -1); // VOY AL POS DONDE SE BORRO EL ULTIMO
		read(arc, npos); // Tomo la posicion del anteultimo que se borro
		seek(arc, filepos(arc) - 1); // El read anterior hizo mover el seek +1, volvemos a la pos anterior
		write(arc, n); // Doy de alta el nuevo archivo
		seek(arc, 0); // voy a la pos 0
		write(arc, npos); // anoto en la pos 0 la pos del que ahora es el ultimo borrado
	end; 
	close(arc);
end;

procedure modificarNovelaEncontrada(var n:novela);
begin
	write('genero: ');
	readln(n.genero);
	write('nombre: ');
	readln(n.nombre);
	write('duracion: ');
	readln(n.duracion);
	write('director: ');
	readln(n.director);
	write('precio: ');
	readln(n.precio);
end;

procedure modificarNovela(var arc:archivo);
var
	n:novela;
	cod:integer;
	esta:boolean;
begin
	reset(arc);
	writeln('Ingrese el codigo de novela que desea modificar');
	readln(cod);
	esta:=false;
	while(not eof(arc) and (not esta))do begin
		read(arc, n);
		if(n.codigo = cod)then begin
			esta:=true;
			modificarNovelaEncontrada(n);
			seek(arc, filepos(arc)-1);
			write(arc, n);
		end;
	end;
	if(not esta) then
		writeln('El codigo de novela ingresado no existe');
		
	close(arc);
end;

procedure darDeBaja(var arc:archivo);
var
	n, cabecera:novela;
	cod, pos:integer;
	esta:boolean;
begin
	reset(arc);
	writeln('Ingrese el codigo de novela que desea dar de baja');
	readln(cod);
	esta:=false;
	seek(arc, 0);
    read(arc, cabecera); // Leo el registro cabecera
    pos := 1;
    while(not eof(arc) and (not esta))do begin
        read(arc, n);
        if(n.codigo = cod)then begin
            esta:=true;
            seek(arc, pos); // Voy a la posición de la novela a borrar
            write(arc, cabecera); // Copio el registro cabecera en esa posición
            cabecera.codigo := -pos; // Actualizo el campo código de la cabecera
            seek(arc, 0);
            write(arc, cabecera); // Escribo la cabecera actualizada
        end;
        pos := pos + 1;
    end;
	if(not esta) then
		writeln('El codigo de novela ingresado no existe');
	close(arc);
end;

procedure exportarArchivo(var arc:archivo);
var
	n:novela;
	novelas:text;
begin
	reset(arc);
	assign(novelas, 'novelas.txt');
	rewrite(novelas);
	
	while(not eof(arc))do begin
		read(arc, n);
		if(n.codigo < 1) then
			write(novelas, 'Registro cabecera: ');
		write(novelas, 'Codigo=', n.codigo, 
            ' Genero=', n.genero, 
            ' Nombre=', n.nombre, 
            ' Duracion=', n.duracion, 
            ' Director=', n.director, 
            ' Precio=', n.precio:0:2);
        writeln(novelas);
	end;
	close(arc);
	close(novelas);
end;

procedure imprimirArchivo(var arc:archivo);
var
	n:novela;
begin
	reset(arc);
	while(not eof(arc)) do begin
		read(arc, n);
		writeln(n.codigo, ' - ',n.nombre);
	end;
	close(arc);
end;

var
	arc_log:archivo;
	opcion:integer;
BEGIN
	mostrarMenu;
	readln(opcion);
	while(opcion <> 9) do begin
		case opcion of
			1:crearArchivo(arc_log);
			2:darDeAlta(arc_log);
			3:modificarNovela(arc_log);
			4:darDeBaja(arc_log);
			5:exportarArchivo(arc_log);
			6:imprimirArchivo(arc_log);
		else writeln('Opcion invalida');
		end;
		mostrarMenu;
		readln(opcion);
	end;
END.

