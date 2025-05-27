{
11. Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el
siguiente formato:

Departamento

División

Número de Empleado	Total de Hs.	Importe a cobrar
...... 				.......... 		.........

...... 				.......... 		.........

Total de horas división: ____

Monto total por división: ___

División

.................

Total horas departamento: ____
Monto total departamento: ____

Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría
}


program tp2.ejercicio11;
const
	valorAlto=9999;
	DF = 15;
type
	categorias = 1..DF; 
	empleado = record
		departamento:integer;
		division:integer;
		numero:integer;
		categoria: categorias;
		cantHorasExtras:integer;
	end;		
	
	archivo = file of empleado;	
	vector = array[categorias] of real;

procedure cargarVector(var v:vector);
var
	i:categorias;
	carga:text;
	valorHora:real; 
begin
	assign(carga, 'categorias.txt');
	reset(carga);
	while(not eof(carga)) do begin
		readln(carga, i, valorHora);
		v[i]:=valorHora;
	end;
	close(carga);
end;

procedure crearArchivoMaestro(var mae:archivo);
var
	e:empleado;
	carga:text;
begin
	assign(mae, 'maestro');
	rewrite(mae);
	assign(carga, 'maestro.txt');
	reset(carga);
	while not eof(carga) do
		with e do begin
			readln(carga, departamento, division, numero, categoria, cantHorasExtras);
			write(mae, e);
		end;
	close(mae);
	close(carga);
end;

procedure leerEmpleado(var mae:archivo; var e:empleado);
begin
	if(not eof(mae))then
		read(mae, e)
	else
		e.departamento := valorAlto;
end;

procedure recorrerArchivo(var mae:archivo; v:vector);
var
	e:empleado;
	montoDepartamento, montoDivision, importe:real;
	horasDepartamento, horasDivision, horasExtra:integer;
	depaActual, diviActual, empleadoActual:integer;
begin
	reset(mae);
	leerEmpleado(mae, e);
	while(e.departamento <> valorAlto) do begin
		depaActual:= e.departamento;
		writeln();
		writeln('Departamento ',depaActual);
		horasDepartamento:=0;
		montoDepartamento:=0;
		while(e.departamento = depaActual)do begin
			diviActual:= e.division;
			horasDivision:=0;
			montoDivision:=0;
			writeln();
			writeln('Division ',diviActual);
			writeln('Numero de empleado   Total de hs   importe a cobrar');
			while((e.departamento = depaActual)and(e.division = diviActual))do begin
				empleadoActual := e.numero;
				horasExtra:=0;
				importe:=v[e.categoria];
				while((e.departamento = depaActual)and(e.division = diviActual)and(e.numero = empleadoActual)) do begin
					horasExtra:=horasExtra + e.cantHorasExtras;
					
					leerEmpleado(mae, e);	
				end;
				importe:= importe * horasExtra;
				montoDivision:=montoDivision + importe;
				horasDivision:=horasDivision+horasExtra;
				writeln(empleadoActual,'		     ', horasExtra,'		   ', importe:0:2);
			end;
			writeln('Total de horas division: ', horasDivision);
			writeln('Monto total por division: ', montoDivision:0:2);
			horasDepartamento:= horasDepartamento + horasDivision;
			montoDepartamento:= montoDepartamento + montoDivision;
				
		end;
		writeln('Total horas departamento ', horasDepartamento);
		writeln('Monto total departamento ', montoDepartamento:0:2);
	end;
	close(mae);
end;

var
	v: vector;
	mae: archivo;
BEGIN
	cargarVector(v);
	crearArchivoMaestro(mae);
	recorrerArchivo(mae, v);
END.
	

