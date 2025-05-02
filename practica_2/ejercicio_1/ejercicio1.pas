{
Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.

Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.
   
}


program untitled;
const
	valorAlto = 999;
type
	empleado = record
		codigo:integer;
		nombre:string;
		monto:real;
	end;
	
	archivo = file of empleado;
//El archivo se carga de informacion que posee la empresa 
//la informacion voy a suponer que esta en un txt
procedure cargarArchivo(var a:archivo); 
var
	e:empleado;
	arch:text;
begin
	writeln('Cargando archivo...');
	rewrite(a);
	
	assign(arch, 'empleados.txt');
	reset(arch);

	while(not eof(arch))do begin
		readln(arch, e.codigo,e.monto,e.nombre);
		write(a, e);
	end;
	
	close(a);
	close(arch)
end;

procedure leer(var arc: archivo; var dato: empleado);
begin
    if(not(eof(arc))) then
        read(arc, dato)
    else
        dato.codigo := valorAlto;
end;

procedure compactarArchivo(var detalle,maestro:archivo);
var
	e,actual:empleado;
	total:real;
begin
	writeln('Compactando archivo...');
	reset(detalle);
	rewrite(maestro);
	leer(detalle, e);
	
	while(e.codigo <> valorAlto)do begin
		actual:= e;
		total:= 0;
		while(actual.codigo = e.codigo) do begin
			total := total + e.monto;
			leer(detalle, e);
		end;
		actual.monto := total;
		write(maestro, actual);
	
	end;
	
	close(detalle);
	close(maestro);
	writeln('Archivo compactado');
end;

procedure imprimirMaestro(var maestro: archivo);
var
    emp: empleado;
begin
    reset(maestro);
    while(not EOF(maestro)) do
        begin
            read(maestro, emp);
            writeln('Codigo=', emp.codigo, ' Nombre=', emp.nombre, ' MontoTotal=', emp.monto:0:2);
        end;
    close(maestro);
end;

var
	arch_maestro, arch_detalle:archivo;
BEGIN
	Assign(arch_detalle, 'empleados');
	Assign(arch_maestro, 'empleadosCompactado');
	cargarArchivo(arch_detalle);
	compactarArchivo(arch_detalle, arch_maestro);
	imprimirMaestro(arch_maestro);
END.

