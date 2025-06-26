{
7. Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que permita borrar especies de aves extintas. Este programa debe
disponer de dos procedimientos:

	a. Un procedimiento que dada una especie de ave (su código) marque la misma
	como borrada (en caso de querer borrar múltiples especies de aves, se podría
	invocar este procedimiento repetidamente).

	b. Un procedimiento que compacte el archivo, quitando definitivamente las
	especies de aves marcadas como borradas. Para quitar los registros se deberá
	copiar el último registro del archivo en la posición del registro a borrar y luego
	eliminar del archivo el último registro de forma tal de evitar registros duplicados.

		i. Implemente una variante de este procedimiento de compactación del
		archivo (baja física) donde el archivo se trunque una sola vez.

}


program tp3.ejercicio7;

type
	especie= record
		codigo:integer;
		nombre:string;
		familia:string;
		descripcion:string;
		zona_geografica:string
	end;
	
	archivo= file of especie;

procedure leerRegistro(var e:especie);
begin
    write('Ingrese el codigo de especie ');
    readln(e.codigo);
    if(e.codigo <> -1) then begin
		write('Ingrese el nombre de la especie ');
		readln(e.nombre);
		write('Ingrese la familia de ave ');
		readln(e.familia);
		write('Ingrese la descripcion de la especie ');
		readln(e.descripcion);
		write('Ingrese la zona geografica de la especie ');
		readln(e.zona_geografica);
    end;
end;

procedure crearArchivo(var arc:archivo);
var
	e:especie;
begin
	assign(arc, 'especies');
	rewrite(arc);
	leerRegistro(e);
	while(e.codigo <> -1) do begin
		write(arc, e);
		leerRegistro(e);
	end;
	close(arc);
end;

procedure borrarEspecie(var arc:archivo);
var
	e:especie;
	cod:integer;
	esta:boolean;
begin
	reset(arc);
	write('Ingrese un codigo de especie para eliminar ');
	readln(cod);
	esta:=false;
	
	while(not eof(arc)and (not esta)) do begin
		read(arc, e);
		if(e.codigo = cod)then begin
			esta:=true;
			e.codigo:= e.codigo * -1;
			seek(arc, filepos(arc)-1);
			write(arc, e);
		end;
	end;
	
	if(not esta) then writeln('El codigo ingresado no existe');
	close(arc);
end;

procedure imprimirArchivo(var arc: archivo);
var
    e:especie;
begin
    reset(arc);
    while (not eof(arc)) do
        begin
            read(arc, e);
            writeln('Codigo=', e.codigo, ' Nombre=', e.nombre);
        end;
    close(arc);
end;

procedure compactarArchivo(var arc:archivo);
var
    e, ult: especie;
    pos, ultPos, tam: integer;
begin
    reset(arc);
    tam := filesize(arc);
    pos := 0;
    while (pos < tam) do begin
        seek(arc, pos);
        read(arc, e);
        if (e.codigo < 0) then begin
            ultPos := tam - 1;
            if pos <> ultPos then begin
                seek(arc, ultPos);
                read(arc, ult);
                seek(arc, pos);
                write(arc, ult);
            end;
            tam := tam - 1;
            seek(arc, tam);
            truncate(arc);
            // No incrementamos pos, revisamos el nuevo registro copiado
        end
        else
            pos := pos + 1;
    end;
    close(arc);
end;

var
	arc_log:archivo;
BEGIN
	crearArchivo(arc_log);
	imprimirArchivo(arc_log);
	borrarEspecie(arc_log);
	borrarEspecie(arc_log);
	borrarEspecie(arc_log);
	//imprimirArchivo(arc_log);
	compactarArchivo(arc_log);
	imprimirArchivo(arc_log);
END.

