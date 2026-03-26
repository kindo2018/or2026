embed_scf( [ ], _ ).
embed_scf( [ P-S | H ], F ):-
   member( P-S, F ),
    embed_scf( H, F ).

scf_deformation( _-type, F, F, R, R ). 
scf_deformation( X-type, H, F, B, R ):-
    minimal_removal( A, D ),
    \+ member( A, B ),  
    scf( X-type, G, D, W ), W = poss,  
    embed_scf( G, H ),
    scf_deformation( X-type, H, F, [ A | B ], R ). 

 scf_deformation( X, H, F, R ):- scf_deformation( X, H, F, [], R ).


scf_deformation_x( _-type, F, F, R, R, K, K ). 
scf_deformation_x( X-type, H, F, B, R, [Q0:R0|C], K ):-
    minimal_removal( A, D ),
    \+ member( A, B ),  
    scf( X-type, G, D, W ), W = poss,  
    stat_not_best_outcomes( X-type, G, Q1, R1 ),
    R1 > R0,
    embed_scf( G, H ),
    scf_deformation_x( X-type, H, F, [ A | B ], R, [ Q1:R1, Q0:R0 | C ], K ). 

 scf_deformation_x( X, H, F, R, K ):-
    scf_deformation_x( X, H, F, [], R, [0:0], K ).


:- dynamic( tmp_max_poss_triad/3 ).

init_tmp_max_poss_triad:- abolish( tmp_max_poss_triad/3 ).

gen_triad_max_poss:-
	 C = init_tmp_max_poss_triad( _, _, _ ),
	 \+ clause( C, _ ),
	 init_tmp_max_poss_triad,
	 findall( P-_, pp( P ), F0 ),
	 T=gs-type,
	 scf_deformation_x( T, F0, F, R, K ),
	 findall( Rx, ( 
		 member( X, R ),
		 indexed_profiles( Rx, X )
	 ), L ),
	 length( L, 3 ),
	 assert( tmp_max_poss_triad( F, K, L ) ),
	 fail.

gen_triad_max_poss.

/*

?- hist( tmp_max_poss_triad( F, K, L ), K ).

 [(6/24:0.25),(5/24:0.21),(4/24:0.17),(0:0)]:6
 [(12/24:0.5),(11/24:0.46),(10/24:0.42),(0:0)]:6
 [(13/24:0.54),(12/24:0.5),(11/24:0.46),(0:0)]:12
 [(14/24:0.58),(13/24:0.54),(12/24:0.5),(0:0)]:6
 [(20/24:0.83),(19/24:0.79),(18/24:0.75),(0:0)]:6
total:36
true.

?- tmp_max_poss_triad( F, K, L ), fig(gs-type, F ), !, member( P-S, F ), manipulable( J, P-S, V, F ), J<3, nl, write( J:P-S:V ), fail; nl.


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  a  a  b  b  a  b  
2:[a,c,b]  a  a  a  c  c  c  
3:[b,a,c]  b  b  b  b  b  b  
4:[b,c,a]  b  b  b  b  b  b  
5:[c,a,b]  c  c  c  c  c  c  
6:[c,b,a]  c  c  c  c  c  c  
--
1:[[a,b,c],[b,a,c]]-b:[[a,c,b],[b,a,c]]-a
1:[[a,c,b],[c,a,b]]-c:[[a,b,c],[c,a,b]]-a
false.

?- hist( ( tmp_max_poss_triad( F, X, Triad ), stat_not_best_outcomes( gs-type, F, _, R ) ), R ).

 0.23:6
 0.46:6
 0.5:12
 0.54:6
 0.77:6
total:36
true.

?-

*/


findall_manipulability( F, M, K ):-
	 findall( J:P-S:V, (
		 member( P-S, F ),
		 manipulable( J, P-S, V, F ),
		 J < 3
	 ), M ),
	 length( M, K ).

fig_marked_manipulability( F, M ):-
	 findall( P-T, (
		 member( P-S, F ),
		 findall( J, member( J:P-S:_, M ), H ),
		 atomic_list_concat( [S|H], T )
	 ), F1 ),
	 fig( gs-type, F1 ). 



% ?- ['C:/Users/kenry/deform_scf.pl'].