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

listaNumeros([1,2,3,4,5,6,7,8,9]).

coordenadas( [[1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8], [1, 9], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7], [2, 8], [2, 9], [3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7], [3, 8], [3, 9], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7], [4, 8], [4, 9], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [5, 7], [5, 8], [5, 9], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7], [6, 8], [6, 9], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7], [7, 8], [7, 9], [8, 1], [8, 2], [8, 3], [8, 4], [8, 5], [8, 6], [8, 7], [8, 8], [8, 9], [9, 1], [9, 2], [9, 3], [9, 4], [9, 5], [9, 6], [9, 7], [9, 8], [9, 9]]).

agregar(N,X,Y,TableroF,TableroNuevo):-tableroProlog(TableroF,Columnas,Cuadros),Z is (((X-1) div 3)*3 + ((Y-1) div 3))+1
							,jugadaValida(N,X,Y,Z,TableroF,Columnas,Cuadros),
    		agregarATablero(N,X,Y,TableroF,TableroNuevo).
jugadaValida(N,X,Y,Z,Filas,Columnas,Cuadros):-no_perteneceAMatriz(N,X,Filas),no_perteneceAMatriz(N,Z,Cuadros),
							no_perteneceAMatriz(N,Y,Columnas).

no_perteneceAMatriz(N,NroLista,TableroF):-obtenerLista(NroLista,TableroF,L),no_pertenece(N,L).

obtenerLista(1,[A|_],A).
obtenerLista(N,[_|B],A):- Aux is N-1, obtenerLista(Aux,B,A).

no_pertenece(_,[]).
no_pertenece(N,[X|L]):-N\=X,no_pertenece(N,L).

agregarATablero(N,X,Y,TableroF,TableroN):-obtenerLista(X,TableroF,Fila),reemplazar(N,Y,Fila,FilaNueva),
    										reemplazar(FilaNueva,X,TableroF,TableroN).

reemplazar(Nuevo,1,[_|L],[Nuevo|L]).
reemplazar(Nuevo,N,[X|L],[X|LNueva]):- Aux is N-1, reemplazar(Nuevo,Aux,L,LNueva).

comprobar(TableroF):-coordenadas(C),comprobar_aux(TableroF,C).

comprobar_aux(_,[]).
comprobar_aux(TableroF,[[X,Y]|C]):-esCero(TableroF,X,Y),listaNumeros(L),
									asignarNumero(TableroF,X,Y,L,TableroNuevo),comprobar_aux(TableroNuevo,C).
comprobar_aux(TableroF,[[_,_]|C]):-comprobar_aux(TableroF,C).

esCero(TableroF,X,Y):-obtenerLista(X,TableroF,L),obtenerLista(Y,L,E),E=0.

asignarNumero(TableroF,X,Y,[],TableroF).
asignarNumero(TableroF,X,Y,[E|L],TableroNuevo):-agregar(E,X,Y,TableroF,TableroNuevo),
											asignarNumero(TableroF,X,Y,L,TableroNuevo).
asignarNumero(TableroF,X,Y,[_|L],TableroNuevo):-asignarNumero(TableroF,X,Y,L,TableroNuevo).