{
5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:

Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente.

procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);

   
}


program tp3.ejercicio5;
type
	reg_flor = record
		nombre: String[45];
		codigo: integer;
	end;

	tArchFlores = file of reg_flor;

procedure leerRegistro(var f:reg_flor);
begin
	write('ingrese un codigo: ');
	readln(f.codigo);
	if(f.codigo <> -1)then begin
		write('ingrese un nombre: ');
		readln(f.nombre);
	end;
end;

procedure crearArchivo(var a: tArchFlores);
var
	f:reg_flor;
begin
	assign(a, 'flores');
	rewrite(a);
	
	f.codigo:= 0;
	f.nombre:= '';
	write(a, f);
	
	leerRegistro(f);
	while(f.codigo <> -1)do begin
		write(a, f);
		leerRegistro(f);
	end;
	close(a);
end;

procedure eliminarFlor(var a: tArchFlores; flor:reg_flor);
var
	f, cabecera:reg_flor;
	pos:integer;
	esta:boolean;
begin
	reset(a);
	
	esta:=false;
	seek(a, 0);
    read(a, cabecera); // Leo el registro cabecera
    pos := 1;
    while(not eof(a) and (not esta))do begin
        read(a, f);
        if(f.codigo = flor.codigo)then begin
            esta:=true;
            seek(a, pos); // Voy a la posición de la novela a borrar
            write(a, cabecera); // Copio el registro cabecera en esa posición
            cabecera.codigo := -pos; // Actualizo el campo código de la cabecera
            seek(a, 0);
            write(a, cabecera); // Escribo la cabecera actualizada
        end;
        pos := pos + 1;
    end;
	if(not esta) then
		writeln('El codigo de novela ingresado no existe');
	
	close(a);
end;

procedure agregarFlor (var a: tArchFlores; nombre: string; codigo:integer);
var
	f, cabecera:reg_flor;
begin
	reset(a);
	
	f.nombre:= nombre;
	f.codigo:= codigo;
	 
	read(a, cabecera);
	if(cabecera.codigo = 0)then begin
		seek(a, filesize(a));
		write(a, f)
	end
	else begin
		seek(a, cabecera.codigo * -1); 
		read(a, cabecera); 
		seek(a, filepos(a) - 1); 
		write(a, f); 
		seek(a, 0);
		write(a, cabecera); 
	end; 
	close(a);
end;

procedure listarFlores(var a: tArchFLores);
var
	flores:text;
	f:reg_flor;
begin
	assign(flores, 'flores.txt');
	rewrite(flores);
	reset(a);
	while(not eof(a))do begin
		read(a, f);
		if(f.codigo>0) then begin
			write(flores, 
				' codigo= ', f.codigo,
				' nombre= ', f.nombre
			);
			writeln(flores);
		end;
	end;
	
	close(a);
	close(flores);
end;

var
	arc_log:tArchFlores;
	flor:reg_flor;
BEGIN
	crearArchivo(arc_log);
	
	writeln('Ingrese los datos de la flor que desea eliminar');
	leerRegistro(flor);
	eliminarFlor(arc_log, flor);
	
	writeln('Ingrese los datos de la flor que desea eliminar');
	leerRegistro(flor);
	eliminarFlor(arc_log, flor);
	
	agregarFlor(arc_log, 'Rosa', 10);
	listarFlores(arc_log);
END.

