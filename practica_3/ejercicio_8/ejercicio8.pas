{
8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:

a. BuscarDistribucion: módulo que recibe por parámetro el archivo, un
nombre de distribución y devuelve la posición dentro del archivo donde se
encuentra el registro correspondiente a la distribución dada (si existe) o
devuelve -1 en caso de que no exista..

b. AltaDistribucion: módulo que recibe como parámetro el archivo y el registro
que contiene los datos de una nueva distribución, y se encarga de agregar
la distribución al archivo reutilizando espacio disponible en caso de que
exista. (El control de unicidad lo debe realizar utilizando el módulo anterior).
En caso de que la distribución que se quiere agregar ya exista se debe
informar “ya existe la distribución”.

c. BajaDistribucion: módulo que recibe como parámetro el archivo y el
nombre de una distribución, y se encarga de dar de baja lógicamente la
distribución dada. Para marcar una distribución como borrada se debe
utilizar el campo cantidad de desarrolladores para mantener actualizada
la lista invertida. Para verificar que la distribución a borrar exista debe utilizar
el módulo BuscarDistribucion. En caso de no existir se debe informar “Distribución no existente”.


}


program tp3.ejercicio8;
type
	distribucion = record
		nombre:string;
		anio_lanzamiento:integer;
		version:string;
		cant_desarrolladores:integer;
		descripcion:string;
	end;
	
	archivo = file of distribucion;

procedure leerDistribucion(var d: distribucion);
begin
    write('Ingrese el nombre de la distribucion ');
    readln(d.nombre);
    if(d.nombre <> 'fin') then begin
		write('Ingrese el anio de lanzamiento ');
		readln(d.anio_lanzamiento);
		write('Ingrese el numero de version de kernel ');
		readln(d.version);
		write('Ingrese la cantidad de desarrolladores ');
		readln(d.cant_desarrolladores);
		write('Ingrese la descripcion ');
		readln(d.descripcion);
	end;
end;

procedure crearArchivo(var arc: archivo);
var
    d: distribucion;
begin
    assign(arc, 'distribuciones');
    rewrite(arc);
    d.nombre:= '';
    d.cant_desarrolladores:= 0;
    d.anio_lanzamiento:= 0;
    d.version:= '';
    d.descripcion:= '';
    write(arc, d);
    
    leerDistribucion(d);
    while(d.nombre <> 'fin') do begin
		write(arc, d);
		leerDistribucion(d);
	end;
    close(arc);
end;

procedure imprimirArchivo(var arc: archivo);
var
    d: distribucion;
begin
    reset(arc);
    while(not eof(arc)) do
        begin
            read(arc, d);
            writeln('Nombre=', d.nombre, ' Cant=', d.cant_desarrolladores);
        end;
    close(arc);
end;

function BuscarDistribucion(var arc: archivo; nombre: string): integer;
var
    pos: integer;
    d: distribucion;
begin
    pos:= -1;
    reset(arc);
    while(not eof(arc)) do begin
		read(arc, d);
		if(d.nombre = nombre) then
			pos:= filepos(arc)-1;
	end;
    close(arc);
    BuscarDistribucion:= pos;
end;

procedure AltaDistribucion(var arc: archivo; d:distribucion);
var
	cabecera:distribucion;
begin
	if(BuscarDistribucion(arc, d.nombre) = -1) then begin
		reset(arc);
		read(arc, cabecera);
		if(cabecera.cant_desarrolladores = 0) then begin
			seek(arc, filesize(arc));
			write(arc, d);
		end
		else begin
			seek(arc, cabecera.cant_desarrolladores * -1);
			read(arc, cabecera);
			seek(arc, filepos(arc)-1);
			write(arc, d);
			seek(arc, 0);
			write(arc, cabecera);
			close(arc);
		end;
		close(arc);
	end
	else writeln('Ya existe la distribucion');
		
end;

procedure BajaDistribucion(var arc:archivo; nombre:string);
var
	cabecera, d:distribucion;
begin
	d.nombre := nombre;
	if(BuscarDistribucion(arc, nombre) <> -1) then begin
		reset(arc);
		read(arc, cabecera);
		read(arc, d);
		while(d.nombre <> nombre) do
			read(arc, d);
		seek(arc, filepos(arc)-1);
		write(arc, cabecera);
		cabecera.cant_desarrolladores:= (filepos(arc)-1) * -1;
		seek(arc, 0);
		write(arc, cabecera);
		close(arc);
	end
	else writeln('Distribucion no existente');
end;

var
	arc_log:archivo;
	d:distribucion;
BEGIN
	crearArchivo(arc_log);
	//imprimirArchivo(arc_log);
	BajaDistribucion(arc_log, 'Debian');
	
	imprimirArchivo(arc_log);
	leerDistribucion(d);
	AltaDistribucion(arc_log, d);
	imprimirArchivo(arc_log);
	
END.

