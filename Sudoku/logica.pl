%
% logica.pl
% @author Felder, Tomas Ariel - Suburu, Ignacio
% @version 1.0
% @see https://docs.google.com/viewer?a=v&pid=sites&srcid=ZGVmYXVsdGRvbWFpbnxsY2NkY2ljMjAxN3xneDo3MGZiNGNiNTQxOTg1MjM4
% Proyecto 1 de la asginatura Logica para Ciencias de la Computacion, Universidad Nacional del Sur, Año 2017. El mismo se basa en la implementacion de la jugabilidad de un Sudoku, en el lenguaje prolog.

% ---------------------------------------------------------------------------------------------------
% Estructura del tablero y numeros validos.

% tableroProlog/3
% +ListaDeFilas, -ListaDeColumnas, -ListaDeCuadros.
% Metodo que al ingresar una lista de filas del sudoku (representacion empleada), devuelve la lista de columnas y de cuadros del mismo. Es inversible, es decir, que se podria ingresar alguna de las otras dos representaciones y funcionaria igual.

tableroProlog(TableroF,TableroC,TableroR):-
TableroF=[[P11,P12,P13,P14,P15,P16,P17,P18,P19],
[P21,P22,P23,P24,P25,P26,P27,P28,P29],
[P31,P32,P33,P34,P35,P36,P37,P38,P39],
[P41,P42,P43,P44,P45,P46,P47,P48,P49],
[P51,P52,P53,P54,P55,P56,P57,P58,P59],
[P61,P62,P63,P64,P65,P66,P67,P68,P69],
[P71,P72,P73,P74,P75,P76,P77,P78,P79],
[P81,P82,P83,P84,P85,P86,P87,P88,P89],
[P91,P92,P93,P94,P95,P96,P97,P98,P99]]
,
TableroC=[[P11,P21,P31,P41,P51,P61,P71,P81,P91],
[P12,P22,P32,P42,P52,P62,P72,P82,P92],
[P13,P23,P33,P43,P53,P63,P73,P83,P93],
[P14,P24,P34,P44,P54,P64,P74,P84,P94],
[P15,P25,P35,P45,P55,P65,P75,P85,P95],
[P16,P26,P36,P46,P56,P66,P76,P86,P96],
[P17,P27,P37,P47,P57,P67,P77,P87,P97],
[P18,P28,P38,P48,P58,P68,P78,P88,P98],
[P19,P29,P39,P49,P59,P69,P79,P89,P99]]
,
TableroR=[[P11,P12,P13,P21,P22,P23,P31,P32,P33],
[P14,P15,P16,P24,P25,P26,P34,P35,P36],
[P17,P18,P19,P27,P28,P29,P37,P38,P39],
[P41,P42,P43,P51,P52,P53,P61,P62,P63],
[P44,P45,P46,P54,P55,P56,P64,P65,P66],
[P47,P48,P49,P57,P58,P59,P67,P68,P69],
[P71,P72,P73,P81,P82,P83,P91,P92,P93],
[P74,P75,P76,P84,P85,P86,P94,P95,P96],
[P77,P78,P79,P87,P88,P89,P97,P98,P99]].

% nroValido/1
% Secuencia de hechos que determinan si dado un numero, este es valido para el Sudoku. Se puede usar de forma invertida consultando con una variable, que retorne un numero valido.

nroValido(1).
nroValido(2).
nroValido(3).
nroValido(4).
nroValido(5).
nroValido(6).
nroValido(7).
nroValido(8).
nroValido(9).


% ---------------------------------------------------------------------------------------------------
% Predicados auxiliares

% obtenerElemento/3
% +Posicion del elemento, +Lista donde buscar el elemento, -Elemento
% Predicado que devuelve el elemento en la posicion N de una lista especifica.

obtenerElemento(1,[A|_],A).
obtenerElemento(N,[_|B],A):- Aux is N-1, obtenerElemento(Aux,B,A).

% no_pertenece/2
% +Numero a chequear, +Lista donde chequear
% predicado que es verdadero cuando un numero N no pertenece a la lista especificada y falso en caso contrario.

no_pertenece(_,[]).
no_pertenece(N,[X|L]):-N\=X,no_pertenece(N,L).

% reemplazar/4
% +Elemento a ingresar, +Posicion en la lista, +Lista de entrada, -Lista de salida
% Predicado que reemplaza el elemento ubicado en la posicion N de la lista de entrada por el nuevo elemento y retorna la lista modificada.

reemplazar(Nuevo,1,[_|L],[Nuevo|L]).
reemplazar(Nuevo,N,[X|L],[X|LNueva]):- Aux is N-1, reemplazar(Nuevo,Aux,L,LNueva).


% ---------------------------------------------------------------------------------------------------
% Predicados para realizacion de movimiento

% agregar/5
% +Numero a Ingresar, +Coordenada X, +Coordenada Y, +Tablero de entrada, -Tablero de salida
%    Predicado que intenta agregar el numero dado en el tablero de Sudoku, obteniendo primero las tres representaciones (filas, columnas y cuadros) y despues comprobando en cada uno de estas si es una jugada valida. Si lo es, lo agrega al tablero en la posicion indicada, devolviendo el tablero con el numero ingresado.

agregar(N,X,Y,TableroF,TableroNuevo):-tableroProlog(TableroF,Columnas,Cuadros),
nroValido(X),nroValido(Y),Z is (((X-1) div 3)*3 + ((Y-1) div 3))+1,
nroValido(N),
jugadaValida(N,X,Y,Z,TableroF,Columnas,Cuadros),
agregarATablero(N,X,Y,TableroF,TableroNuevo).

% borrarJugada/5
% +Numero a ingresar, +Coordenada X, +Coordenada Y, +Tablero de entrada, -Tablero de salida
%  Predicado que reemplaza el contenido de la casilla en la posicion indicada por las coordenadas X e Y por un '0' y devuelve el tablero modificado.

borrarJugada(N,X,Y,TableroF,TableroNuevo):-N=0,nroValido(X),nroValido(Y),
agregarATablero(N,X,Y,TableroF,TableroNuevo).

% jugadaValida/7
% +Numero a ingresar, +Coordenada X, +Coordenada Y, +Numero de region, +Tablero en representacion de filas, +Tablero en representacion de columnas, +Tablero en representacion de regiones
% Predicado que resuelve si el numero N ya pertenece a la lista correspondiente en el tablero de filas, el tablero de columnas o el tablero de regiones.

jugadaValida(N,X,Y,Z,Filas,Columnas,Cuadros):-no_perteneceAMatriz(N,X,Filas),no_perteneceAMatriz(N,Z,Cuadros),
no_perteneceAMatriz(N,Y,Columnas).

% no_perteneceAMatriz/3
% +Numero a chequear, +Numero de lista, +Tablero
% Predicado que chequea si un numero N pertenece a una lista de una estructura en forma de lista de listas. En este caso resuelve si un numero pertenece a una lista especifica de un tablero dependiendo la representacion del mismo.

no_perteneceAMatriz(N,NroLista,TableroF):-obtenerElemento(NroLista,TableroF,L),no_pertenece(N,L).

% agregarATablero/5
% +Numero a ingresar, +Coordenada X, +Coordenada Y, +Tablero de entrada, -Tablero de salida
% reemplaza el numero ubicado en la coordenada X e Y del tablero recibido por N y retorna el tablero modificado

agregarATablero(N,X,Y,TableroF,TableroN):-obtenerElemento(X,TableroF,Fila),reemplazar(N,Y,Fila,FilaNueva),
reemplazar(FilaNueva,X,TableroF,TableroN).


% ---------------------------------------------------------------------------------------------------
% Predicados para comprobacion de resolubilidad del Sudoku

% comprobar/1
% +Tablero de entrada
% Predicado que devuelve verdadero en caso de que el tablero recibido tenga solucion y falso en caso contrario

comprobar(Tablero):-resolver(Tablero,_).

% resolver/2
% +Tablero de entrada, -Tablero de salida
% Predicado que intenta resolver el tablero recibido. Primero obtendra mediante el predicado tableroProlog/3 las otras dos representaciones necesarias. Luego mediante el predicado agregarNumero intentara agregar un numero en la proxima posicion vacia. Si tiene exito llamara nuevamente con el tablero nuevo con el numero ingresado. En caso de falla (que no pueda agregar un numero) entrara en el caso base o final que comprobara si el sudoku esta resuelto.

% Caso recursivo
resolver(TableroF,TableroOut):-tableroProlog(TableroF,TableroC,TableroR),
    			agregarNumero(TableroF,TableroNuevo,TableroC,TableroR,1),
				resolver(TableroNuevo,TableroOut).

% Caso base o final, cuando llega al punto en que no puede agregar mas numeros, chequea si el sudoku esta resuelto
resolver(TableroF,TableroF):-resuelto(TableroF).

% agregarNumero/5
% +Tablero de filas, -Tablero de salida, +Tablero de columnas, +Tablero de Regiones, +Numero de fila actual de recorrido
% Predicado que recorre el tablero de filas buscando una posicion en la que pueda agregar un numero. El caso base es cuando hay un cero en la fila actual. El caso recursivo es cuando no hay cero en la fila actual y debe buscar en la fila siguiente. Ira contabilizando el numero de fila en la que se encuentra para poder hacer la cuenta del cuadro luego. Si tiene exito, retornara el tablero de filas actualizado.

agregarNumero([Fila|Tablero],[Nueva|Tablero],TableroC,TableroR,NroF):-buscarCero(Fila,Nueva,Fila,TableroC,TableroR,NroF,1).
agregarNumero([Fila|Tablero],[Fila|T],TableroC,TableroR,NroF):-no_pertenece(0,Fila), Naux is NroF+1,
    							agregarNumero(Tablero,T,TableroC,TableroR,Naux).

% buscarCero/7
% +Fila de entrada que es recorrida, -Fila nueva de salida, +Fila de entrada que no es recorrida, +Tablero de columnas, +Tablero de regiones, +Numero de fila, +Numero de columna actual que se va a actualizando.
% Busca un cero en una fila y lo reemplaza por un numero valido que no pertenezca ni a la fila, ni a la columna, ni tampoco a la region o cuadro en cuestion. El caso recursivo es cuando todavia no encontro el cero de la fila, quita un elemento a la fila, avanza de columna en el tablero de ellas, suma uno al numero de columnas y llama recursivamente. El caso base es el planteado al principio, cuando encuentra el cero, lo intenta reemplazar.

% Caso base
buscarCero([0|Xs],[N|Xs],Fila,[Col|_],TableroR,NroF,Nroc):-nroValido(N),no_pertenece(N,Fila),no_pertenece(N,Col),Z is (((NroF-1) div 3)*3 + ((Nroc-1) div 3))+1,
    			obtenerElemento(Z,TableroR,L),no_pertenece(N,L).

%Caso recursivo
buscarCero([X|Xs],[X|Nueva],Fila,[_|TableroC],TableroR,NroF,Nroc):-X\=0,Naux is Nroc+1,buscarCero(Xs,Nueva,Fila,TableroC,TableroR,NroF,Naux).

% ---------------------------------------------------------------------------------------------------
% Predicados para chequeo de completitud del sudoku

% resuelto/1
% +Tablero de entrada
% Predicado que resuelve si se ah llegado al final del tablero en cada una de sus representaciones.

resuelto(TableroF):-tableroProlog(TableroF,Columnas,Cuadros),final(TableroF),final(Columnas),final(Cuadros).

% final/1
% +Lista de listas
% Predicado que chequea que no haya elementos repetidos dentro de cada lista perteneciente al tablero recibido.

% Caso base
final([]).

%Caso recursivo
final([Lista|Resto]):-todos_diferentes(Lista),
    				final(Resto).

% todos_diferentes/1
% +Lista de entrada
% Predicado que devuelve verdadero en caso de que todos los numeros de la lista de entrada sean diferentes y distintos de '0'.

%Casos base
todos_diferentes([]).
todos_diferentes([X,[]]):-X\=0.

%Caso recursivo
todos_diferentes([X|L]):-X\=0,no_pertenece(X,L),todos_diferentes(L).

% ---------------------------------------------------------------------------------------------------
