% sct2025y.pl
% 29-30 Dec 2025, 1-6 Jan 2026 (sct2025),
% 6-7(x) 11-13(x2,x3), 13-17(y), 18-21(y2) Jan 2026

mapz( end, F, F ):-!.
mapz( end( X ), F, F:X ):-!.

mapz( Axiom, A, F ):-
	% Axiom \= end,
	 apply( Axiom, [ A -> B, X ] ),
	 mapz( X, B, F ).

tol( [X|D], A -> [X|A], tol( D ) ).   
tol( [_|D], A -> A, tol( D ) ).   
tol( [ ], A -> B, end ):- reverse( A, B ).   

collect( B, A -> [X|A], collect( B ) ):-
	 member( X, B ),
	 \+ member( X, A ).

collect( _, A -> A, end ):- !.   

/*

?- mapz( tol([a,b,c]), [ ], F ), write( F ), fail.
[a,b,c][a,b][a,c][a][b,c][b][c][]
false.

?- mapz( collect([a,b,c]), [ ], F ), write(F), fail.
[c,b,a][b,a][b,c,a][c,a][a][c,a,b][a,b][a,c,b][c,b][b][b,a,c][a,c][a,b,c][b,c][c][]
false.

*/

unanimity( (X,Y), [ X>Y, X>Y ], X>Y ). 
unanimity( (X,Y), [ Y>X, Y>X ], Y>X ). 

% n = 3

unanimity( (X,Y), [ S, S, S ], S ):- member( S, [ X>Y, Y>X ] ). 


iia( (X,Y), [ X>Y, Y>X ], X>Y ). 
iia( (X,Y), [ X>Y, Y>X ], Y>X ). 
iia( (X,Y), [ Y>X, X>Y ], X>Y ). 
iia( (X,Y), [ Y>X, X>Y ], Y>X ). 

% n = 3

iia( (X,Y), [ X>Y, X>Y, Y>X ], S ):- member( S, [ X>Y, Y>X ] ).
iia( (X,Y), [ Y>X, Y>X, X>Y ], S ):- member( S, [ X>Y, Y>X ] ).
%
iia( (X,Y), [ X>Y, Y>X, X>Y ], S ):- member( S, [ X>Y, Y>X ] ). 
iia( (X,Y), [ X>Y, Y>X, Y>X ], S ):- member( S, [ X>Y, Y>X ] ). 
iia( (X,Y), [ Y>X, X>Y, X>Y ], S ):- member( S, [ X>Y, Y>X ] ). 
iia( (X,Y), [ Y>X, X>Y, Y>X ], S ):- member( S, [ X>Y, Y>X ] ). 


aggregation_rule( (X,Y), [A | B ], C ):- 
	 unanimity( (X,Y), [ A | B ], C );
	 iia( (X,Y), [ A | B ], C ). 


assign( B, A -> [ (P,Q) -> S | A ], assign( B ) ):-
	 member( X, B ),
	 member( Y, B ),
	 aggregation_rule( (X,Y), [P | Q], S ),
	 \+ member( (P,Q)->_, A ).

assign( _, A -> A, end ):- !.   


% note. assign not to be used here after. 
% the above as a sample of using mapz 

/*

?- mapz( assign([a,b,c,d]), [ ], F ), length( F, N ).
F = [(d>d, [d>d, d>d]->d>d), (d>d, [d>d]->d>d), (d>c, [c>d, d>c]->c>d), (d>c, [c>d, c>d]->c>d), (c>d, [d>c, ... > ...]->c>d), (c>d, [... > ...|...]->c>d), (... > ..., [...]->c>d), (..., ... -> ... > ...), (... -> ...)|...],
N = 68 .

?- mapz( assign([a,b,c]), [ ], F ), length( F, N ).
F = [(c>c, [c>c, c>c]->c>c), (c>c, [c>c]->c>c), (c>b, [b>c, c>b]->b>c), (c>b, [b>c, b>c]->b>c), (b>c, [c>b, ... > ...]->b>c), (b>c, [... > ...|...]->b>c), (... > ..., [...]->b>c), (..., ... -> ... > ...), (... -> ...)|...],
N = 36 .


*/



order( [ X, Y, Z ], [ A, B, C ] ):-
 member( A, [X>Y,Y>X] ), 
 member( B, [Y>Z,Z>Y] ), 
 member( C, [Z>X,X>Z] ),
 D = [ [ X>Y, Y>Z, Z>X ], [ Y>X, Z>Y, X>Z ] ],
 \+ member( [ A, B, C ], D ).

/*

?- order([a,b,c], A ), nl, write( A ), fail.

[a>b,b>c,a>c]
[a>b,c>b,c>a]
[a>b,c>b,a>c]
[b>a,b>c,c>a]
[b>a,b>c,a>c]
[b>a,c>b,c>a]
false.

*/


order( [ X, Y, Z, W ], R ):-
 member( A, [X>Y,Y>X] ), 
 member( B, [Y>Z,Z>Y] ), 
 member( C, [Z>X,X>Z] ),
 member( A1, [X>W,W>X] ), 
 member( B1, [Y>W,W>Y] ), 
 member( C1, [Z>W,W>Z] ),
 R = [ A, B, C, A1, B1, C1 ],
 permutation_to_pairwise_order( [ X, Y, Z, W ], _, R ).

/*

?- order([a,b,c,d], A ), nl, write( A ), fail.

[a>b,b>c,a>c,a>d,b>d,c>d]
[a>b,b>c,a>c,a>d,b>d,d>c]
[a>b,b>c,a>c,a>d,d>b,d>c]
[a>b,b>c,a>c,d>a,d>b,d>c]
[a>b,c>b,c>a,a>d,b>d,c>d]
[a>b,c>b,c>a,a>d,d>b,c>d]
[a>b,c>b,c>a,d>a,d>b,c>d]
[a>b,c>b,c>a,d>a,d>b,d>c]
[a>b,c>b,a>c,a>d,b>d,c>d]
[a>b,c>b,a>c,a>d,d>b,c>d]
[a>b,c>b,a>c,a>d,d>b,d>c]
[a>b,c>b,a>c,d>a,d>b,d>c]
[b>a,b>c,c>a,a>d,b>d,c>d]
[b>a,b>c,c>a,d>a,b>d,c>d]
[b>a,b>c,c>a,d>a,b>d,d>c]
[b>a,b>c,c>a,d>a,d>b,d>c]
[b>a,b>c,a>c,a>d,b>d,c>d]
[b>a,b>c,a>c,a>d,b>d,d>c]
[b>a,b>c,a>c,d>a,b>d,d>c]
[b>a,b>c,a>c,d>a,d>b,d>c]
[b>a,c>b,c>a,a>d,b>d,c>d]
[b>a,c>b,c>a,d>a,b>d,c>d]
[b>a,c>b,c>a,d>a,d>b,c>d]
[b>a,c>b,c>a,d>a,d>b,d>c]
false.

*/


order( [ X, Y, Z, W, V ], R ):-
 member( A, [X>Y,Y>X] ), 
 member( B, [Y>Z,Z>Y] ), 
 member( C, [Z>X,X>Z] ),
 member( A1, [X>W,W>X] ), 
 member( B1, [Y>W,W>Y] ), 
 member( C1, [Z>W,W>Z] ),
 member( A2, [X>V,V>X] ), 
 member( B2, [Y>V,V>Y] ), 
 member( C2, [Z>V,V>Z] ),
 member( D, [W>V,W>Z] ),
 R = [ A, B, C, A1, B1, C1, A2, B2, C2, D ],
 permutation_to_pairwise_order( [ X, Y, Z, W, V ], _, R ).


show_domain( L, _ ):- 
	 findall( J, nth1( J, L, _ ), H ),
	 format('~w\t~w;', ['',H] ),
	 nl,
	 fail.
show_domain( L, D ):- 
	 nth1( J, L, S ),
	 findall( T, ( 
		 nth1( _, L, X ),
		 ( nth1( I, D, [ S, X ] ) -> T = I ; T = '-' )
	 ) , W ),
	 format('~w:~w\t~w;\n', [J,S, W] ),
	 fail.
show_domain( _, _ ).

repeated_strings( C, N, B ):-
	 findall( C, between( 1, N, _ ), B ).  

align_right( X, N, F, Y ):-
	 atom_length( X, K ),
	 W is N - K,
	 repeated_strings( F, W, B ),
	 atomic_list_concat( B, '', A ),
	 atom_concat( A, X, Y ). 


show_domain( A, L, _ ):- 
	 length( L, K ),
	 atom_length( K, N ),
	 findall( Jx, ( nth1( J, L, _ ), align_right( J, N, '\s', Jx ) ),  H ),
	 atomic_list_concat( A, '', Ax ),
	 format('~w\t~w;', [Ax,H] ),
	 nl,
	 fail.
show_domain( A, L, D ):- 
	 length( L, K ),
	 atom_length( K, N ),
	 nth1( J, L, S ),
	 findall( Tx, ( 
		 nth1( _, L, X ),
		 ( nth1( I, D, [ S, X ] ) -> T = I ; T = '-' ),
		 align_right( T, N, '\s', Tx )
	 ) , W ),
	 order_as_concat( A, _, S, Sx ),  
	 format('~w:~w\t~w;\n', [J,Sx, W] ),
	 fail.
show_domain( _, _, _ ).

show_swf( L, _ ):- 
	 findall( J, nth1( J, L, _ ), H ),
	 format('~w\t~w;', ['',H] ),
	 nl,
	 fail.
show_swf( L, F ):- 
	 nth1( J, L, S ),
	 findall( T, ( 
		 nth1( _, L, X ),
		 ( ( member( [ S, X ]-Y, F ), nth1( I, L, Y ) ) -> T = I ; T = '-' )
	 ) , W ),
	 format('~w:~w\t~w;\n', [J,S, W] ),
	 fail.
show_swf( _, _ ).


swf_value_in_triple( S, [ P1, P2 ], [ W1, W2, W3 ], [ A, B, C ] ):- 
	 member( [ X1, X2 ] -> W1, S ),
	 member( [ Y1, Y2 ] -> W2, S ),
	 member( [ Z1, Z2 ] -> W3, S ),
	 P1 = [ X1, Y1, Z1 ],
	 P2 = [ X2, Y2, Z2 ],
	 order( [ A, B, C ], P1 ),
	 order( [ A, B, C ], P2 ).

swf_value_in_triple( S, [ P1, P2, P3 ], [ W1, W2, W3 ], [ A, B, C ] ):- 
	 member( [ W1, W2, W3 ],  [ [ A > B, B > C, C > A ], [ B > A, C > B, A > C ] ] ),
	 member( [ X1, X2, X3 ] -> W1, S ),
	 member( [ Y1, Y2, Y3 ] -> W2, S ),
	 member( [ Z1, Z2, Z3 ] -> W3, S ),
	 P1 = [ X1, Y1, Z1 ],
	 P2 = [ X2, Y2, Z2 ],
	 P3 = [ X3, Y3, Z3 ],
	 order( [ A, B, C ], P1 ),
	 order( [ A, B, C ], P2 ),
	 order( [ A, B, C ], P3 ).


/*

?- n2m4_max_poss( F ), swf_value_in_triple( F, A, B, C ).
F = [([d>c, d>c]->d>c), ([d>c, c>d]->d>c), ([d>b, d>b]->d>b), ([d>b, b>d]->d>b), ([d>a, d>a]->d>a), ([d>a, ... > ...]->a>d), ([... > ...|...]->c>d), ([...|...]-> ... > ...), (... -> ...)|...],
A = [[d>c, c>a, d>a], [c>d, c>a, a>d]],
B = [d>c, c>a, a>d],
C = [d, c, a] .


*/

inequality_index( F, G, Mz/ Nz, Tz ):-
	 findall( J, ( member( P->S, F ), nth1( J, P, S ) ), G ),
	 length( G, Nz ),
	 sum_list( G, Mz ),
	 Tz is Mz / Nz.

write_inequality_index( F ):-
	 inequality_index( F, _, Mz / Nz, Tz ),
	 writeln( inequality( Tz )= Mz/Nz ).

/*


?- [n3m3_max_poss].
true.

?- hist( (n3m3_max_poss(F), inequality_index( F, A, B, C ) ), C=B:A ).

 (2=96/48:[1,2,3,1,2,1,3,1,1,2,3,1,2,1,3,1,2,3,2,3,1,2,3,1,2,3,1,2,1,3,2,3,2,3,2,3,1,2,3,2,3,1,3,1,2,1,2,3]):1
 (2=96/48:[1,2,3,1,2,1,3,1,1,2,3,1,2,1,3,2,3,2,3,2,3,1,2,3,1,2,3,3,2,2,3,2,3,1,3,1,2,1,2,3,1,1,3,1,2,1,2,3]):1
 (2=96/48:[1,2,3,1,2,1,3,2,3,1,2,3,1,2,1,3,1,2,3,1,3,1,2,1,2,3,1,2,3,1,2,1,3,1,2,3,2,3,1,2,3,2,3,2,3,1,2,3]):1
 (2=96/48:[1,2,3,1,2,1,3,2,3,1,2,3,3,2,2,3,2,3,1,3,1,2,1,2,3,1,2,3,3,2,2,3,1,1,3,1,2,1,2,3,1,1,3,1,2,1,2,3]):1
 (2=96/48:[1,2,3,3,2,2,3,1,2,3,1,2,1,3,2,3,1,1,3,1,2,1,2,3,1,2,3,1,2,1,3,1,2,3,1,3,1,2,1,2,3,2,3,2,3,1,2,3]):1
 (2=96/48:[1,2,3,3,2,2,3,1,2,3,3,2,2,3,1,1,3,1,2,1,2,3,1,2,3,1,2,1,3,2,3,1,1,3,1,2,1,2,3,2,3,1,3,1,2,1,2,3]):1
total:6
true.

?- hist( (n3m3_max_poss(F), inequality_index( F, A, B, C ) ), C=B ).

 (2=96/48):6
total:6
true.

?- hist( (n3m3_max_poss(F), inequality_index( F, A, B, C ), bagof( 1, member( J, A ), L ), length( L, K ) ), C=B:J:K ).

 (2=96/48:1:16):6
 (2=96/48:2:16):6
 (2=96/48:3:16):6
total:18
true.

?- [n2m3_max_poss].true.

?- hist( (n2m3_max_poss(F), inequality_index( F, A, B, C ), bagof( 1, member( J, A ), L ), length( L, K ) ), C=B:J:K ).

 (1.4444444444444444=26/18:1:10):6
 (1.4444444444444444=26/18:2:8):6
 (1.5=27/18:1:9):6
 (1.5=27/18:2:9):6
 (1.5555555555555556=28/18:1:8):6
 (1.5555555555555556=28/18:2:10):6
total:36
true.


?- [n2m4_max_poss].
true.

?- n2m4_max_poss(F).
F = [([d>c, d>c]->d>c), ([d>c, c>d]->d>c), ([d>b, d>b]->d>b), ([d>b, b>d]->d>b), ([d>a, d>a]->d>a), ([d>a, ... > ...]->a>d), ([... > ...|...]->c>d), ([...|...]-> ... > ...), (... -> ...)|...] .

?- hist( (n2m4_max_poss(F), inequality_index( F, A, B, C ) ), C=B ).

 (1.3611111111111112=49/36):12
 (1.4166666666666667=51/36):8
 (1.5833333333333333=57/36):8
 (1.6388888888888888=59/36):12
total:40
true.

?- hist( (n2m4_max_poss(F), inequality_index( F, A, B, C ), bagof( 1, member( J, A ), L ), length( L, K ) ), C=B:J:K ).

 (1.3611111111111112=49/36:1:23):12
 (1.3611111111111112=49/36:2:13):12
 (1.4166666666666667=51/36:1:21):8
 (1.4166666666666667=51/36:2:15):8
 (1.5833333333333333=57/36:1:15):8
 (1.5833333333333333=57/36:2:21):8
 (1.6388888888888888=59/36:1:13):12
 (1.6388888888888888=59/36:2:23):12
total:80
true.


?- [n2m5_max_poss_and_min_cut_pairwise].
true.


?- hist( (n2m5_max_poss_and_min_cut(_,_,F,_,_), inequality_index( F, A, B, C ), bagof( 1, member( J, A ), L ), length( L, K ) ), C=B:J:K ).

 (1.35=81/60:1:39):20
 (1.35=81/60:2:21):20
 (1.65=99/60:1:21):20
 (1.65=99/60:2:39):20
total:80
true.

*/


d_pair( B, X, Y ):-
	 member( X, B ),
	 member( Y, B ),
	 X @< Y.


unassigned( B, (X,Y), A, [P|Q] -> S ):-
	 d_pair( B, X, Y ),
	 aggregation_rule( ( X, Y ), [ P | Q ], S ),
	 \+ member( [P|Q] -> _, A ).

first_in_remaining( G, X, H, Y ):-
	 copy_term( G:X, H:Y ), 
	 call( G ), 
	 \+ (
		 call( H ),
		 Y @< X
	 ).

d_triple( B, [ X, Y, Z ] ):-
	 append( _, [X|U], B ),
	 append( _, [Y|V], U ),
	 append( _, [Z|_], V ).

/*

?- d_triple([a,b,c,d], T ), nl, write( T ), fail.

[a,b,c]
[a,b,d]
[a,c,d]
[b,c,d]
false.

*/

intransitivity( right, S, A, [P,Q], [X,Y,Z], [P1,Q1,P2,Q2] ):-
	 S = ( X > Y ),
	 member( [ P1, Q1 ] -> Y>Z, A ),
	 order( [X,Y,Z], [ P,P1,P2 ] ),
	 member( [ P2, Q2 ] -> Z>X, A ),
	 order( [X,Y,Z], [ Q,Q1,Q2 ] ).

intransitivity( left, S, A, [P,Q], [X,Y,Z], [P1,Q1,P2,Q2] ):-
	 S = ( Y > X ),
	 member( [ P1, Q1 ] -> Z>Y, A ),
	 order( [X,Y,Z], [ P,P1,P2 ] ),
	 member( [ P2, Q2 ] -> X>Z, A ),
	 order( [X,Y,Z], [ Q,Q1,Q2 ] ).

intransitivity3( right, S, A, [P,Q,R], [X,Y,Z], [P1,Q1,R1,P2,Q2,R2] ):-
	 S = ( X > Y ),
	 member( [ P1, Q1, R1 ] -> Y>Z, A ),
	 order( [X,Y,Z], [ P,P1,P2 ] ),
	 order( [X,Y,Z], [ R,R1,R2 ] ),
	 member( [ P2, Q2, R2 ] -> Z>X, A ),
	 order( [X,Y,Z], [ Q,Q1,Q2 ] ).

intransitivity3( left, S, A, [P,Q,R], [X,Y,Z], [P1,Q1,R1,P2,Q2,R2] ):-
	 S = ( Y > X ),
	 member( [ P1, Q1, R1 ] -> Z>Y, A ),
	 order( [X,Y,Z], [ P,P1,P2 ] ),
	 order( [X,Y,Z], [ R,R1,R2 ] ),
	 member( [ P2, Q2, R2 ] -> X>Z, A ),
	 order( [X,Y,Z], [ Q,Q1,Q2 ] ).

assign_next( B, A, [P|Q] -> S ):-
	 G = unassigned( B, _, A, [P|Q] -> S ),
	 first_in_remaining( G, [P|Q], _, _ ).


transitive1( B, A -> [ [P,Q] -> S | A ], transitive1( B ) ):-
	 assign_next( B, A, [P,Q]->S ),
	 \+ intransitivity( _, S, A, [P,Q], _, _ ).

transitive1( _, A -> A, end ):- !.   

/*

?- mapz( transitive1([a,b,c]), [ ], F ), length( F, N ), N>11, nl, forall( (member( X, F ), X\=([Y,Y]->Y) ) , ( writeln(X;' '))), fail.

[c>b,b>c]->c>b; 
[c>a,a>c]->c>a; 
[b>c,c>b]->b>c; 
[b>a,a>b]->b>a; 
[a>c,c>a]->a>c; 
[a>b,b>a]->a>b; 

[c>b,b>c]->b>c; 
[c>a,a>c]->a>c; 
[b>c,c>b]->c>b; 
[b>a,a>b]->a>b; 
[a>c,c>a]->c>a; 
[a>b,b>a]->b>a; 
false.

?- 

tell('n2m3_min_cut.txt'),  A=[a,b,c], mapz( transitive(A, []), [ ], F:C ), length( F, N ), N>11, length(C, K), K=2, nl, concat_order_domain( A, C, D ), write( D ), fail; told.

?- 
tell('n2m3_max_poss.pl'), A= [a,b,c], time(( mapz( transitive(A, []), [ ], F:C ), length( F, N ), N>11, length(C, K), K=2, write( n2m3_max_poss( F ) ), writeln('.'), fail; told ) ).

*/

partial_triple( W, [ X, Y, Z ] ):-
	 append( A, [ X | _ ], W ),
	 append( B, [ Y | _ ], W ),
	 A \= B,
	 append( C, [ Z | _ ], W ),
	 A \= C,
	 B \= C,
	 subset( A, B ),
	 subset( B, C ).

/*

?- partially_consistent_triple( [a,b,c,d], P, [a>b, c>b, a>c] ).
P = [a>b, c>b, a>c, a>d, b>d, c>d] .

?- 
*/

consistent_triple( B, P, R ):-
	 order( B, P ),
	 subset( P, R ),
	 subset( R, P ).

transitive( B, C, A -> [ [P,Q] ->S | A ], transitive( B, D ) ):-
	 assign_next( B, A, [P,Q]->S ),
	 findall( W,(
		 intransitivity( _, S, A, [P,Q], [X,Y,Z], M ),
		 M = [P1,Q1,P2,Q2],
		 order_as_concat( [X,Y,Z], _, [P,P1,P2], U ),
		 order_as_concat( [X,Y,Z], _, [Q,Q1,Q2], V ),
%		 sort( [X,Y,Z], T ),
%		 consistent_triple( T, U, [P,P1,P2] ),
%		 consistent_triple( T, V, [Q,Q1,Q2] ),
		 W = [ U, V ]
	 ), L ),
	 append( L, C, H ),
	 sort( H, D ).

transitive( _, C, A -> A, end( C ) ):- !.   

transitive3( B, C, A -> [ [P,Q,R] ->S | A ], transitive3( B, D ) ):-
	 assign_next( B, A, [P,Q,R]->S ),
	 findall( W,(
		 intransitivity3( _, S, A, [P,Q,R], [X,Y,Z], M ),
		 M = [P1,Q1,R1,P2,Q2,R2],
		 sort( [X,Y,Z], T ),
		 consistent_triple( T, V1, [P,P1,P2] ),
		 consistent_triple( T, V2, [Q,Q1,Q2] ),
		 consistent_triple( T, V3, [R,R1,R2] ),
		 W = [ V1, V2, V3 ]
	 ), L ),
	 append( L, C, H ),
	 sort( H, D ).


transitive3( _, C, A -> A, end( C ) ):- !.   

/*

?- mapz( transitive([a,b,c], []), [ ], F:C ), length( F, N ), N>11, length(C, K), nl, forall( (member( X, F ), X\=([Y,Y]->Y) ) , ( writeln(X;' '))), write(C).

[c>b,b>c]->b>c; 
[c>a,a>c]->a>c; 
[b>c,c>b]->b>c; 
[b>a,a>b]->a>b; 
[a>c,c>a]->a>c; 
[a>b,b>a]->a>b; 
[[[a>b,c>b,c>a],[b>a,b>c,c>a]],[[b>a,b>c,c>a],[a>b,c>b,c>a]]]
F = [([c>b, c>b]->c>b), ([c>b, b>c]->b>c), ([c>a, c>a]->c>a), ([c>a, a>c]->a>c), ([b>c, c>b]->b>c), ([b>c, ... > ...]->b>c), ([... > ...|...]->b>a), ([...|...]-> ... > ...), (... -> ...)|...],
C = [[[a>b, c>b, c>a], [b>a, b>c, c>a]], [[b>a, b>c, c>a], [a>b, c>b, c>a]]],
N = 12,
K = 2 .

?- 

?- hist((mapz( transitive([a,b,c], []), [ ], F:C ), length( F, N ), N>11, length(C, K)), N:K ).

 (12:0):2
 (12:2):18
 (12:3):12
 (12:6):18
 (12:7):12
 (12:12):2
total:64
true.

?- time(hist((mapz( transitive([a,b,c], []), [ ], F:C ), length( F, N ), N>11, length(C, K)), N:K )).

 (12:0):2
 (12:2):18
 (12:3):12
 (12:6):18
 (12:7):12
 (12:12):2
total:64
% 273,782 inferences, 0.031 CPU in 0.021 seconds (149% CPU, 8761024 Lips)
true.

?- A=[a,b,c], mapz( transitive(A, []), [ ], F:C ), length( F, N ), N>11, length(C, K), K=2, nl, concat_order_domain( A, C, D ), write( D ), fail.

[[cab,bca],[bca,cab]]
[[bca,cab],[cba,bac]]
[[cab,bca],[bac,cba]]
[[bac,cba],[cba,bac]]
[[bac,cba],[bca,abc]]
[[cab,bca],[cba,acb]]
[[abc,bca],[cba,bac]]
[[abc,bca],[bca,abc]]
[[abc,bca],[bac,acb]]
[[acb,cba],[bca,cab]]
[[acb,cba],[cba,acb]]
[[acb,cba],[cab,abc]]
[[acb,bac],[bca,abc]]
[[abc,cab],[cba,acb]]
[[abc,cab],[cab,abc]]
[[abc,cab],[acb,bac]]
[[cab,abc],[bac,acb]]
[[acb,bac],[bac,acb]]
false.


?- mapz( transitive([a,b,c,d]), [ ], F ), length( F, N ), N>23, nl, forall( (member( X, F ), X\=([Y,Y]->Y) ) , ( writeln(X;' '))), fail.

[d>c,c>d]->d>c; 
[d>b,b>d]->d>b; 
[d>a,a>d]->d>a; 
[c>d,d>c]->c>d; 
[c>b,b>c]->c>b; 
[c>a,a>c]->c>a; 
[b>d,d>b]->b>d; 
[b>c,c>b]->b>c; 
[b>a,a>b]->b>a; 
[a>d,d>a]->a>d; 
[a>c,c>a]->a>c; 
[a>b,b>a]->a>b; 

[d>c,c>d]->c>d; 
[d>b,b>d]->b>d; 
[d>a,a>d]->a>d; 
[c>d,d>c]->d>c; 
[c>b,b>c]->b>c; 
[c>a,a>c]->a>c; 
[b>d,d>b]->d>b; 
[b>c,c>b]->c>b; 
[b>a,a>b]->a>b; 
[a>d,d>a]->d>a; 
[a>c,c>a]->c>a; 
[a>b,b>a]->b>a; 
false.


?- time(hist((mapz( transitive([a,b,c,d], []), [ ], F:C ), length( F, N ), N>23, length(C, K)), N:K )).

 (24:0):2
 (24:6):40
 (24:8):168
 (24:9):96
 (24:10):48
 (24:11):48
 (24:12):180
 (24:13):240
 (24:14):192
 (24:15):192
 (24:16):96
 (24:17):432
 (24:18):696
 (24:19):192
 (24:20):96
 (24:21):208
 (24:22):432
 (24:23):192
 (24:24):186
 (24:25):48
 (24:26):48
 (24:27):144
 (24:28):120
total:4096
% 48,082,051 inferences, 2.906 CPU in 3.062 seconds (95% CPU, 16544362 Lips)
true.

?- N=2, B=[a,b,c,d], length( B, M ), hist((mapz( transitive(B, []), [ ], F:C ), length( F, I ), I>2^(N-1)*(M*(M-1))-1, length(C, K)), I:K ).

 (24:0):2
 (24:6):40
 (24:8):168
 (24:9):96
 (24:10):48
 (24:11):48
 (24:12):180
 (24:13):240
 (24:14):192
 (24:15):192
 (24:16):96
 (24:17):432
 (24:18):696
 (24:19):192
 (24:20):96
 (24:21):208
 (24:22):432
 (24:23):192
 (24:24):186
 (24:25):48
 (24:26):48
 (24:27):144
 (24:28):120
total:4096
N = 2,
B = [a, b, c, d],
M = 4.

?- N=2, M=5,A is 2^(N-1)*(M*(M-1)).N = 2,
M = 5,
A = 40.

?- N=2, B=[a,b,c,d,e], length( B, M ), mapz( transitive(B, []), [ ], F:C ), length( F, I ), I>2^(N-1)*(M*(M-1))-1, length(C, K).
N = 2,
B = [a, b, c, d, e],
M = 5,
F = [([e>d, e>d]->e>d), ([e>d, d>e]->d>e), ([e>c, e>c]->e>c), ([e>c, c>e]->c>e), ([e>b, e>b]->e>b), ([e>b, ... > ...]->b>e), ([... > ...|...]->e>a), ([...|...]-> ... > ...), (... -> ...)|...],
C = [[[a>b, c>b, c>a], [b>a, b>c, c>a]], [[a>b, d>b, d>a], [b>a, b>d, d>a]], [[a>b, e>b, e>a], [b>a, b>e, e>a]], [[a>c, d>c, d>a], [c>a, c>d, ... > ...]], [[a>c, e>c, ... > ...], [c>a, ... > ...|...]], [[a>d, ... > ...|...], [... > ...|...]], [[... > ...|...], [...|...]], [[...|...]|...], [...|...]|...],
I = 40,
K = 20 .

?- tell( 'test_n2m5.txt' ), N=2, B=[a,b,c,d,e], length( B, M ), time( hist((mapz( transitive(B, []), [ ], F:C ), length( F, I ), I>2^(N-1)*(M*(M-1))-1, length(C, K)), I:K ) ), told.
% 28,925,757,922 inferences, 1589.906 CPU in 1830.939 seconds (87% CPU, 18193373 Lips)
N = 2,
B = [a, b, c, d, e],
M = 5.

% rerun 24 Jan 2026

?- N=2, B=[a,b,c,d,e], length( B, M ), time( ( mapz( transitive(B, []), [ ], F:C ), length( F, I ), I>2^(N-1)*(M*(M-1))-1, length(C, K), assert( tmp_n2m5_swf( N,B, F, C, I, K ) ), fail ; true ) ).


?- N=2, B=[a,b,c,d,e], length( B, M ), time( hist((mapz( transitive(B, []), [ ], F:C ), length( F, I ), I>2^(N-1)*(M*(M-1))-1, length(C, K)), I:K ) ).

 (40:0):2
 (40:9):40
 (40:12):20
 (40:14):120
 (40:15):80
 (40:18):580
 (40:19):360
 (40:20):1860
 (40:21):1920
 (40:22):720
 (40:23):1320
 (40:24):3920
 (40:25):3360
 (40:26):4560
 (40:27):5000
 (40:28):3840
 (40:29):8520
 (40:30):15860
 (40:31):10680
 (40:32):10020
 (40:33):15800
 (40:34):18840
 (40:35):22680
 (40:36):30040
 (40:37):19680
 (40:38):30480
 (40:39):37520
 (40:40):44460
 (40:41):37800
 (40:42):46340
 (40:43):40560
 (40:44):54540
 (40:45):58080
 (40:46):50160
 (40:47):40080
 (40:48):54910
 (40:49):48120
 (40:50):54648
 (40:51):42360
 (40:52):35880
 (40:53):30000
 (40:54):44300
 (40:55):33600
 (40:56):21180
 (40:57):14880
 (40:58):17520
 (40:59):14160
 (40:60):9052
 (40:61):3240
 (40:62):1680
 (40:63):1200
 (40:64):1380
 (40:65):480
 (40:66):120
 (40:70):24
total:1048576
% 28,986,575,919 inferences, 1389.016 CPU in 5041.808 seconds (28% CPU, 20868430 Lips)
N = 2,
B = [a, b, c, d, e],
M = 5.

?- 


?- N=2, B=[a,b,c,d,e], length( B, M ), time( ( mapz( transitive(B, []), [ ], F:C ), length( F, I ), I>2^(N-1)*(M*(M-1))-1, length(C, K), assert( tmp_n2m5_swf( N,B, F, C, I, K ) ), fail ; true ) ).
% 31,643,425,295 inferences, 2165.078 CPU in 2561.355 seconds (85% CPU, 14615373 Lips)
N = 2,
B = [a, b, c, d, e],
M = 5.

?- hist( tmp_n2m5_swf(N,B,F,C,I,K ), K ).

 0:2
 9:40
 12:20
 14:120
 15:80
 18:580
 19:360
 20:1860
 21:1920
 22:720
 23:1320
 24:3920
 25:3360
 26:4560
 27:5000
 28:3840
 29:8520
 30:15860
 31:10680
 32:10020
 33:15800
 34:18840
 35:22680
 36:30040
 37:19680
 38:30480
 39:37520
 40:44460
 41:37800
 42:46340
 43:40560
 44:54540
 45:58080
 46:50160
 47:40080
 48:54910
 49:48120
 50:54648
 51:42360
 52:35880
 53:30000
 54:44300
 55:33600
 56:21180
 57:14880
 58:17520
 59:14160
 60:9052
 61:3240
 62:1680
 63:1200
 64:1380
 65:480
 66:120
 70:24
total:1048576
true.

?- tell( 'tmp_n2m5_swf.pl' ),C = tmp_n2m5_swf(N,B,F,C,I,K ), C, write( C ), writeln(.), fail; told.
true.

?- G = tmp_n2m5_swf( N, B, F, C, I, K ), hist( (G,length(F,I),K=46), I:K ).

 (40:46):50160
total:50160
G = tmp_n2m5_swf(N, B, F, C, I, K).

?- 

% debug for the earlier run.(duplication anomaly)

?- N=2, B=[a,b,c,d,e], length( B, M ), time( ( mapz( transitive(B, []), [ ], F:C ), length( F, I ), I>2^(N-1)*(M*(M-1))-1, length(C, K), G = tmp_n2m5_max( (N, M), B, F, C, K ), assert( G ) ; fail ) ).

total:1048577
G = tmp_n2m5_max((N, M), B, F, C, K).

?- G = tmp_n2m5_max( (N, M), B, F, C, K ), hist( (G,length(F,I),K=46), I:K ).

 (40:46):50161
total:50161
G = tmp_n2m5_max((N, M), B, F, C, K).


(K=46)

?- G = tmp_n2m5_max( (_,_), _, _, _, K ), findall( 1, call((G,K=46)), L ), length(L, N ).
G = tmp_n2m5_max((_, _), _, _, _, K),
L = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
N = 50161.  

However,

?- G = tmp_n2m5_max( _, _, _, _, K ), findall( 1, call((G,K=46)), L ), length(L, N ).
G = tmp_n2m5_max(_, _, _, _, K),
L = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
N = 50160.


?-  set_prolog_flag(stack_limit, 2_147_483_648).
true.

?- G = tmp_n2m5_max( (_,_), _, _, _, K ), findall( G, call((G,K=46)), L ), length(L, N ), sort(L, H), subtract( L, H, D ).
G = tmp_n2m5_max((_, _), _, _, _, K),
L = [tmp_n2m5_max((2, 5), [a, b, c, d, e], [([e>d, e>d]->e>d), ([e>d, d>e]->d>e), ([e>c, e>c]->e>c), ([e>c, ... > ...]->e>c), ([... > ...|......
N = 50161,
H = [tmp_n2m5_ma...
D = [].

*/


swf( S ) :-
 S = [
 ( a>b,a>b ) -> a>b, 
 ( b>a,b>a ) -> b>a, 
 ( b>c,b>c ) -> b>c, 
 ( c>b,c>b ) -> c>b, 
 ( a>c,a>c ) -> a>c, 
 ( c>a,c>a ) -> c>a, 
 %
 ( a>b,b>a ) -> F_1, 
 ( b>a,a>b ) -> F_2, 
 ( b>c,c>b ) -> F_3, 
 ( c>b,b>c ) -> F_4, 
 ( a>c,c>a ) -> F_5, 
 ( c>a,a>c ) -> F_6
 ], 
 member( F_1, [a>b,b>a] ), 
 member( F_2, [a>b,b>a] ), 
 member( F_3, [b>c,c>b] ), 
 member( F_4, [b>c,c>b] ), 
 member( F_5, [a>c,c>a] ), 
 member( F_6, [a>c,c>a] ),
 \+ (
	 member( ( A1, A2 ) -> X>Y, S ),
	 member( ( B1, B2 ) -> Y>Z, S ),
	 member( ( C1, C2 ) -> Z>X, S ),
	 sort( [ A1, B1, C1 ], D1 ),
	 sort( [ A2, B2, C2 ], D2 ),
	% assert( tmp_pp1( D1, D2 )),	
	 D = [ [ a>b, b>c, c>a ], [ a>c, b>a, c>b] ],
	 \+ member( D1, D ),
	 \+ member( D2, D )
 ).  

table_swf( F ):-
	 nl,write('==='),member( X, F ), X=(A,B->C),
	 findall(J, nth1( J, [A,B], C ), D ),
	 nl, write( X:D ), fail ; true.

/*

?- length( A,6), swf( F ), append( A, B, F ), nl, write(B ), fail.

[(a>b,b>a->a>b),(b>a,a>b->b>a),(b>c,c>b->b>c),(c>b,b>c->c>b),(a>c,c>a->a>c),(c>a,a>c->c>a)]
[(a>b,b>a->b>a),(b>a,a>b->a>b),(b>c,c>b->c>b),(c>b,b>c->b>c),(a>c,c>a->c>a),(c>a,a>c->a>c)]
false.

?- swf( F ), table_swf( F ), fail.

===
(a>b,a>b->a>b):[1,2]
(b>a,b>a->b>a):[1,2]
(b>c,b>c->b>c):[1,2]
(c>b,c>b->c>b):[1,2]
(a>c,a>c->a>c):[1,2]
(c>a,c>a->c>a):[1,2]
(a>b,b>a->a>b):[1]
(b>a,a>b->b>a):[1]
(b>c,c>b->b>c):[1]
(c>b,b>c->c>b):[1]
(a>c,c>a->a>c):[1]
(c>a,a>c->c>a):[1]
===
(a>b,a>b->a>b):[1,2]
(b>a,b>a->b>a):[1,2]
(b>c,b>c->b>c):[1,2]
(c>b,c>b->c>b):[1,2]
(a>c,a>c->a>c):[1,2]
(c>a,c>a->c>a):[1,2]
(a>b,b>a->b>a):[2]
(b>a,a>b->a>b):[2]
(b>c,c>b->c>b):[2]
(c>b,b>c->b>c):[2]
(a>c,c>a->c>a):[2]
(c>a,a>c->a>c):[2]
false.

*/

/*

?- findall(1,(tmp_pp(A,B ), order( [a,b,c], A ) ), L ), length(L,N).
L = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
N = 23.

?- findall(1,(tmp_pp(A,B ), order( [a,b,c], B ) ), L ), length(L,N).
L = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
N = 26.

?- findall(1,(tmp_pp(A,B ), order( [a,b,c], C ), sort( C, B ) ), L ), length(L,N).
L = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
N = 378.

?- findall(1,(tmp_pp(A,B ), order( [a,b,c], C ), sort( C, A ) ), L ), length(L,N).
L = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
N = 370.

?- 

*/
	


swfx( S ) :-
 S = [
 ( a>b,a>b ) -> a>b, 
 ( b>a,b>a ) -> b>a, 
 ( b>c,b>c ) -> b>c, 
 ( c>b,c>b ) -> c>b, 
 ( a>c,a>c ) -> a>c, 
 ( c>a,c>a ) -> c>a, 
 %
 ( a>b,b>a ) -> F_1, 
 ( b>a,a>b ) -> F_2, 
 ( b>c,c>b ) -> F_3, 
 ( c>b,b>c ) -> F_4, 
 ( a>c,c>a ) -> F_5, 
 ( c>a,a>c ) -> F_6
 ], 
 member( F_1, [a>b,b>a] ), 
 member( F_2, [a>b,b>a] ), 
 member( F_3, [b>c,c>b] ), 
 member( F_4, [b>c,c>b] ), 
 member( F_5, [a>c,c>a] ), 
 member( F_6, [a>c,c>a] ),
 \+ (
	 order( [ a, b, c ], [ X1, Y1, Z1 ] ),
	 order( [ a, b, c ], [ X2, Y2, Z2 ] ),
	 member( ( X1, X2 ) -> S1, S ),
	 member( ( Y1, Y2 ) -> S2, S ),
	 member( ( Z1, Z2 ) -> S3, S ),
	 \+ order( [ a, b, c ], [ S1, S2, S3 ] )
 ).  


swf_assignment( [ A, B, C ], F, S ) :-
 S = [
 ( A>B,A>B ) -> A>B, 
 ( B>A,B>A ) -> B>A, 
 ( B>C,B>C ) -> B>C, 
 ( C>B,C>B ) -> C>B, 
 ( A>C,A>C ) -> A>C, 
 ( C>A,C>A ) -> C>A, 
 %
 ( A>B,B>A ) -> F_1, 
 ( B>A,A>B ) -> F_2, 
 ( B>C,C>B ) -> F_3, 
 ( C>B,B>C ) -> F_4, 
 ( A>C,C>A ) -> F_5, 
 ( C>A,A>C ) -> F_6
 ], 
 member( F_1, [A>B,B>A] ), 
 member( F_2, [A>B,B>A] ), 
 member( F_3, [B>C,C>B] ), 
 member( F_4, [B>C,C>B] ), 
 member( F_5, [A>C,C>A] ), 
 member( F_6, [A>C,C>A] ),
 F = [ F_1, F_2, F_3, F_4, F_5, F_6 ].



swf_violation( [ A, B, C ], S, [ P1, P2 ], [W1, W2, W3] ):-
	 member( ( X1, X2 ) -> W1, S ),
	 member( ( Y1, Y2 ) -> W2, S ),
	 member( ( Z1, Z2 ) -> W3, S ),
	 P1 = [ X1, Y1, Z1 ],
	 P2 = [ X2, Y2, Z2 ],
	 order( [ A, B, C ], P1 ),
	 order( [ A, B, C ], P2 ),
	 \+ order( [ A, B, C ], [ W1, W2, W3 ] ).



swf( [ A, B, C ], S ) :-
	 swf_assignment( [ A, B, C ], _, S ),
	 \+ (
		 swf_violation( [ A, B, C ], S, P, W )
	 	 ,debug_swf( P, W )
	 ).



debug_swf( [ P1, P2 ], [W1, W2, W3] ):-
	 P1 = [ X1, Y1, Z1 ],
	 P2 = [ X2, Y2, Z2 ],
	 X = [ X1, X2 ],
	 Y = [ Y1, Y2 ],
	 Z = [ Z1, Z2 ],
	 Fs = [( X1, X2 ) -> W1, ( Y1, Y2 ) -> W2, ( Z1, Z2 ) -> W3 ],
	 assert( tmp_blocked( X, Y, Z, Fs  ) ).


findall_nv( B, A, H ):-
       findall( B, ( A, \+ var( B ) ), H ).

hist( A, B ):-
      findall_nv( B, A, C ),
      sort( C, D ),
      \+ (
		bagof( '*', ( member( B, D ), member( B, C ) ), E ),
	    length( E, X ),
		nl,
	    tab( 1 ),
	    \+ write(  B: X  )
	  ),
	  nl,
      length( C, N ),
      write( total : N ).

/*

?- hist((setof( S, swf_assignment( [ a, b, c ], F, S ), D ), length( D, N ) ), N ).

 1:64
total:64
true.

?- swf( [a,b,c], F ), table_swf( F ), fail.

===
(a>b,a>b->a>b):[1,2]
(b>a,b>a->b>a):[1,2]
(b>c,b>c->b>c):[1,2]
(c>b,c>b->c>b):[1,2]
(a>c,a>c->a>c):[1,2]
(c>a,c>a->c>a):[1,2]
(a>b,b>a->a>b):[1]
(b>a,a>b->b>a):[1]
(b>c,c>b->b>c):[1]
(c>b,b>c->c>b):[1]
(a>c,c>a->a>c):[1]
(c>a,a>c->c>a):[1]
===
(a>b,a>b->a>b):[1,2]
(b>a,b>a->b>a):[1,2]
(b>c,b>c->b>c):[1,2]
(c>b,c>b->c>b):[1,2]
(a>c,a>c->a>c):[1,2]
(c>a,c>a->c>a):[1,2]
(a>b,b>a->b>a):[2]
(b>a,a>b->a>b):[2]
(b>c,c>b->c>b):[2]
(c>b,b>c->b>c):[2] 
(a>c,c>a->c>a):[2]
(c>a,a>c->a>c):[2]
false.

?- 

?- hist( tmp_blocked( A,B, C, D ), D ).

 [(a>b,a>b->a>b),(b>c,c>b->b>c),(a>c,c>a->c>a)]:16
 [(a>b,a>b->a>b),(c>b,b>c->b>c),(c>a,a>c->c>a)]:12
 [(a>b,b>a->a>b),(b>c,b>c->b>c),(a>c,c>a->c>a)]:4
 [(a>b,b>a->a>b),(c>b,b>c->b>c),(c>a,c>a->c>a)]:2
 [(a>b,b>a->b>a),(c>b,b>c->c>b),(a>c,a>c->a>c)]:2
 [(a>b,b>a->b>a),(c>b,c>b->c>b),(a>c,c>a->a>c)]:4
 [(b>a,a>b->a>b),(b>c,b>c->b>c),(c>a,a>c->c>a)]:1
 [(b>a,a>b->b>a),(c>b,c>b->c>b),(c>a,a>c->a>c)]:1
 [(b>a,b>a->b>a),(b>c,c>b->c>b),(a>c,c>a->a>c)]:12
 [(b>a,b>a->b>a),(c>b,b>c->c>b),(c>a,a>c->a>c)]:8
total:62
true.

% previous

 [(a>b,a>b->a>b),(b>c,c>b->b>c),(a>c,c>a->c>a)]:16
 [(a>b,a>b->a>b),(c>b,b>c->b>c),(c>a,a>c->c>a)]:8
 [(a>b,b>a->a>b),(b>c,b>c->b>c),(a>c,c>a->c>a)]:8
 [(a>b,b>a->a>b),(c>b,b>c->b>c),(c>a,c>a->c>a)]:4
 [(a>b,b>a->b>a),(b>c,c>b->c>b),(a>c,c>a->a>c)]:8
 [(a>b,b>a->b>a),(c>b,b>c->c>b),(a>c,a>c->a>c)]:2
 [(a>b,b>a->b>a),(c>b,b>c->c>b),(a>c,c>a->a>c)]:2
 [(a>b,b>a->b>a),(c>b,b>c->c>b),(c>a,a>c->a>c)]:4
 [(a>b,b>a->b>a),(c>b,c>b->c>b),(a>c,c>a->a>c)]:2
 [(b>a,a>b->a>b),(b>c,b>c->b>c),(c>a,a>c->c>a)]:2
 [(b>a,a>b->a>b),(b>c,c>b->b>c),(c>a,c>a->c>a)]:1
 [(b>a,a>b->b>a),(b>c,c>b->c>b),(a>c,c>a->a>c)]:1
 [(b>a,a>b->b>a),(b>c,c>b->c>b),(c>a,a>c->a>c)]:2
 [(b>a,a>b->b>a),(c>b,b>c->c>b),(c>a,a>c->a>c)]:1
 [(b>a,b>a->b>a),(b>c,c>b->c>b),(a>c,c>a->a>c)]:1
total:62
true.

*/


show_table( L, _, _ ):- 
	 nth1( 1, L, X ),
	 findall( R, (
		 nth1( J, L, _ ),
		 atom_concat( J, '\t', R )
	 ), H ),
	 nl,
	 term_string( 1:X, S ),
	 atom_length( S, K ),
	 tab( K ),
	 format('\t~w;\n', [H] ),
	 term_string( H, P ),
	 atom_length( P, M ),
	 N is 2 * K + M - 2,
	 format('~`-t ~*|;', [N]),
	 nl,
	 fail.
show_table( L, Schema, F ):-
	 nth1( J, L, X ),
	 findall( T, ( 
		 nth1( _, L, Y ),
		 table_mapping( F, X, Y, Schema, T )
	 ) , W ),
	 format('~w:~w\t~w;\n', [J, X, W] ),
	 fail.
show_table( _, _, _ ).

show_table( L, F ):-
	 show_table( L, _, F ).

table_schema( X, Y, V, [ X, Y ] -> V  ).
table_schema( X, Y, V, ( X, Y ) -> V  ).
table_mapping( F, X, Y, ( X, Y ) -> V, T  ):-
 		 member( Fxy, F ),
		 table_schema( X, Y, V, Fxy ),
		 !,
		 term_string( V, S ),
		 atom_concat( S, '\t', T ).
table_mapping( _, _, _, _, '-\t' ).

/*

?- swf( [a,b,c], F ), L=[a>b, b>a, b>c, c>b, c>a, a>c], show_table( L, F ).
        [1      ,2      ,3      ,4      ,5      ,6      ];
1:a>b   [a>b    ,a>b    ,-      ,-      ,-      ,-      ];
2:b>a   [b>a    ,b>a    ,-      ,-      ,-      ,-      ];
3:b>c   [-      ,-      ,b>c    ,b>c    ,-      ,-      ];
4:c>b   [-      ,-      ,c>b    ,c>b    ,-      ,-      ];
5:c>a   [-      ,-      ,-      ,-      ,c>a    ,c>a    ];
6:a>c   [-      ,-      ,-      ,-      ,a>c    ,a>c    ];
F = [(a>b, a>b->a>b), (b>a, b>a->b>a), (b>c, b>c->b>c), (c>b, c>b->c>b), (a>c, a>c->a>c), (c>a, c>a->c>a), (... > ..., ... > ... -> a>b), (..., ... -> ... > ...), (... -> ...)|...],
L = [a>b, b>a, b>c, c>b, c>a, a>c] ;
        [1      ,2      ,3      ,4      ,5      ,6      ];
1:a>b   [a>b    ,b>a    ,-      ,-      ,-      ,-      ];
2:b>a   [a>b    ,b>a    ,-      ,-      ,-      ,-      ];
3:b>c   [-      ,-      ,b>c    ,c>b    ,-      ,-      ];
4:c>b   [-      ,-      ,b>c    ,c>b    ,-      ,-      ];
5:c>a   [-      ,-      ,-      ,-      ,c>a    ,a>c    ];
6:a>c   [-      ,-      ,-      ,-      ,c>a    ,a>c    ];
F = [(a>b, a>b->a>b), (b>a, b>a->b>a), (b>c, b>c->b>c), (c>b, c>b->c>b), (a>c, a>c->a>c), (c>a, c>a->c>a), (... > ..., ... > ... -> b>a), (..., ... -> ... > ...), (... -> ...)|...],
L = [a>b, b>a, b>c, c>b, c>a, a>c] ;
false.

?- 


?- findall( S, tmp_blocked( X, Y, Z, S ), W ), sort( W, V), member( F, V ), L=[a>b, b>a, b>c, c>b, c>a, a>c], show_table( L, F ), length( V, N ).
        [1      ,2      ,3      ,4      ,5      ,6      ];
1:a>b   [a>b    ,-      ,-      ,-      ,-      ,-      ];
2:b>a   [-      ,-      ,-      ,-      ,-      ,-      ];
3:b>c   [-      ,-      ,-      ,b>c    ,-      ,-      ];
4:c>b   [-      ,-      ,-      ,-      ,-      ,-      ];
5:c>a   [-      ,-      ,-      ,-      ,-      ,-      ];
6:a>c   [-      ,-      ,-      ,-      ,c>a    ,-      ];
W = [[(a>b, b>a->a>b), (c>b, b>c->b>c), (c>a, c>a->c>a)], [(a>b, a>b->a>b), (c>b, b>c->b>c), (c>a, a>c->c>a)], [(a>b, a>b->a>b), (b>c, c>b->b>c), (a>c, c>a->c>a)], [(a>b, a>b->a>b), (b>c, c>b->b>c), (... > ..., ... > ... -> c>a)], [(b>a, a>b->a>b), (... > ..., ... > ... -> b>c), (..., ... -> ... > ...)], [(... > ..., ... > ... -> a>b), (..., ... -> ... > ...), (... -> ...)], [(..., ... -> ... > ...), (... -> ...)|...], [(... -> ...)|...], [...|...]|...],
V = [[(a>b, a>b->a>b), (b>c, c>b->b>c), (a>c, c>a->c>a)], [(a>b, a>b->a>b), (c>b, b>c->b>c), (c>a, a>c->c>a)], [(a>b, b>a->a>b), (b>c, b>c->b>c), (a>c, c>a->c>a)], [(a>b, b>a->a>b), (c>b, b>c->b>c), (... > ..., ... > ... -> c>a)], [(a>b, b>a->b>a), (... > ..., ... > ... -> c>b), (..., ... -> ... > ...)], [(... > ..., ... > ... -> b>a), (..., ... -> ... > ...), (... -> ...)], [(..., ... -> ... > ...), (... -> ...)|...], [(... -> ...)|...], [...|...]|...],
F = [(a>b, a>b->a>b), (b>c, c>b->b>c), (a>c, c>a->c>a)],
L = [a>b, b>a, b>c, c>b, c>a, a>c],
N = 15 .

?- 

*/


swf_blocking( [ A, B, C ], F, W, [ P1, P2 ], S ) :-
	 swf_assignment( [A, B, C ], F, S ),
	 swf_violation( [ A, B, C ], S, [ P1, P2 ], W ).  

swf_blocking( A, F, W, P ) :-
	 swf_blocking( A, F, W, P, _ ) .



/*

?- hist((setof( P, S^swf_blocking( [ a, b, c ], F, S, P ), D ), length( D, N ) ), N ).

 2:18
 3:12
 6:18
 7:12
 12:2
total:62
true.

?- A is 2/6^2.
A = 0.05555555555555555.


?- hist(swf_blocking( [ a, b, c ], F, [ S1, S2, S3 ], [ P1, P2 ] ), S1:S2:S3) .

 ((a>b):(b>c):(c>a)):144
 ((b>a):(c>b):(a>c)):144
total:288
true.


?- hist(swf_blocking( [ a, b, c ], F, [ S1, S2, S3 ], [ P1, P2 ] ), P1:P2) .

 ([a>b,b>c,a>c]:[a>b,c>b,c>a]):16
 ([a>b,b>c,a>c]:[b>a,b>c,c>a]):16
 ([a>b,b>c,a>c]:[b>a,c>b,c>a]):16
 ([a>b,c>b,a>c]:[b>a,b>c,a>c]):16
 ([a>b,c>b,a>c]:[b>a,b>c,c>a]):16
 ([a>b,c>b,a>c]:[b>a,c>b,c>a]):16
 ([a>b,c>b,c>a]:[a>b,b>c,a>c]):16
 ([a>b,c>b,c>a]:[b>a,b>c,a>c]):16
 ([a>b,c>b,c>a]:[b>a,b>c,c>a]):16
 ([b>a,b>c,a>c]:[a>b,c>b,a>c]):16
 ([b>a,b>c,a>c]:[a>b,c>b,c>a]):16
 ([b>a,b>c,a>c]:[b>a,c>b,c>a]):16
 ([b>a,b>c,c>a]:[a>b,b>c,a>c]):16
 ([b>a,b>c,c>a]:[a>b,c>b,a>c]):16
 ([b>a,b>c,c>a]:[a>b,c>b,c>a]):16
 ([b>a,c>b,c>a]:[a>b,b>c,a>c]):16
 ([b>a,c>b,c>a]:[a>b,c>b,a>c]):16
 ([b>a,c>b,c>a]:[b>a,b>c,a>c]):16
total:288
true.

?- hist( swf_blocking( [ a, b, c ], F, S, P ), S;P ).
 ([a>b,b>c,c>a];[[a>b,b>c,a>c],[a>b,c>b,c>a]]):16
 ([a>b,b>c,c>a];[[a>b,b>c,a>c],[b>a,b>c,c>a]]):16
 ([a>b,b>c,c>a];[[a>b,b>c,a>c],[b>a,c>b,c>a]]):8
 ([a>b,b>c,c>a];[[a>b,c>b,a>c],[b>a,b>c,c>a]]):8
 ([a>b,b>c,c>a];[[a>b,c>b,c>a],[a>b,b>c,a>c]]):16
 ([a>b,b>c,c>a];[[a>b,c>b,c>a],[b>a,b>c,a>c]]):8
 ([a>b,b>c,c>a];[[a>b,c>b,c>a],[b>a,b>c,c>a]]):16
 ([a>b,b>c,c>a];[[b>a,b>c,a>c],[a>b,c>b,c>a]]):8
 ([a>b,b>c,c>a];[[b>a,b>c,c>a],[a>b,b>c,a>c]]):16
 ([a>b,b>c,c>a];[[b>a,b>c,c>a],[a>b,c>b,a>c]]):8
 ([a>b,b>c,c>a];[[b>a,b>c,c>a],[a>b,c>b,c>a]]):16
 ([a>b,b>c,c>a];[[b>a,c>b,c>a],[a>b,b>c,a>c]]):8
 ([b>a,c>b,a>c];[[a>b,b>c,a>c],[b>a,c>b,c>a]]):8
 ([b>a,c>b,a>c];[[a>b,c>b,a>c],[b>a,b>c,a>c]]):16
 ([b>a,c>b,a>c];[[a>b,c>b,a>c],[b>a,b>c,c>a]]):8
 ([b>a,c>b,a>c];[[a>b,c>b,a>c],[b>a,c>b,c>a]]):16
 ([b>a,c>b,a>c];[[a>b,c>b,c>a],[b>a,b>c,a>c]]):8
 ([b>a,c>b,a>c];[[b>a,b>c,a>c],[a>b,c>b,a>c]]):16
 ([b>a,c>b,a>c];[[b>a,b>c,a>c],[a>b,c>b,c>a]]):8
 ([b>a,c>b,a>c];[[b>a,b>c,a>c],[b>a,c>b,c>a]]):16
 ([b>a,c>b,a>c];[[b>a,b>c,c>a],[a>b,c>b,a>c]]):8
 ([b>a,c>b,a>c];[[b>a,c>b,c>a],[a>b,b>c,a>c]]):8
 ([b>a,c>b,a>c];[[b>a,c>b,c>a],[a>b,c>b,a>c]]):16
 ([b>a,c>b,a>c];[[b>a,c>b,c>a],[b>a,b>c,a>c]]):16
total:288
true.

?- setof( P->'*', F^S^swf_blocking( [ a, b, c ], F, S, P ), D ), I=[1,3,5,4,2,6], findall( R, order( [a,b,c], R ), Lx ), findall( R, ( member( K, I ), nth1( K, Lx, R ) ), L ), show_table( L, D ).

                [1      ,2      ,3      ,4      ,5      ,6      ];
---------------------------------------------------------------- ;
1:[a>b,b>c,a>c] [-      ,-      ,-      ,*      ,*      ,*      ];
2:[a>b,c>b,a>c] [-      ,-      ,*      ,*      ,-      ,*      ];
3:[b>a,b>c,a>c] [-      ,*      ,-      ,-      ,*      ,*      ];
4:[b>a,b>c,c>a] [*      ,*      ,-      ,-      ,*      ,-      ];
5:[a>b,c>b,c>a] [*      ,-      ,*      ,*      ,-      ,-      ];
6:[b>a,c>b,c>a] [*      ,*      ,*      ,-      ,-      ,-      ];
D = [([[a>b, b>c, a>c], [a>b, c>b, c>a]]->(*)), ([[a>b, b>c, a>c], [b>a, b>c, c>a]]->(*)), ([[a>b, b>c, a>c], [b>a, c>b, ... > ...]]->(*)), ([[a>b, c>b, ... > ...], [b>a, ... > ...|...]]->(*)), ([[a>b, ... > ...|...], [... > ...|...]]->(*)), ([[... > ...|...], [...|...]]->(*)), ([[...|...]|...]->(*)), ([...|...]->(*)), (... -> ...)|...],
I = [1, 3, 5, 4, 2, 6],
Lx = [[a>b, b>c, a>c], [a>b, c>b, c>a], [a>b, c>b, a>c], [b>a, b>c, c>a], [b>a, b>c, a>c], [b>a, c>b, ... > ...]],
L = [[a>b, b>c, a>c], [a>b, c>b, a>c], [b>a, b>c, a>c], [b>a, b>c, c>a], [a>b, c>b, c>a], [b>a, c>b, ... > ...]].

?- 
 

?- S=[a>b,b>c,c>a], setof( P->'*', F^S^swf_blocking( [ a, b, c ], F, S, P ), D ), I=[1,3,5,4,2,6], findall( R, order( [a,b,c], R ), Lx ), findall( R, ( member( K, I ), nth1( K, Lx, R ) ), L ), show_table( L, D ), fail.

                [1      ,2      ,3      ,4      ,5      ,6      ];
---------------------------------------------------------------- ;
1:[a>b,b>c,a>c] [-      ,-      ,-      ,*      ,*      ,*      ];
2:[a>b,c>b,a>c] [-      ,-      ,-      ,*      ,-      ,-      ];
3:[b>a,b>c,a>c] [-      ,-      ,-      ,-      ,*      ,-      ];
4:[b>a,b>c,c>a] [*      ,*      ,-      ,-      ,*      ,-      ];
5:[a>b,c>b,c>a] [*      ,-      ,*      ,*      ,-      ,-      ];
6:[b>a,c>b,c>a] [*      ,-      ,-      ,-      ,-      ,-      ];
false.

?- S=[b>a,c>b,a>c], setof( P->'*', F^S^swf_blocking( [ a, b, c ], F, S, P ), D ), I=[1,3,5,4,2,6], findall( R, order( [a,b,c], R ), Lx ), findall( R, ( member( K, I ), nth1( K, Lx, R ) ), L ), show_table( L, D ), fail.

                [1      ,2      ,3      ,4      ,5      ,6      ];
---------------------------------------------------------------- ;
1:[a>b,b>c,a>c] [-      ,-      ,-      ,-      ,-      ,*      ];
2:[a>b,c>b,a>c] [-      ,-      ,*      ,*      ,-      ,*      ];
3:[b>a,b>c,a>c] [-      ,*      ,-      ,-      ,*      ,*      ];
4:[b>a,b>c,c>a] [-      ,*      ,-      ,-      ,-      ,-      ];
5:[a>b,c>b,c>a] [-      ,-      ,*      ,-      ,-      ,-      ];
6:[b>a,c>b,c>a] [*      ,*      ,*      ,-      ,-      ,-      ];
false.

*/

order_labels( L ):-  I=[1,3,5,4,2,6], findall( R, order( [a,b,c], R ), Lx ), findall( R, ( member( K, I ), nth1( K, Lx, R ) ), L ).

order_labels( A, L ):- findall( R, order( A, R ), L ).

/*

?- setof( P->'*', S^swf_blocking( [ a, b, c ], F, S, P ), D ), length( D, 2 ), order_labels( L ), show_table( L, D ).

                [1      ,2      ,3      ,4      ,5      ,6      ];
---------------------------------------------------------------- ;
1:[a>b,b>c,a>c] [-      ,-      ,-      ,-      ,-      ,-      ];
2:[a>b,c>b,a>c] [-      ,-      ,-      ,-      ,-      ,-      ];
3:[b>a,b>c,a>c] [-      ,-      ,-      ,-      ,-      ,-      ];
4:[b>a,b>c,c>a] [-      ,-      ,-      ,-      ,*      ,-      ];
5:[a>b,c>b,c>a] [-      ,-      ,-      ,*      ,-      ,-      ];
6:[b>a,c>b,c>a] [-      ,-      ,-      ,-      ,-      ,-      ];
F = [a>b, a>b, b>c, b>c, a>c, a>c],
D = [([[a>b, c>b, c>a], [b>a, b>c, c>a]]->(*)), ([[b>a, b>c, c>a], [a>b, c>b, c>a]]->(*))],
L = [[a>b, b>c, a>c], [a>b, c>b, a>c], [b>a, b>c, a>c], [b>a, b>c, c>a], [a>b, c>b, c>a], [b>a, c>b, ... > ...]] .

?- findall( X, ( setof( P->'*', S^swf_blocking( [ a, b, c ], F, S, P ), D ), length( D, 2 ), member( X, D ) ), G ), sort( G, H ), order_labels( L ), show_table( L, H ).

                [1      ,2      ,3      ,4      ,5      ,6      ];
---------------------------------------------------------------- ;
1:[a>b,b>c,a>c] [-      ,-      ,-      ,*      ,*      ,-      ];
2:[a>b,c>b,a>c] [-      ,-      ,*      ,-      ,-      ,*      ];
3:[b>a,b>c,a>c] [-      ,*      ,-      ,-      ,-      ,*      ];
4:[b>a,b>c,c>a] [*      ,-      ,-      ,-      ,*      ,-      ];
5:[a>b,c>b,c>a] [*      ,-      ,-      ,*      ,-      ,-      ];
6:[b>a,c>b,c>a] [-      ,*      ,*      ,-      ,-      ,-      ];
G = [([[a>b, c>b, c>a], [b>a, b>c, c>a]]->(*)), ([[b>a, b>c, c>a], [a>b, c>b, c>a]]->(*)), ([[b>a, b>c, c>a], [a>b, c>b, ... > ...]]->(*)), ([[b>a, c>b, ... > ...], [b>a, ... > ...|...]]->(*)), ([[a>b, ... > ...|...], [... > ...|...]]->(*)), ([[... > ...|...], [...|...]]->(*)), ([[...|...]|...]->(*)), ([...|...]->(*)), (... -> ...)|...],
H = [([[a>b, b>c, a>c], [a>b, c>b, c>a]]->(*)), ([[a>b, b>c, a>c], [b>a, b>c, c>a]]->(*)), ([[a>b, c>b, a>c], [b>a, b>c, ... > ...]]->(*)), ([[a>b, c>b, ... > ...], [b>a, ... > ...|...]]->(*)), ([[a>b, ... > ...|...], [... > ...|...]]->(*)), ([[... > ...|...], [...|...]]->(*)), ([[...|...]|...]->(*)), ([...|...]->(*)), (... -> ...)|...],
L = [[a>b, b>c, a>c], [a>b, c>b, a>c], [b>a, b>c, a>c], [b>a, b>c, c>a], [a>b, c>b, c>a], [b>a, c>b, ... > ...]].

?- 

*/


swf_assignment_n3( [ A, B, C ], F, S ) :-
 S = [
 ( A>B,A>B, A>B ) -> A>B, 
 ( B>A,B>A, B>A ) -> B>A, 
 ( B>C,B>C, B>C ) -> B>C, 
 ( C>B,C>B, C>B ) -> C>B, 
 ( A>C,A>C, A>C ) -> A>C, 
 ( C>A,C>A, C>A ) -> C>A, 
 %
 ( A>B,B>A, A>B ) -> F_1, 
 ( B>A,A>B, B>A ) -> F_2, 
 ( B>C,C>B, B>C ) -> F_3, 
 ( C>B,B>C, C>B ) -> F_4, 
 ( A>C,C>A, A>C ) -> F_5, 
 ( C>A,A>C, C>A ) -> F_6,
 ( A>B,B>A, B>A ) -> F_1x, 
 ( B>A,A>B, A>B ) -> F_2x, 
 ( B>C,C>B, C>B ) -> F_3x, 
 ( C>B,B>C, B>C ) -> F_4x, 
 ( A>C,C>A, C>A ) -> F_5x, 
 ( C>A,A>C, A>C ) -> F_6x
 ], 
 member( F_1, [A>B,B>A] ), 
 member( F_2, [A>B,B>A] ), 
 member( F_3, [B>C,C>B] ), 
 member( F_4, [B>C,C>B] ), 
 member( F_5, [A>C,C>A] ), 
 member( F_6, [A>C,C>A] ),
 member( F_1x, [A>B,B>A] ), 
 member( F_2x, [A>B,B>A] ), 
 member( F_3x, [B>C,C>B] ), 
 member( F_4x, [B>C,C>B] ), 
 member( F_5x, [A>C,C>A] ), 
 member( F_6x, [A>C,C>A] ),
 F = [ F_1, F_2, F_3, F_4, F_5, F_6,
	F_1x, F_2x, F_3x, F_4x, F_5x, F_6x ].

swf_assignment_n3_dash( [ A, B, C ], F, S ) :-
 S = [
 ( A>B,A>B, A>B ) -> A>B, 
 ( B>A,B>A, B>A ) -> B>A, 
 ( B>C,B>C, B>C ) -> B>C, 
 ( C>B,C>B, C>B ) -> C>B, 
 ( A>C,A>C, A>C ) -> A>C, 
 ( C>A,C>A, C>A ) -> C>A, 
 %
 ( A>B,B>A, A>B ) -> F_1, 
 ( B>A,A>B, B>A ) -> F_2, 
 ( B>C,C>B, B>C ) -> F_3, 
 ( C>B,B>C, C>B ) -> F_4, 
 ( A>C,C>A, A>C ) -> F_5, 
 ( C>A,A>C, C>A ) -> F_6,
 ( A>B,B>A, B>A ) -> F_1x, 
 ( B>A,A>B, A>B ) -> F_2x, 
 ( B>C,C>B, C>B ) -> F_3x, 
 ( C>B,B>C, B>C ) -> F_4x, 
 ( A>C,C>A, C>A ) -> F_5x, 
 ( C>A,A>C, A>C ) -> F_6x,
 ( A>B,A>B, B>A ) -> F_1y, 
 ( B>A,B>A, A>B ) -> F_2y, 
 ( B>C,B>C, C>B ) -> F_3y, 
 ( C>B,C>B, B>C ) -> F_4y, 
 ( A>C,A>C, C>A ) -> F_5y, 
 ( C>A,C>A, A>C ) -> F_6y
 ], 
 member( F_1, [A>B,B>A] ), 
 member( F_2, [A>B,B>A] ), 
 member( F_3, [B>C,C>B] ), 
 member( F_4, [B>C,C>B] ), 
 member( F_5, [A>C,C>A] ), 
 member( F_6, [A>C,C>A] ),
 member( F_1x, [A>B,B>A] ), 
 member( F_2x, [A>B,B>A] ), 
 member( F_3x, [B>C,C>B] ), 
 member( F_4x, [B>C,C>B] ), 
 member( F_5x, [A>C,C>A] ), 
 member( F_6x, [A>C,C>A] ),
 member( F_1y, [A>B,B>A] ),
 member( F_2y, [A>B,B>A] ), 
 member( F_3y, [B>C,C>B] ), 
 member( F_4y, [B>C,C>B] ), 
 member( F_5y, [A>C,C>A] ), 
 member( F_6y, [A>C,C>A] ),
 F = [ F_1, F_2, F_3, F_4, F_5, F_6,
	F_1x, F_2x, F_3x, F_4x, F_5x,F_6x,
	F_1y, F_2y, F_3y, F_4y, F_5y, F_6y ].

swf_violation_n3( [ A, B, C ], S, [ P1, P2, P3 ], [W1, W2, W3] ):-
	 member( ( X1, X2, X3 ) -> W1, S ),
	 member( ( Y1, Y2, Y3 ) -> W2, S ),
	 member( ( Z1, Z2, Z3 ) -> W3, S ),
	 P1 = [ X1, Y1, Z1 ],
	 P2 = [ X2, Y2, Z2 ],
	 P3 = [ X3, Y3, Z3 ],
	 order( [ A, B, C ], P1 ),
	 order( [ A, B, C ], P2 ),
	 order( [ A, B, C ], P3 ),
	 \+ order( [ A, B, C ], [ W1, W2, W3 ] ).

swf_violation_n3_dash( [ A, B, C ], _, S, [ P1, P2, P3 ], [W1, W2, W3] ):-
/*
	 F = [ F_1, F_2, F_3, F_4, F_5, F_6,
		F_1x, F_2x, F_3x, F_4x, F_5x,F_6x,
		F_1y, F_2y, F_3y, F_4y, F_5y, F_6y ],
	 member( X1, [ F_1, F_2 ] ),
	 member( X2, [ F_1x, F_2x ] ),
	 member( X3, [ F_1y, F_2y ] ),
	 member( Y1, [ F_3, F_4 ] ),
	 member( Y2, [ F_3x, F_4x ] ),
	 member( Y3, [ F_3y, F_4y ] ),
	 member( Z1, [ F_5, F_6 ] ),
	 member( Z2, [ F_5x, F_6x ] ),
	 member( Z3, [ F_5y, F_6y ] ),
 */
	 member( [ W1, W2, W3 ],  [ [ A > B, B > C, C > A ], [ B > A, C > B, A > C ] ] ),
	 member( ( X1, X2, X3 ) -> W1, S ),
	 member( ( Y1, Y2, Y3 ) -> W2, S ),
	 member( ( Z1, Z2, Z3 ) -> W3, S ),
%	 \+ order( [ A, B, C ], [ W1, W2, W3 ] ),
	 P1 = [ X1, Y1, Z1 ],
	 P2 = [ X2, Y2, Z2 ],
	 P3 = [ X3, Y3, Z3 ],
	 order( [ A, B, C ], P1 ),
	 order( [ A, B, C ], P2 ),
	 order( [ A, B, C ], P3 ).

swf_blocking_n3( [ A, B, C ], F, W, [ P1, P2, P3 ], S ) :-
	 swf_assignment_n3( [ A, B, C ], F, S ),
	 swf_violation_n3( [ A, B, C ], S, [ P1, P2, P3 ], W ).  

swf_blocking_n3( A, F, W, P ) :-
	 swf_blocking_n3( A, F, W, P, _ ) .

swf_blocking_n3_dash( [ A, B, C ], F, W, [ P1, P2, P3 ], S ) :-
	 swf_assignment_n3_dash( [ A, B, C ], F, S ),
	 swf_violation_n3_dash( [ A, B, C ], F, S, [ P1, P2, P3 ], W ).  

swf_blocking_n3_dash( A, F, W, P ) :-
	 swf_blocking_n3_dash( A, F, W, P, _ ) .


/*



?- hist((setof( S, swf_assignment_n3( [ a, b, c ], F, S ), D ), length( D, N ) ), N ).

 1:4096
total:4096
true.


?- hist((setof( P, S^swf_blocking_n3( [ a, b, c ], F, S, P ), D ), length( D, N ) ), N ).

 4:42
 5:60
 6:30
 7:72
 8:78
 9:36
 10:204
 11:36
 12:193
 13:132
 14:216
 15:216
 16:378
 17:276
 18:346
 19:192
 20:315
 21:132
 22:264
 23:180
 24:171
 25:96
 26:126
 27:36
 28:66
 29:12
 30:60
 31:12
 32:42
 33:12
 35:12
 36:24
 41:12
 43:12
 54:2
total:4093
true.

?- A is 4/6^3.
A = 0.018518518518518517.

?- 

?- % set_prolog_flag(stack_limit, 2_147_483_648).
%set_prolog_flag(stack_limit, 4_294_967_296).
%==>
 set_prolog_flag(stack_limit, 17_179_869_184).
 
true.

?- hist((setof( P, S^swf_blocking_n3_dash( [ a, b, c ], F, S, P ), D ), length( D, N ) ), N ).

*** stack limit exceeded ***

?- swf_blocking_n3_dash( [ a, b, c ], F, S, P ),  assert( tmp_n3_blocked( F, S, P ) ), fail.
false.


*/


% Base: [X,Y,Z], Permutation:P, PairwiseOrder:[A,B,C]

permutation_to_pairwise_order( [ X, Y, Z ], P, [ A, B, C ] ):-
	 permutation( [X,Y,Z], P ),
	 append( _, [ X | AX ], P ),
	 append( _, [ Y | AY ], P ),
	 append( _, [ Z | AZ ], P ),
	 (subset( AY, AX ) -> A = (X>Y) ; A=(Y>X) ), 
	 (subset( AZ, AY ) -> B = (Y>Z) ; B=(Z>Y) ), 
	 (subset( AX, AZ ) -> C = (Z>X) ; C=(X>Z) ).

/*

?- permutation_to_pairwise_order( [a,b,c], P, B ).
P = [a, b, c],
B = [a>b, b>c, a>c] .

?- permutation_to_pairwise_order( [a,b,c], P, B ), nl, write( P=B ), fail.

[a,b,c]=[a>b,b>c,a>c]
[a,c,b]=[a>b,c>b,a>c]
[b,a,c]=[b>a,b>c,a>c]
[b,c,a]=[b>a,b>c,c>a]
[c,a,b]=[a>b,c>b,c>a]
[c,b,a]=[b>a,c>b,c>a]
false.

*/

permutation_to_pairwise_order( [ X, Y, Z, W ], P, S ):-
	 \+ var( S ),
	 %S \= [ _, _, _, _, _, _ ],
	 permutation_to_pairwise_order( [ X, Y, Z, W ], P, R ),
	 subset( S, R ),
	 !.

permutation_to_pairwise_order( [ X, Y, Z, W ], P, [ A, B, C, A1, B1, C1 ] ):-
	 permutation( [X,Y,Z, W], P ),
	 append( _, [ X | AX ], P ),
	 append( _, [ Y | AY ], P ),
	 append( _, [ Z | AZ ], P ),
	 append( _, [ W | AW ], P ),
	 (subset( AY, AX ) -> A = (X>Y) ; A=(Y>X) ), 
	 (subset( AZ, AY ) -> B = (Y>Z) ; B=(Z>Y) ), 
	 (subset( AX, AZ ) -> C = (Z>X) ; C=(X>Z) ),
	 (subset( AW, AX ) -> A1 = (X>W) ; A1=(W>X) ), 
	 (subset( AW, AY ) -> B1 = (Y>W) ; B1=(W>Y) ), 
	 (subset( AW, AZ ) -> C1 = (Z>W) ; C1=(W>Z) ).

/*

?- order([1,2,3,4], P), permutation_to_pairwise_order( [1,2,3,4], R, P ).
P = [1>2, 2>3, 1>3, 1>4, 2>4, 3>4],
R = [1, 2, 3, 4] ;
P = [1>2, 2>3, 1>3, 1>4, 2>4, 4>3],
R = [1, 2, 4, 3] .

?-

?- A=[a,b,c,d], hist((order(A, R ), permutation_to_pairwise_order( A, P, R ) ), P;R ).

 ([a,b,c,d];[a>b,b>c,a>c,a>d,b>d,c>d]):1
 ([a,b,d,c];[a>b,b>c,a>c,a>d,b>d,d>c]):1
 ([a,c,b,d];[a>b,c>b,a>c,a>d,b>d,c>d]):1
 ([a,c,d,b];[a>b,c>b,a>c,a>d,d>b,c>d]):1
 ([a,d,b,c];[a>b,b>c,a>c,a>d,d>b,d>c]):1
 ([a,d,c,b];[a>b,c>b,a>c,a>d,d>b,d>c]):1
 ([b,a,c,d];[b>a,b>c,a>c,a>d,b>d,c>d]):1
 ([b,a,d,c];[b>a,b>c,a>c,a>d,b>d,d>c]):1
 ([b,c,a,d];[b>a,b>c,c>a,a>d,b>d,c>d]):1
 ([b,c,d,a];[b>a,b>c,c>a,d>a,b>d,c>d]):1
 ([b,d,a,c];[b>a,b>c,a>c,d>a,b>d,d>c]):1
 ([b,d,c,a];[b>a,b>c,c>a,d>a,b>d,d>c]):1
 ([c,a,b,d];[a>b,c>b,c>a,a>d,b>d,c>d]):1
 ([c,a,d,b];[a>b,c>b,c>a,a>d,d>b,c>d]):1
 ([c,b,a,d];[b>a,c>b,c>a,a>d,b>d,c>d]):1
 ([c,b,d,a];[b>a,c>b,c>a,d>a,b>d,c>d]):1
 ([c,d,a,b];[a>b,c>b,c>a,d>a,d>b,c>d]):1
 ([c,d,b,a];[b>a,c>b,c>a,d>a,d>b,c>d]):1
 ([d,a,b,c];[a>b,b>c,a>c,d>a,d>b,d>c]):1
 ([d,a,c,b];[a>b,c>b,a>c,d>a,d>b,d>c]):1
 ([d,b,a,c];[b>a,b>c,a>c,d>a,d>b,d>c]):1
 ([d,b,c,a];[b>a,b>c,c>a,d>a,d>b,d>c]):1
 ([d,c,a,b];[a>b,c>b,c>a,d>a,d>b,d>c]):1
 ([d,c,b,a];[b>a,c>b,c>a,d>a,d>b,d>c]):1
total:24
A = [a, b, c, d].

 
*/

permutation_to_pairwise_order( [ X, Y, Z, W, V ], P, S ):-
	 \+ var( S ),
	 %S \= [ _, _, _, _, _, _, _, _, _, _ ],
	 permutation_to_pairwise_order( [ X, Y, Z, W, V ], P, R ),
	 subset( S, R ),
	 !.

permutation_to_pairwise_order( [ X, Y, Z, W, V ], P, [ A, B, C, A1, B1, C1, A2, B2, C2, D ] ):-
	 permutation( [X,Y,Z, W,V], P ),
	 append( _, [ X | AX ], P ),
	 append( _, [ Y | AY ], P ),
	 append( _, [ Z | AZ ], P ),
	 append( _, [ W | AW ], P ),
	 append( _, [ V | AV ], P ),
	 (subset( AY, AX ) -> A = (X>Y) ; A=(Y>X) ), 
	 (subset( AZ, AY ) -> B = (Y>Z) ; B=(Z>Y) ), 
	 (subset( AX, AZ ) -> C = (Z>X) ; C=(X>Z) ),
	 (subset( AW, AX ) -> A1 = (X>W) ; A1=(W>X) ), 
	 (subset( AW, AY ) -> B1 = (Y>W) ; B1=(W>Y) ), 
	 (subset( AW, AZ ) -> C1 = (Z>W) ; C1=(W>Z) ),
	 (subset( AV, AX ) -> A2 = (X>V) ; A2=(V>X) ), 
	 (subset( AV, AY ) -> B2 = (Y>V) ; B2=(V>Y) ), 
	 (subset( AV, AZ ) -> C2 = (Z>V) ; C2=(V>Z) ), 
	 (subset( AV, AW ) -> D = (W>V) ; D=(V>W) ).


order_as_list( A, P, T ):-
	 permutation_to_pairwise_order( A, P, T ).


profile_as_order_list( A, B, L ):- 
	 findall( P, (
		 member( T, B ),
		 permutation_to_pairwise_order( A, P, T )
	 ), L ).


order_as_concat( A, R, T, P ):-
	 permutation_to_pairwise_order( A, R, T ),
	 atomic_list_concat( R, P ).



concat_order_profile( A, B, L ):- 
	 findall( P, (
		 member( T, B ),
		 order_as_concat( A, _, T, P )
	 ), L ).

concat_order_domain( A, D, Dx ):- 
	 findall( H, ( member( T, D ), concat_order_profile( A, T, H ) ), Dx ).



 
/*

?- A=[a,b,c,d], hist((order(A, R ), order_as_concat( A, P, R, T ) ), P;T ).

 ([a,b,c,d];abcd):1
 ([a,b,d,c];abdc):1
 ([a,c,b,d];acbd):1
 ([a,c,d,b];acdb):1
 ([a,d,b,c];adbc):1
 ([a,d,c,b];adcb):1
 ([b,a,c,d];bacd):1
 ([b,a,d,c];badc):1
 ([b,c,a,d];bcad):1
 ([b,c,d,a];bcda):1
 ([b,d,a,c];bdac):1
 ([b,d,c,a];bdca):1
 ([c,a,b,d];cabd):1
 ([c,a,d,b];cadb):1
 ([c,b,a,d];cbad):1
 ([c,b,d,a];cbda):1
 ([c,d,a,b];cdab):1
 ([c,d,b,a];cdba):1
 ([d,a,b,c];dabc):1
 ([d,a,c,b];dacb):1
 ([d,b,a,c];dbac):1
 ([d,b,c,a];dbca):1
 ([d,c,a,b];dcab):1
 ([d,c,b,a];dcba):1
total:24
A = [a, b, c, d].

?- setof( H, P^( swf_blocking( [ a, b, c ], F, S, P ), concat_order_profile( [a,b,c], P, H ) ), D ).
F = [a>b, a>b, b>c, b>c, a>c, a>c],
S = [a>b, b>c, c>a],
D = [[bca, cab], [cab, bca]] .

?- setof( H, P^( swf_blocking( [ a, b, c ], F, S, P ), concat_order_profile( [a,b,c], P, H ) ), D ), length( D, 2 ), nl, write( D;S;F ), fail.

[[bca,cab],[cab,bca]];[a>b,b>c,c>a];[a>b,a>b,b>c,b>c,a>c,a>c]
[[bac,cba],[cba,bac]];[b>a,c>b,a>c];[a>b,a>b,c>b,c>b,a>c,a>c]
[[abc,bca],[bca,abc]];[a>b,b>c,c>a];[a>b,a>b,c>b,c>b,c>a,c>a]
[[acb,cba],[cba,acb]];[b>a,c>b,a>c];[b>a,b>a,b>c,b>c,a>c,a>c]
[[abc,cab],[cab,abc]];[a>b,b>c,c>a];[b>a,b>a,b>c,b>c,c>a,c>a]
[[acb,bac],[bac,acb]];[b>a,c>b,a>c];[b>a,b>a,c>b,c>b,c>a,c>a]
false.

?- setof( H, P^S^( swf_blocking( [ a, b, c ], F, S, P ), concat_order_profile( [a,b,c], P, H ) ), D ), length( D, 2 ), nl, write( D;F ), fail.

[[bca,cab],[cab,bca]];[a>b,a>b,b>c,b>c,a>c,a>c]
[[bca,cab],[cba,bac]];[a>b,a>b,b>c,c>b,a>c,a>c]
[[bac,cba],[cab,bca]];[a>b,a>b,c>b,b>c,a>c,a>c]
[[bac,cba],[cba,bac]];[a>b,a>b,c>b,c>b,a>c,a>c]
[[bac,cba],[bca,abc]];[a>b,a>b,c>b,c>b,a>c,c>a]
[[abc,bca],[cba,bac]];[a>b,a>b,c>b,c>b,c>a,a>c]
[[abc,bca],[bca,abc]];[a>b,a>b,c>b,c>b,c>a,c>a]
[[cab,bca],[cba,acb]];[a>b,b>a,b>c,b>c,a>c,a>c]
[[abc,bca],[bac,acb]];[a>b,b>a,c>b,c>b,c>a,c>a]
[[acb,cba],[bca,cab]];[b>a,a>b,b>c,b>c,a>c,a>c]
[[acb,bac],[bca,abc]];[b>a,a>b,c>b,c>b,c>a,c>a]
[[acb,cba],[cba,acb]];[b>a,b>a,b>c,b>c,a>c,a>c]
[[acb,cba],[cab,abc]];[b>a,b>a,b>c,b>c,a>c,c>a]
[[abc,cab],[cba,acb]];[b>a,b>a,b>c,b>c,c>a,a>c]
[[abc,cab],[cab,abc]];[b>a,b>a,b>c,b>c,c>a,c>a]
[[abc,cab],[acb,bac]];[b>a,b>a,b>c,c>b,c>a,c>a]
[[bac,acb],[cab,abc]];[b>a,b>a,c>b,b>c,c>a,c>a]
[[acb,bac],[bac,acb]];[b>a,b>a,c>b,c>b,c>a,c>a]
false.

?- findall( D, ( setof( H, P^( swf_blocking( [ a, b, c ], F, S, P ), concat_order_profile( [a,b,c], P, H ) ), D ), length( D, 2 ) ), L ), 
setof( H, P^S^( swf_blocking( [ a, b, c ], F, S, P ), concat_order_profile( [a,b,c], P, H ) ), D ), length( D, 2 ), nl, write( D:F), nth1(J, L, D ), write( [J] ), fail.

[[bca,cab],[cab,bca]]:[a>b,a>b,b>c,b>c,a>c,a>c][1]
[[bca,cab],[cba,bac]]:[a>b,a>b,b>c,c>b,a>c,a>c]
[[bac,cba],[cab,bca]]:[a>b,a>b,c>b,b>c,a>c,a>c]
[[bac,cba],[cba,bac]]:[a>b,a>b,c>b,c>b,a>c,a>c][2]
[[bac,cba],[bca,abc]]:[a>b,a>b,c>b,c>b,a>c,c>a]
[[abc,bca],[cba,bac]]:[a>b,a>b,c>b,c>b,c>a,a>c]
[[abc,bca],[bca,abc]]:[a>b,a>b,c>b,c>b,c>a,c>a][3]
[[cab,bca],[cba,acb]]:[a>b,b>a,b>c,b>c,a>c,a>c]
[[abc,bca],[bac,acb]]:[a>b,b>a,c>b,c>b,c>a,c>a]
[[acb,cba],[bca,cab]]:[b>a,a>b,b>c,b>c,a>c,a>c]
[[acb,bac],[bca,abc]]:[b>a,a>b,c>b,c>b,c>a,c>a]
[[acb,cba],[cba,acb]]:[b>a,b>a,b>c,b>c,a>c,a>c][4]
[[acb,cba],[cab,abc]]:[b>a,b>a,b>c,b>c,a>c,c>a]
[[abc,cab],[cba,acb]]:[b>a,b>a,b>c,b>c,c>a,a>c]
[[abc,cab],[cab,abc]]:[b>a,b>a,b>c,b>c,c>a,c>a][5]
[[abc,cab],[acb,bac]]:[b>a,b>a,b>c,c>b,c>a,c>a]
[[bac,acb],[cab,abc]]:[b>a,b>a,c>b,b>c,c>a,c>a]
[[acb,bac],[bac,acb]]:[b>a,b>a,c>b,c>b,c>a,c>a][6]
false.

?- 


?- setof( P, S^swf_blocking( [ a, b, c ], F, S, P ), D ), length( D, N ), N=2, assert( tmp_n2m3_max_poss( F, D ) ), fail.
false.



?- hist( ( tmp_n2m3_max_poss( F, D ), findall( H, ( member( T, D ), concat_order_profile( [a,b,c], T, H ) ), P ) ),  P ).

 [[abc,bca],[bac,acb]]:1
 [[abc,bca],[bca,abc]]:1
 [[abc,bca],[cba,bac]]:1
 [[abc,cab],[acb,bac]]:1
 [[abc,cab],[cab,abc]]:1
 [[abc,cab],[cba,acb]]:1
 [[acb,bac],[bac,acb]]:1
 [[acb,bac],[bca,abc]]:1
 [[acb,cba],[bca,cab]]:1
 [[acb,cba],[cab,abc]]:1
 [[acb,cba],[cba,acb]]:1
 [[bac,cba],[bca,abc]]:1
 [[bac,cba],[cba,bac]]:1
 [[bca,cab],[cba,bac]]:1
 [[cab,abc],[bac,acb]]:1
 [[cab,bca],[bac,cba]]:1
 [[cab,bca],[bca,cab]]:1
 [[cab,bca],[cba,acb]]:1
total:18
true.

?- hist( ( tmp_n2m3_max_poss( F, D ), !, member( T, D ), profile_as_order_list( [a,b,c], T, P ) ), P ).

 [[b,c,a],[c,a,b]]:1
 [[c,a,b],[b,c,a]]:1
total:2
true.

% genetate and verify swfs using sct2026.pl

?- C = [[bca,cab],[cab,bca]], nm_domain( 2, 3, [a,b,c], [1,2], L, K, U ), subtract( U, C, D ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, write( N: SWV ), fail.

34:1111111211221133131134412155123456
34:1234561234561234561234612356123456
34:1111112222223333334444455555666666
false.



?- setof( P, S^swf_blocking_n3( [ a, b, c ], F, S, P ), D ), length( D, N ), N=4, assert( tmp_n3_blocked( F, D ) ), fail.


?- hist( ( tmp_n3_blocked( F, D ), !, member( T, D ), profile_as_order_list( [a,b,c], T, P ) ), P ).

 [[a,c,b],[b,c,a],[c,a,b]]:1
 [[b,a,c],[c,a,b],[b,c,a]]:1
 [[b,c,a],[c,a,b],[b,c,a]]:1
 [[c,a,b],[b,c,a],[c,a,b]]:1
total:4
true.

?- order_as_concat( [a,b,c], P, R, B ), nl, write( R:P=B ), fail.

[a>b,b>c,a>c]:[a,b,c]=abc
[a>b,c>b,a>c]:[a,c,b]=acb
[b>a,b>c,a>c]:[b,a,c]=bac
[b>a,b>c,c>a]:[b,c,a]=bca
[a>b,c>b,c>a]:[c,a,b]=cab
[b>a,c>b,c>a]:[c,b,a]=cba
false.

?- hist( ( tmp_n3_blocked( F, D ), !, member( T, D ), concat_order_profile( [a,b,c], T, P ) ), P ).

 [acb,bca,cab]:1
 [bac,cab,bca]:1
 [bca,cab,bca]:1
 [cab,bca,cab]:1
total:4
true.

?- hist( ( tmp_n3_blocked( F, D ),  findall( P, ( member( T, D ), concat_order_profile( [a,b,c], T, P ) ), H ) ), H ).

 [[abc,bca,abc],[acb,bac,bac],[bac,acb,bac],[bca,abc,abc]]:1
 [[abc,bca,abc],[acb,bca,abc],[bac,acb,bac],[bca,acb,bac]]:1
 [[abc,bca,abc],[acb,bca,abc],[bca,abc,bca],[cba,abc,bca]]:1
 [[abc,bca,abc],[acb,bca,abc],[cab,bac,cba],[cba,bac,cba]]:1
 [[abc,bca,bca],[abc,cba,bca],[bac,acb,acb],[bac,cab,acb]]:1
 [[abc,bca,bca],[abc,cba,bca],[bca,abc,abc],[bca,acb,abc]]:1
 [[abc,bca,bca],[abc,cba,bca],[cba,abc,bac],[cba,bac,bac]]:1
 [[abc,bca,bca],[bac,cba,bac],[bca,abc,bca],[cba,bac,bac]]:1
 [[abc,cab,abc],[acb,bac,acb],[cab,abc,abc],[bac,acb,acb]]:1
 [[abc,cab,abc],[acb,bac,acb],[cab,bac,acb],[bac,cab,abc]]:1
 [[abc,cab,abc],[bac,cab,abc],[bca,acb,cba],[cba,acb,cba]]:1
 [[abc,cab,abc],[cab,abc,cab],[bac,cab,abc],[cba,abc,cab]]:1
 [[abc,cab,cab],[abc,cba,cab],[acb,bac,bac],[acb,bca,bac]]:1
 [[abc,cab,cab],[abc,cba,cab],[cab,abc,abc],[cab,bac,abc]]:1
 [[abc,cab,cab],[abc,cba,cab],[cba,abc,acb],[cba,acb,acb]]:1
 [[abc,cab,cab],[acb,cba,acb],[cab,abc,cab],[cba,acb,acb]]:1
 [[abc,cba,acb],[acb,cba,acb],[bac,cab,bca],[bca,cab,bca]]:1
 [[abc,cba,acb],[acb,cba,acb],[bca,acb,cba],[cba,acb,cba]]:1
 [[abc,cba,acb],[acb,cba,acb],[cab,abc,cab],[cba,abc,cab]]:1
 [[abc,cba,bac],[acb,bca,cab],[cab,bca,cab],[bac,cba,bac]]:1
 [[abc,cba,bac],[bac,cba,bac],[bca,abc,bca],[cba,abc,bca]]:1
 [[abc,cba,bac],[cab,bac,cba],[bac,cba,bac],[cba,bac,cba]]:1
 [[acb,bac,acb],[cab,bac,acb],[bac,acb,bac],[bca,acb,bac]]:1
 [[acb,bac,acb],[cab,bac,acb],[bca,abc,bca],[cba,abc,bca]]:1
 [[acb,bac,bac],[acb,bca,bac],[bac,acb,acb],[bac,cab,acb]]:1
 [[acb,bac,bac],[acb,bca,bac],[bca,abc,abc],[bca,acb,abc]]:1
 [[acb,bca,cab],[cab,bca,cab],[bac,cab,bca],[bca,cab,bca]]:1
 [[acb,bca,cab],[cab,bca,cab],[bca,acb,cba],[cba,acb,cba]]:1
 [[acb,bca,cba],[acb,cba,cba],[bca,acb,cab],[bca,cab,cab]]:1
 [[acb,bca,cba],[acb,cba,cba],[cab,abc,abc],[cab,bac,abc]]:1
 [[acb,bca,cba],[acb,cba,cba],[cba,abc,acb],[cba,acb,acb]]:1
 [[acb,cba,cba],[cab,bca,cab],[bca,cab,cab],[cba,acb,cba]]:1
 [[bac,cab,cba],[bac,cba,cba],[bca,abc,abc],[bca,acb,abc]]:1
 [[bac,cab,cba],[bac,cba,cba],[cba,abc,bac],[cba,bac,bac]]:1
 [[bca,acb,cab],[bca,cab,cab],[cba,abc,bac],[cba,bac,bac]]:1
 [[cab,abc,abc],[cab,bac,abc],[bac,acb,acb],[bac,cab,acb]]:1
 [[cab,abc,cab],[bac,acb,bac],[bca,acb,bac],[cba,abc,cab]]:1
 [[cab,bac,bca],[cab,bca,bca],[bac,cab,cba],[bac,cba,cba]]:1
 [[cab,bac,bca],[cab,bca,bca],[bca,acb,cab],[bca,cab,cab]]:1
 [[cab,bac,bca],[cab,bca,bca],[cba,abc,acb],[cba,acb,acb]]:1
 [[cab,bac,cba],[bac,cab,bca],[bca,cab,bca],[cba,bac,cba]]:1
 [[cab,bca,bca],[bac,cba,cba],[bca,cab,bca],[cba,bac,cba]]:1
total:42
true.

% genetate and verify swfs using sct2026.pl

?- C = [[cab,bca,bca],[bac,cba,cba],[bca,cab,bca],[cba,bac,cba]], nm_domain( 3, 3, [a,b,c], [1,2,3], L, K, U ), subtract( U, C, D ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, write( N: SWV ), fail.

212:12345612345612345612345612345612345612345612345612345612345612345612345612345612345612345612345612345612345123456123456123456123456123561234561234561234561234561235612345612345612345612345612345123456123456123456
212:11111122222233333344444455555566666611111122222233333344444455555566666611111122222233333344444455555566666111111222222333333444444555556666661111112222223333334444455555566666611111122222233333444444555555666666
212:11111111111111111111111111111111111122222222222222222222222222222222222233333333333333333333333333333333333444444444444444444444444444444444445555555555555555555555555555555555566666666666666666666666666666666666
false.


?- findall( H, ( tmp_n3_blocked( F, D ),  member( T, D ), concat_order_profile( [a,b,c], T, H ) ), C ), nm_domain( 3, 3, [a,b,c], [1,2,3], L, K, U ), subtract( U, C, D ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, write( N: SWV ), fail.

168:123456123456123456235623461612345612345614562412345613451234561456123456123456351245235624123456123456123612345623461234563512361234561234561613451245123456123456123456
168:111111222222333333444455556611111122222233334455555566661111112222333333444444556666111122333333444444555566666611112222223344445555556666661122223333444444555555666666
168:111111111111111111111111111122222222222222222222222222223333333333333333333333333333444444444444444444444444444455555555555555555555555555556666666666666666666666666666
false.

% by permutation of order in blocked profiles, we could find the maximal posible domain for the case of n=m=3. 

?- C = [[abc,bca,abc],[acb,bac,bac],[bac,acb,bac],[bca,abc,abc],[abc,abc,bca],[bac,bac,acb]], nm_domain( 3, 3, [a,b,c], [1,2,3], L, K, U ), subtract( U, C, D ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, write( N: SWV ), fail.

210:123561234561234562345612345612345612345612345612456123456123456123456123456124561345612345612345612345623456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456
210:111112222223333334444455555566666611111122222233333444444555555666666111111222223333344444455555566666611111222222333333444444555555666666111111222222333333444444555555666666111111222222333333444444555555666666
210:121552225551234565445655555555665622255522255522656556656555555556656123456226563346646446655665666666654456556656464466464466556656666666555555555555556656556656555555556656556656556656666666666666556656666666
210:111111111111111111111111111111111122222222222222222222222222222222222333333333333333333333333333333333344444444444444444444444444444444444555555555555555555555555555555555555666666666666666666666666666666666666
false.


?- C = [[abc,bca,abc],[acb,bac,bac],[bac,acb,bac],[bca,abc,abc],[abc,abc,bca],[bac,bac,acb]], nm_domain( 3, 3, [a,b,c], [1,2,3], L, K, U ), subtract( U, C, D ), map_axiom_swf( L, D, SWF ), dict_or_poss( D, SWF, Result), nl, write( Result), show_values( L, SWF, U, N, SWV ), nl, write( N: SWV ), fail.

dict(3)
216:123-56123456123456-2345612345612345612345612345612-45612345612345612345612345612-4561-3456123456123456123456-23456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456
dict(2)
216:111-11222222333333-4444455555566666611111122222233-33344444455555566666611111122-2223-3333444444555555666666-11111222222333333444444555555666666111111222222333333444444555555666666111111222222333333444444555555666666
poss
216:121-55222555123456-5445655555555665622255522255522-65655665655555555665612345622-6563-3466464466556656666666-54456556656464466464466556656666666555555555555556656556656555555556656556656556656666666666666556656666666
dict(1)
216:111-11111111111111-1111111111111111122222222222222-22222222222222222222233333333-3333-3333333333333333333333-44444444444444444444444444444444444555555555555555555555555555555555555666666666666666666666666666666666666
false.

dict(1)

?- String = '111-11111111111111-1111111111111111122222222222222-22222222222222222222233333333-3333-3333333333333333333333-44444444444444444444444444444444444555555555555555555555555555555555555666666666666666666666666666666666666', string_to_tables(String, Tables), print_tables_3x2(Tables) .
111-11   222222   333333
111111   222222   33-333
111111   22-222   3-3333
-11111   222222   333333
111111   222222   333333
111111   222222   333333

-44444   555555   666666
444444   555555   666666
444444   555555   666666
444444   555555   666666
444444   555555   666666
444444   555555   666666
String = '111-11111111111111-1111111111111111122222222222222-22222222222222222222233333333-3333-3333333333333333333333-44444444444444444444444444444444444555555555555555555555555555555555555666666666666666666666666666666666666',
Tables = [[['1', '1', '1', -, '1', '1'], ['1', '1', '1', '1', '1', '1'], ['1', '1', '1', '1', '1'|...], [-, '1', '1', '1'|...], ['1', '1', '1'|...], ['1', '1'|...]], [['2', '2', '2', '2', '2', '2'], ['2', '2', '2', '2', '2'|...], ['2', '2', -, '2'|...], ['2', '2', '2'|...], ['2', '2'|...], ['2'|...]], [['3', '3', '3', '3', '3'|...], ['3', '3', -, '3'|...], ['3', -, '3'|...], ['3', '3'|...], ['3'|...], [...|...]], [[-, '4', '4', '4'|...], ['4', '4', '4'|...], ['4', '4'|...], ['4'|...], [...|...]|...], [['5', '5', '5'|...], ['5', '5'|...], ['5'|...], [...|...]|...], [['6', '6'|...], ['6'|...], [...|...]|...]] .


dict(2)

?- String = '111-11222222333333-4444455555566666611111122222233-33344444455555566666611111122-2223-3333444444555555666666-11111222222333333444444555555666666111111222222333333444444555555666666111111222222333333444444555555666666', string_to_tables(String, Tables), print_tables_3x2(Tables) .
111-11   111111   111111
222222   222222   22-222
333333   33-333   3-3333
-44444   444444   444444
555555   555555   555555
666666   666666   666666

-11111   111111   111111
222222   222222   222222
333333   333333   333333
444444   444444   444444
555555   555555   555555
666666   666666   666666
String = '111-11222222333333-4444455555566666611111122222233-33344444455555566666611111122-2223-3333444444555555666666-11111222222333333444444555555666666111111222222333333444444555555666666111111222222333333444444555555666666',
Tables = [[['1', '1', '1', -, '1', '1'], ['2', '2', '2', '2', '2', '2'], ['3', '3', '3', '3', '3'|...], [-, '4', '4', '4'|...], ['5', '5', '5'|...], ['6', '6'|...]], [['1', '1', '1', '1', '1', '1'], ['2', '2', '2', '2', '2'|...], ['3', '3', -, '3'|...], ['4', '4', '4'|...], ['5', '5'|...], ['6'|...]], [['1', '1', '1', '1', '1'|...], ['2', '2', -, '2'|...], ['3', -, '3'|...], ['4', '4'|...], ['5'|...], [...|...]], [[-, '1', '1', '1'|...], ['2', '2', '2'|...], ['3', '3

dict(3)

?- String = '121-55222555123456-5445655555555665622255522255522-65655665655555555665612345622-6563-3466464466556656666666-54456556656464466464466556656666666555555555555556656556656555555556656556656556656666666666666556656666666', string_to_tables(String, Tables), print_tables_3x2(Tables) .
121-55   222555   123456
222555   222555   22-656
123456   22-656   3-3466
-54456   556656   464466
555555   555555   556656
556656   556656   666666

-54456   555555   556656
556656   555555   556656
464466   556656   666666
464466   556656   666666
556656   555555   556656
666666   556656   666666
String = '121-55222555123456-5445655555555665622255522255522-65655665655555555665612345622-6563-3466464466556656666666-54456556656464466464466556656666666555555555555556656556656555555556656556656556656666666666666556656666666',
Tables = [[['1', '2', '1', -, '5', '5'], ['2', '2', '2', '5', '5', '5'], ['1', '2', '3', '4', '5'|...], [-, '5', '4', '4'|...], ['5', '5', '5'|...], ['5', '5'|...]], [['2', '2', '2', '5', '5', '5'], ['2', '2', '2', '5', '5'|...], ['2', '2', -, '6'|...], ['5', '5', '6'|...], ['5', '5'|...], ['5'|...]], [['1', '2', '3', '4', '5'|...], ['2', '2', -, '6'|...], ['3', -, '3'|...], ['4', '6'|...], ['5'|...], [...|...]], [[-, '5', '4', '4'|...], ['5', '5', '6'|...], ['4', '6'|...], ['4'|...], [...|...]|...], [['5', '5', '5'|...], ['5', '5'|...], ['5'|...], [...|...]|...], [['5', '5'|...], ['5'|...], [...|...]|...]] .

?- 

poss

?- String = '123-56123456123456-2345612345612345612345612345612-45612345612345612345612345612-4561-3456123456123456123456-23456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456', string_to_tables(String, Tables), print_tables_3x2(Tables) .
123-56   123456   123456
123456   123456   12-456
123456   12-456   1-3456
-23456   123456   123456
123456   123456   123456
123456   123456   123456

-23456   123456   123456
123456   123456   123456
123456   123456   123456
123456   123456   123456
123456   123456   123456
123456   123456   123456
String = '123-56123456123456-2345612345612345612345612345612-45612345612345612345612345612-4561-3456123456123456123456-23456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456',
Tables = [[['1', '2', '3', -, '5', '6'], ['1', '2', '3', '4', '5', '6'], ['1', '2', '3', '4', '5'|...], [-, '2', '3', '4'|...], ['1', '2', '3'|...], ['1', '2'|...]], [['1', '2', '3', '4', '5', '6'], ['1', '2', '3', '4', '5'|...], ['1', '2', -, '4'|...], ['1', '2', '3'|...], ['1', '2'|...], ['1'|...]], [['1', '2', '3', '4', '5'|...], ['1', '2', -, '4'|...], ['1', -, '3'|...], ['1', '2'|...], ['1'|...], [...|...]], [[-, '2', '3', '4'|...], ['1', '2', '3'|...], ['1', '2'|...], ['1'|...], [...|...]|...], [['1', '2', '3'|...], ['1', '2'|...], ['1'|...], [...|...]|...], [['1', '2'|...], ['1'|...], [...|...]|...]] .


*/


swf_assignment_n2m4( [ A, B, C, D ], F, S ) :-
 S = [
 ( A>B,B>A ) -> F_1, 
 ( B>A,A>B ) -> F_2, 
 ( B>C,C>B ) -> F_3, 
 ( C>B,B>C ) -> F_4, 
 ( A>C,C>A ) -> F_5, 
 ( C>A,A>C ) -> F_6,
 ( A>D,D>A ) -> F_1y, 
 ( D>A,A>D ) -> F_2y, 
 ( B>D,D>B ) -> F_3y, 
 ( D>B,B>D ) -> F_4y, 
 ( C>D,D>C ) -> F_5y, 
 ( D>C,C>D ) -> F_6y | Unan ],
 T = [ A, B, C, D ], 
 findall( ( X > Y, X > Y )-> X > Y, ( member( X, T ), member( Y, T ), X \=Y ), Unan ), 
 member( F_1, [A>B,B>A] ), 
 member( F_2, [A>B,B>A] ), 
 member( F_3, [B>C,C>B] ), 
 member( F_4, [B>C,C>B] ), 
 member( F_5, [A>C,C>A] ), 
 member( F_6, [A>C,C>A] ),
 member( F_1y, [A>D,D>A] ),
 member( F_2y, [A>D,D>A] ), 
 member( F_3y, [B>D,D>B] ), 
 member( F_4y, [B>D,D>B] ), 
 member( F_5y, [D>C,C>D] ), 
 member( F_6y, [D>C,C>D] ),
 F = [ F_1, F_2, F_3, F_4, F_5, F_6,
	F_1y, F_2y, F_3y, F_4y, F_5y, F_6y ].


/*

?- hist((setof( S, swf_assignment_n2m4( [ a, b, c, d ], F, S ), D ), length( D, N ) ), N ).

 1:4096
total:4096
true.

*/


swf_map_profile_n2m4( [ A, B, C, D ], S, [ P1, P2 ], [W1, W2, W3, W4, W5, W6] ):-
	 member( ( X1, X2 ) -> W1, S ),
	 member( ( Y1, Y2 ) -> W2, S ),
	 member( ( Z1, Z2 ) -> W3, S ),
	 member( ( S1, S2 ) -> W4, S ),
	 member( ( T1, T2 ) -> W5, S ),
	 member( ( U1, U2 ) -> W6, S ),
	 P1 = [ X1, Y1, Z1, S1, T1, U1 ],
	 P2 = [ X2, Y2, Z2, S2, T2, U2 ],
	 order( [ A, B, C, D ], P1 ),
	 order( [ A, B, C, D ], P2 ).

swf_map_profile_n2m4_debug( [ A, B, C, D ], S, [ P1, P2 ], [W1, W2, W3, W4, W5, W6] ):-
	 order( [ A, B, C, D ], P1 ),
	 order( [ A, B, C, D ], P2 ),
	 P1 = [ X1, Y1, Z1, S1, T1, U1 ],
	 P2 = [ X2, Y2, Z2, S2, T2, U2 ],
	\+ (%write([0]),
	 member( ( X1, X2 ) -> W1, S ),%write([1]),
	 member( ( Y1, Y2 ) -> W2, S ),%write([2]),
	 member( ( Z1, Z2 ) -> W3, S ),%write([3]),
	 member( ( S1, S2 ) -> W4, S ),%write([4]),
	 member( ( T1, T2 ) -> W5, S ),%write([5]),
	 member( ( U1, U2 ) -> W6, S )
	).

/*

?- swf_assignment_n2m4( [ a, b, c, d ], F, S ),!, swf_map_profile_n2m4_debug( [ a, b, c, d ], S, P, W ), !,\+ ( member( X, S ), \+ writeln(X) ), concat_order_profile( [a,b,c,d], P, Px ), write(Px).
a>b,b>a->a>b
b>a,a>b->a>b
b>c,c>b->b>c
c>b,b>c->b>c
a>c,c>a->a>c
c>a,a>c->a>c
a>d,d>a->a>d
d>a,a>d->a>d
b>d,d>b->b>d
d>b,b>d->b>d
c>d,d>c->d>c
d>c,c>d->d>c
a<b,a<b->a<b
a<c,a<c->a<c
a<d,a<d->a<d
b<a,b<a->b<a
b<c,b<c->b<c
b<d,b<d->b<d
c<a,c<a->c<a
c<b,c<b->c<b
c<d,c<d->c<d
d<a,d<a->d<a
d<b,d<b->d<b
d<c,d<c->d<c
[abcd,abcd]
F = [a>b, a>b, b>c, b>c, a>c, a>c, a>d, a>d, ... > ...|...],
S = [(a>b, b>a->a>b), (b>a, a>b->a>b), (b>c, c>b->b>c), (c>b, b>c->b>c), (a>c, c>a->a>c), (c>a, a>c->a>c), (... > ..., ... > ... -> a>d), (..., ... -> ... > ...), (... -> ...)|...],
P = [[a>b, b>c, a>c, a>d, b>d, c>d], [a>b, b>c, a>c, a>d, b>d, c>d]],
W = [_, _, _, _, _, _],
Px = [abcd, abcd] .

?- 

*/


/*

?- swf_assignment_n2m4( [ a, b, c, d ], F, S ), findall( P, swf_map_profile_n2m4( [ a, b, c, d ], S, P, W ), D ), length( D, N ).
F = [a>b, a>b, b>c, b>c, a>c, a>c, a>d, a>d, ... > ...|...],
S = [(a>b, b>a->a>b), (b>a, a>b->a>b), (b>c, c>b->b>c), (c>b, b>c->b>c), (a>c, c>a->a>c), (c>a, a>c->a>c), (... > ..., ... > ... -> a>d), (..., ... -> ... > ...), (... -> ...)|...],
D = [[[a>b, b>c, a>c, a>d, b>d, c>d], [b>a, c>b, c>a, d>a, d>b, ... > ...]], [[a>b, b>c, a>c, a>d, b>d, ... > ...], [b>a, c>b, c>a, d>a, ... > ...|...]], [[a>b, b>c, a>c, a>d, ... > ...|...], [b>a, c>b, c>a, ... > ...|...]], [[a>b, b>c, a>c, ... > ...|...], [b>a, c>b, ... > ...|...]], [[a>b, c>b, ... > ...|...], [b>a, ... > ...|...]], [[a>b, ... > ...|...], [... > ...|...]], [[... > ...|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 24 .

==> fix

?- swf_assignment_n2m4( [ a, b, c, d ], F, S ), findall( P, swf_map_profile_n2m4( [ a, b, c, d ], S, P, W ), D ), length( D, N ).
F = [a>b, a>b, b>c, b>c, a>c, a>c, a>d, a>d, ... > ...|...],
S = [(a>b, b>a->a>b), (b>a, a>b->a>b), (b>c, c>b->b>c), (c>b, b>c->b>c), (a>c, c>a->a>c), (c>a, a>c->a>c), (... > ..., ... > ... -> a>d), (..., ... -> ... > ...), (... -> ...)|...],
D = [[[a>b, b>c, a>c, a>d, b>d, c>d], [a>b, b>c, a>c, a>d, b>d, ... > ...]], [[a>b, b>c, a>c, a>d, b>d, ... > ...], [a>b, b>c, a>c, a>d, ... > ...|...]], [[a>b, b>c, a>c, a>d, ... > ...|...], [a>b, b>c, a>c, ... > ...|...]], [[a>b, b>c, a>c, ... > ...|...], [a>b, b>c, ... > ...|...]], [[a>b, b>c, ... > ...|...], [a>b, ... > ...|...]], [[a>b, ... > ...|...], [... > ...|...]], [[... > ...|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 576 .

*/

swf_map_n2m4( [ A, B, C, D ], S, [ P1, P2 ], W ):-
	 swf_map_profile_n2m4( [ A, B, C, D ], S, [ P1, P2 ], W ),
	 order( [ A, B, C, D ], W ).

swf_violation_n2m4( [ A, B, C, D ], S, [ P1, P2 ], W ):-
	 swf_map_profile_n2m4( [ A, B, C, D ], S, [ P1, P2 ], W ),
	 \+ order( [ A, B, C, D ], W ).


swf_blocking_n2m4( [ A, B, C, D ], F, [ P1, P2 ], W, S ) :-
	 swf_assignment_n2m4( [ A, B, C, D ], F, S ),
	 swf_violation_n2m4( [ A, B, C, D ], S, [ P1, P2 ], W ).  

swf_blocking_n2m4( A, F, P, W ) :-
	 swf_blocking_n2m4( A, F, P, W, _ ) .

swf_n2m4( [ A, B, C, D ], F, S ) :-
	 swf_assignment_n2m4( [ A, B, C, D ], F, S ),
	 \+ swf_violation_n2m4( [ A, B, C, D ], S, _, _ ).  

swf_n2m4_map( X, F, S, SWF ) :-
	 swf_assignment_n2m4( X, F, S ),
	 swf_n2m4_map( X, S, SWF ).

swf_n2m4_map( X, S, SWF ) :-
	 %X = [A,B,C,D],
	 G = (
		 swf_map_n2m4( X, S, P, W ),
		 concat_order_profile( X, P, Px ),
		 order_as_concat( X, _, W, Wx )
	 ),
	 findall( Px-Wx, G, SWF ). 

/*

?- swf_blocking_n2m4( [ a, b, c, d ], F, P, W, S ).
F = [a>b, a>b, b>c, b>c, a>c, a>c, a>d, a>d, ... > ...|...],
P = [[a>b, b>c, a>c, a>d, d>b, d>c], [b>a, c>b, c>a, d>a, b>d, c>d]],
W = [a>b, b>c, a>c, a>d, d>b, c>d],
S = [(a>b, b>a->a>b), (b>a, a>b->a>b), (b>c, c>b->b>c), (c>b, b>c->b>c), (a>c, c>a->a>c), (c>a, a>c->a>c), (... > ..., ... > ... -> a>d), (..., ... -> ... > ...), (... -> ...)|...] .


?- abolish( tmp_n2m4_min/ 4 ).
true.

?- swf_blocking_n2m4( [ a, b, c, d ], F, P,W,S ), assert( tmp_block_n2m4( F, P, W, S ) ), fail.
false.

?- 
?- hist( tmp_block_n2m4( F, P, W, S ), 1 ).

 1:823296
total:823296
true.

?- setof( P, W^tmp_block_n2m4( F, P, W, S ), H ), length( H, N ).
F = [a>b, a>b, b>c, b>c, a>c, a>c, a>d, a>d, ... > ...|...],
S = [(a>b, b>a->a>b), (b>a, a>b->a>b), (b>c, c>b->b>c), (c>b, b>c->b>c), (a>c, c>a->a>c), (c>a, a>c->a>c), (... > ..., ... > ... -> a>d), (..., ... -> ... > ...), (... -> ...)|...],
H = [[[a>b, b>c, a>c, a>d, d>b, d>c], [a>b, c>b, a>c, a>d, d>b, ... > ...]], [[a>b, b>c, a>c, a>d, d>b, ... > ...], [a>b, c>b, c>a, a>d, ... > ...|...]], [[a>b, b>c, a>c, a>d, ... > ...|...], [a>b, c>b, c>a, ... > ...|...]], [[a>b, b>c, a>c, ... > ...|...], [b>a, c>b, ... > ...|...]], [[a>b, b>c, ... > ...|...], [a>b, ... > ...|...]], [[a>b, ... > ...|...], [... > ...|...]], [[... > ...|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 98 .

?- setof( P, W^tmp_block_n2m4( F, P, W, S ), H ), length( H, N ), assert( tmp_blocked_pp_n2m4( S, H, N ) ), fail.

?- setof( P, W^tmp_block_n2m4( F, P, W, S ), H ), length( H, N ), assert( tmp_blocked_pp_n2m4( F, S, H, N ) ), fail.
false.

?- 


?- hist( tmp_blocked_pp_n2m4( S, H, N ), N).
 72:40
 96:60
 98:96
 100:12
 110:96
 123:48
 128:48
 132:24
 144:12
 148:144
 152:48
 153:96
 160:192
 166:96
 167:96
 176:96
 183:48
 184:48
 188:216
 192:32
 194:144
 198:96
 200:168
 202:48
 204:48
 205:192
 206:144
 208:24
 210:96
 216:144
 219:48
 222:16
 227:96
 228:48
 234:96
 236:96
 238:96
 240:22
 244:192
 249:96
 252:72
 256:96
 262:96
 264:12
 272:48
 279:48
 284:144
 288:12
 290:96
 292:12
total:4094
true.

?- 


?- tmp_blocked_pp_n2m4( S, H, 72 ), swf_n2m4_map( [a,b,c,d], S, SWF ), length( SWF, N), length( H, KJ ).
S = [(a>b, b>a->a>b), (b>a, a>b->a>b), (b>c, c>b->b>c), (c>b, b>c->c>b), (a>c, c>a->a>c), (c>a, a>c->a>c), (... > ..., ... > ... -> a>d), (..., ... -> ... > ...), (... -> ...)|...],
H = [[[a>b, c>b, c>a, d>a, d>b, c>d], [a>b, b>c, a>c, d>a, d>b, ... > ...]], [[a>b, c>b, c>a, d>a, d>b, ... > ...], [a>b, c>b, a>c, d>a, ... > ...|...]], [[a>b, c>b, c>a, d>a, ... > ...|...], [b>a, b>c, a>c, ... > ...|...]], [[a>b, c>b, c>a, ... > ...|...], [b>a, b>c, ... > ...|...]], [[a>b, c>b, ... > ...|...], [a>b, ... > ...|...]], [[a>b, ... > ...|...], [... > ...|...]], [[... > ...|...], [...|...]], [[...|...]|...], [...|...]|...],
SWF = [[abcd, abcd]-abcd, [abcd, abdc]-abcd, [abcd, adbc]-abcd, [abcd, dabc]-abcd, [abcd, cabd]-abcd, [abcd, cadb]-abcd, [abcd|...]-abcd, [...|...]-abcd, ... - ...|...],
N = 504,
KJ = 72 .

?- 


?- tmp_blocked_pp_n2m4( S, C, 72 ), !, nm_domain( 2, 4, A, I, L, K, U ), concat_order_domain( A, C, Cx ), subtract( U, Cx, D ), !, map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, dict_or_poss( D, SWF, Dict ), write( [Dict] ), nl, write( N: SWV ),fail.

[dict(2)]
504:123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcfgijklmo123456789acfgimo123456789abcdefgilmo12345678abcgilmo123456789abcdefghijklmno123456789abcdefghijklmno1234569acdefghijkmno1234569acdefgimo123456789acdefghimno123456acdeghimno123456789abcdefghijklmno123456789abcdefghijklmno123456abcdeghijklmno123456abcgijklmo12345678abcghijklmno123456acghijkmno
[poss]
504:11111111111111111111111122222222222222222222222233333333333333333333333344444444444444444444444455555555555555555555555566666666666666666666666611111177777711771711771722222288888822882822882811111177997999911799111111779aa9aaaa222222888bbb228bbbbb22222288cbcccbcc33333333dd3ddddddd333ddd44444444ee4eeeeeee444eee333333fffddffdf33fdf333333fggddfgggg44444444ehheeehhhhhh444444iieeihiihi555555555jjj555jjjjjjjjj666666666kkk666kkkkkkkkk555555lll55ljljjlljl555555mlmmmjjlmm66666666nknnnnkkknnn666666ooonokkono
[dict(1)]
504:11111111111111111111111122222222222222222222222233333333333333333333333344444444444444444444444455555555555555555555555566666666666666666666666677777777777777777777777788888888888888888888888899999999999999999999aaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbccccccccccccccccddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeffffffffffffffffffffgggggggggggggggghhhhhhhhhhhhhhhhhhhhiiiiiiiiiiiiiiiijjjjjjjjjjjjjjjjjjjjjjjjkkkkkkkkkkkkkkkkkkkkkkkkllllllllllllllllllllmmmmmmmmmmmmmmmmnnnnnnnnnnnnnnnnnnnnoooooooooooooooo
false.


?- tmp_blocked_pp_n2m4( S, C, 72 ), \+ (nth1( J, S, X ), writeln(J:X), fail ).
1:(a>b,b>a->a>b)
2:(b>a,a>b->a>b)
3:(b>c,c>b->b>c)
4:(c>b,b>c->c>b)
5:(a>c,c>a->a>c)
6:(c>a,a>c->a>c)
7:(a>d,d>a->a>d)
8:(d>a,a>d->a>d)
9:(b>d,d>b->b>d)
10:(d>b,b>d->d>b)
11:(c>d,d>c->c>d)
12:(d>c,c>d->d>c)
13:(a>b,a>b->a>b)
14:(a>c,a>c->a>c)
15:(a>d,a>d->a>d)
16:(b>a,b>a->b>a)
17:(b>c,b>c->b>c)
18:(b>d,b>d->b>d)
19:(c>a,c>a->c>a)
20:(c>b,c>b->c>b)
21:(c>d,c>d->c>d)
22:(d>a,d>a->d>a)
23:(d>b,d>b->d>b)
24:(d>c,d>c->d>c)
S = [(a>b, b>a->a>b), (b>a, a>b->a>b), (b>c, c>b->b>c), (c>b, b>c->c>b), (a>c, c>a->a>c), (c>a, a>c->a>c), (... > ..., ... > ... -> a>d), (..., ... -> ... > ...), (... -> ...)|...],
C = [[[a>b, c>b, c>a, d>a, d>b, c>d], [a>b, b>c, a>c, d>a, d>b, ... > ...]], [[a>b, c>b, c>a, d>a, d>b, ... > ...], [a>b, c>b, a>c, d>a, ... > ...|...]], [[a>b, c>b, c>a, d>a, ... > ...|...], [b>a, b>c, a>c, ... > ...|...]], [[a>b, c>b, c>a, ... > ...|...], [b>a, b>c, ... > ...|...]], [[a>b, c>b, ... > ...|...], [a>b, ... > ...|...]], [[a>b, ... > ...|...], [... > ...|...]], [[... > ...|...], [...|...]], [[...|...]|...], [...|...]|...] .

?- 


?-  tmp_blocked_pp_n2m4( S, C, 72 ), concat_order_domain( [a,b,c,d], C, Cx ), \+ ( swf_violation_n2m4( [ a, b, c, d ], S, X, W ), concat_order_profile( [a,b,c,d ], X, Px ), writeln( Px;W), fail ).
[cdab,dabc];[a>b,c>b,a>c,d>a,d>b,c>d]
[cdab,dacb];[a>b,c>b,a>c,d>a,d>b,c>d]
[cdab,bdac];[a>b,c>b,a>c,d>a,d>b,c>d]
[cdab,dbac];[a>b,c>b,a>c,d>a,d>b,c>d]
[dcab,cabd];[a>b,c>b,c>a,a>d,d>b,d>c]
[dcab,cadb];[a>b,c>b,c>a,a>d,d>b,d>c]
[dcab,bcad];[a>b,c>b,c>a,a>d,d>b,d>c]
[dcab,cbad];[a>b,c>b,c>a,a>d,d>b,d>c]
[bcad,cabd];[a>b,b>c,c>a,a>d,b>d,c>d]
[bcad,cadb];[a>b,b>c,c>a,a>d,b>d,c>d]
[bcad,cdab];[a>b,b>c,c>a,a>d,b>d,c>d]
[bcad,dcab];[a>b,b>c,c>a,a>d,b>d,c>d]
[bcda,dabc];[a>b,b>c,a>c,d>a,b>d,c>d]
[bcda,cabd];[a>b,b>c,c>a,a>d,b>d,c>d]
[bcda,cadb];[a>b,b>c,c>a,a>d,b>d,c>d]
[bcda,cdab];[a>b,b>c,c>a,d>a,b>d,c>d]
[bcda,dcab];[a>b,b>c,c>a,d>a,b>d,c>d]
[bcda,dacb];[a>b,b>c,a>c,d>a,b>d,c>d]
[bcda,bdac];[b>a,b>c,a>c,d>a,b>d,c>d]
[bcda,dbac];[b>a,b>c,a>c,d>a,b>d,c>d]
[bdca,dabc];[a>b,b>c,a>c,d>a,b>d,d>c]
[bdca,cabd];[a>b,b>c,c>a,a>d,b>d,d>c]
[bdca,cadb];[a>b,b>c,c>a,a>d,b>d,d>c]
[bdca,cdab];[a>b,b>c,c>a,d>a,b>d,d>c]
[bdca,dcab];[a>b,b>c,c>a,d>a,b>d,d>c]
[bdca,dacb];[a>b,b>c,a>c,d>a,b>d,d>c]
[bdca,bcad];[b>a,b>c,c>a,a>d,b>d,d>c]
[bdca,cbad];[b>a,b>c,c>a,a>d,b>d,d>c]
[dbca,cabd];[a>b,b>c,c>a,a>d,d>b,d>c]
[dbca,cadb];[a>b,b>c,c>a,a>d,d>b,d>c]
[dbca,cdab];[a>b,b>c,c>a,d>a,d>b,d>c]
[dbca,dcab];[a>b,b>c,c>a,d>a,d>b,d>c]
[dbca,bcad];[b>a,b>c,c>a,a>d,d>b,d>c]
[dbca,bacd];[b>a,b>c,a>c,a>d,d>b,d>c]
[dbca,badc];[b>a,b>c,a>c,a>d,d>b,d>c]
[dbca,cbad];[b>a,b>c,c>a,a>d,d>b,d>c]
[bdac,dabc];[a>b,b>c,a>c,d>a,b>d,d>c]
[bdac,cdab];[a>b,b>c,a>c,d>a,b>d,d>c]
[bdac,dcab];[a>b,b>c,a>c,d>a,b>d,d>c]
[bdac,dacb];[a>b,b>c,a>c,d>a,b>d,d>c]
[dbac,bcad];[b>a,b>c,a>c,a>d,d>b,d>c]
[dbac,bacd];[b>a,b>c,a>c,a>d,d>b,d>c]
[dbac,badc];[b>a,b>c,a>c,a>d,d>b,d>c]
[dbac,cbad];[b>a,b>c,a>c,a>d,d>b,d>c]
[cbad,bacd];[b>a,c>b,a>c,a>d,b>d,c>d]
[cbad,badc];[b>a,c>b,a>c,a>d,b>d,c>d]
[cbad,bdac];[b>a,c>b,a>c,a>d,b>d,c>d]
[cbad,dbac];[b>a,c>b,a>c,a>d,b>d,c>d]
[cbda,dabc];[a>b,c>b,a>c,d>a,b>d,c>d]
[cbda,cdab];[a>b,c>b,c>a,d>a,b>d,c>d]
[cbda,dcab];[a>b,c>b,c>a,d>a,b>d,c>d]
[cbda,dacb];[a>b,c>b,a>c,d>a,b>d,c>d]
[cbda,bacd];[b>a,c>b,a>c,a>d,b>d,c>d]
[cbda,badc];[b>a,c>b,a>c,a>d,b>d,c>d]
[cbda,bdac];[b>a,c>b,a>c,d>a,b>d,c>d]
[cbda,dbac];[b>a,c>b,a>c,d>a,b>d,c>d]
[cdba,dabc];[a>b,c>b,a>c,d>a,d>b,c>d]
[cdba,dacb];[a>b,c>b,a>c,d>a,d>b,c>d]
[cdba,bcad];[b>a,c>b,c>a,a>d,d>b,c>d]
[cdba,bacd];[b>a,c>b,a>c,a>d,d>b,c>d]
[cdba,badc];[b>a,c>b,a>c,a>d,d>b,c>d]
[cdba,bdac];[b>a,c>b,a>c,d>a,d>b,c>d]
[cdba,dbac];[b>a,c>b,a>c,d>a,d>b,c>d]
[cdba,cbad];[b>a,c>b,c>a,a>d,d>b,c>d]
[dcba,cabd];[a>b,c>b,c>a,a>d,d>b,d>c]
[dcba,cadb];[a>b,c>b,c>a,a>d,d>b,d>c]
[dcba,bcad];[b>a,c>b,c>a,a>d,d>b,d>c]
[dcba,bacd];[b>a,c>b,a>c,a>d,d>b,d>c]
[dcba,badc];[b>a,c>b,a>c,a>d,d>b,d>c]
[dcba,bdac];[b>a,c>b,a>c,d>a,d>b,d>c]
[dcba,dbac];[b>a,c>b,a>c,d>a,d>b,d>c]
[dcba,cbad];[b>a,c>b,c>a,a>d,d>b,d>c]
S = [(a>b, b>a->a>b), (b>a, a>b->a>b), (b>c, c>b->b>c), (c>b, b>c->c>b), (a>c, c>a->a>c), (c>a, a>c->a>c), (... > ..., ... > ... -> a>d), (..., ... -> ... > ...), (... -> ...)|...],
C = [[[a>b, c>b, c>a, d>a, d>b, c>d], [a>b, b>c, a>c, d>a, d>b, ... > ...]], [[a>b, c>b, c>a, d>a, d>b, ... > ...]
...




?- tmp_n2m4_min( S, C, 4 ), swf_n2m4_map( [a,b,c,d], F, S, SWF ), member( P-X, SWF ), \+ pareto_rule( P - X ).
false.

?- tmp_n2m4_min( S, C, 4 ), swf_n2m4_map( [a,b,c,d], F, S, SWF ), member( P-X, SWF ), \+ iia_rule( P - X, SWF ).
false.

?- 

?- tmp_n2m4_min( S, C, 4 ), swf_n2m4_map( [a,b,c,d], F, S, SWF ), length( SWF, N ), forall( member( X, SWF ), ( nl, write( X )) ).

[abcd,dcba]-abcd
[abdc,cdba]-abdc
[adbc,cbda]-adbc
[dabc,cbad]-adbc
[cabd,dbac]-abcd
[dcab,bacd]-adbc
[acbd,dbca]-abcd
[adcb,bcda]-adbc
[dacb,bcad]-adbc
[bcad,dacb]-abcd
[bcda,adcb]-abcd
[bdca,acdb]-abdc
[dbca,acbd]-adbc
[bacd,dcab]-abcd
[badc,cdab]-abdc
[bdac,cadb]-abdc
[dbac,cabd]-adbc
[cbad,dabc]-abcd
[cbda,adbc]-abcd
[dcba,abcd]-adbc
S = [(a>b, b>a->a>b), (b>a, a>b->a>b), (b>c, c>b->b>c), (c>b, b>c->b>c), (a>c, c>a->a>c), (c>a, a>c->a>c), (... > ..., ... > ... -> a>d), (..., ... -> ... > ...), (... -> ...)|...],
C = [[[a>b, c>b, a>c, a>d, d>b, c>d], [b>a, b>c, c>a, d>a, b>d, ... > ...]], [[a>b, c>b, c>a, a>d, d>b, ... > ...], [b>a, b>c, a>c, d>a, ... > ...|...]], [[a>b, c>b, c>a, d>a, ... > ...|...], [b>a, b>c, a>c, ... > ...|...]], [[b>a, c>b, c>a, ... > ...|...], [a>b, b>c, ... > ...|...]]],
F = [a>b, a>b, b>c, b>c, a>c, a>c, a>d, a>d, ... > ...|...],
SWF = [[abcd, dcba]-abcd, [abdc, cdba]-abdc, [adbc, cbda]-adbc, [dabc, cbad]-adbc, [cabd, dbac]-abcd, [dcab, bacd]-adbc, [acbd|...]-abcd, [...|...]-adbc, ... - ...|...],
N = 20 .

?- 


?- nm_domain( 2, 4, A, I, L, K, U ), length( D, 10 ), append( D, _, U ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, write( N: SWV ), dict_or_poss( D, SWF, Dict ), write( Dict ), fail.

10:1111111111dict(1)
10:1133131111poss
10:1211221211poss
10:1234561211poss
10:1111117777poss
10:1133137777poss
10:1211227877poss
10:1234567877poss
10:1111117799poss
10:1133137799poss
10:1211227899poss
10:1234567899poss
10:111111779aposs
10:113313779aposs
10:121122789aposs
10:123456789adict(2)
false.

?- 
?- nm_domain( 2, 4, A, I, L, K, U ), length( D, 20 ), append( D, _, U ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, write( N: SWV ), dict_or_poss( D, SWF, Dict ), write( Dict ), fail.

20:11111111111111111111dict(1)
20:11111177777711771711poss
20:12112212112211111122poss
20:12112278778811771722poss
20:11331311111133333313poss
20:113313779979ddffdf13poss
20:12345612112234334456poss
20:123456789abcdefghijkdict(2)
false.

?- nm_domain( 2, 4, A, I, L, K, U ), length( D, 30 ), append( D, _, U ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, write( N: SWV ), dict_or_poss( D, SWF, Dict ), write( Dict ), fail.

30:111111111111111111111111121122poss
30:121122121122111111222222121122poss
30:111111777777117717117717121122poss
30:121122787788117717228828121122poss
30:111111111111111111111111222222dict(1)
30:121122121122111111222222222222poss
30:111111777777117717117717222222poss
30:121122787788117717228828222222poss
30:123456121122343344565566123456poss
30:123456789abcdefghijklmno123456dict(2)
false.

?- nm_domain( 2, 4, A, I, L, K, U ), length( D, 100 ), append( D, _, U ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, write( N: SWV ), dict_or_poss( D, SWF, Dict ), write( Dict ), fail.

100:1234561211223433445655661234561211223433445655661234561211223433445655661234561211223433445655661234poss
100:123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno1234dict(2)
100:1111111111111111111111112222222222222222222222223333333333333333333333333334443333333433444444442225poss
100:1111111111111111111111112222222222222222222222223333333333333333333333334444444444444444444444445555dict(1)
false.

?- nm_domain( 2, 4, A, I, L, K, U ), length( D, 200 ), append( D, _, U ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, write( N: SWV ), dict_or_poss( D, SWF, Dict ), write( Dict ), fail.

200:11111111111111111111111122222222222222222222222233333333333333333333333344444444444444444444444455555555555555555555555566666666666666666666666611111177777711771711771722222288888822882822882811111177poss
200:11111111111111111111111122222222222222222222222233333333333333333333333344444444444444444444444455555555555555555555555566666666666666666666666677777777777777777777777788888888888888888888888877777777poss
200:123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno12345678dict(2)
200:11111111111111111111111122222222222222222222222233333333333333333333333344444444444444444444444455555555555555555555555566666666666666666666666677777777777777777777777788888888888888888888888899999999dict(1)
false.

?- nm_domain( 2, 4, A, I, L, K, U ), length( D, 300 ), append( D, _, U ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, write( N: SWV ), dict_or_poss( D, SWF, Dict ), write( Dict ), fail.

300:123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdefghijklmno123456789abcdict(2)
300:111111111111111111111111222222222222222222222222333333333333333333333333444444444444444444444444555555555555555555555555666666666666666666666666777777777777777777777777888888888888888888888888999999999999999999999999aaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbccccccccccccccccccccccccdddddddddddddict(1)
false.

*/

