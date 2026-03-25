preference_order( A, P ):-
	 permutation( A, B ),
	 atomic_list_concat( B, P ).

n_profile( N, A, P ):-
	 length( P, N ),
	 maplist( preference_order( A ), P ).
%	 maplist( permutation( A ), P ).

domain(
	 alternatives( A ),
	 persons( I ),
	 preferences( H ),
	 size( K ),
	 profiles( D )
 ):-
	 length( I, N ),
	 findall( P, preference_order( A, P ), H ),
	 findall( P, n_profile( N, A, P ), U ),
	 select_n( D, U, K ).

base_case( A, I, H, K, D ):-
	 A = [a, b, c ],
	 I = [1, 2],
	 K_full is 6 ^ 2,
	 ( var( K ) -> K is K_full ; between( 1, K_full, K ) ),
	 domain(
		 alternatives( A ),
		 persons( I ),
		 preferences( H ),
		 size( K ),
		 profiles( D )
	 ).

mapy( _, [ ], F, F ).

mapy( Axiom, [ X | D ], A, F ):-
	 apply( Axiom, [ X, D, A, B ] ),
	 mapy( Axiom, D, B, F ).

mapy( Axiom, D, F ):-
	 reverse( D, Dx ),
	 mapy( Axiom, Dx, [ ], F ).

subsequence( K, P, H ):-
	 mapy( take_or_leave( K ), P, H ).

subsequently_multiply( X, _, [ S ], [ S * X ] ).
subsequently_multiply( J, _, [ ], [ J ] ).

factorial( 0, 1 ).
factorial( K, F ):-
	 findall( J, between( 1, K, J ), D ),
	 mapy( subsequently_multiply, D, [ A ] ),
	 F is A.


nm_domain( N, M, A, I, H, K, D ):-
	 append( A, _,[a, b, c, d, e, f, g, h, i, j, k, l, m, n ] ),
	 length( A, M ),
	 findall( J, between( 1, N, J ), I ),
	 factorial( M, V ),
	 K_full is V ^ N,
	 ( var( K ) -> K is K_full ; between( 1, K_full, K ) ),
	 domain(
		 alternatives( A ),
		 persons( I ),
		 preferences( H ),
		 size( K ),
		 profiles( D )
	 ).


rank( P, X, K ):- sub_atom( P, K, 1,_,X).

preference( X, Y, P ):-
	 rank( P, X, K ), 
	 rank( P, Y, J ),
	 K < J. 

unanimous_pp( _, _, [ ] ).
unanimous_pp( X, Y, [ R | P ] ):-
	 preference( X, Y, R ),
	 unanimous_pp( X, Y, P ).

pareto_rule( P - S ):-
	 forall(
		 unanimous_pp( X, Y, P ),
		 preference( X, Y, S )
	 ).

iia_rule( P - S, F ):-
	 \+ iia_violation( P - S, F, _, _ ).

iia_referer( P-S, F, (X, Y), Q-T ):-
	 preference( X, Y, S ),
	 member( Q - T, F ),
	 \+ reversal_xy( P -> Q, (X, Y), _ ).

iia_immediate_referer( P-S, F, (X, Y), Q-T ):-
	 once( iia_referer( P-S, F, (X, Y), Q-T ) ).

iia_violation( P-S, F, (X, Y), Q-T ):-
	 preference( X, Y, S ),  % this is necessary
	 iia_immediate_referer( P-S, F, (X, Y), Q-T ),
	 %iia_referer( P-S, F, (X, Y), Q-T ),
	 \+ preference( X, Y, T ).

reversal_xy( P1 -> P2, (X, Y), [J, R->Q] ):-
	 nth1( J, P1, R ),
	 preference( X, Y, R ),
	 nth1( J, P2, Q ),
	 \+ preference( X, Y, Q ).

reversal_xy( P1 -> P2, (X, Y), [J, R->Q] ):-
	 nth1( J, P1, R ),
	 \+ preference( X, Y, R ),
	 nth1( J, P2, Q ),
	 preference( X, Y, Q ).


axiom_swf( H, P, ( P - S ), _, F ):- 
	 member( S, H ),
	 pareto_rule( P - S ),
	 iia_rule( P - S, F ).


dictatorship( [ ], [ ], dict( _ ) ). 
dictatorship( [ P | D ], [ P - S | F ], dict( J ) ):- 
	 nth1( J, P, S ),
	 dictatorship( D, F, dict( J ) ).

map_axiom_swf( _, [ ], F, F ).

map_axiom_swf( L, [ X | D ], A, F ):-
	 axiom_swf( L, X, Y, D, A ),
	 % X: current term
	 % Y: value assigned; ( X, A, D ) => Y 
	 % D: remaining list
	 % A: inductive outcome (i.e., accumulator)
	 map_axiom_swf( L, D, [Y|A], F ).

map_axiom_swf( L, D, F ):-
	 reverse( D, Dx ),
	 map_axiom_swf( L, Dx, [ ], F ).



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


/*

?- base_case( A, I, L, K, D ), di_chain( D, L, (a,b), H, G ),  length( H, 6 ), show_domain( L, H ).
        [1,2,3,4,5,6];
1:abc   [-,-,-,1,-,-];
2:acb   [-,-,6,-,-,-];
3:bac   [-,-,-,-,-,2];
4:bca   [-,-,-,-,3,-];
5:cab   [5,-,-,-,-,-];
6:cba   [-,4,-,-,-,-];
A = [a, b, c],
I = [1, 2],
L = [abc, acb, bac, bca, cab, cba],
K = 36,
D = [[abc, abc], [abc, acb], [abc, bac], [abc, bca], [abc, cab], [abc, cba], [acb, abc], [acb|...], [...|...]|...],
H = [[abc, bca], [bac, cba], [bca, cab], [cba, acb], [cab, abc], [acb, bac]],
G = [(a, b), (a, c), (b, c), (b, a), (c, a), (c, b), (a, b)] .

?- base_case( A, I, L, K, D ), di_chain( D, L, (a,b), H, G ),  length( H, 6 ), writeln( H ), fail.

?- nm_domain( 2, 3, A, I, L, K, D ), di_chain( D, L, (a,b), H, G ),  length( H, 6 ), writeln( G ), fail.
[(a,b),(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)]
[(b,c),(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)]
[(c,a),(c,b),(c,a),(b,a),(b,c),(a,c),(a,b)]
[(a,b),(c,b),(c,a),(b,a),(b,c),(a,c),(a,b)]
[(a,b),(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)]
[(b,c),(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)]
[(c,a),(c,b),(c,a),(b,a),(b,c),(a,c),(a,b)]
[(a,b),(c,b),(c,a),(b,a),(b,c),(a,c),(a,b)]
false.

*/

show_values( W, F, N, SWF ):- 
	 findall( J, (
		 member( _-S, F ),
		 nth1( K, W, S ),
		 ( K < 10 -> J =K ; K1 is 87 + K, char_code( J, K1 ) )  
	 ), E ), 
	 length( E, N ),
	 atomic_list_concat( E, SWF ).

show_values( W, F, D, N, SWF ):- 
	 findall( J, (
		 member( P, D ), 
		 ( member( P-S, F ) -> nth1( J, W, S ); J = '-' )  % 5 Jan 2026
	 ), E ), 
	 length( E, N ),
	 atomic_list_concat( E, SWF ).

gen_swf( Size, Alternatives, Persons, L, Domain, SWF ):-
	 domain(
		 alternatives( Alternatives ),
		 persons( Persons ),
		 preferences( L ),
		 size( Size ),
		 profiles( Domain )
	 ),
	 map_axiom_swf( L, Domain, SWF ).

gen_swf( Size, Alternatives, Persons, L, Domain, SWF, Dict ):-
	 gen_swf( Size, Alternatives, Persons, L, Domain, SWF ),
%	 ( dictatorship( Domain, SWF, Dict )-> true ; Dict = poss ).
	 dict_or_poss( Domain, SWF, Dict ).

dict_or_poss( Domain, SWF, Result ):-
	 dictatorship( Domain, SWF, Dict ),
	 !,
	 Result = Dict.

dict_or_poss( _, _, poss ).

test_case( Size, Alternatives, Persons, Result ):-
	 gen_swf( Size, Alternatives, Persons, L, _, SWF, Dict ),
	 Dict = Result,
	 show_values( L, SWF, N, SWV ),
	 nl, write( SWV; N; Dict ),
	 fail ;  Result= complete.


/*

?- nm_domain( 2, 3, A, I, L, K, D ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ).
A = [a, b, c],
I = [1, 2],
L = [abc, acb, bac, bca, cab, cba],
K = N, N = 36,
D = [[abc, abc], [abc, acb], [abc, bac], [abc, bca], [abc, cab], [abc, cba], [acb, abc], [acb|...], [...|...]|...],
SWF = [[abc, abc]-abc, [abc, acb]-acb, [abc, bac]-bac, [abc, bca]-bca, [abc, cab]-cab, [abc, cba]-cba, [acb|...]-abc, [...|...]-acb, ... - ...|...],
SWV = '123456123456123456123456123456123456' .


?-  C = [ [acb,bca,cab], [bac,cab,bca], [bca,cab,bca], [cab,bca,cab] ],
nm_domain( 3, 3, [a,b,c], [1,2,3], L, K, U ), subtract( U, C, D ), map_axiom_swf( L, D, SWF ), show_values( L, SWF, N, SWV ), nl, write( N: SWV ), fail.

212:12345612345612345612345612345612345612345612345612345612346123456123456123456123456123456123456123561234561234561234561234561234561235612345612345612345612345612346123456123456123456123456123456123456123456123456
212:11111122222233333344444455555566666611111122222233333344444555555666666111111222222333333444444555556666661111112222223333334444445555566666611111122222233333344444555555666666111111222222333333444444555555666666
212:11111111111111111111111111111111111122222222222222222222222222222222222333333333333333333333333333333333334444444444444444444444444444444444455555555555555555555555555555555555666666666666666666666666666666666666
false.

?- L is 6^2, A = [a,b,c], S = [1,2], test_case( L, A, S, D ).
123456123456123456123456123456123456;36;dict(2)
111111222222333333444444555555666666;36;dict(1)
A = [a, b, c],
L = 36,
S = [1, 2]

?- L is 6^3, A = [a,b,c], S = [1,2,3], test_case( L, A, S, D ).

123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456123456;216;dict(3)
111111222222333333444444555555666666111111222222333333444444555555666666111111222222333333444444555555666666111111222222333333444444555555666666111111222222333333444444555555666666111111222222333333444444555555666666;216;dict(2)
111111111111111111111111111111111111222222222222222222222222222222222222333333333333333333333333333333333333444444444444444444444444444444444444555555555555555555555555555555555555666666666666666666666666666666666666;216;dict(1)
A = [a, b, c],
L = 216,
S = [1, 2, 3]
2.069 seconds cpu time


?- L is 6^2 - 2, A = [a,b,c], S = [1,2], test_case( L, A, S, poss ).

1215522255533466464466555555666666;34;poss
1215522255512345654456555555556656;34;poss
1215522255512345612345622255522656;34;poss
1134422656333444444444556656666666;34;poss
1134412345633344444444454456464466;34;poss
1134412345633344433344412345633466;34;poss
1234562265633466464466556656666666;34;poss
1234562265612345654456556656556656;34;poss
1133131233211331311344123456123456;34;poss
1133131233233333344444454456464466;34;poss
1133131233233333333344412345633466;34;poss
1234561234563346646446654456464466;34;poss
1211222222221233254456555555556656;34;poss
1211221211221233212345612155123456;34;poss
1211222222221233212345622255522656;34;poss
1111111211221133131134412155123456;34;poss
1111112222221133131134422255522656;34;poss
1111111211223333333334441215533466;34;poss
A = [a, b, c],
L = 34,
S = [1, 2]
8.097 seconds cpu time

*/

implied_decisiveness( D, L, P, ( X, Y ) -> ( Z, W ) ):-
	 member( P, D ),
	 map_axiom_swf( L, [ P ], [ P - S ] ),
	 preference( X, Y, S ),
	 preference( Z, W, S ),
	 ( X, Y ) \= ( Z, W ),
	 \+ unanimous_pp( Z, W, P ),
	 \+ \+ (
		 map_axiom_swf( L, [ P ], [ P - T ] ),
		 preference( X, Y, T ),
		 preference( Z, W, T )
	 ),
	 \+ (
		 map_axiom_swf( L, [ P ], [ P - T ] ),
		 preference( X, Y, T ),
		 preference( W, Z, T )
	 ).

implied_decisiveness_profiles( D, L, X, H ):-
	 setof( P, implied_decisiveness( D, L, P, X ), H ).



/*

?- base_case( A, I, L, K, D ), hist( implied_decisiveness( D, L, P, X ),  X ), fail.

 [(a,b->a,c),2]
 [(a,b->c,b),2]
 [(a,c->a,b),2]
 [(a,c->b,c),2]
 [(b,a->b,c),2]
 [(b,a->c,a),2]
 [(b,c->a,c),2]
 [(b,c->b,a),2]
 [(c,a->b,a),2]
 [(c,a->c,b),2]
 [(c,b->a,b),2]
 [(c,b->c,a),2]
total:24
false.

*/

% chain_of_implied_decisiveness

di_chain( _, _, (X,Y), P, A, B, [ P | A ], [ (X,Y) | B ] ).
di_chain( D, L, (X,Y), P, A, B, G, H ):-
	 implied_decisiveness( D, L, P, ( Z, W ) -> ( X, Y ) ),
	 \+ member( ( Z, W ), B ), 
	 member( Q, D ),
	 \+ reversal_xy( P -> Q, (Z, W), _ ),
	 di_chain( D, L, (Z,W), Q, [ P | A ], [ (X,Y) | B ], G, H ).

di_chain( D, L, B, P, G, H ):-
	 member( P, D ),
	 di_chain( D, L, B, P, [ ], [ ], G, H ).

di_cycle( D, L, B, P, G, H ):-
	 di_chain( D, L, B, P, G, H ),
	 G = [ Q | _ ],
	 H = [ C | _ ],
	 \+ reversal_xy( P -> Q, B, _ ),
	 implied_decisiveness( D, L, Q, B -> C ).

test_chain( B, N, L, P, G, H ):-
	 base_case( _, _, L, _, D ), 
	% nm_domain( 2, 3, _, _, L, _, D ),
	 di_chain( D, L, B, P, G, H ),
	 length( H, N ).

test_cycle( B, N, L, P, G, H ):-
	 base_case( _, _, L, _, D ), 
	 di_cycle( D, L, B, P, G, H ),
	 length( H, N ).


test_chain_nm( N, M, B, K, L, P, G, H ):-
	 nm_domain( N, M, _, _, L, _, D ),
	 di_chain( D, L, B, P, G, H ),
	 length( H, K ).

test_cycle_nm( N, M, B, K, L, P, G, H ):-
	 nm_domain( N, M, _, _, L, _, D ),
	 di_cycle( D, L, B, P, G, H ),
	 length( H, K ).

/*

?- test_nm_cycle( 2,3, L, ( a, b ), 6, P, G, H ), show_domain( L, G ).
        [1,2,3,4,5,6];
1:abc   [-,-,-,1,-,-];
2:acb   [-,-,6,-,-,-];
3:bac   [-,-,-,-,-,2];
4:bca   [-,-,-,-,3,-];
5:cab   [5,-,-,-,-,-];
6:cba   [-,4,-,-,-,-];
L = [abc, acb, bac, bca, cab, cba],
P = [acb, bac],
G = [[abc, bca], [bac, cba], [bca, cab], [cba, acb], [cab, abc], [acb, bac]],
H = [(a, c), (b, c), (b, a), (c, a), (c, b), (a, b)] .

?- test_chain(  (a, b ), 6, L, P, G, H ), show_domain( L, G ).
        [1,2,3,4,5,6];
1:abc   [-,-,-,1,-,-];
2:acb   [-,-,6,-,-,-];
3:bac   [-,-,-,-,-,2];
4:bca   [-,-,-,-,3,-];
5:cab   [5,-,-,-,-,-];
6:cba   [-,4,-,-,-,-];
L = [abc, acb, bac, bca, cab, cba],
P = [acb, bac],
G = [[abc, bca], [bac, cba], [bca, cab], [cba, acb], [cab, abc], [acb, bac]],
H = [(a, c), (b, c), (b, a), (c, a), (c, b), (a, b)] .


?- hist((base_case( A, I, L, K, D ), member(P, D ), di_chain( D, L, (a,b), P, G, H), length( G, N ), N>5), P:N;H ).

 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)]):9
 ([acb,cba]:6;[(c,b),(c,a),(b,a),(b,c),(a,c),(a,b)]):9
 ([bac,acb]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)]):9
 ([cba,acb]:6;[(c,b),(c,a),(b,a),(b,c),(a,c),(a,b)]):9
total:36
true.


?- hist((base_case( A, I, L, K, D ), member(P, D ), di_chain( D, L, (a,b), P, G, H), length( G, N ), N>5, P=[acb,bac]), P:N;H;G ).

 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[abc,bca],[bac,cba],[bca,cab],[cba,acb],[cab,abc],[acb,bac]]):1
 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[abc,cab],[bac,cba],[bca,cab],[cba,acb],[cab,abc],[acb,bac]]):1
 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[abc,cba],[bac,cba],[bca,cab],[cba,acb],[cab,abc],[acb,bac]]):1
 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[acb,bca],[bac,cba],[bca,cab],[cba,acb],[cab,abc],[acb,bac]]):1
 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[acb,cab],[bac,cba],[bca,cab],[cba,acb],[cab,abc],[acb,bac]]):1
 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[acb,cba],[bac,cba],[bca,cab],[cba,acb],[cab,abc],[acb,bac]]):1
 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[bac,bca],[bac,cba],[bca,cab],[cba,acb],[cab,abc],[acb,bac]]):1
 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[bac,cab],[bac,cba],[bca,cab],[cba,acb],[cab,abc],[acb,bac]]):1
 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[bac,cba],[bac,cba],[bca,cab],[cba,acb],[cab,abc],[acb,bac]]):1
total:9
true.

?- hist((base_case( A, I, L, K, D ), member(P, D ), di_cycle( D, L, (a,b), P, H, G), length( G, N ), P=[acb,bac]), P:N;G;H ).

 ([acb,bac]:2;[(c,b),(a,b)];[[cab,bca],[acb,bac]]):1
 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[abc,bca],[bac,cba],[bca,cab],[cba,acb],[cab,abc],[acb,bac]]):1
total:2
true.
?- 

?- hist((base_case( A, I, L, K, D ), member(P, D ), di_cycle( D, L, (a,b), P, H, G), length( G, N )), P:N;G;H ).

 ([acb,bac]:2;[(c,b),(a,b)];[[cab,bca],[acb,bac]]):1
 ([acb,bac]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[abc,bca],[bac,cba],[bca,cab],[cba,acb],[cab,abc],[acb,bac]]):1
 ([acb,cba]:2;[(a,c),(a,b)];[[abc,bca],[acb,cba]]):1
 ([acb,cba]:6;[(c,b),(c,a),(b,a),(b,c),(a,c),(a,b)];[[cab,bca],[cba,bac],[bca,abc],[bac,acb],[abc,cab],[acb,cba]]):1
 ([bac,acb]:2;[(c,b),(a,b)];[[bca,cab],[bac,acb]]):1
 ([bac,acb]:6;[(a,c),(b,c),(b,a),(c,a),(c,b),(a,b)];[[bca,abc],[cba,bac],[cab,bca],[acb,cba],[abc,cab],[bac,acb]]):1
 ([cba,acb]:2;[(a,c),(a,b)];[[bca,abc],[cba,acb]]):1
 ([cba,acb]:6;[(c,b),(c,a),(b,a),(b,c),(a,c),(a,b)];[[bca,cab],[bac,cba],[abc,bca],[acb,bac],[cab,abc],[cba,acb]]):1
total:8
true.



?- time((test_chain_nm( 2,4, (a, b ), K, L, P, G, H ), K>5)), show_domain( L, G ).
% 428,738,943 inferences, 26.750 CPU in 26.847 seconds (100% CPU, 16027624 Lips)
        [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24];
1:abcd  [-,1,-,-,2,-,-,-,-,5,-,-,4,-,-,-,-,-,-,-,-,-,-,-];
2:abdc  [-,-,-,-,-,3,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
3:acbd  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
4:acdb  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,6,-,-,-,-,-,-];
5:adbc  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
6:adcb  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
7:bacd  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
8:badc  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
9:bcad  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
10:bcda [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
11:bdac [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
12:bdca [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
13:cabd [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
14:cadb [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
15:cbad [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
16:cbda [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
17:cdab [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
18:cdba [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
19:dabc [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
20:dacb [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
21:dbac [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
22:dbca [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
23:dcab [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
24:dcba [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
K = 6,
L = [abcd, abdc, acbd, acdb, adbc, adcb, bacd, badc, bcad|...],
P = [acdb, cdba],
G = [[abcd, abdc], [abcd, adbc], [abdc, adcb], [abcd, cabd], [abcd, bcda], [acdb, cdba]],
H = [(c, d), (b, d), (b, c), (a, c), (a, d), (a, b)] .
?- 

?- time((test_chain_nm( 2,4, (a, b ), K, L, P, G, H ), K>4)), show_domain( L, G ).
% 18,155,292 inferences, 1.375 CPU in 1.409 seconds (98% CPU, 13203849 Lips)
        [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24];
1:abcd  [-,1,-,-,2,-,-,-,-,-,-,-,4,-,-,-,-,-,-,-,-,-,-,-];
2:abdc  [-,-,-,-,-,3,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
3:acbd  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,5,-,-,-,-,-,-,-,-,-];
4:acdb  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
5:adbc  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
6:adcb  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
7:bacd  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
8:badc  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
9:bcad  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
10:bcda [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
11:bdac [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
12:bdca [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
13:cabd [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
14:cadb [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
15:cbad [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
16:cbda [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
17:cdab [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
18:cdba [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
19:dabc [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
20:dacb [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
21:dbac [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
22:dbca [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
23:dcab [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
24:dcba [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
K = 5,
L = [abcd, abdc, acbd, acdb, adbc, adcb, bacd, badc, bcad|...],
P = [acbd, cbad],
G = [[abcd, abdc], [abcd, adbc], [abdc, adcb], [abcd, cabd], [acbd, cbad]],
H = [(c, d), (b, d), (b, c), (a, c), (a, b)] .


?- time((test_chain_nm( 2,4, (a, b ), K, L, P, G, H ), K>5)), show_domain( L, G ).
% 428,738,943 inferences, 27.531 CPU in 28.459 seconds (97% CPU, 15572811 Lips)
        [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24];
1:abcd  [-,1,-,-,2,-,-,-,-,5,-,-,4,-,-,-,-,-,-,-,-,-,-,-];
2:abdc  [-,-,-,-,-,3,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
3:acbd  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
4:acdb  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,6,-,-,-,-,-,-];
5:adbc  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
6:adcb  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
7:bacd  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
8:badc  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
9:bcad  [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
10:bcda [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
11:bdac [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
12:bdca [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
13:cabd [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
14:cadb [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
15:cbad [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
16:cbda [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
17:cdab [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
18:cdba [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
19:dabc [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
20:dacb [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
21:dbac [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
22:dbca [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
23:dcab [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
24:dcba [-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-];
K = 6,
L = [abcd, abdc, acbd, acdb, adbc, adcb, bacd, badc, bcad|...],
P = [acdb, cdba],
G = [[abcd, abdc], [abcd, adbc], [abdc, adcb], [abcd, cabd], [abcd, bcda], [acdb, cdba]],
H = [(c, d), (b, d), (b, c), (a, c), (a, d), (a, b)] .

?- 

?- time((test_chain_nm( 2,4, (a, b ), K, L, P, G, H ), K>5)), show_domain( L, G ).
...so long

?- time((test_chain_nm( 3,3, (a, b ), K, L, P, G, H ), K>5)), \+ ( member( X, [[ A,B,_], [A,_,B], [_,A,B]] ), findall( [A,B], member( X, G ), D ), \+ show_domain( L, D ) ).
% 392,109 inferences, 0.047 CPU in 0.043 seconds (109% CPU, 8364992 Lips)
        [1,2,3,4,5,6];
1:abc   [-,6,-,-,5,-];
2:acb   [-,-,-,-,-,4];
3:bac   [-,-,-,-,-,-];
4:bca   [1,-,-,-,-,-];
5:cab   [-,-,-,3,-,-];
6:cba   [-,-,2,-,-,-];
        [1,2,3,4,5,6];
1:abc   [5,-,6,-,-,-];
2:acb   [-,4,-,-,-,-];
3:bac   [-,-,-,-,-,-];
4:bca   [-,-,-,1,-,-];
5:cab   [-,-,-,-,3,-];
6:cba   [-,-,-,-,-,2];
        [1,2,3,4,5,6];
1:abc   [-,-,-,1,-,-];
2:acb   [-,-,6,-,-,-];
3:bac   [-,-,-,-,-,2];
4:bca   [-,-,-,-,3,-];
5:cab   [5,-,-,-,-,-];
6:cba   [-,4,-,-,-,-];
K = 6,
L = [abc, acb, bac, bca, cab, cba],
P = [abc, acb, bac],
G = [[bca, abc, bca], [cba, bac, cba], [cab, bca, cab], [acb, cba, acb], [abc, cab, abc], [abc, acb, bac]],
H = [(a, c), (b, c), (b, a), (c, a), (c, b), (a, b)] .


?- time((test_chain_nm( 3,3, (a, b ), K, L, P, G, H ), K>5)),  map_axiom_swf( L, G, SWF ), ( dictatorship( Domain, SWF, Dict )-> true ; Dict = poss ).
% 392,109 inferences, 0.031 CPU in 0.044 seconds (72% CPU, 12547488 Lips)
K = 6,
L = [abc, acb, bac, bca, cab, cba],
P = [abc, acb, bac],
G = Domain, Domain = [[bca, abc, bca], [cba, bac, cba], [cab, bca, cab], [acb, cba, acb], [abc, cab, abc], [abc, acb, bac]],
H = [(a, c), (b, c), (b, a), (c, a), (c, b), (a, b)],
SWF = [[bca, abc, bca]-bca, [cba, bac, cba]-cba, [cab, bca, cab]-cab, [acb, cba, acb]-acb, [abc, cab, abc]-abc, [abc, acb|...]-abc],
Dict = dict(1) ;
K = 6,
L = [abc, acb, bac, bca, cab, cba],
P = [abc, acb, bac],
G = [[bca, abc, bca], [cba, bac, cba], [cab, bca, cab], [acb, cba, acb], [abc, cab, abc], [abc, acb, bac]],
H = [(a, c), (b, c), (b, a), (c, a), (c, b), (a, b)],
SWF = [[bca, abc, bca]-bca, [cba, bac, cba]-cba, [cab, bca, cab]-cab, [acb, cba, acb]-acb, [abc, cab, abc]-acb, [abc, acb|...]-acb],
Dict = poss ;
K = 6,
L = [abc, acb, bac, bca, cab, cba],
P = [abc, acb, bac],
G = [[bca, abc, bca], [cba, bac, cba], [cab, bca, cab], [acb, cba, acb], [abc, cab, abc], [abc, acb, bac]],
H = [(a, c), (b, c), (b, a), (c, a), (c, b), (a, b)],
SWF = [[bca, abc, bca]-bca, [cba, bac, cba]-cba, [cab, bca, cab]-cab, [acb, cba, acb]-cab, [abc, cab, abc]-cab, [abc, acb|...]-acb],
Dict = poss ;
K = 6,
L = [abc, acb, bac, bca, cab, cba],
P = [abc, acb, bac],
G = Domain, Domain = [[bca, abc, bca], [cba, bac, cba], [cab, bca, cab], [acb, cba, acb], [abc, cab, abc], [abc, acb, bac]],
H = [(a, c), (b, c), (b, a), (c, a), (c, b), (a, b)],
SWF = [[bca, abc, bca]-abc, [cba, bac, cba]-bac, [cab, bca, cab]-bca, [acb, cba, acb]-cba, [abc, cab, abc]-cab, [abc, acb|...]-acb],
Dict = dict(2) .

?- time((test_chain_nm( 3,3, (a, b ), K, L, P, G, H ), K>5,  map_axiom_swf( L, G, SWF ), ( dictatorship( Domain, SWF, Dict )-> true ; Dict = poss ), Dict= poss )).
% 402,848 inferences, 0.031 CPU in 0.046 seconds (67% CPU, 12891136 Lips)
K = 6,
L = [abc, acb, bac, bca, cab, cba],
P = [abc, acb, bac],
G = [[bca, abc, bca], [cba, bac, cba], [cab, bca, cab], [acb, cba, acb], [abc, cab, abc], [abc, acb, bac]],
H = [(a, c), (b, c), (b, a), (c, a), (c, b), (a, b)],
SWF = [[bca, abc, bca]-bca, [cba, bac, cba]-cba, [cab, bca, cab]-cab, [acb, cba, acb]-acb, [abc, cab, abc]-acb, [abc, acb|...]-acb],
Dict = poss .


*/

/*

% a concise version

chain( _, _, X, P, A, B, [ P | A ], [ X | B ] ). 
chain( D, L, X, P, A, B, G, H ):-
	 implied_relation( D, L, P, Z -> X ),
	 \+ member( Z, B ), member( Q, D ),
	 \+ reversal( P -> Q, Z, _ ),
	 chain( D, L, Z, Q, [ P | A ], [ X | B ], G, H ).

d_chain( D, L, B, P, G, H ):-
	 member( P, D ),
	 chain( D, L, B, P, [ ], [ ], G, H ).

d_cycle( D, L, B, P, G, H ):-
	 d_chain( D, L, B, P, G, H ),
	 G = [ Q | _ ], H = [ C | _ ],
	 \+ reversal( P -> Q, B, _ ),
	 implied_relation( D, L, Q, B -> C ).

*/

%:- use_rendering( graphviz ). 

paren_profile( P, S ):-
	 atomic_list_concat( P, ',', R ),  
	 atomic_list_concat( [ '(', R, ')' ], S ).

edge_make( P, (X, Y), (Z, W), E ):- 
	 paren_profile( P, S ),
	 atom_concat( X, Y, U ),  
	 atom_concat( Z, W, V ),  
	 E = edge( U -> V, [ label = S ] ).


di_graph( _, _, (X,Y), P, A, B, C, [P|A], [ (X,Y) | B ], C ).
di_graph( D, L, (X,Y), P, A, B, C, G, H, S ):-
	 implied_decisiveness( D, L, P, ( Z, W ) -> ( X, Y ) ),
	 \+ member( ( Z, W ), B ), 
	 member( Q, D ),
	 \+ reversal_xy( P -> Q, (Z, W), _ ),
	 edge_make( P, (Z, W), (X, Y), E ),
	 di_graph( D, L, (Z,W), Q, [ P | A ], [ (X,Y) | B ], [ E | C ], G, H, S ).


di_graph( D, L, B, P, G, H, C ):-
	 member( P, D ),
	 di_graph( D, L, B, P, [], [ ], [ ], G, H, C ).

di_cycle_graph( D, L, B, P, G, H, [E|C] ):-
	 member( P, D ),
	 di_graph( D, L, B, P, G, H, C ),
	 G = [ Q | _ ],
	 H = [ X | _ ],
	 \+ reversal_xy( P -> Q, B, _ ),
	 implied_decisiveness( D, L, Q, B -> X ),
	 edge_make( P, B, X, E ).

test_graph( B, N, P, G, H, L, Graph ):-
	 nm_domain( 2, 3, _, _, L, _, D ),
	 di_cycle_graph( D, L, B, P, G, H, C ),
	 length( H, N ),
	 Graph=digraph( [ rankdir = 'LR' | C ] ).

/*

?- test_graph( ( a, b ), N, P, G, H, L, GR ), N>5.


?- nm_domain( 2, 3, A, I, L, K, D ), di_graph( D, L, (a,b), P, G, H ), length( H, 6 ), nl, write( H ).

[(b,a), (b,c), (b,a), (c,a), (c,b), (a,b)]
A = [a, b, c],
D = [[abc, abc], [abc, acb], [abc, bac], [abc, bca], [abc, cab], [abc, cba], [acb, abc], [acb, acb], [acb, bac], [acb, bca], [acb, cab], [acb, cba], [bac, abc], [bac, acb], [bac, bac], [bac, bca], [bac, cab], [bac, cba], [bca, abc], [bca, acb], [bca, bac], [bca, bca], [bca, cab], [bca, cba], [cab, abc], [cab, acb], [cab, bac], [cab, bca], [cab, cab], [cab, cba], [cba, abc], [cba, acb], [cba, bac], [cba, bca], [cba, cab], [cba, cba]],
G = [edge((ba->bc),[label = '(bac,acb)']), edge((bc->ba),[label = '(bca,cab)']), edge((ba->ca),[label = '(cba,acb)']), edge((ca->cb),[label = '(cab,abc)']), edge((cb->ab),[label = '(acb,bac)'])],
H = [(b,a), (b,c), (b,a), (c,a), (c,b), (a,b)],
I = [1, 2],
K = 36,
L = [abc, acb, bac, bca, cab, cba],
P = [acb, bac]

?- test_graph( ( a, b ), N, P, G, L,H ), G= [(a,b)|_].

debug

?- base_case( A, I, L, K, D ), !, hist( (di_graph( D, L, (a,b), P, H, G), length( H,1 )), G:H:P ).

 ([(a,c),(a,b)]:[edge((ac->ab),[label=(acb,cba)])]:[acb,cba]):9
 ([(a,c),(a,b)]:[edge((ac->ab),[label=(cba,acb)])]:[cba,acb]):9
 ([(c,b),(a,b)]:[edge((cb->ab),[label=(acb,bac)])]:[acb,bac]):9
 ([(c,b),(a,b)]:[edge((cb->ab),[label=(bac,acb)])]:[bac,acb]):9
total:36
A = [a, b, c],
I = [1, 2],
L = [abc, acb, bac, bca, cab, cba],
K = 36,
D = [[abc, abc], [abc, acb], [abc, bac], [abc, bca], [abc, cab], [abc, cba], [acb, abc], [acb|...], [...|...]|...].

?- base_case( A, I, L, K, D ), !, hist( (di_chain( D, L, (a,b), P, H, G), length( H,1 )), G:H:P ).

 ([(a,c),(a,b)]:[[acb,cba]]:[acb,cba]):9
 ([(a,c),(a,b)]:[[cba,acb]]:[cba,acb]):9
 ([(c,b),(a,b)]:[[acb,bac]]:[acb,bac]):9
 ([(c,b),(a,b)]:[[bac,acb]]:[bac,acb]):9
total:36
A = [a, b, c],
I = [1, 2],
L = [abc, acb, bac, bca, cab, cba],
K = 36,
D = [[abc, abc], [abc, acb], [abc, bac], [abc, bca], [abc, cab], [abc, cba], [acb, abc], [acb|...], [...|...]|...].

?- hist((base_case( A, I, L, K, D ), di_chain( D, L, (a,b), P, H, G), length( H,1 )), G:H:P ).

 ([(a,c),(a,b)]:[[acb,cba]]:[acb,cba]):9
 ([(a,c),(a,b)]:[[cba,acb]]:[cba,acb]):9
 ([(c,b),(a,b)]:[[acb,bac]]:[acb,bac]):9
 ([(c,b),(a,b)]:[[bac,acb]]:[bac,acb]):9
total:36
true.

?- hist((base_case( A, I, L, K, D ), di_chain( D, L, (a,b), P, H, G), length( H,2 ), G=[(a,c),(a,b)]), P ).

 [acb,cba]:9
 [cba,acb]:9
total:18
true.

?- hist((base_case( A, I, L, K, D ), di_chain( D, L, (a,b), P, H, G), length( H,2 ), G=[(a,c),(a,b)]), H ).

 [[abc,bca],[acb,cba]]:1
 [[abc,cab],[acb,cba]]:1
 [[abc,cba],[acb,cba]]:1
 [[acb,bca],[acb,cba]]:1
 [[acb,cab],[acb,cba]]:1
 [[acb,cba],[acb,cba]]:1
 [[bac,bca],[acb,cba]]:1
 [[bac,cab],[acb,cba]]:1
 [[bac,cba],[acb,cba]]:1
 [[bca,abc],[cba,acb]]:1
 [[bca,acb],[cba,acb]]:1
 [[bca,bac],[cba,acb]]:1
 [[cab,abc],[cba,acb]]:1
 [[cab,acb],[cba,acb]]:1
 [[cab,bac],[cba,acb]]:1
 [[cba,abc],[cba,acb]]:1
 [[cba,acb],[cba,acb]]:1
 [[cba,bac],[cba,acb]]:1
total:18
true.

*/


% complementary projection
%--------------------------------------------------
complementary_map( [], [], [] ).
complementary_map( [1|Y], [_|B], C ):-
	 complementary_map( Y, B, C ).
complementary_map( [0|Y], [A|B], [A|C] ):-
	 complementary_map( Y, B, C ).

% サブリストを指標関数で抽出
list_projection_n( [ ], [ ], [ ], N, N ).
list_projection_n( [ 0 | A ], [ _ | Y ], Z, K, N ) :-
	number( N ), K > N, !,
	list_projection_n( A, Y, Z, K, N ).
list_projection_n( [ 1 | A ], [ X | Y ], [ X | Z ], K, N ) :-
	number( N ), K < N,
	K1 is K + 1,
	list_projection_n( A, Y, Z, K1, N ).
list_projection_n( [ 0 | A ], [ _ | Y ], Z, K, N ) :-
	number( N ), 
	list_projection_n( A, Y, Z, K, N ).
list_projection_n( [ 0 | A ], [ _ | Y ], Z, K, N ) :-
	var( N ), 
	list_projection_n( A, Y, Z, K, N ).
list_projection_n( [ 1 | A ], [ X | Y ], [ X | Z ], K, N ) :-
	var( N ), 
	K1 is K + 1,
	list_projection_n( A, Y, Z, K1, N ).


% 任意長のサブリストを抽出

select_n( A, B, K ):-
	 number( K ),
	 length( B, N ),
	 K > N / 2,
	 !,
	 M is N - K,
	 list_projection_n( X, B, _, 0, M ),
	 complementary_map( X, B, A ).
%	 subtract( B, C, A ).

select_n( A, B, K ):-
	 list_projection_n( _, B, A, 0, K ).


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


