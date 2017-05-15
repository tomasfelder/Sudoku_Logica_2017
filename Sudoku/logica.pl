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
		  
nroValido(1).
nroValido(2).
nroValido(3).
nroValido(4).
nroValido(5).
nroValido(6).
nroValido(7).
nroValido(8).
nroValido(9).

agregar(N,X,Y,TableroF,TableroNuevo):-tableroProlog(TableroF,Columnas,Cuadros),
							nroValido(X),nroValido(Y),Z is (((X-1) div 3)*3 + ((Y-1) div 3))+1,
    						nroValido(N),
    						jugadaValida(N,X,Y,Z,TableroF,Columnas,Cuadros),
    						agregarATablero(N,X,Y,TableroF,TableroNuevo).
    						
borrarJugada(N,X,Y,TableroF,TableroNuevo):-N=0,nroValido(X),nroValido(Y),
    								agregarATablero(N,X,Y,TableroF,TableroNuevo).    	
    										
jugadaValida(N,X,Y,Z,Filas,Columnas,Cuadros):-no_perteneceAMatriz(N,X,Filas),no_perteneceAMatriz(N,Z,Cuadros),
							no_perteneceAMatriz(N,Y,Columnas).

no_perteneceAMatriz(N,NroLista,TableroF):-obtenerElemento(NroLista,TableroF,L),no_pertenece(N,L).

obtenerElemento(1,[A|_],A).
obtenerElemento(N,[_|B],A):- Aux is N-1, obtenerElemento(Aux,B,A).

no_pertenece(_,[]).
no_pertenece(N,[X|L]):-N\=X,no_pertenece(N,L).

agregarATablero(N,X,Y,TableroF,TableroN):-obtenerElemento(X,TableroF,Fila),reemplazar(N,Y,Fila,FilaNueva),
    										reemplazar(FilaNueva,X,TableroF,TableroN).

reemplazar(Nuevo,1,[_|L],[Nuevo|L]).
reemplazar(Nuevo,N,[X|L],[X|LNueva]):- Aux is N-1, reemplazar(Nuevo,Aux,L,LNueva).

comprobar(Tablero):-resolver(Tablero,_).

resolver(TableroF,TableroOut):-tableroProlog(TableroF,TableroC,_),
    			agregarNumero(TableroF,TableroNuevo,TableroC),
    			tableroProlog(TableroNuevo,_,Cuadros),
    			todos_diferentes_matriz(Cuadros),
				resolver(TableroNuevo,TableroOut).

resolver(TableroF,TableroOut):-resuelto(TableroF),copiarSalida(TableroF,TableroOut).

resuelto(TableroF):-tableroProlog(TableroF,Columnas,Cuadros),final(TableroF),final(Columnas),final(Cuadros).

copiarSalida([],[]).
copiarSalida([X|Xs],[X|Ys]):-copiarSalida(Xs,Ys).

agregarNumero([Fila|Tablero],[Nueva|Tablero],TableroC):-buscarCero(Fila,Nueva,Fila,TableroC).
agregarNumero([Fila|Tablero],[Fila|T],TableroC):-no_pertenece(0,Fila),
    							agregarNumero(Tablero,T,TableroC).

buscarCero([0|Xs],[N|Xs],Fila,[Col|_]):-nroValido(N),no_pertenece(N,Fila),no_pertenece(N,Col).
buscarCero([X|Xs],[X|Nueva],Fila,[_|TableroC]):-X\=0,buscarCero(Xs,Nueva,Fila,TableroC).

todos_diferentes_matriz([]).
todos_diferentes_matriz([Lista|Resto]):-todos_diferentes(Lista),
    				todos_diferentes_matriz(Resto).

todos_diferentes([]).
todos_diferentes([_,[]]).
todos_diferentes([X|L]):-X\=0,no_pertenece(X,L),todos_diferentes(L).
todos_diferentes([X|L]):-X=0,todos_diferentes(L).

final([]).
final([Lista|Resto]):-todos_diferentes_2(Lista),
    				final(Resto).

todos_diferentes_2([]).
todos_diferentes_2([X,[]]):-X\=0.
todos_diferentes_2([X|L]):-X\=0,no_pertenece(X,L),todos_diferentes_2(L).