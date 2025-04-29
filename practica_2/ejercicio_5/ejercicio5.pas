{
4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.

Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}


program tp2.ejercicio5;
const 
	valorAlto = 999;
	fin = 'fin';
	DF = 5;
type
	rango = 1..DF;
	
	infoSesion = record
		codigo: integer;
		tiempoTotalSesion:integer;
		fecha:string;
	end;
	
	detalle = file of infoSesion;
	vectorRegistro = array[rango] of infoSesion;
	vectorArchivo = array[rango] of detalle;

procedure mostrarMenu;
begin
	writeln('=== MENU ===');
	writeln('1. Crear archivos');
	writeln('2. Iniciar sesion');
	writeln('3. Actualizar maestro');
	writeln('9. terminar');
end;


procedure mostrarMenu2;
begin
	writeln('=== INICIO SESION ===');
	writeln('1. maquina 1');
	writeln('2. maquina 2');
	writeln('3. maquina 3');
	writeln('4. maquina 4');
	writeln('5. maquina 5');
end;


procedure imprimirInfo(i:infoSesion);
begin
	writeln('cod: ',i.codigo);
	
end;

procedure listarEmpleados(var a:detalle);
var
	i:infoSesion;
begin
	writeln('Lista de empleados');
	reset(a);
	while not eof(a) do begin
		read(a, i);
		imprimirInfo(i);
	end;
	close(a);
end;

procedure crearArchivoDetalle(var arch:detalle; ind:rango);
var
	i:infoSesion;
	carga:text;
begin
	assign(carga, 'detalle.txt');
	rewrite(arch);
	reset(carga);
	while(not eof(carga))do begin
		with i do begin
			readln(carga, codigo, tiempoTotalSesion, fecha); 
			write(arch, i);
		end;
	end;
	
	close(arch);
	close(carga);
	
	writeln('ARCHIVO DETALLE CREADO');
end;

procedure crearDetalles(var v:vectorArchivo);
var
	i:rango;
begin
	//IMPORTANTISIMO QUE LOS DIFERENTES ARCHIVOS DETALLES TENGAS DIFERENTES NOMBRES
	assign(v[1], 'detalle1');
	assign(v[2], 'detalle2');
	assign(v[3], 'detalle3');
	assign(v[4], 'detalle4');
	assign(v[5], 'detalle5');
	for i:= 1 to DF do 
		crearArchivoDetalle(v[i], i);
		
end;



procedure leerDetalle(var ad:detalle; var i:infoSesion);
begin

		
	if(not eof(ad))then begin
		read(ad, i);
		
	end
	else
		i.codigo:= valorAlto;
end;

procedure leerSesion(var i:infoSesion);
begin
	write('codigo de usuario: ');
	readln(i.codigo);
	write('fecha de inicio: ');
	readln(i.fecha);
	write('tiempo de sesion: ');
	readln(i.tiempoTotalSesion);
end;

procedure minimo (var vr: vectorRegistro; var min:infoSesion; var v:vectorArchivo);
var
	i, pos:rango;
begin
	min.fecha:=fin;
	min.codigo:=valorAlto;
	for i:= 1 to DF do
        if (vr[i].codigo < min.codigo) or ((vr[i].codigo = min.codigo) and (vr[i].fecha < min.fecha)) then
            begin
                min:= vr[i];
                pos:= i;
            end;
	if(min.codigo <> valorAlto)then
		leerDetalle(v[pos],vr[pos]);
	
end;

procedure actualizarMaestro(var v:vectorArchivo; var am:detalle);
var
	min, actual:infoSesion;
	i:rango;
	vr:vectorRegistro;
	nombre:string;
begin
	nombre:= 'var/log/maestro';
	assign(am, nombre);
	rewrite(am);
	
	for i:=1 to DF do begin
		reset(v[i]);
		leerDetalle(v[i], vr[i]);
	end;
		
	minimo(vr,min,v);
	while(min.codigo <> valorAlto)do begin
		actual.codigo:= min.codigo;
		while(actual.codigo = min.codigo) do begin
			actual.fecha:= min.fecha;
			actual.tiempoTotalSesion:= 0;
			while((actual.codigo = min.codigo)and(actual.fecha = min.fecha)) do begin
				actual.tiempoTotalSesion:= actual.tiempoTotalSesion + min.tiempoTotalSesion;
				minimo(vr,min,v);
			end;
			imprimirInfo(actual);
			write(am, actual);
		end;
	end;
	close(am);
	for i:= 1 to DF do
        close(v[i]);
end;

procedure actualizarDetalle(var ad:detalle);
var
	i:infoSesion;
begin
	reset(ad);
	leerSesion(i);
	Seek(ad, filesize(ad));
	write(ad, i);
	close(ad);
end;

procedure iniciarSesion(var v:vectorArchivo);
var
	opcion:integer;
begin
	mostrarMenu2;
	readln(opcion);
	case opcion of
		1:actualizarDetalle(v[1]);
		2:actualizarDetalle(v[2]);
		3:actualizarDetalle(v[3]);
		4:actualizarDetalle(v[4]);
		5:actualizarDetalle(v[5]);
	else writeln('opcion invalida');
	end;
end;

procedure imprimirMaestro(var mae: detalle);
var
    s: infoSesion;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, s);
            writeln('Codigo=', s.codigo, ' Fecha=', s.fecha, ' Tiempo=', s.tiempoTotalSesion );
        end;
    close(mae);
end;

var
	opcion:integer;
	v:vectorArchivo;
	maestro:detalle;
BEGIN

	mostrarMenu;
	readln(opcion);
	while (opcion<>9)do begin
		case opcion of
			1:crearDetalles(v);
			2:iniciarSesion(v);
			3:ActualizarMaestro(v, maestro);  
			4:imprimirMaestro(maestro);
		else writeln('opcion invalida');
		end;
		mostrarMenu;
		readln(opcion);
	end;
END.

