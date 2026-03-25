% arrow2019.pl
% n-person version of icaart2014.pl( 30 Dec 2013 )
% 4-6 Jun 2019 extremal lemma
% 18-27, 31 Dec 2019 revised
% 18-23 Jun 2024
% 19 Jul 2024
% 5-6 Aug 2024

% 6-25 Nov 2025 (arrow2024x.pl)
% 29 Nov - 7 Dec 2025 (arrow2024x-29Nov.pl)

% Kenryo Indo( kenryo.indo@gmail.com )
%-----------------------------------------------------------------

n_list( N, L ):-
	 findall( I, between( 1, N, I ), L ).

social_ranking( A, S ):-
	 top_rank( A, S ).

top_rank( A, [ A | _ ] ).

condorcet_adjacent_ranking( [ A | R ], Q ):-
	 append( R, [ A ], Q ).


extremal_lemma( B, R, S ):-
	 all_voters_rank_b_as_top_or_bottom( B, R ),
	 social_ranking_should_rank_b_as_top_or_bottom( B, S ).


:- dynamic user_alternatives/1.

alternatives( A ):- 
	 clause( user_alternatives( A ), _ ),
	 !.
alternatives( _ ):- 
	 writeln( 'no alternatives/1. (use chalt/1 to define.)' ).

chalt( B ):-
	 clause( user_alternatives( B ), _ ),
	 !.
chalt( B ):-
	 abolish( user_alternatives/ 1 ),
	 assert( user_alternatives( B ) ).


:- dynamic user_persons/1.

persons( A ):- 
	 clause( user_persons( A ), _ ),
	 !.
persons( _ ):- 
	 writeln( 'no persons/1. (use chpers/1 to define.)' ).

chpers( B ):-
	 clause( user_persons( B ), _ ),
	 !.
chpers( B ):-
	 abolish( user_persons/ 1 ),
	 assert( user_persons( B ) ).

n_person( N ):-
	persons( I ),
	length( I, N ).

% added: 13 Nov 2024

person( I ):-
	persons( N ),
	member( I, N ).


:- chalt([a,b,c]), chpers([ 1,2] ). 

/* rankings and profiles */

ranking( R ):-
	alternatives( A ),
	ranking( A, R ).

/*
	 Ra = [ a, b, c ],
	 Rb = [ b, c, a ],
	 Rc = [ c, a, b ],
	 R1a = [ c, b, a ],
	 R1b = [ a, c, b ],
	 R1c = [ b, a, c ],
	 R = [ Ra, Rb, Rc, R1a, R1b, R1c ].
*/


/*

?- chpers( [a,b]).
true.

?- chalt([1,2,4]).
true.

?- pp(A).
A = [[1, 2, 4], [1, 2, 4]] ;
A = [[1, 2, 4], [1, 4, 2]] ;
A = [[1, 2, 4], [2, 1, 4]] .

?- 
*/

ranking( P, B ):-
	 permutation( B, P ).


% use maplist instead

ranking_profile( _, [ ] ).
ranking_profile( B, [ R | P ] ):-
	 ranking( R, B ),
	 ranking_profile( B, P ).

/*

?- hist1n( ( between( 1, 8, J ), length( P, J ), ranking_profile( [ a, b, c ], P ) ), J ).

 [ 1, 6 ]
 [ 2, 36 ]
 [ 3, 216 ]
 [ 4, 1296 ]
 [ 5, 7776 ]
 [ 6, 46656 ]
 [ 7, 279936 ]
 [ 8, 1679616 ]
total:2015538
true.

*/


extremal_ranking( X, Alts, [ X | R ] ):-
	 ranking( [ X | R ], Alts ).

extremal_ranking( X, Alts, [ Y | R ] ):-
	 ranking( [ Y | R ], Alts ),
	 X \= Y,
	 last( R, X ).

/*

?- extremal_ranking( b, [ a, b, c ], R ).
R = [ b, a, c ] ;
R = [ b, c, a ] ;
R = [ a, c, b ] ;
R = [ c, a, b ] ;
false.

*/


all_extremal_rankings( X, B, U ):-
	 G = extremal_ranking( X, B, P ),
	 findall( P, G, U ).

extremal_profile( _, _, [ ] ).
extremal_profile( X, B, [ R | P ] ):-
	 extremal_ranking( X, B, R ),
	 extremal_profile( X, B, P ).

all_extremal_profiles( N, X, Alts, D ):-
	 length( P, N ),
	 G = extremal_profile( X, Alts, P ),
	 findall( P, G, D ).

all_extremal_profiles( N, D ):-
	 X = b,
	 Alts = [ a, b, c ],
	 all_extremal_profiles( N, X, Alts, D ).

/*

?- length( P, 3 ), extremal_profile( b, [ a, b, c ], P ).
P = [ [ b, a, c ], [ b, a, c ], [ b, a, c ] ] ;
P = [ [ b, a, c ], [ b, a, c ], [ b, c, a ] ] ;
P = [ [ b, a, c ], [ b, a, c ], [ a, c, b ] ] .

?- all_extremal_profiles( 2, b, [ a, b, c ], D ), nth1( J, D, P ), nl, write( J; P ), fail.

1;[ [ b, a, c ], [ b, a, c ] ]
2;[ [ b, a, c ], [ b, c, a ] ]
3;[ [ b, a, c ], [ a, c, b ] ]
4;[ [ b, a, c ], [ c, a, b ] ]
5;[ [ b, c, a ], [ b, a, c ] ]
6;[ [ b, c, a ], [ b, c, a ] ]
7;[ [ b, c, a ], [ a, c, b ] ]
8;[ [ b, c, a ], [ c, a, b ] ]
9;[ [ a, c, b ], [ b, a, c ] ]
10;[ [ a, c, b ], [ b, c, a ] ]
11;[ [ a, c, b ], [ a, c, b ] ]
12;[ [ a, c, b ], [ c, a, b ] ]
13;[ [ c, a, b ], [ b, a, c ] ]
14;[ [ c, a, b ], [ b, c, a ] ]
15;[ [ c, a, b ], [ a, c, b ] ]
16;[ [ c, a, b ], [ c, a, b ] ]
false.

*/


/*

using icaart2014.pl

?- m1(A),f( F, A, swf_axiom), fig(swf, F ), fail.

          123456
1:[a,c,b] ----5-
2:[a,b,c] -----6
3:[b,a,c] 1-----
4:[b,c,a] -2----
5:[c,b,a] --3---
6:[c,a,b] ---4--
--
          123456
1:[a,c,b] ----1-
2:[a,b,c] -----2
3:[b,a,c] 3-----
4:[b,c,a] -4----
5:[c,b,a] --5---
6:[c,a,b] ---6--
--
false.

*/


%-----------------------------------------------------------------
% social choice theory : a generalization of the program in icaart2014
%-----------------------------------------------------------------
% eliminating super-Arrovean profiles by using Prolog
% Windows 7 OS SWI-Prolog version 6.4.1 ( and 5.6.52 )
% based on iccart2014.pl ( Sep 2010 - 30 Dec 2013 )
% URL: http://www.xkindo.net/sclp/pl/icaart2014.pl

% modified: 19 Jun 2024

x( X ):- 
	 alternatives( A ),
	 member( X, A ).

rc0( 1, [ a, c, b ] ).
rc0( 2, [ a, b, c ] ).
rc0( 3, [ b, a, c ] ).
rc0( 4, [ b, c, a ] ).
rc0( 5, [ c, b, a ] ).
rc0( 6, [ c, a, b ] ).

rc0rc( 1, [A,B,C], [ A, C, B ] ).
rc0rc( 2, [A,C,B], [ A, B, C ] ).
rc0rc( 3, [B,A,C], [ B, A, C ] ).
rc0rc( 4, [B,C,A], [ B, C, A ] ).
rc0rc( 5, [C,A,B], [ C, B, A ] ).
rc0rc( 6, [C,B,A], [ C, A, B ] ).


rc( J, R ):-
	alternatives( A ),
	findall( P, permutation( A, P ), L ),
	nth1( J, L, R ).

/*
?- permutation( [ a, b, c ], R ).
R = [ a, b, c ] ;
R = [ a, c, b ] ;
R = [ b, a, c ] ;
R = [ b, c, a ] ;
R = [ c, a, b ] ;
R = [ c, b, a ] ;
false.
*/

rc0id_to_rcid( R, I, J ):-
	rc0( I, R ),
	rc( J, R ).

pp_from_rc0_numbered( PP0_ids, PP_ids ):-
	findall( Y, (
		 member( X, PP0_ids ),
		 rc0id_to_rcid( _, X, Y )
	), PP_ids ).

domain_from_numbered_rc0( D0, D ):-
	findall( PP, (
		 member( PP0, D0 ),
		 pp_from_rc0_numbered( PP0, PP )
	), D ).

/*

?- chalt([a,b,c]).
true.

?- chpers([1,2]).
true.

?- scf_dict( ring_1, I ),domain_from_numbered_rc0( I, D ).
I = [[1, 4], [1, 6], [3, 2], [3, 6], [5, 2], [5, 4]],
D = [[2, 4], [2, 5], [3, 1], [3, 5], [6, 1], [6, 4]].

*/



r( [ X, Y ], R ):-
	 ranking( R ),
	 append( _, [ X | Z ], R ),
	 member( Y, [ X | Z ] ).

i( [ X, Y ], R ):-
	 r( [ X, Y ], R ),
	 r( [ Y, X ], R ).

p( [ X, Y ], R ):-
	 r( [ X, Y ], R ),
	 \+ i( [ X, Y ], R ).

/*

?- p( B, R ).
B = [ a, c ],
R = [ a, c, b ] ;
B = [ a, b ],
R = [ a, c, b ] .

?- maplist( p, [ [ a, c ], [ a, b ] ], R ).
R = [ [ a, c, b ], [ a, c, b ] ] ;
R = [ [ a, c, b ], [ a, b, c ] ] ;
R = [ [ a, c, b ], [ c, a, b ] ] ;
R = [ [ a, b, c ], [ a, c, b ] ] .

*/


p( R ):-
	 ranking( R ).

/* preference profile */

% case of n =2

% 6 Nov 2025
ppc( [  ], C, C, W, W ).
ppc( [ _ | X ], C, D, Q, W ):-
	 rc( I, R ),
	 ppc( X, [ I | C ], D, [ R | Q ], W ).
ppc( C, P ):-
	persons( N ),
	ppc( N, [ ], C, [ ], P ).

% general n-person case ( with 3-alternatives )

% modified: 15 Dec 2024; 17 Dec 2024

pp( N, Indices, P ):-
	 length( Indices, N ),
	 length( P, N ),
	 maplist( rc, Indices, P ).

pp( N, P ):-
	 between(1, 100, N ),
	 pp( N, _, P ).

pp( P ):-
	 persons( I ),
	 length( I, N ),
	 pp( N, _, P ).

all_profiles( U ):-
	 findall( R, pp( R ), U ).


/*

?- pp( 3, I, P ).
I = [ 1, 1, 1 ],
P = [ [ a, c, b ], [ a, c, b ], [ a, c, b ] ] ;
I = [ 1, 1, 2 ],
P = [ [ a, c, b ], [ a, c, b ], [ a, b, c ] ] ;
I = [ 1, 1, 3 ],
P = [ [ a, c, b ], [ a, c, b ], [ b, a, c ] ] .

?- hist1n( ( between( 1, 8, J ), pp( J, _, P ) ), J ).
 [ 1, 6 ]
 [ 2, 36 ]
 [ 3, 216 ]
 [ 4, 1296 ]
 [ 5, 7776 ]
 [ 6, 46656 ]
 [ 7, 279936 ]
 [ 8, 1679616 ]
total:2015538
true.

*/

all_profiles( N, U ):-
	 findall( R, pp( N, _, R ), U ).



%-----------------------------------------------------------------
% binary representation for profiles
%-----------------------------------------------------------------

xy_profile( [ ], _, [ ] ).

xy_profile( [ X | B ], [ X, Y ], [ R | L ] ):-
	 p( [ X, Y ], R ),
	 xy_profile( B, [ X, Y ], L ).

xy_profile( [ Y | B ], [ X, Y ], [ R | L ] ):-
	 p( [ Y, X ], R ),
	 xy_profile( B, [ X, Y ], L ).

xy_profile( [ '*' | B ], [ X, Y ], [ R | L ] ):-
	 i( [ X, Y ], R ),
	 xy_profile( B, [ X, Y ], L ).

/*

?- pp( 3, _, P ), xy_profile( S, [ a, b ], P ).
P = [ [ a, c, b ], [ a, c, b ], [ a, c, b ] ],
S = [ a, a, a ] .

*/

xy_profile_in_sign( [ ], _, [ ] ).

xy_profile_in_sign( [ + | B ], Pair, [ R | L ] ):-
	 p( Pair, R ),
	 xy_profile_in_sign( B, Pair, L ).

xy_profile_in_sign( [ - | B ], [ X, Y ], [ R | L ] ):-
	 p( [ Y, X ], R ),
	 xy_profile_in_sign( B, [ X, Y ], L ).

xy_profile_in_sign( [ 0 | B ], [ X, Y ], [ R | L ] ):-
	 i( [ Y, X ], R ),
	 xy_profile_in_sign( B, [ X, Y ], L ).


/*

?- pp( 3, _, P ), xy_profile_in_sign( S, [ a, b ], P ).
P = [ [ a, c, b ], [ a, c, b ], [ a, c, b ] ],
S = [ +, +, + ] .

*/

pair( X, Y ):-
	 x( X ),
	 x( Y ).

distinct_pair( X, Y ):-
	 pair( X, Y ),
	 X @< Y.


pp_in_sign( P, D, S ):-
%	 findall( [ X, Y ], distinct_pair( X, Y ), D ),
	 alternatives( [ A, B, C ] ),
	 D = [ [A,B], [B,C], [C,A] ],
	 findall( P, member( _, D ), L ),
	 findall( _, member( _, D ), S ),
	 maplist( xy_profile_in_sign, S, D, L ).

/*

%m1(1)-m2(1)

?- all_profiles( L ), nth1( 12, L, P ), nth1(32, L, Q ), member( X, [P, Q ]), pp_in_sign( X, B,  S), writeln( X;B:S), fail.
[[1,3,2],[3,2,1]];[[1,2],[2,3],[3,1]]:[[+,-],[-,-],[-,+]]
[[3,2,1],[1,3,2]];[[1,2],[2,3],[3,1]]:[[-,+],[-,-],[+,-]]
false.

%m2(6)-m2(2)

?- all_profiles( L ), nth1( 23, L, P ), nth1(25, L, Q ), member( X, [P, Q ]), pp_in_sign( X, B,  S), writeln( X;B:S), fail.
[[2,3,1],[3,1,2]];[[1,2],[2,3],[3,1]]:[[-,+],[+,-],[+,+]]
[[3,1,2],[1,2,3]];[[1,2],[2,3],[3,1]]:[[+,+],[-,+],[+,-]]
false.

?- 



*/

p_in_sign( P, D, S ):-
%	 findall( [ X, Y ], distinct_pair( X, Y ), D ),
	 pp_in_sign( [P], D, Y ),
	 findall( X, member( [X], Y ), S ).

/*

?- p(P), p_in_sign( P, B,  S), writeln( P:S), fail.
[1,2,3]:[+,+,-]
[1,3,2]:[+,-,-]
[2,1,3]:[-,+,-]
[3,1,2]:[+,-,+]
[2,3,1]:[-,+,+]
[3,2,1]:[-,-,+]
false.

*/

%-----------------------------------------------------------------
% super-Arrovian domain for 2-individual and 3-alternative case
%-----------------------------------------------------------------
%

/*
jv( 1, 5 ).
jv( 2, 6 ).
jv( 3, 1 ).
jv( 4, 2 ).
jv( 5, 3 ).
jv( 6, 4 ).
*/

% modified: 19 Jun 2024

jv( 2, 6 ).
jv( 1, 5 ).
jv( 3, 2 ).
jv( 4, 1 ).
jv( 6, 3 ).
jv( 5, 4 ).

%ppc( [ K, J ], [ R, Q ] ):- jv( K, J ), rc( K, R ), rc( J, Q ).

m1( C ):- % findall( P, ppc( _, P ), C ).
	 indices_of_arrow_ring( ring_1, M ), 
	 indexed_profiles( M, C ). 
m2( C ):- % findall( [ Q, P ], ppc( _, [ P, Q ] ), C ).
	 indices_of_arrow_ring( ring_2, M ), 
	 indexed_profiles( M, C ). 
m( C ):- m1( A ), m2( B ), append( A, B, C ).

/*

% 11 Nov 2025

 ?- m(A), select_n(D,A,6),  \+ swf( F, D), indexed_profiles( X, D ), fig( domain, D ), assert( tmp_arrow( X, D ) ), fail.


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  2  -  
2:[a,c,b]  -  -  -  -  -  1  
3:[b,a,c]  -  3  -  -  -  -  
4:[b,c,a]  4  -  -  -  -  -  
5:[c,a,b]  -  -  -  6  -  -  
6:[c,b,a]  -  -  5  -  -  -  
--

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  4  2  -  
2:[a,c,b]  -  -  -  -  -  1  
3:[b,a,c]  -  3  -  -  -  5  
4:[b,c,a]  -  -  -  -  6  -  
5:[c,a,b]  -  -  -  -  -  -  
6:[c,b,a]  -  -  -  -  -  -  
--

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  5  2  -  
2:[a,c,b]  -  -  4  -  -  1  
3:[b,a,c]  -  -  -  -  -  6  
4:[b,c,a]  -  -  -  -  -  -  
5:[c,a,b]  -  -  -  3  -  -  
6:[c,b,a]  -  -  -  -  -  -  
--

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  6  -  -  
2:[a,c,b]  -  -  5  -  -  1  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  -  -  -  -  -  -  
5:[c,a,b]  4  -  -  3  -  -  
6:[c,b,a]  -  -  2  -  -  -  
--

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  1  -  
2:[a,c,b]  -  -  -  -  -  -  
3:[b,a,c]  -  2  -  -  -  5  
4:[b,c,a]  3  -  -  -  6  -  
5:[c,a,b]  -  -  -  -  -  -  
6:[c,b,a]  -  4  -  -  -  -  
--
           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  -  -  
2:[a,c,b]  -  -  -  -  -  -  
3:[b,a,c]  -  1  -  -  -  -  
4:[b,c,a]  2  -  -  -  6  -  
5:[c,a,b]  5  -  -  -  -  -  
6:[c,b,a]  -  4  3  -  -  -  
--

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  -  -  
2:[a,c,b]  -  -  6  -  -  -  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  1  -  -  -  -  -  
5:[c,a,b]  5  -  -  3  -  -  
6:[c,b,a]  -  4  2  -  -  -  
--

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  4  -  -  
2:[a,c,b]  -  -  3  -  -  -  
3:[b,a,c]  -  -  -  -  -  5  
4:[b,c,a]  -  -  -  -  6  -  
5:[c,a,b]  2  -  -  -  -  -  
6:[c,b,a]  -  1  -  -  -  -  
--
false.

?- all_profiles( U ), m(A), subtract( U, A, B ), select_n(C,A,6), append( B, C, D ),  \+ swf( F, D ), indexed_profiles( X, D ), fig( domain, D ), assert( tmp_min_arrow( X, D ) ), fail.


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  2  3  -  26 4  
2:[a,c,b]  5  6  -  7  8  25 
3:[b,a,c]  9  27 10 11 12 -  
4:[b,c,a]  28 13 14 15 -  16 
5:[c,a,b]  -  17 18 30 19 20 
6:[c,b,a]  21 -  29 22 23 24 
--

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  2  3  28 -  4  
2:[a,c,b]  5  6  27 7  8  -  
3:[b,a,c]  9  -  10 11 12 29 
4:[b,c,a]  -  13 14 15 30 16 
5:[c,a,b]  26 17 18 -  19 20 
6:[c,b,a]  21 25 -  22 23 24 
--
false.

?- 

?- hist1n(( tmp_arrow( X, D ), member( P, D ), profile_as_sign_pattern( K, P, [S1,S2,S3] ) ), S1;S2;S3 ).

 [([a,b]:[+,+];[b,c]:[+,-];[c,a]:[-,+]),4]
 [([a,b]:[+,+];[b,c]:[-,+];[c,a]:[+,-]),4]
 [([a,b]:[+,-];[b,c]:[+,+];[c,a]:[-,+]),4]
 [([a,b]:[+,-];[b,c]:[-,+];[c,a]:[+,+]),4]
 [([a,b]:[+,-];[b,c]:[-,+];[c,a]:[-,-]),4]
 [([a,b]:[+,-];[b,c]:[-,-];[c,a]:[-,+]),4]
 [([a,b]:[-,+];[b,c]:[+,+];[c,a]:[+,-]),4]
 [([a,b]:[-,+];[b,c]:[+,-];[c,a]:[+,+]),4]
 [([a,b]:[-,+];[b,c]:[+,-];[c,a]:[-,-]),4]
 [([a,b]:[-,+];[b,c]:[-,-];[c,a]:[+,-]),4]
 [([a,b]:[-,-];[b,c]:[+,-];[c,a]:[-,+]),4]
 [([a,b]:[-,-];[b,c]:[-,+];[c,a]:[+,-]),4]
total:48
true.

?- tmp_arrow( X, D ), hist1n(( member( P, D ), profile_as_sign_pattern( K, P, [S1,S2,S3] ) ), S1;S2;S3 ).

 [([a,b]:[+,+];[b,c]:[+,-];[c,a]:[-,+]),1]
 [([a,b]:[+,-];[b,c]:[-,+];[c,a]:[+,+]),1]
 [([a,b]:[+,-];[b,c]:[-,-];[c,a]:[-,+]),1]
 [([a,b]:[-,+];[b,c]:[+,+];[c,a]:[+,-]),1]
 [([a,b]:[-,+];[b,c]:[+,-];[c,a]:[-,-]),1]
 [([a,b]:[-,-];[b,c]:[-,+];[c,a]:[+,-]),1]
total:6
X = [[2, 6], [1, 5], [3, 2], [4, 1], [6, 3], [5, 4]],
D = [[[a, c, b], [c, b, a]], [[a, b, c], [c, a, b]], [[b, a, c], [a, c, b]], [[b, c, a], [a, b, c]], [[c, b, a], [b, a|...]], [[c, a|...], [b|...]]] ;

 [([a,b]:[+,+];[b,c]:[+,-];[c,a]:[-,+]),1]
 [([a,b]:[+,-];[b,c]:[+,+];[c,a]:[-,+]),1]
 [([a,b]:[+,-];[b,c]:[-,-];[c,a]:[-,+]),1]
 [([a,b]:[-,+];[b,c]:[+,-];[c,a]:[+,+]),1]
 [([a,b]:[-,+];[b,c]:[+,-];[c,a]:[-,-]),1]
 [([a,b]:[-,-];[b,c]:[+,-];[c,a]:[-,+]),1]
total:6
X = [[2, 6], [1, 5], [3, 2], [1, 4], [3, 6], [4, 5]],
D = [[[a, c, b], [c, b, a]], [[a, b, c], [c, a, b]], [[b, a, c], [a, c, b]], [[a, b, c], [b, c, a]], [[b, a, c], [c, b|...]], [[b, c|...], [c|...]]] ;

 [([a,b]:[+,+];[b,c]:[+,-];[c,a]:[-,+]),1]
 [([a,b]:[+,-];[b,c]:[+,+];[c,a]:[-,+]),1]
 [([a,b]:[+,-];[b,c]:[-,+];[c,a]:[+,+]),1]
 [([a,b]:[+,-];[b,c]:[-,+];[c,a]:[-,-]),1]
 [([a,b]:[+,-];[b,c]:[-,-];[c,a]:[-,+]),1]
 [([a,b]:[-,-];[b,c]:[+,-];[c,a]:[-,+]),1]
total:6
X = [[2, 6], [1, 5], [5, 4], [2, 3], [1, 4], [3, 6]],
D = [[[a, c, b], [c, b, a]], [[a, b, c], [c, a, b]], [[c, a, b], [b, c, a]], [[a, c, b], [b, a, c]], [[a, b, c], [b, c|...]], [[b, a|...], [c|...]]] ;

 [([a,b]:[+,+];[b,c]:[-,+];[c,a]:[+,-]),1]
 [([a,b]:[+,-];[b,c]:[+,+];[c,a]:[-,+]),1]
 [([a,b]:[+,-];[b,c]:[-,+];[c,a]:[+,+]),1]
 [([a,b]:[+,-];[b,c]:[-,+];[c,a]:[-,-]),1]
 [([a,b]:[+,-];[b,c]:[-,-];[c,a]:[-,+]),1]
 [([a,b]:[-,-];[b,c]:[-,+];[c,a]:[+,-]),1]
total:6
X = [[2, 6], [6, 3], [5, 4], [5, 1], [2, 3], [1, 4]],
D = [[[a, c, b], [c, b, a]], [[c, b, a], [b, a, c]], [[c, a, b], [b, c, a]], [[c, a, b], [a, b, c]], [[a, c, b], [b, a|...]], [[a, b|...], [b|...]]] ;

 [([a,b]:[+,+];[b,c]:[+,-];[c,a]:[-,+]),1]
 [([a,b]:[-,+];[b,c]:[+,+];[c,a]:[+,-]),1]
 [([a,b]:[-,+];[b,c]:[+,-];[c,a]:[+,+]),1]
 [([a,b]:[-,+];[b,c]:[+,-];[c,a]:[-,-]),1]
 [([a,b]:[-,+];[b,c]:[-,-];[c,a]:[+,-]),1]
 [([a,b]:[-,-];[b,c]:[+,-];[c,a]:[-,+]),1]
total:6
X = [[1, 5], [3, 2], [4, 1], [6, 2], [3, 6], [4, 5]],
D = [[[a, b, c], [c, a, b]], [[b, a, c], [a, c, b]], [[b, c, a], [a, b, c]], [[c, b, a], [a, c, b]], [[b, a, c], [c, b|...]], [[b, c|...], [c|...]]] ;

 [([a,b]:[+,+];[b,c]:[-,+];[c,a]:[+,-]),1]
 [([a,b]:[-,+];[b,c]:[+,+];[c,a]:[+,-]),1]
 [([a,b]:[-,+];[b,c]:[+,-];[c,a]:[+,+]),1]
 [([a,b]:[-,+];[b,c]:[+,-];[c,a]:[-,-]),1]
 [([a,b]:[-,+];[b,c]:[-,-];[c,a]:[+,-]),1]
 [([a,b]:[-,-];[b,c]:[-,+];[c,a]:[+,-]),1]
total:6
X = [[3, 2], [4, 1], [6, 3], [6, 2], [5, 1], [4, 5]],
D = [[[b, a, c], [a, c, b]], [[b, c, a], [a, b, c]], [[c, b, a], [b, a, c]], [[c, b, a], [a, c, b]], [[c, a, b], [a, b|...]], [[b, c|...], [c|...]]] ;

 [([a,b]:[+,+];[b,c]:[-,+];[c,a]:[+,-]),1]
 [([a,b]:[+,-];[b,c]:[-,+];[c,a]:[+,+]),1]
 [([a,b]:[+,-];[b,c]:[-,+];[c,a]:[-,-]),1]
 [([a,b]:[-,+];[b,c]:[+,+];[c,a]:[+,-]),1]
 [([a,b]:[-,+];[b,c]:[-,-];[c,a]:[+,-]),1]
 [([a,b]:[-,-];[b,c]:[-,+];[c,a]:[+,-]),1]
total:6
X = [[4, 1], [6, 3], [5, 4], [6, 2], [5, 1], [2, 3]],
D = [[[b, c, a], [a, b, c]], [[c, b, a], [b, a, c]], [[c, a, b], [b, c, a]], [[c, b, a], [a, c, b]], [[c, a, b], [a, b|...]], [[a, c|...], [b|...]]] ;

 [([a,b]:[+,+];[b,c]:[-,+];[c,a]:[+,-]),1]
 [([a,b]:[+,-];[b,c]:[+,+];[c,a]:[-,+]),1]
 [([a,b]:[+,-];[b,c]:[-,+];[c,a]:[-,-]),1]
 [([a,b]:[-,+];[b,c]:[+,-];[c,a]:[+,+]),1]
 [([a,b]:[-,+];[b,c]:[-,-];[c,a]:[+,-]),1]
 [([a,b]:[-,-];[b,c]:[+,-];[c,a]:[-,+]),1]
total:6
X = [[6, 2], [5, 1], [2, 3], [1, 4], [3, 6], [4, 5]],
D = [[[c, b, a], [a, c, b]], [[c, a, b], [a, b, c]], [[a, c, b], [b, a, c]], [[a, b, c], [b, c, a]], [[b, a, c], [c, b|...]], [[b, c|...], [c|...]]].

?- ;
?- tell('test_swf_1.txt'), all_profiles( U ),m(A), subtract( U, A, B ), tmp_arrow(X,C), append( B, C, D ),  swf( F, D ), fig( swf, F ), write(X), fail; told.
true.

?- 

% old

?- m1( D ), member(X,D), writeln(X), fail.
[[a,c,b],[c,b,a]]
[[a,b,c],[c,a,b]]
[[b,a,c],[a,c,b]]
[[b,c,a],[a,b,c]]
[[c,b,a],[b,a,c]]
[[c,a,b],[b,c,a]]
false.

?- m1( D ), swf(F, D ).
false.

?- s1( D ), member(X,D), writeln(X), fail.
[[a,c,b],[b,c,a]]
[[a,c,b],[c,a,b]]
[[b,a,c],[a,b,c]]
[[b,a,c],[c,a,b]]
[[c,b,a],[a,b,c]]
[[c,b,a],[b,c,a]]
false.

?- s1( D ), scf(F, D ).
false.

% using the older numbering system

?- m1( C ), nth1( J, C, X ), m2( D ), findall( K, ( member( K0, [ J-1, J, J+1 ] ), K1 is K0 mod 6, ( K1 = 0 -> K =6; K = K1 ), nth1( K, D, Y ) ), L ), nl, write( J; X; L ), fail.

1;[ [ a, c, b ], [ c, b, a ] ];[ 6, 1, 2 ]
2;[ [ a, b, c ], [ c, a, b ] ];[ 1, 2, 3 ]
3;[ [ b, a, c ], [ a, c, b ] ];[ 2, 3, 4 ]
4;[ [ b, c, a ], [ a, b, c ] ];[ 3, 4, 5 ]
5;[ [ c, b, a ], [ b, a, c ] ];[ 4, 5, 6 ]
6;[ [ c, a, b ], [ b, c, a ] ];[ 5, 6, 1 ]
false.


?- m1( C ), nth1( J, C, X ), m2( D ), findall( Y, ( member( K0, [ J-1, J, J+1 ] ), K1 is K0 mod 6, ( K1 = 0 -> K = 6; K = K1 ), nth1( K, D, Y ) ), L ), nl, write( J; L ), fail.

1;[[[b,c,a],[c,a,b]],[[c,b,a],[a,c,b]],[[c,a,b],[a,b,c]]]
2;[[[c,b,a],[a,c,b]],[[c,a,b],[a,b,c]],[[a,c,b],[b,a,c]]]
3;[[[c,a,b],[a,b,c]],[[a,c,b],[b,a,c]],[[a,b,c],[b,c,a]]]
4;[[[a,c,b],[b,a,c]],[[a,b,c],[b,c,a]],[[b,a,c],[c,b,a]]]
5;[[[a,b,c],[b,c,a]],[[b,a,c],[c,b,a]],[[b,c,a],[c,a,b]]]
6;[[[b,a,c],[c,b,a]],[[b,c,a],[c,a,b]],[[c,b,a],[a,c,b]]]
false.

?- m1( C ), nth1( J, C, X ), ppc( A, X ), m2( D ), findall( [ B1, B2 ], ( member( K0, [ J-1, J, J+1 ] ), K1 is K0 mod 6, ( K1 = 0 -> K =6; K = K1 ), nth1( K, D, [ Y1, Y2 ] ), ppc( [ B2, B1 ], [ Y2, Y1 ] ) ), L ), nl, write( J; A; L ), fail.

1;[ 1, 5 ];[ [ 4, 6 ], [ 5, 1 ], [ 6, 2 ] ]
2;[ 2, 6 ];[ [ 5, 1 ], [ 6, 2 ], [ 1, 3 ] ]
3;[ 3, 1 ];[ [ 6, 2 ], [ 1, 3 ], [ 2, 4 ] ]
4;[ 4, 2 ];[ [ 1, 3 ], [ 2, 4 ], [ 3, 5 ] ]
5;[ 5, 3 ];[ [ 2, 4 ], [ 3, 5 ], [ 4, 6 ] ]
6;[ 6, 4 ];[ [ 3, 5 ], [ 4, 6 ], [ 5, 1 ] ]
false.


?- m1( A ), nth1( J, A, X ), findall( B: S, ( member( B, [ [ a, b ], [ b, c ], [ c, a ] ] ), xy_profile_in_sign( S, B, X ) ), C ).
A = [[[a, c, b], [c, b, a]], [[a, b, c], [c, a, b]], [[b, a, c], [a, c, b]], [[b, c, a], [a, b, c]], [[c, b, a], [b, a|...]], [[c, a|...], [b|...]]],
J = 1,
X = [[a, c, b], [c, b, a]],
C = [[a, b]:[+, -], [b, c]:[-, -], [c, a]:[-, +]] .


?- m1( A ), nth1( J, A, X ), findall( B: S, ( member( B, [ [ a, b ], [ b, c ], [ c, a ] ] ), xy_profile_in_sign( S, B, X ) ), C ), nl, write( J : C ), fail.

1:[[a,b]:[+,-],[b,c]:[-,-],[c,a]:[-,+]]
2:[[a,b]:[+,+],[b,c]:[+,-],[c,a]:[-,+]]
3:[[a,b]:[-,+],[b,c]:[+,-],[c,a]:[-,-]]
4:[[a,b]:[-,+],[b,c]:[+,+],[c,a]:[+,-]]
5:[[a,b]:[-,-],[b,c]:[-,+],[c,a]:[+,-]]
6:[[a,b]:[+,-],[b,c]:[-,+],[c,a]:[+,+]]
false.

  ?- m1( A ), nth1( J, A, X ), nl, between( 1, 2, I ), tab( 1 ),  findall( S, ( member( B, [ [ a, b ], [ b, c ], [ c, a ] ] ), xy_profile_in_sign( L, B, X ), nth1( I, L, S) ), C ), write( J : C ), fail.

 1:[+,-,-] 1:[-,-,+]
 2:[+,+,-] 2:[+,-,+]
 3:[-,+,-] 3:[+,-,-]
 4:[-,+,+] 4:[+,+,-]
 5:[-,-,+] 5:[-,+,-]
 6:[+,-,+] 6:[-,+,+]
false.

% note. decisiveness vertically propagetes between singular signs.

?- pp( K, P ), xy_profile( S, [ X, Y ], P ), nth1( J, P, Q ), p( [ Z, X ], Q ).
K = [1, 1],
P = [[a, c, b], [a, c, b]],
S = [c, c],
X = c,
Y = b,
J = 1,
Q = [a, c, b],
Z = a .

?- pp( K, P ), agree( S, [ X, Y ], P ).K = [1, 1],
P = [[a, c, b], [a, c, b]],
S =  (+),
X = a,
Y = c .


*/


%-----------------------------------------------------------------
% filter
%-----------------------------------------------------------------
% added: 12, 17 Nov 2024 new generator and filter.

filter( _, [ ], _, F, F ).
filter( Axiom, [ X | D ], S, A, F ):-
	 apply( Axiom, [ X, S->T, A ] ), % 制約を変換する
	 !,
	 B = [ X | A ],
	 filter( Axiom, D, T, B, F ).
filter( Axiom, [ _ | D ], S, A, F ):-
	 filter( Axiom, D, S, A, F ).

sample_filter1( X, S ->T, _ ):- S = (X>0), T = (_>0), call( S ).
sample_filter2( X, S ->T, _ ):- S = (X<0), T = (_<0), call( S ).
sample_filter3( X, S ->T, _ ):- S = (X<0), T = (_>0), call( S ).
sample_filter3( X, S ->T, _ ):- S = (X>0), T = (_<0), call( S ).
	 
/*


?- filter( sample_filter1, [1,2,0,-5,-8,22,-11], S, [], F ).
S = (1>0),
F = [22, 2, 1] .

?- filter( sample_filter2, [1,2,0,-5,-8,22,-11], S, [], F ).
S = (-5<0),
F = [-11, -8, -5] ;
false.

?- filter( sample_filter3, [1,2,0,-5,-8,22,-11], S, [], F ).
S = (1>0),
F = [-11, 22, -5, 1] ;
false.

?- [arrow2024x], chalt([1,2,3]), [restricted_domain].
true.

?- dichotomous_domain( S,D ), fig_domain( D ), !, fail.


           1  2  3  4  5  6  
           ------------------
1:[1,2,3]  -  -  -  -  -  -  
2:[1,3,2]  -  25 24 23 22 21 
3:[2,1,3]  -  20 19 18 17 16 
4:[2,3,1]  -  15 14 13 12 11 
5:[3,1,2]  -  10 9  8  7  6  
6:[3,2,1]  -  5  4  3  2  1  
--
false.

*/



%-----------------------------------------------------------------
% generic function with the cumulative argument
%-----------------------------------------------------------------
% modified: 12,16 Nov 2024 new generator; 26 Nov 2024.

f( F, D, Axiom ):-
	%f_2014( F, D, Axiom ).
	%f_2014x( F, D, Axiom, [ ] ).
	f_2024( F, D, Axiom ).

f_2024( F, [ ], _, F ).
f_2024( F, [ X | D ], Axiom, A ):-
	 apply( Axiom, [ X, Y, A ] ),
	 f_2024( F, D, Axiom,[ X - Y | A ] ).

unbound_f( F ):-
	 var( F )
	 ;
	 member( _-X, F ),
	 var( X ).


if_unbound_f( F, D ):-
	 \+ unbound_f( F ),
%	 findall( X, member( X-_, F ), D ),
%	 modified: 18 Nov 2025
	 findall( X, member( X-_, F ), D1 ),
	 sort( D, S ),
	 sort( D1, S ),
	 !.
if_unbound_f( _, _ ).

f_2024( F, D, Axiom ):-
	 if_unbound_f( F, D ),
	 reverse( D, DR ),
	 f_2024( F, DR, Axiom, [ ] ).
 
% earlier versions of f/3.

f_2014( [ ], [ ], _ ).
f_2014( [ X - Y | F ], [ X | D ], Axiom ):-
	 f_2014( F, D, Axiom ),
	 Goal =.. [ Axiom, X, Y, F ],
	 Goal.

f_2014x( [ ], [ ], _ ).
f_2014x( [ X - Y | F ], [ X | D ], Axiom ):-
	 f_2014x( F, D, Axiom ),
	 writeln(apply( Axiom, [ X, Y, F ] )),
	 apply( Axiom, [ X, Y, F ] ).


sample_axiom( _, A, _ ):- between( 0, 2, A ).

/*

?- f( F, [ a, b ], sample_axiom ).
F = [ a-0, b-0 ] ;
F = [ a-1, b-0 ] ;
F = [ a-2, b-0 ] ;
F = [ a-0, b-1 ] ;
F = [ a-1, b-1 ] ;
F = [ a-2, b-1 ] ;
F = [ a-0, b-2 ] ;
F = [ a-1, b-2 ] ;
F = [ a-2, b-2 ].


?- m(D), f( F, D, scf_axiom ), non_imposed(F), \+ dictatorial_scf( _, F ), fig( scf, F ), !, fail.


           1  2  3  4  5  6  
           ------------------
1:[1,2,3]  -  -  -  1  1  -  
2:[1,3,2]  -  -  1  -  -  1  
3:[2,1,3]  -  1  -  -  -  2  
4:[2,3,1]  1  -  -  -  3  -  
5:[3,1,2]  1  -  -  1  -  -  
6:[3,2,1]  -  1  1  -  -  -  
--
false.

*/



% alternative generator

g0( Axiom, D, F ):-
	 f( Axiom, D, [ ], H ),
	 findall( [Y|X], member( X-Y, H ), F ).

g( _, [ ], F, F ).
g( Axiom, [ X | D ], A, F ):-
	 apply( Axiom, [ X, Y, A ] ),
	 \+ member( X, A ), 
	 Z = [ Y | X ],
	 g( Axiom, D, [ Z | A ], F ).

g( Axiom, D, F ):-
	 \+ unbound_f( F ),
	 findall( X, member( X-_, F ), D ),
	 !,
	 g( Axiom, D, [ ], F ).

g( Axiom, D, F ):-
	 g( Axiom, D, [ ], F ).
	%g0( Axiom, D, F ).

% 16 Dec 2025  mapx (same as f_2024)

mapx( _, [ ], F, F ).

mapx( Axiom, [ X | D ], A, F ):-
	 apply( Axiom, [ X, Y, A, D ] ),
	 mapx( Axiom, D, [ Y | A ], F ).

mapx( Axiom, D, F ):-
	 mapx( Axiom, D, [ ], F ).

axiom( swf, X, (X-Y), F, _ ):-
	 ranking( Y ),
	 pareto( X - Y ),
	 iia( X - Y, F ).

axiom( scf, X, (X-Y), F, D ):-
%	 alternative( Y ),
	 x( Y ),
	 \+ manipulable_n( _, X - Y, _, F ),
	 ( D \= [ ] -> true ; non_imposed( [ X-Y | F ] ) ).

/*

% debug

manipulable( 1, [ R, Q ] - S, [ P, Q ] - T, F ):-
	 member( [ P, Q ] - T, F ),
	 ( p( T, S, R ); p( S, T, P ) ).
manipulable( 2, [ R, Q ] - S, [ R, W ] - T, F ):-
	 member( [ R, W ] - T, F ),
	 ( p( T, S, Q ); p( S, T, W ) ).

manipulable_n( J, PP - S, PP1 -T, F ):-
 	member( PP - S, F ),
	append( A, [ R | B ], PP ),
	append( A, [ Q | B ], PP1 ),
	( p( [ T, S ], R ); p( [ S, T ], Q ) ),
 	member( PP1 - T, F ),
	length( [ _ | A ], J ).

?- s1(D), mapx( axiom(scf), D, F ), member( X, F ), manipulable_2( J, X, Y, F ), fig( scf, F ).


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  -  -  
2:[a,c,b]  -  -  -  a  a  -  
3:[b,a,c]  a  -  -  -  a  -  
4:[b,c,a]  -  -  -  -  -  -  
5:[c,a,b]  -  -  -  -  -  -  
6:[c,b,a]  b  -  -  c  -  -  
--
D = [[[a, c, b], [b, c, a]], [[a, c, b], [c, a, b]], [[b, a, c], [a, b, c]], [[b, a, c], [c, a, b]], [[c, b, a], [a, b|...]], [[c, b|...], [b|...]]],
F = [[[c, b, a], [b, c, a]]-c, [[c, b, a], [a, b, c]]-b, [[b, a, c], [c, a, b]]-a, [[b, a, c], [a, b|...]]-a, [[a, c|...], [c|...]]-a, [[a|...], [...|...]]-a],
X = [[c, b, a], [b, c, a]]-c,
J = 2,
Y = [[c, b, a], [a, b, c]]-b .

?- pp( P ), pp(Q), Q\=P, x(A), x(B), X=P-A, Y=Q-B, F=[X,Y],  manipulable_2( J, X, Y, F ), \+ is_manipulable( J, X, Y, F ), fig( scf, F ).


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  a  -  -  -  -  -  
2:[a,c,b]  b  -  -  -  -  -  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  -  -  -  -  -  -  
5:[c,a,b]  -  -  -  -  -  -  
6:[c,b,a]  -  -  -  -  -  -  
--
P = [[a, b, c], [a, b, c]],
Q = [[a, c, b], [a, b, c]],
A = a,
B = b,
X = [[a, b, c], [a, b, c]]-a,
Y = [[a, c, b], [a, b, c]]-b,
F = [[[a, b, c], [a, b, c]]-a, [[a, c, b], [a, b, c]]-b],
J = 1 .


*/


%-----------------------------------------------------------------
% Types of social choice rules
%-----------------------------------------------------------------
type_of_social_rule( swf ).
type_of_social_rule( scf ).
type_of_social_rule( mcf ).


%-----------------------------------------------------------------
% Arrow-type preference aggregation ( SWF; social welfare function )
%-----------------------------------------------------------------
swf( F ):-
	 all_profiles( U ),
	 swf( F, U ).

swf( F, D ):-
	 f( F, D, swf_axiom ),
	 \+ dictatorial_swf( _, F ).

swf_axiom( X, Y, F ):-
	 rc( _, Y ),
%	 alternatives( A ),
%	 permutation( A, Y ),
	 pareto( X - Y ),
	 iia( X - Y, F ).

% a version which reproduces and modifies CE(2007).

swf_07(F,[],F).
swf_07([PP-Q|F],[PP|L],X):- swf_axiom(PP, Q, X ), swf_07(F,L,[ PP-Q | X ] ).
swf_07(F):-all_profiles(L),swf_07(F,L,[ ]).


% n = 2

agree_2( +, B, [ R, Q ] ):-
	 p( B, R ),
	 p( B, Q ).

agree_2( -, [ X, Y ], [ R, Q ] ):-
	 p( [ Y, X ], R ),
	 p( [ Y, X ], Q ).


% general n-person case ( with 3-alternatives )

agree_n( _, _, [ ] ).

agree_n( +, Pair, [ R | L ] ):-
	 p( Pair, R ),
	 agree_n( +, Pair, L ).

agree_n( -, [ X, Y ], [ R | L ] ):-
	 p( [ Y, X ], R ),
	 agree_n( -, [ X, Y ], L ).

agree( S, W, L ):-
	 agree_n( S, W, L ).



pareto( X - Y ):-
	 \+ (
		 agree( +, W, X ),
		 \+ r( W, Y )
	 ),
	 \+ (
		 agree( -, W, X ),
		 r( W, Y )
	 ).


exactly_agree( +, B, [ R, Q ] ):-
	 r( B, R ),
	 r( B, Q ).

exactly_agree( -, [ X, Y ], [ R, Q ] ):-
	 r( [ Y, X ], R ),
	 r( [ Y, X ], Q ).


% n = 2

iia_2( [ P, Q ] - S, F ):-
	 \+ (
		 x( A ),
		 x( B ),
		 member( [ U, V ] - T, F ),
		 exactly_agree( _, [ A, B ], [ P, U ] ),
		 exactly_agree( _, [ A, B ], [ Q, V ] ),
		 \+ exactly_agree( _, [ A, B ], [ S, T ] )
	 ).


% n >= 1

iia_n_bak( PP - S, F ):-
	 \+ (
		 x( A ),
		 x( B ),
		 member( PP1 - T, F ),
		 xy_profile_in_sign( PP_AB, [ A, B ], PP ),
		 xy_profile_in_sign( PP_AB, [ A, B ], PP1 ),
		 \+ exactly_agree( _, [ A, B ], [ S, T ] )
	 ).

iia_n( PP - S, F ):-
	 \+ (
		 x( A ),
		 x( B ),
		 once( ( 
			 member( PP1 - T, F ),
			 xy_profile_in_sign( PP_AB, [ A, B ], PP ),
			 xy_profile_in_sign( PP_AB, [ A, B ], PP1 ) 
		 ) ),
		 \+ exactly_agree( _, [ A, B ], [ S, T ] )
	 ).

% system switch

iia( PP - S, F ):-
	 iia_n( PP - S, F ).


% dictatorial_swf: 6 Jun 2019 corrected & generalized

dictatorial_swf_2( J, [ [ A, B ] - C | F ] ):-
	 nth1( J, [ A, B ], C ),
	 \+ (
		 member( [ P, Q ] - S, F ),
		 nth1( J, [ P, Q ], R ),
		 S \= R
	 ).

dictatorial_swf_n( J, [ P - A | F ] ):-
	 nth1( J, P, A ),
	 \+ (
		 member( PP - S, F ),
		 nth1( J, PP, R ),
		 S \= R
	 ).

dictatorial_swf( J, F ):-
	 dictatorial_swf_n( J, F ),
	 \+ ( person( I ), I\= J, dictatorial_swf_n( I, F ) ).  % correct: 10 Nov 2025


%-----------------------------------------------------------------
% automated-proof of Arrow's impossibility theorem.
%-----------------------------------------------------------------
/*

 ?- swf( F ).
false.

 ?- all_profiles( U ), f( F, U, swf_axiom ), fig( swf, F ), fail.

   123456
1:[ a, b, c ] 123456
2:[ a, c, b ] 123456
3:[ b, a, c ] 123456
4:[ b, c, a ] 123456
5:[ c, a, b ] 123456
6:[ c, b, a ] 123456
--
   123456
1:[ a, b, c ] 111111
2:[ a, c, b ] 222222
3:[ b, a, c ] 333333
4:[ b, c, a ] 444444
5:[ c, a, b ] 555555
6:[ c, b, a ] 666666
--
false.

*/


%-----------------------------------------------------------------
% incremental and sequential construction of swf/scf
%-----------------------------------------------------------------
% 22-23 Jun 2024

incremental_swf( X, Y, F ):-
	 pp( X ),
	 \+ member( X - _, F ), 
	 rc( _, Y ),
	 pareto( X - Y ),
	 iia( X - Y, F ).

incremental_scf( X, Y, F ):-
	 pp( X ),
	 \+ member( X - _, F ), 
	 x( Y ),
	 \+ manipulable( _, X - Y, F ).


sequential_swf( X, Y, F ):-
	 pp( X ),
	 \+ (
		 member( Z - _, F ), 
		 Z @=< X
	 ), 
	 rc( _, Y ),
	 pareto( X - Y ),
	 iia( X - Y, F ).

sequential_scf( X, Y, F ):-
	 pp( X ),
	 \+ (
		 member( Z - _, F ), 
		 Z @=< X
	 ), 
	 x( Y ),
	 \+ manipulable( _, X - Y, F ).

/*

?- gen(sequential_scf, [], F), non_imposed( F ), \+ dictatorial_scf( J, F ), length( F, K ), K >12, fig(scf, F ).

          123456
1:[a,b,c] aabbcc
2:[a,c,b] aabbcc
3:[b,a,c] b-----
4:[b,c,a] ------
5:[c,a,b] ------
6:[c,b,a] ------
--
F = [[[a, b, c], [a, b, c]]-a, [[a, b, c], [a, c, b]]-a, [[a, b, c], [b, a, c]]-b, [[a, b, c], [b, c|...]]-b, [[a, b|...], [c|...]]-c, [[a|...], [...|...]]-c, [[...|...]|...]-a, [...|...]-a, ... - ...|...],
K = 13 .

?- gen(sequential_swf, [], F), \+ dictatorial_swf( J, F ), length( F, K ), K >12, fig(swf, F ).

          123456
1:[a,b,c] 111111
2:[a,c,b] 121122
3:[b,a,c] 1-----
4:[b,c,a] ------
5:[c,a,b] ------
6:[c,b,a] ------
--
F = [[[a, b, c], [a, b, c]]-[a, b, c], [[a, b, c], [a, c, b]]-[a, b, c], [[a, b, c], [b, a, c]]-[a, b, c], [[a, b, c], [b, c|...]]-[a, b, c], [[a, b|...], [c|...]]-[a, b, c], [[a|...], [...|...]]-[a, b|...], [[...|...]|...]-[a|...], [...|...]-[...|...], ... - ...|...],
K = 13 .


*/

%-----------------------------------------------------------------
% another generic function
%-----------------------------------------------------------------
% 22 Jun 2024

gen( _, F, F ).
gen( Axiom, H, F ):-
	 G =.. [ Axiom, X, Y, H ],
	 call( G ),
	 gen( Axiom, [ X-Y | H ], F ).

sample_f( X, Y, F ):-
	 member( X, [a, b ]),
	 between( 0, 4, Y ),
	 \+ (
		 member( _-Z, F ),
		 Z > Y
	 ),
	 \+ (
		 member( P, F ),
		 P @=< X-Y
	 ).

/*

?- gen( sample_f, [ ], F ), nl, write( F ), fail.

[]
[a-0]
[a-1]
[a-2]
[a-3]
[a-4]
[b-0]
[a-0,b-0]
[a-1,b-0]
[a-2,b-0]
[a-3,b-0]
[a-4,b-0]
[b-1]
[a-1,b-1]
[a-2,b-1]
[a-3,b-1]
[a-4,b-1]
[b-2]
[a-2,b-2]
[a-3,b-2]
[a-4,b-2]
[b-3]
[a-3,b-3]
[a-4,b-3]
[b-4]
[a-4,b-4]
false.

*/




%-----------------------------------------------------------------
% generating single-ranking averse domain
%-----------------------------------------------------------------
% 19-23 Jun 2024


gen_sra_domain( _, D, D ).
gen_sra_domain( R, H, D ):-
	 pp( PP ),
	 \+ (
		member( QP, H ),
		QP @=< PP
	 ),
	 \+ (
		f( F, [ PP | H ], swf_axiom ),
		 member( _ - R, F )
	 ),
	 gen_sra_domain( R, [ PP | H ], D ).

gen_sra_domain( R, D ):-
	 ranking( R ),
	 gen_sra_domain( R, [ ], D ).


/*

?- gen_sra_domain( [a,b,c], D ), length( D,N ), N>9, assert( tmp_10( N, D ) ).

?- tmp_10( N, D ), N >13, indexed_profiles( IND, D ), nl, write( IND ).

[[2,2],[2,5],[2,6],[3,2],[3,3],[3,4],[3,5],[3,6],[4,2],[4,3],[4,4],[4,5],[4,6],[5,2]]
N = 14,
D = [[[a, c, b], [a, c, b]], [[a, c, b], [c, a, b]], [[a, c, b], [c, b, a]], [[b, a, c], [a, c, b]], [[b, a, c], [b, a|...]], [[b, a|...], [b|...]], [[b|...], [...|...]], [[...|...]|...], [...|...]|...],
IND = [[2, 2], [2, 5], [2, 6], [3, 2], [3, 3], [3, 4], [3, 5], [3|...], [...|...]|...] .

?- tmp_10(N,D), N >13, swf( F, D ), fig( swf, F ), fail.

          123456
1:[a,b,c] ------
2:[a,c,b] -2--22
3:[b,a,c] -33333
4:[b,c,a] -33444
5:[c,a,b] -2----
6:[c,b,a] ------
--
          123456
1:[a,b,c] ------
2:[a,c,b] -2--55
3:[b,a,c] -33444
4:[b,c,a] -33444
5:[c,a,b] -2----
6:[c,b,a] ------
--
          123456
1:[a,b,c] ------
2:[a,c,b] -2--56
3:[b,a,c] -33444
4:[b,c,a] -33444
5:[c,a,b] -2----
6:[c,b,a] ------
--
          123456
1:[a,b,c] ------
2:[a,c,b] -2--55
3:[b,a,c] -23456
4:[b,c,a] -23456
5:[c,a,b] -2----
6:[c,b,a] ------
--
          123456
1:[a,b,c] ------
2:[a,c,b] -2--55
3:[b,a,c] -33444
4:[b,c,a] -44444
5:[c,a,b] -5----
6:[c,b,a] ------
--
          123456
1:[a,b,c] ------
2:[a,c,b] -2--56
3:[b,a,c] -33444
4:[b,c,a] -44444
5:[c,a,b] -5----
6:[c,b,a] ------
--
          123456
1:[a,b,c] ------
2:[a,c,b] -2--55
3:[b,a,c] -23456
4:[b,c,a] -54456
5:[c,a,b] -5----
6:[c,b,a] ------
--
          123456
1:[a,b,c] ------
2:[a,c,b] -2--56
3:[b,a,c] -23456
4:[b,c,a] -54456
5:[c,a,b] -5----
6:[c,b,a] ------
--
false.

?- tmp_10(N,D), (N >14, swf( F, D ) -> fig( swf, F ); true), fail.

          123456
1:[a,b,c] ------
2:[a,c,b] -23456
3:[b,a,c] -33444
4:[b,c,a] -3344-
5:[c,a,b] ---4--
6:[c,b,a] ------
--
false.

?- findall( 1, (tmp_10(N,D), N =14), L), length( L, M ).
L = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
M = 14.

?- tell_goal('temp10.pl',forall,tmp_10(_,_)).complete
true .

%retry 24 Jun 2024. 実験はメインでなくスレッドで走らせること．

?- dynamic temp_10/2.
?- abolish(temp_10/2).

Thread 1?-  time(( gen_sra_domain( [a,b,c], D ), length( D, N ), N>9, assert( tmp_10(N, D) ), fail; true )).


Thread 2?- repeat, findall( 1, clause(tmp_13(N,D),_), L), length( L, M ), tstamp( M, T ), sleep(5), fail

?- repeat, findall( 1, clause(tmp_10(N,D),_), L), length( L, M ), tstamp( M, T ), sleep(5), fail.
0,[date(2024/6/24),time(8-7-41)]
0,[date(2024/6/24),time(8-7-46)]
0,[date(2024/6/24),time(8-7-51)]
0,[date(2024/6/24),time(8-7-56)]
0,[date(2024/6/24),time(8-8-1)]
0,[date(2024/6/24),time(8-8-6)]
0,[date(2024/6/24),time(8-8-11)]
1,[date(2024/6/24),time(8-8-16)]
1,[date(2024/6/24),time(8-8-21)]
1,[date(2024/6/24),time(8-8-26)]
1,[date(2024/6/24),time(8-8-31)]
1,[date(2024/6/24),time(8-8-36)]
1,[date(2024/6/24),time(8-8-41)]
1,[date(2024/6/24),time(8-8-46)]
2,[date(2024/6/24),time(8-8-51)]
2,[date(2024/6/24),time(8-8-56)]
2,[date(2024/6/24),time(8-9-2)]
2,[date(2024/6/24),time(8-9-7)]
3,[date(2024/6/24),time(8-9-12)]
3,[date(2024/6/24),time(8-9-17)]
4,[date(2024/6/24),time(8-9-22)]
5,[date(2024/6/24),time(8-9-27)]
6,[date(2024/6/24),time(8-9-32)]
11,[date(2024/6/24),time(8-9-37)]
11,[date(2024/6/24),time(8-9-42)]
11,[date(2024/6/24),time(8-9-47)]
11,[date(2024/6/24),time(8-9-52)]
11,[date(2024/6/24),time(8-9-57)]
12,[date(2024/6/24),time(8-10-2)]
12,[date(2024/6/24),time(8-10-7)]
12,[date(2024/6/24),time(8-10-12)]
12,[date(2024/6/24),time(8-10-17)]
13,[date(2024/6/24),time(8-10-22)]
13,[date(2024/6/24),time(8-10-27)]
14,[date(2024/6/24),time(8-10-32)]
15,[date(2024/6/24),time(8-10-37)]
20,[date(2024/6/24),time(8-10-42)]
21,[date(2024/6/24),time(8-10-47)]
21,[date(2024/6/24),time(8-10-52)]
21,[date(2024/6/24),time(8-10-57)]
...
以下は100秒ごとログを記録．

?- repeat, findall( N, clause(tmp_10(N,D),_), L), length( L, M ), max_list( L, Max ), tstamp( no, T ), assert( tmp_log( T, M, Max ) ), sleep(100), fail.
88,[date(2024/6/24),time(8-14-55)]
140,[date(2024/6/24),time(8-16-35)]
208,[date(2024/6/24),time(8-18-15)]
300,[date(2024/6/24),time(8-19-55)]
320,[date(2024/6/24),time(8-21-35)]
373,[date(2024/6/24),time(8-23-15)]
439,[date(2024/6/24),time(8-24-55)]
531,[date(2024/6/24),time(8-26-35)]
541,[date(2024/6/24),time(8-29-58)]
586,[date(2024/6/24),time(8-31-39)]
645,[date(2024/6/24),time(8-33-19)]
723,[date(2024/6/24),time(8-34-59)]
845,[date(2024/6/24),time(8-36-39)]
1004,[date(2024/6/24),time(8-38-19)]
1094,[date(2024/6/24),time(8-39-59)]
1095,[date(2024/6/24),time(8-41-39)]
1098,[date(2024/6/24),time(8-43-19)]
1105,[date(2024/6/24),time(8-44-59)]
1106,[date(2024/6/24),time(8-46-40)]
1107,[date(2024/6/24),time(8-48-20)]
1116,[date(2024/6/24),time(8-50-0)]
1125,[date(2024/6/24),time(8-51-40)]
1141,[date(2024/6/24),time(9-0-48)]
1162,[date(2024/6/24),time(9-2-28)]
1166,[date(2024/6/24),time(9-4-8)]
1172,[date(2024/6/24),time(9-5-48)]
1186,[date(2024/6/24),time(9-7-28)]
1207,[date(2024/6/24),time(9-9-8)]
1217,[date(2024/6/24),time(9-10-48)]
1244,[date(2024/6/24),time(9-12-28)]
1262,[date(2024/6/24),time(9-16-49)]
1295,[date(2024/6/24),time(9-18-29)]
1334,[date(2024/6/24),time(9-20-9)]
1337,[date(2024/6/24),time(9-21-49)]
1339,[date(2024/6/24),time(9-23-29)]
...
以下は600秒(10分)ごと．
?- repeat, findall( 1, clause(tmp_10(N,D),_), L), length( L, M ), tstamp( M, T ), sleep(600), fail.
1393,[date(2024/6/24),time(9-32-29)]
...
最大長も表示する
repeat, findall( N, clause(tmp_10(N,D),_), L), length( L, M ), max_list( L,X ), tstamp( M:X, T ), sleep(600), fail.
2271:14,[date(2024/6/24),time(12-20-27)]
2484:14,[date(2024/6/24),time(12-38-45)]
2636:14,[date(2024/6/24),time(12-48-48)]
2893:14,[date(2024/6/24),time(12-59-23)]
3171:14,[date(2024/6/24),time(13-10-19)]

?- findall( K,tmp_10( K, _ ),L),max_list(L,X), length( L, N), findall( 1, member( 14, L ),L14),length(L14,N14).
L = [10, 10, 10, 10, 10, 10, 10, 10, 10|...],
X = 14,
N = 3448,
L14 = [1, 1, 1, 1, 1, 1, 1, 1],
N14 = 8.

...
3465:14,[date(2024/6/24),time(13-21-10)]
3541:15,[date(2024/6/24),time(13-39-35)]
3718:15,[date(2024/6/24),time(13-53-7)]

?- tmp_10(N,D), (N >14, swf( F, D ) -> fig( swf, F ); true), fail.
          123456
1:[a,b,c] ------
2:[a,c,b] -23456
3:[b,a,c] -33444
4:[b,c,a] -3344-
5:[c,a,b] ---4--
6:[c,b,a] ------
--
false.

?- findall( K,tmp_10( K, _ ),L),max_list(L,X), length( L, N), findall( 1, member( 14, L ),L14),length(L14,N14), findall( 1, member( 15, L ),L15),length(L15,N15).
L = [10, 10, 10, 10, 10, 10, 10, 10, 10|...],
X = 15,
N = 3725,
L14 = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
N14 = 14,
L15 = [1],
N15 = 1.

?- findall( K,tmp_10( K, _ ),L),max_list(L,Upper), length( L, N), Lower=14, findall( Np, ( between( Lower,Upper,P ), findall( 1, member( P, L ),Lp),length(Lp,Np) ), Hist ).
L = [10, 10, 10, 10, 10, 10, 10, 10, 10|...],
Upper = 16,
N = 9028,
Lower = 14,
Hist = [95, 14, 1].


...

7441:15,[date(2024/6/24),time(19-9-2)]
7648:16,[date(2024/6/24),time(19-20-9)]
...
17286:16,[date(2024/6/25),time(1-50-11)]
17621:16,[date(2024/6/25),time(2-0-11)]
17789:17,[date(2024/6/25),time(2-10-12)]
17881:17,[date(2024/6/25),time(2-20-12)]

?- findall( K,tmp_10( K, _ ),L),max_list(L,Upper), length( L, N), Lower=14, findall( Np, ( between( Lower,Upper,P ), findall( 1, member( P, L ),Lp),length(Lp,Np) ), Hist ).
L = [10, 10, 10, 10, 10, 10, 10, 10, 10|...],
Upper = 17,
N = 23673,
Lower = 14,
Hist = [548, 119, 16, 1].

...
26661:17,[date(2024/6/25),time(7-40-16)]
27040:17,[date(2024/6/25),time(7-50-16)]
27410:17,[date(2024/6/25),time(8-0-16)]
27793:17,[date(2024/6/25),time(8-10-16

  ?- findall( K,tmp_10( K, _ ),L),max_list(L,Upper), length( L, N), Lower=14, findall( Np, ( between( Lower,Upper,P ), findall( 1, member( P, L ),Lp),length(Lp,Np) ), Hist ).
L = [10, 10, 10, 10, 10, 10, 10, 10, 10|...],
Upper = 17,
N = 27963,
Lower = 14,
Hist = [820, 196, 29, 2].

...
34484:17,[date(2024/6/25),time(11-20-19)]
34876:17,[date(2024/6/25),time(11-30-19)]
35259:17,[date(2024/6/25),time(11-40-19)]

 ?- findall( K,tmp_10( K, _ ),L),max_list(L,Upper), length( L, N), Lower=14, findall( Np, ( between( Lower,Upper,P ), findall( 1, member( P, L ),Lp),length(Lp,Np) ), Hist ).
L = [10, 10, 10, 10, 10, 10, 10, 10, 10|...],
Upper = 17,
N = 35545,
Lower = 14,
Hist = [1134, 277, 42, 3].


37185:17,[date(2024/6/25),time(12-30-20)]
37555:17,[date(2024/6/25),time(12-40-20)]
37855:17,[date(2024/6/25),time(12-50-20)]


 ?- findall( K,tmp_10( K, _ ),L),max_list(L,Upper), length( L, N), Lower=14, findall( Np, ( between( Lower,Upper,P ), findall( 1, member( P, L ),Lp),length(Lp,Np) ), Hist ).
L = [10, 10, 10, 10, 10, 10, 10, 10, 10|...],
Upper = 17,
N = 38068,
Lower = 14,
Hist = [1336, 341, 54, 4].

38510:17,[date(2024/6/25),time(13-10-21)]
38891:17,[date(2024/6/25),time(13-20-21)]
39282:17,[date(2024/6/25),time(13-30-21)]

 ?- findall( K,tmp_10( K, _ ),L),max_list(L,Upper), length( L, N), Lower=14, findall( Np, ( between( Lower,Upper,P ), findall( 1, member( P, L ),Lp),length(Lp,Np) ), Hist ).
L = [10, 10, 10, 10, 10, 10, 10, 10, 10|...],
Upper = 17,
N = 39468,
Lower = 14,
Hist = [1492, 395, 65, 5].

% リアルタイムモニター変更

?- repeat, findall( N, clause(tmp_10(N,D),_), L), length( L, M ), max_list( L,X ), Lower=14, Upper=X, findall( Np, ( between( Lower,Upper,P ), findall( 1, member( P, L ),Lp),length(Lp,Np) ), H ), tstamp( M:X;H, T ), sleep(600), fail.

(39615:17;[1496,395,65,5]),[date(2024/6/25),time(13-39-31)]

(41081:17;[1733,489,86,7]),[date(2024/6/25),time(14-19-32)]
(41388:17;[1822,560,120,15]),[date(2024/6/25),time(14-29-32)]
(41788:18;[1822,560,120,16,1]),[date(2024/6/25),time(14-39-32)]
...
(67294:18;[3175,984,204,24,1]),[date(2024/6/26),time(4-40-6)]
(67405:18;[3201,1016,225,31,2]),[date(2024/6/26),time(4-50-7)]

 ?- findall( K,tmp_10( K, _ ),L),max_list(L,Upper), length( L, N), Lower=14, findall( Np, ( between( Lower,Upper,P ), findall( 1, member( P, L ),Lp),length(Lp,Np) ), Hist ).
L = [10, 10, 10, 10, 10, 10, 10, 10, 10|...],
Upper = 18,
N = 68691,
Lower = 14,
Hist = [3212, 1017, 225, 31, 2].



ファイルに出力．

% goals

?- tell_goal( 'log_generate_sra_domain.txt', forall,tmp_log(_,_,_) ), tell_goal( 'tmp_10.pl', forall,tmp_10(_,_) ).


% tentatively max SWF

?- tell('test.txt'), findall( K,tmp_10( K, _ ),L), max_list(L,Upper), tmp_10(Upper,D), write( * ), nl, swf( F, D ), fig( swf, F ), fail; told.
true.


*/


/*

% loging

?- tmp_log( [date(Date),time(H-M-S)], Count, MaxSize ), term_string( Date, DS ), atomic_list_concat( [H,M,S], ':', Time ), atomic_list_concat( [ DS,Time,Count,MaxSize],',', P ),nl, write(P) .

2024/6/24,8:38:31,1034,13
Date = 2024/6/24,
H = 8,
M = 38,
S = 31,
Count = 1034,
MaxSize = 13,
DS = "2024/6/24",
Time = '8:38:31',
P = '2024/6/24,8:38:31,1034,13' .
*/


%テーブル出力

table_sra_domains:-
	 tell('table_sra_domains.csv' ),
	 writeln( 'date, time(h), time(m), time(s), Count, MaxSize' ),
	 tmp_log( [date(Date),time(H-M-S)], Count, MaxSize ),
	 term_string( Date, DS ),
	 atomic_list_concat( [ DS,H,M,S,Count,MaxSize],',', P ),
	 writeln( P ),
	 fail
	 ;
	 told.


/*


?- m(M), m1(M1), nth1( J, M1, PP1 ), m2( M2), nth1( K, M2, PP2), subtract( M, [PP1,PP2], D ), \+ \+ swf( F, D), writeln([J,K]), fail.
[1,1]
[1,2]
[1,3]
[1,5]
[1,6]
[2,1]
[2,2]
[2,3]
[2,4]
[2,6]
[3,1]
[3,2]
[3,3]
[3,4]
[3,5]
[4,2]
[4,3]
[4,4]
[4,5]
[4,6]
[5,1]
[5,3]
[5,4]
[5,5]
[5,6]
[6,1]
[6,2]
[6,4]
[6,5]
[6,6]
false.

?- m(M), m1(M1), nth1( J, M1, PP1 ), m2( M2), nth1( K, M2, PP2), subtract( M, [PP1,PP2], D ), \+ swf( F, D), writeln([J,K]), fail.
[1,4]
[2,5]
[3,6]
[4,1]
[5,2]
[6,3]
false.

?- m(M), m1(M1), nth1( J, M1, PP1 ), m2( M2), nth1( K, M2, PP2), subtract( M, [PP1,PP2], D ), \+ swf( F, D), writeln([J,K]:[PP1,PP2]), fail.
[1,4]:[[[a,c,b],[c,b,a]],[[a,b,c],[b,c,a]]]
[2,5]:[[[a,b,c],[c,a,b]],[[b,a,c],[c,b,a]]]
[3,6]:[[[b,a,c],[a,c,b]],[[b,c,a],[c,a,b]]]
[4,1]:[[[b,c,a],[a,b,c]],[[c,b,a],[a,c,b]]]
[5,2]:[[[c,b,a],[b,a,c]],[[c,a,b],[a,b,c]]]
[6,3]:[[[c,a,b],[b,c,a]],[[a,c,b],[b,a,c]]]
false.

?- m(M), m1(M1), nth1( J, M1, PP1 ), m2( M2), nth1( K, M2, PP2), subtract( M, [PP1,PP2], D ), \+ \+ ( swf( F, D), \+ member( _-[a,b,c], F ) ), writeln([J,K]), fail.
[2,2]
[2,3]
[2,4]
[3,2]
[3,3]
[3,4]
[4,2]
[4,3]
[4,4]
false.


*/


%-----------------------------------------------------------------
% expanding domains
%-----------------------------------------------------------------
% 2 Jul 2024 

partial_ranking_of( _, [ ] ).

partial_ranking_of( [ X | S ], [ X | R ] ):-
	!,
	partial_ranking_of( S, R ).

partial_ranking_of( S, [ X | R ] ):-
	append( _, [ X | T ], S ),
	partial_ranking_of( T, R ).

/*

% imbed partial order by using list projection

?- B=[_,_,_], list_projection(A,B,[3]).
B = [_, _, 3],
A = [0, 0, 1] ;
B = [_, 3, _],
A = [0, 1, 0] ;
B = [3, _, _],
A = [1, 0, 0] ;
false.

?- B=[_,2,_], list_projection(A,B,[3]).
B = [_, 2, 3],
A = [0, 0, 1] ;
B = [3, 2, _],
A = [1, 0, 0] ;
false.

?- B=[_,a,_,_], list_projection(A,B,[b,c]).
B = [_, a, b, c],
A = [0, 0, 1, 1] ;
B = [b, a, _, c],
A = [1, 0, 0, 1] ;
B = [b, a, c, _],
A = [1, 0, 1, 0] ;
false.

*/


% 5 Jul 2024

merge_ranking( P, Q, R ):-
	 union( P, Q, U ),
	 length( U, N ),
	 length( R, N ),
	 list_projection( _, R, P ),
	 partial_ranking_of( R, Q ).

/*

?- merge_ranking( [1,3,5], [2,4], R ).
R = [2, 4, 1, 3, 5] ;
R = [2, 1, 4, 3, 5] ;
R = [2, 1, 3, 4, 5] ;
R = [2, 1, 3, 5, 4] ;
R = [1, 2, 4, 3, 5] ;
R = [1, 2, 3, 4, 5] ;
R = [1, 2, 3, 5, 4] ;
R = [1, 3, 2, 4, 5] ;
R = [1, 3, 2, 5, 4] ;
R = [1, 3, 5, 2, 4] ;
false.

*/

% 19 Jun 2024?
% modified: 5 Jul 2024

p_extended_with( K, P, P ):-
	 member( K, P ),
	 !.

p_extended_with( K, P, Q ):-
	 append( PH, PT, P ),
	 append( PH, [ K | PT ], Q ).

pp_extended_with( K, PP, QP ):-
	 maplist( p_extended_with(K), PP, QP ).
		 

/*

?- tmp_Q3_excluding_pp( _, [P|_]), !,p_extended_with( 2, P, Q ).
P = [4, 3, 5, 6, 1],
Q = [2, 4, 3, 5, 6, 1] ;
P = [4, 3, 5, 6, 1],
Q = [4, 2, 3, 5, 6, 1] ;
P = [4, 3, 5, 6, 1],
Q = [4, 3, 2, 5, 6, 1] ;
P = [4, 3, 5, 6, 1],
Q = [4, 3, 5, 2, 6, 1] ;
P = [4, 3, 5, 6, 1],
Q = [4, 3, 5, 6, 2, 1] ;
P = [4, 3, 5, 6, 1],
Q = [4, 3, 5, 6, 1, 2] ;
false.

*/

p_imbed_to( P, Q, Q ):-
	 partial_ranking_of( Q, P ),
	 !.

p_imbed_to( P, Q, R ):-
	 merge_ranking( P, Q, R ).

pp_imbed_to( PP, QP, RP ):-
	 maplist( p_imbed_to( PP ), QP, RP ).
		 

/*

?- exclusive_dom_Q1(_,_,[_,Q|D],14), T=[3,4,5], pp_imbed_to( T, Q, R ), nl, write( Q->R ), fail.

[[1,2,4],[1,4,2]]->[[1,2,3,4,5],[1,3,4,2,5]]
[[1,2,4],[1,4,2]]->[[1,2,3,4,5],[1,3,4,5,2]]
[[1,2,4],[1,4,2]]->[[1,2,3,4,5],[3,1,4,2,5]]
[[1,2,4],[1,4,2]]->[[1,2,3,4,5],[3,1,4,5,2]]
[[1,2,4],[1,4,2]]->[[1,3,2,4,5],[1,3,4,2,5]]
[[1,2,4],[1,4,2]]->[[1,3,2,4,5],[1,3,4,5,2]]
[[1,2,4],[1,4,2]]->[[1,3,2,4,5],[3,1,4,2,5]]
[[1,2,4],[1,4,2]]->[[1,3,2,4,5],[3,1,4,5,2]]
[[1,2,4],[1,4,2]]->[[3,1,2,4,5],[1,3,4,2,5]]
[[1,2,4],[1,4,2]]->[[3,1,2,4,5],[1,3,4,5,2]]
[[1,2,4],[1,4,2]]->[[3,1,2,4,5],[3,1,4,2,5]]
[[1,2,4],[1,4,2]]->[[3,1,2,4,5],[3,1,4,5,2]]
false.

*/


extended_domain_by_singlton( D, K, H ):-
	 findall( QP, (
		 member( PP, D ),
		 pp_extended_with( K, PP, QP )
	 ), H ).


extended_domain_Q1_exc214_D14( H ):-
	 exclusive_dom_Q1(_,_, D,14),
	 extended_domain_by_singlton( D, 3, H ).

% substitution by symbol-exchange.

substitute_element_of_list( [ ], _, _, [ ] ).

substitute_element_of_list( [ X | A ], X, Y, [ Y | B ] ):-
	 substitute_element_of_list( A, X, Y, B ),
	 !.
substitute_element_of_list( [ Z | A ], X, Y, [ Z | B ] ):-
	 substitute_element_of_list( A, X, Y, B ).

/*

?- substitute_element_of_list( [1,2,3], 2, a, P).
P = [1, a, 3].

*/


substitute_list( B, [ ], B ).
substitute_list( A, [ Y / X | T ], B ):-
	 substitute_element_of_list( A, X, Y, C ),
	 substitute_list( C, T, B ),
	 !.

/*

?- substitute_list( [1,2,3],[a/2, B/1, a/3], P).
B = 3,
P = [a, a, a].

?- substitute_list( [1,2,3],[a/2, B/1, C/3], P).
B = 3,
P = [C, a, C].

?- substitute_list( [1,2,3],[a/2, b/1, C/3], P).
P = [b, a, C].

?- substitute_list( [1,2,3],[a/2, b/1, c/S], P).
S = b,
P = [c, a, 3].

?- exclusive_dom_Q1(_,_,D,14), member( [X,Y], D ), S=[a/1,b/2,c/3,d/4], substitute_list( X, S, Z ), substitute_list( Y, S, W), nl, write( X->Z;Y->W ), fail.

[1,2,4]->[a,b,d];[1,2,4]->[a,b,d]
[1,2,4]->[a,b,d];[1,4,2]->[a,d,b]
[1,2,4]->[a,b,d];[4,1,2]->[d,a,b]
[1,4,2]->[a,d,b];[1,2,4]->[a,b,d]
[1,4,2]->[a,d,b];[1,4,2]->[a,d,b]
[1,4,2]->[a,d,b];[4,1,2]->[d,a,b]
[1,4,2]->[a,d,b];[4,2,1]->[d,b,a]
[4,1,2]->[d,a,b];[1,2,4]->[a,b,d]
[4,1,2]->[d,a,b];[1,4,2]->[a,d,b]
[4,1,2]->[d,a,b];[4,1,2]->[d,a,b]
[4,1,2]->[d,a,b];[4,2,1]->[d,b,a]
[4,2,1]->[d,b,a];[1,4,2]->[a,d,b]
[4,2,1]->[d,b,a];[4,1,2]->[d,a,b]
[4,2,1]->[d,b,a];[4,2,1]->[d,b,a]
false.


*/

  
pp_xyz_renamed( [ ], _, _, [  ] ).
pp_xyz_renamed( [ P | PP ], [X,Y,Z], [S,T,U], [ Q | QP ] ):-
	Subst = [ S/X, T/Y, U/Z ], 
	substitute_list( P, Subst, Q ),
	pp_xyz_renamed( PP, [X,Y,Z], [S,T,U], QP ).

/*

?- pp(PP), pp_xyz_renamed( PP, [a,b,c], [x,y,z], QP ).
PP = [[a, b, c], [a, b, c]],
QP = [[x, y, z], [x, y, z]] .

?- pp(PP), pp_xyz_renamed( PP, [a,b,c], ['クマ','サル','キジ'], QP ).
PP = [[a, b, c], [a, b, c]],
QP = [[クマ, サル, キジ], [クマ, サル, キジ]] ;
PP = [[a, b, c], [a, c, b]],
QP = [[クマ, サル, キジ], [クマ, キジ, サル]] .

?- exclusive_dom_Q1(_,_,D,14), xyz( 'Q1', T ), member( X, D ), pp_xyz_renamed( X, T, [a,b,c], Y ), nl, write( X->Y ), fail.

[[1,2,4],[1,2,4]]->[[b,a,c],[b,a,c]]
[[1,2,4],[1,4,2]]->[[b,a,c],[b,c,a]]
[[1,2,4],[4,1,2]]->[[b,a,c],[c,b,a]]
[[1,4,2],[1,2,4]]->[[b,c,a],[b,a,c]]
[[1,4,2],[1,4,2]]->[[b,c,a],[b,c,a]]
[[1,4,2],[4,1,2]]->[[b,c,a],[c,b,a]]
[[1,4,2],[4,2,1]]->[[b,c,a],[c,a,b]]
[[4,1,2],[1,2,4]]->[[c,b,a],[b,a,c]]
[[4,1,2],[1,4,2]]->[[c,b,a],[b,c,a]]
[[4,1,2],[4,1,2]]->[[c,b,a],[c,b,a]]
[[4,1,2],[4,2,1]]->[[c,b,a],[c,a,b]]
[[4,2,1],[1,4,2]]->[[c,a,b],[b,c,a]]
[[4,2,1],[4,1,2]]->[[c,a,b],[c,b,a]]
[[4,2,1],[4,2,1]]->[[c,a,b],[c,a,b]]
false.

?- exclusive_dom_Q1(_,_,D,14), xyz( 'Q1', T ), member( X, D ), pp_xyz_renamed( X, T, [a,b,c], Y ), ppc( J, Y ), nl, write( X->J ), fail.

[[4,1,2],[1,2,4]]->[6,3]
[[4,2,1],[1,4,2]]->[5,4]
false.

?- m(M), exclusive_dom_Q1(_,_,D,14), xyz( 'Q1', T ), member( X, D ), pp_xyz_renamed( X, T, [a,b,c], Y ), nth1( J, M, Y ), nl, write( X->J ), fail.

[[1,2,4],[4,1,2]]->11
[[1,4,2],[4,2,1]]->12
[[4,1,2],[1,2,4]]->5
[[4,2,1],[1,4,2]]->6
false.

?- s(S), exclusive_dom_Q1(_,_,D,14), xyz( 'Q1', T ), member( X, D ), pp_xyz_renamed( X, T, [a,b,c], Y ), nth1( J, S, Y ), nl, write( X->J ), fail.

[[1,4,2],[4,1,2]]->12
[[4,1,2],[1,4,2]]->6
false.


?- s(S), m(M), union( S,M,V ), exclusive_dom_Q1(_,_, D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y ), member( Y, V ) ), D ), is_an_exclusive_domain_Q1( D ), nl, write(yesyes),!,fail.

yesyes
false.

?- tell('Q1_swf_special_dom.txt'),  writeln( 'Special SWF:' ).
true.

?- s(S), m(M), union( S,M,V ), exclusive_dom_Q1(_,_, D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y ), member( Y, V ) ), D ), f( F, D, swf_axiom ), fig( swf, F ), dictatorial_swf( J, F ), write( dict(J) ),fail.
false.

?- nl, nl, writeln( 'Special SCF:' ).

?- s(S), m(M), union( S,M,V ), exclusive_dom_Q1(_,_, D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y ), member( Y, V ) ), D ), f( F, D, scf_axiom ), non_imposed( F ), fig( scf, F ), dictatorial_scf( J, F ), write( dict(J) ),fail.
false.

?- told.
true.

?- exclusive_dom_Q1(_,_, D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y ) ), D ), f( F, D, swf_axiom ), \+ write(*).
****************
false.
?- exclusive_dom_Q1(_,_, D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y ) ), D ), f( F, D, scf_axiom ), \+ write(*).
***************
false.

?- exclusive_dom_Q1(_,_, D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y ) ), D ), f( F, D, scf_axiom ), non_imposed( F ).

false.

?- s(S), m(M), union( S,M,V ), exclusive_dom_Q1(_,_, D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y ), member( Y, V ) ), D ), f( F, D, scf_axiom ), non_imposed( F ), \+ write( * ).
******
false.

?- s(S), m(M), union( S,M,V ), exclusive_dom_Q1(_,_, D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y ), member( Y, V ) ), D ), scf( F, D ), \+ write( * ).
******
false.

% Every spcs-scf is nondictatorial. There is no dict-scf.

?- s(S), m(M), union( S,M,V ), exclusive_dom_Q1(_,_, D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y ), member( Y, V ) ), D ), f( F, D, scf_axiom ), dictatorial_scf( _, F ), \+ write( * ).
**
false.

?- s(S), m(M), union( S,M,V ), exclusive_dom_Q1(_,_, D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y ), member( Y, V ) ), D ), f( F, D, scf_axiom ), non_imposed( F ), !, \+ fig( scf, F ).

          123456
1:[a,b,c] ------
2:[a,c,b] ------
3:[b,a,c] -----a
4:[b,c,a] ----cc
5:[c,a,b] ---a--
6:[c,b,a] --bb--
--
false.

?- exclusive_dom_Q1(_,_,D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y )  ), D ), f( F, D, swf_axiom ), fig( swf, F ), !,fail.

          123456
1:[a,b,c] ------
2:[a,c,b] ------
3:[b,a,c] --34-6
4:[b,c,a] --4456
5:[c,a,b] ---555
6:[c,b,a] --6656
--
false.

?- exclusive_dom_Q1(_,_, D1,14), findall( Y, ( xyz( 'Q1', T ), member( X, D1 ), pp_xyz_renamed( X, T, [a,b,c], Y ) ), D ), f( F, D, scf_axiom ), !, \+ fig( scf, F ).

          123456
1:[a,b,c] ------
2:[a,c,b] ------
3:[b,a,c] --aa-a
4:[b,c,a] --aaaa
5:[c,a,b] ---aaa
6:[c,b,a] --aaaa
--
false.


*/

/*

?- A = [1,3,4,2], findall( P:J, nth1( J, A, P ), L ), sort( L, S ), reverse( S, R ), findall( J, member( _:J, R ), H ).
A = [1, 3, 4, 2],
L = [1:1, 3:2, 4:3, 2:4],
S = [1:1, 2:4, 3:2, 4:3],
R = [4:3, 3:2, 2:4, 1:1],
H = [3, 2, 4, 1].

?- 
?- allais(_,_,'Q1',_,D), findall( S, ( nth1( J, D, X ), nth1( K, D, Y ), ( X > Y -> S = 1 ; S = 0 ) ), W ) .
D = [5, 1, 1, 5],
W = [0, 1, 1, 0, 0, 0, 0, 0, 0|...] .

?- findall( W, ( allais(_,_,'Q1',_,D), findall( S, ( nth1( J, D, X ), nth1( K, D, Y ), ( X > Y -> S = 1 ; S = 0 ) ), W ) ), H ), maplist( sum_list, H, T ), writeln( T ).
[4,5,3,5,5,3,6,5,4,5,5,5,5,5,5,3,5,0,0,6,0,5,3,5,3,5,5,5,0,6,5,5,4,4,4,5,5,5,5,3,4,0,5,4,6,5,5,0,5,5,4,3,3,5,3,4,3,6,3,4,6,5,3,3,5,0,4,4,3,6,5,4,3,5,6,4,5,0,3,6,5,5,3,6,3,3,5,3,5,5,3,5,5,5,5,5,5,3,3,4,5,0,5,3,5,5,0,5,3,5,6,5,3,5,6,4]
H = [[0, 1, 1, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 1, 0, 0|...], [0, 1, 0, 0, 0, 0|...], [0, 1, 1, 0, 0|...], [0, 0, 0, 0|...], [0, 1, 0|...], [0, 0|...], [0|...], [...|...]|...],
T = [4, 5, 3, 5, 5, 3, 6, 5, 4|...].


*/


pickup_by_ranking( [ ], _, R, R ).

pickup_by_ranking( L, P, H, R ):-
	 member( P:K, L ),
	 subtract( L, [ P:K ], L1 ),
	 pickup_by_ranking( L1, P, [ K | H ], R ).

pickup_by_ranking( L, P, H, R ):-
	 \+ member( P:_, L ),
	 member( Q:J, L ),
	 subtract( L, [ Q:J ], L1 ),
	 pickup_by_ranking( L1, Q, [ J | H ], R ),
	 !.

pickup_by_ranking( L, P, R ):-
	 sort( L, S ),
	 pickup_by_ranking( S, P, [ ], R ).

/*

?- subtract( [1,1,1,1], [1], N ). 
N = [].

?- subtract( [1:a,1:b,1:a,1:c], [1:A], N ).
A = a,
N = [1:b, 1:c].

?- allais( _,_,'Q1',_,A), findall( P:J, nth1( J, A, P ), L ).
A = [5, 1, 1, 5],
L = [5:1, 1:2, 1:3, 5:4] .

?- allais( _,_,'Q1',_,A), findall( P:J, nth1( J, A, P ), L ), pickup_by_ranking(L,O,[],R).
false.

?- allais( _,_,'Q1',_,A), findall( P:J, nth1( J, A, P ), L ), !, pickup_by_ranking(L,O,R), writeln( R ), fail.
[4,1,3,2]
[4,1,2,3]
[3,2,4,1]
[3,2,1,4]
false.

?- hist1n( ( allais( _,_,'Q1',_,A), findall( P:J, nth1( J, A, P ), L ), pickup_by_ranking(L,O,R) ), R ).

 [[1,2,3,4],28]
 [[1,2,4,3],29]
 [[1,3,2,4],32]
 [[1,3,4,2],23]
 [[1,4,2,3],32]
 [[1,4,3,2],33]
 [[2,1,3,4],25]
 [[2,1,4,3],23]
 [[2,3,1,4],29]
 [[2,3,4,1],24]
 [[2,4,1,3],27]
 [[2,4,3,1],26]
 [[3,1,2,4],37]
 [[3,1,4,2],32]
 [[3,2,1,4],39]
 [[3,2,4,1],33]
 [[3,4,1,2],16]
 [[3,4,2,1],24]
 [[4,1,2,3],34]
 [[4,1,3,2],33]
 [[4,2,1,3],44]
 [[4,2,3,1],28]
 [[4,3,1,2],44]
 [[4,3,2,1],47]
total:742
true.



*/

allais_attention_ranking( Q, Y-Id, A, R ):-
	 allais( Y,Id,Q,_,A),
	 findall( P:J, nth1( J, A, P ), L ),
	 pickup_by_ranking(L,_,R).

/*

?- hist1n( allais_attention_ranking( 'Q1', _, _, R ), R ).

?- hist1n( ( permutation( [1,2,4], P ), allais_attention_ranking( 'Q1', _, _, R ), partial_ranking_of( R, P ) ), P ).

 [[1,2,4],126]
 [[1,4,2],120]
 [[2,1,4],116]
 [[2,4,1],110]
 [[4,1,2],127]
 [[4,2,1],143]
total:742
true.


?- hist1n( ( permutation( [1,2,4], P ), allais( _,_,'Q1', _, R ), \+ ( append( _, [J|T], P ), member( K, T), nth1( J,R,A ), nth1( K, R, B), B>=A ) ), P ).

 [[1,2,4],8]
 [[1,4,2],12]
 [[2,4,1],1]
 [[4,1,2],9]
 [[4,2,1],8]
total:38
true.

*/

% modified: 7 Aug 2024

partial_rank( P, R ):-
	 \+ (
		 append( _, [ A | T ], P ),
		 member( B, T ),
		 nth1( J, R, A ),
		 nth1( K, R, B ),
		 J >= K
	 ).

/*

?- list_projection( _,[1,2,3,4], P ), partial_rank( P,[1,2,3,4] ).
P = [] ;
P = [4] ;
P = [3] ;
P = [3, 4] ;
P = [2] ;
P = [2, 4] ;
P = [2, 3] ;
P = [2, 3, 4] ;
P = [1] ;
P = [1, 4] ;
P = [1, 3] ;
P = [1, 3, 4] ;
P = [1, 2] ;
P = [1, 2, 4] ;
P = [1, 2, 3] ;
P = [1, 2, 3, 4].

*/

weak_partial_rank( P, R ):-
	 \+ (
		 append( _, [ A | T ], P ),
		 member( B, T ),
		 nth1( J, R, A ),
		 nth1( K, R, B ),
		 J > K
	 ).


partial_strict_rank_value( P, R ):-
	 \+ (
		 append( _, [ J | T ], P ), % ex. P = [ 3,1,2 ], R = [ 2,3,5,1 ]
		 member( K, T ),   		% R(3) = 5 > R(1)=2 > R(2)= 3. ok.
		 nth1( J, R, A ),
		 nth1( K, R, B ),
		 B >= A
	 ).

partial_rank_value( P, R ):-
	 \+ (
		 append( _, [ J | T ], P ), % ex. P = [ 3,1,2 ], R = [ 2,3,5,1 ]
		 member( K, T ),   		% R(3) = 5 > R(1)=2 > R(2)= 3. ok.
		 nth1( J, R, A ),
		 nth1( K, R, B ),
		 B > A
	 ).


allais_partial_attentional_rank( Q, P, Y-Id-C, R ):-
	 allais( Y, Id, Q, C, R ),
	 partial_strict_rank_value( P, R ).

allais_weak_partial_attentional_rank( Q, P, Y-Id-C, R ):-
	 allais( Y, Id, Q, C, R ),
	 partial_rank_value( P, R ).

% added: 7 Aug 2024

strictness_of_partial_rank( P, R, D ):-
	 findall( F, (
		 append( _, [ J | T ], P ),
		 member( K, T ),
		 nth1( J, R, A ),
		 nth1( K, R, B ),
		 F is B - A
	 ), L ),
	 max_list( L, M ),
	 M  =< 0,
	 findall( 1, ( member( X, L ), X < 0 ), H ),
	 length( H, D ).

allais_strictness_of_partial_attentional_rank( Q, P, Y-Id-C, R, D ):-
	 allais( Y, Id, Q, C, R ),
	 strictness_of_partial_rank( P, R, D ).

/*

?- allais_strictness_of_partial_attentional_rank( 'Q1', [1,2,3,4],  Y-Id-A, R, D ).
Y = 2012,
Id = 13,
A = 'A',
R = [4, 2, 2, 1],
D = 5 .

*/


/*

?- hist1n( ( permutation( [1,2,3,4], P ), allais_partial_attentional_rank( 'Q1', P,  Y-Id-A, R ) ), P ).

 [[1,3,4,2],1]
 [[1,4,3,2],4]
 [[2,4,3,1],1]
 [[3,1,2,4],1]
 [[3,1,4,2],1]
 [[3,4,2,1],1]
 [[4,2,3,1],1]
 [[4,3,1,2],1]
 [[4,3,2,1],1]
total:12
true.

?- hist1n( ( permutation( [1,2,3,4], P ), allais_weak_partial_attentional_rank( 'Q1', P,  Y-Id-A, R ) ), P ).

 [[1,2,3,4],19]
 [[1,2,4,3],16]
 [[1,3,2,4],28]
 [[1,3,4,2],40]
 [[1,4,2,3],22]
 [[1,4,3,2],49]
 [[2,1,3,4],11]
 [[2,1,4,3],12]
 [[2,3,1,4],11]
 [[2,3,4,1],17]
 [[2,4,1,3],12]
 [[2,4,3,1],18]
 [[3,1,2,4],24]
 [[3,1,4,2],34]
 [[3,2,1,4],13]
 [[3,2,4,1],24]
 [[3,4,1,2],28]
 [[3,4,2,1],26]
 [[4,1,2,3],24]
 [[4,1,3,2],44]
 [[4,2,1,3],18]
 [[4,2,3,1],25]
 [[4,3,1,2],35]
 [[4,3,2,1],26]
total:576
true.

?- hist( ( permutation( [1,2,3,4], P ), allais_weak_partial_attentional_rank( 'Q1', P,  Y-Id-A, R ) ), P ).

******************* [[1,2,3,4],19]
**************** [[1,2,4,3],16]
**************************** [[1,3,2,4],28]
**************************************** [[1,3,4,2],40]
********************** [[1,4,2,3],22]
************************************************* [[1,4,3,2],49]
*********** [[2,1,3,4],11]
************ [[2,1,4,3],12]
*********** [[2,3,1,4],11]
***************** [[2,3,4,1],17]
************ [[2,4,1,3],12]
****************** [[2,4,3,1],18]
************************ [[3,1,2,4],24]
********************************** [[3,1,4,2],34]
************* [[3,2,1,4],13]
************************ [[3,2,4,1],24]
**************************** [[3,4,1,2],28]
************************** [[3,4,2,1],26]
************************ [[4,1,2,3],24]
******************************************** [[4,1,3,2],44]
****************** [[4,2,1,3],18]
************************* [[4,2,3,1],25]
*********************************** [[4,3,1,2],35]
************************** [[4,3,2,1],26]
false.

?- hist( ( permutation( [1,2,3,4], P ), partial_ranking_of( P, [2,1,4] ), allais_weak_partial_attentional_rank( 'Q1', P,  Y-Id-A, R ) ), P ).

*********** [[2,1,3,4],11]
************ [[2,1,4,3],12]
*********** [[2,3,1,4],11]
************* [[3,2,1,4],13]
false.

?- hist_b( ( permutation( [1,2,3,4], P ), allais_weak_partial_attentional_rank( 'Q1', P,  Y-Id-A, R ) ), P, B ), atomic_list_concat( P, CL ), assert( tmp_hist( allais-'Q1', CL, B ) ), fail.
false.

?- tmp_hist(A,B,C).
A = allais-'Q1',
B = '2134',
C = 11 .

?- bagof( B:C, tmp_hist(A,B,C), L ), nl, write( L ).

[1234:19,1243:16,1324:28,1342:40,1423:22,1432:49,2134:11,2143:12,2314:11,2341:17,2413:12,2431:18,3124:24,3142:34,3214:13,3241:24,3412:28,3421:26,4123:24,4132:44,4213:18,4231:25,4312:35,4321:26]
A = allais-'Q1',
L = ['1234':19, '1243':16, '1324':28, '1342':40, '1423':22, '1432':49, '2134':11, '2143':12, ... : ...|...].


?- tmp_hb(_, L ), nl, write( L ), fail.

[1243:6,1324:10,1342:20,1423:20,1432:8]
[1243:6,1324:10,1342:20,1423:18,1432:10]
[1243:10,1324:14,1342:22,1423:27,1432:13,4123:6,4132:4]
[1243:6,1324:10,1342:18,1423:20,1432:10]
[1243:15,1324:30,1342:52,1423:29,1432:26,3124:1,3142:1,3412:1,4123:1,4132:2,4312:2]
false.


?- allais_partial_attentional_rank( 'Q1', [2,1,4],  Y-Id-A, R ).
false.

?- allais_partial_attentional_rank( 'Q1', [2,4,1],  Y-Id-A, R ).
Y = '2013a',
Id = 7,
A = 'B',
R = [1, 4, 2, 3] ;
false.

?- allais_strictness_of_partial_attentional_rank( 'Q1', [2,4,1],  Y-Id-A, R, D ).
Y = 2012,
Id = 8,
A = 'B',
R = [2, 4, 3, 2],
D = 3 .

?- 
?- permutation( [1,2,4], P ), allais_partial_attentional_rank( 'Q1', P,  Y-Id-A, R ).
P = [1, 2, 4],
Y = 2012,
Id = 13,
A = 'A',
R = [4, 2, 2, 1] .

?- hist1n( ( permutation( [1,2,4], P ), allais_partial_attentional_rank( 'Q1', P,  Y-Id-A, R ) ), P ).

 [[1,2,4],8]
 [[1,4,2],12]
 [[2,4,1],1]
 [[4,1,2],9]
 [[4,2,1],8]
total:38
true.

?- hist1n( ( permutation( [1,2,4], P ), allais_weak_partial_attentional_rank( 'Q1', P,  Y-Id-A, R ) ), P ).

 [[1,2,4],35]
 [[1,4,2],66]
 [[2,1,4],16]
 [[2,4,1],28]
 [[4,1,2],59]
 [[4,2,1],42]
total:246
true.

?- A = [ [ 2,1,3,4], [2,1,4,3], [2,3,1,4], [2,4,1,3], [3,2,1,4] ], pp( PP ), \+ \+ ( f([_-S],[PP],swf_axiom),member( S, A ) ),  assert(tmp_pp_rare( PP ) ), fail.
false.

?- A = [ [ 2,1,3,4], [2,1,4,3], [2,3,1,4], [2,4,1,3], [3,2,1,4] ], pp( PP ), \+ ( f([_-S],[PP],swf_axiom),member( S, A ) ),  assert(tmp_pp_rare_no( PP ) ), fail.
false.

?- count(tmp_pp_rare_no(I),N ).
N = 265.

?- count(tmp_pp_rare(I),N ).
N = 311.

?- A = [ [ 1,3,4,2], [1,4,3,2], [3,1,4,2], [4,3,1,2] ], pp( PP ), \+ \+ ( f([_-S],[PP],swf_axiom),member( S, A ) ),  assert(tmp_pp_major( PP ) ), fail.
false.

?- A = [ [ 1,3,4,2], [1,4,3,2], [3,1,4,2], [4,3,1,2] ], pp( PP ), \+ ( f([_-S],[PP],swf_axiom),member( S, A ) ),  assert(tmp_pp_major_no( PP ) ), fail.
false.

?- count(tmp_pp_major_no(I),N ).
N = 290.

?- count(tmp_pp_major(I),N ).
N = 286.

?- exclusive_dom_Q1(_,_, D,17),count( ( member(PP,D), tmp_pp_major( PP )), N ).
D = [[[1, 2, 4, 3], [1, 2, 4, 3]], [[1, 2, 4, 3], [1, 4, 2, 3]], [[1, 2, 4, 3], [1, 4, 3, 2]], [[1, 2, 4, 3], [4, 1, 2|...]], [[1, 2, 4|...], [4, 1|...]], [[1, 2|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 11.

?- exclusive_dom_Q1(_,_, D,17),count( ( member(PP,D), tmp_pp_major_no( PP )), N ).
D = [[[1, 2, 4, 3], [1, 2, 4, 3]], [[1, 2, 4, 3], [1, 4, 2, 3]], [[1, 2, 4, 3], [1, 4, 3, 2]], [[1, 2, 4, 3], [4, 1, 2|...]], [[1, 2, 4|...], [4, 1|...]], [[1, 2|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 6.

?- exclusive_dom_Q1(_,_, D,17),count( ( member(PP,D), tmp_pp_rare( PP )), N ).
D = [[[1, 2, 4, 3], [1, 2, 4, 3]], [[1, 2, 4, 3], [1, 4, 2, 3]], [[1, 2, 4, 3], [1, 4, 3, 2]], [[1, 2, 4, 3], [4, 1, 2|...]], [[1, 2, 4|...], [4, 1|...]], [[1, 2|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 0.

?- exclusive_dom_Q1(_,_, D,17),count( ( member(PP,D), tmp_pp_rare_no( PP )), N ).
D = [[[1, 2, 4, 3], [1, 2, 4, 3]], [[1, 2, 4, 3], [1, 4, 2, 3]], [[1, 2, 4, 3], [1, 4, 3, 2]], [[1, 2, 4, 3], [4, 1, 2|...]], [[1, 2, 4|...], [4, 1|...]], [[1, 2|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 17.

?- count( ( tmp_pp_major(PP), \+ tmp_pp_rare( PP )), N ).
N = 174.


*/


/*****

?- hist1n( ( dom_Q1_D14_ring( D ),f( F, D, swf_axiom), member( _-S, F ) ), S ).

 [[1,2,4],8]
 [[1,4,2],40]
 [[4,1,2],40]
 [[4,2,1],8]
total:96
true.

?- hist1n( ( exclusive_dom_Q1(_,_, D,14),f( F, D, swf_axiom), member( _-S, F ) ), S ).

 [[1,2,4],32]
 [[1,4,2],80]
 [[4,1,2],80]
 [[4,2,1],32]
total:224
true.

?- findall( F, ( exclusive_dom_Q1(_,_, D,14),f( F, D, swf_axiom ) ), L ), member( F, L ), findall( S:K, hist_b( member( _-S, F ), S, K ), O ), nl, write( O ), fail.

[[1,2,4]:5,[1,4,2]:5,[4,1,2]:3,[4,2,1]:1]
[[1,2,4]:3,[1,4,2]:7,[4,1,2]:3,[4,2,1]:1]
[[1,2,4]:3,[1,4,2]:4,[4,1,2]:6,[4,2,1]:1]
[[1,2,4]:3,[1,4,2]:7,[4,1,2]:3,[4,2,1]:1]
[[1,2,4]:1,[1,4,2]:9,[4,1,2]:3,[4,2,1]:1]
[[1,2,4]:1,[1,4,2]:6,[4,1,2]:6,[4,2,1]:1]
[[1,2,4]:3,[1,4,2]:4,[4,1,2]:4,[4,2,1]:3]
[[1,2,4]:1,[1,4,2]:6,[4,1,2]:4,[4,2,1]:3]
[[1,2,4]:3,[1,4,2]:4,[4,1,2]:6,[4,2,1]:1]
[[1,2,4]:1,[1,4,2]:6,[4,1,2]:6,[4,2,1]:1]
[[1,2,4]:1,[1,4,2]:3,[4,1,2]:9,[4,2,1]:1]
[[1,2,4]:1,[1,4,2]:3,[4,1,2]:7,[4,2,1]:3]
[[1,2,4]:3,[1,4,2]:4,[4,1,2]:4,[4,2,1]:3]
[[1,2,4]:1,[1,4,2]:6,[4,1,2]:4,[4,2,1]:3]
[[1,2,4]:1,[1,4,2]:3,[4,1,2]:7,[4,2,1]:3]
[[1,2,4]:1,[1,4,2]:3,[4,1,2]:5,[4,2,1]:5]
false.

?- exclusive_dom_Q1(_,_, D,16),write('--'),nl, findall( F, f( F, D, swf_axiom ), L ), findall( S:K, hist_b( (member( F, L ), member( _-S, F ) ), S, K ), O ), nl, write( O ), fail.
--


?- tmp_swf_174( F, D ), findall( V:K, hist_b( ( member( _-S, F ), atomic_list_concat( S, V ) ), V, K ), O ), nl, write( O ), fail.

[1234:6,1243:6,1324:8,1342:16,1423:10,1432:16,2341:1,2431:2,3124:8,3142:16,3241:2,3412:15,3421:7,4123:9,4132:14,4213:5,4231:6,4312:19,4321:8]
[1342:30,1432:32,3142:24,3412:25,4132:28,4312:35]
[1342:30,1432:32,3142:24,3412:25,4132:28,4312:35]
[1234:6,1243:6,1324:8,1342:16,1423:10,1432:16,2341:1,2431:2,3124:8,3142:16,3241:2,3412:15,3421:7,4123:9,4132:14,4213:5,4231:6,4312:19,4321:8]
false.


% Python向けに．[]は{}に変える．

?- tmp_swf_174( F, D ), findall( V:K, hist_b( ( member( _-S, F ), atomic_list_concat( S, V1 ), term_string( V1, V ) ), V, K ), O ), nl, tab(3), write( O ), write(','), fail.

   ['1234':6,'1243':6,'1324':8,'1342':16,'1423':10,'1432':16,'2341':1,'2431':2,'3124':8,'3142':16,'3241':2,'3412':15,'3421':7,'4123':9,'4132':14,'4213':5,'4231':6,'4312':19,'4321':8],
   ['1342':30,'1432':32,'3142':24,'3412':25,'4132':28,'4312':35],
   ['1342':30,'1432':32,'3142':24,'3412':25,'4132':28,'4312':35],
   ['1234':6,'1243':6,'1324':8,'1342':16,'1423':10,'1432':16,'2341':1,'2431':2,'3124':8,'3142':16,'3241':2,'3412':15,'3421':7,'4123':9,'4132':14,'4213':5,'4231':6,'4312':19,'4321':8],
false.


%γ独裁

?- tmp_swf_174( F, D ), scf( H, D ).
false.

?- tmp_swf_174( F, D ), f( H, D, scf_axiom ), assert( tmp_scf_174( H, D ) ), fail.
false.

?- count( tmp_scf_174( H, D ), N ).
N = 152.

?- tmp_scf_174( H, D ), (dictatorial_scf( J, H )-> Dict=J;Dict=0), (non_imposed(H)-> NI=1; NI=0), assert( tmp_scf_174( H, D, Dict, NI ) ), fail.
false.

?- hist1n( tmp_scf_174( H, D, Dict, NI ), Dict:NI ).

 [0:0,144]
 [1:1,4]
 [2:1,4]
total:152
true.

% 注意 ドメインは単一でＳＷＦ（独裁含む）が４個

?- tmp_swf_174(F, D), findall( [X1,Y1], ( member( PP, D ), PP=[X,Y], subtract( X, [3], X1 ), subtract( Y, [3], Y1 ) ), L0 ), sort( L0, L ), assert( tmp_reduced_dom_174( L ) ).

?- chalt( [1, 2,4]), tmp_reduced_dom_174( L ), \+ (f( F,L,swf_axiom), fig(swf,F)).

          123456
1:[1,2,4] -2--2-
2:[1,4,2] 22--22
3:[2,1,4] ------
4:[2,4,1] ----5-
5:[4,1,2] 22-555
6:[4,2,1] -2--5-
--

?- tmp_swf_174( _, D ), !, between(1,4,J), subtract([1,2,3,4], [J], E), chalt(E), findall( [X1,Y1], ( member( PP, D ), PP=[X,Y], subtract( X, [J], X1 ), subtract( Y, [J], Y1 ) ), L0 ), sort( L0, L ), \+ ( f( G,L,swf_axiom), nl, write([-J] ), fig(swf,G) ).

[- 1]
          123456
1:[2,3,4] ---4-6
2:[2,4,3] ---4-6
3:[3,2,4] ---456
4:[3,4,2] 123456
5:[4,2,3] --34-6
6:[4,3,2] 123456
--
[- 2]
          123456
1:[1,3,4] 123456
2:[1,4,3] 123456
3:[3,1,4] 123456
4:[3,4,1] 123-56
5:[4,1,3] 1234-6
6:[4,3,1] 123456
--
[- 3]
          123456
1:[1,2,4] -2--2-
2:[1,4,2] 22--22
3:[2,1,4] ------
4:[2,4,1] ----5-
5:[4,1,2] 22-555
6:[4,2,1] -2--5-
--
[- 4]
          123456
1:[1,2,3] -2--56
2:[1,3,2] 123456
3:[2,1,3] -2--5-
4:[2,3,1] -2--5-
5:[3,1,2] 123456
6:[3,2,1] 12--5-
--
false.

?- tmp_swf_174( _, D ), !, between(1,4,J), subtract([1,2,3,4], [J], E), chalt(E), findall( [X1,Y1], ( member( PP, D ), PP=[X,Y], subtract( X, [J], X1 ), subtract( Y, [J], Y1 ) ), L0 ), sort( L0, L ), \+ ( f( G,L,scf_axiom), non_imposed( G ), nl, write([-J] ), fig(scf,G) ).

[- 1]
          123456
1:[2,3,4] ---3-4
2:[2,4,3] ---3-4
3:[3,2,4] ---344
4:[3,4,2] 223344
5:[4,2,3] --33-4
6:[4,3,2] 223344
--
[- 2]
          123456
1:[1,3,4] 113344
2:[1,4,3] 113344
3:[3,1,4] 113344
4:[3,4,1] 113-44
5:[4,1,3] 1133-4
6:[4,3,1] 113344
--
[- 3]
          123456
1:[1,2,4] -1--1-
2:[1,4,2] 11--11
3:[2,1,4] ------
4:[2,4,1] ----2-
5:[4,1,2] 11-244
6:[4,2,1] -1--4-
--
[- 4]
          123456
1:[1,2,3] -1--33
2:[1,3,2] 112233
3:[2,1,3] -1--3-
4:[2,3,1] -1--3-
5:[3,1,2] 112233
6:[3,2,1] 11--3-
--
false.

?- tmp_swf_174( _, D ), !, between(1,4,J), subtract([1,2,3,4], [J], E), chalt(E), findall( [X1,Y1], ( member( PP, D ), PP=[X,Y], subtract( X, [J], X1 ), subtract( Y, [J], Y1 ) ), L0 ), sort( L0, L ), f( G,L,scf_axiom), non_imposed( G ), \+ dictatorial_scf(_,G), nl, write([-J] ), fig(scf,G), fail.

[- 3]
          123456
1:[1,2,4] -1--1-
2:[1,4,2] 11--11
3:[2,1,4] ------
4:[2,4,1] ----2-
5:[4,1,2] 11-244
6:[4,2,1] -1--4-
--
[- 3]
          123456
1:[1,2,4] -1--1-
2:[1,4,2] 11--11
3:[2,1,4] ------
4:[2,4,1] ----4-
5:[4,1,2] 11-244
6:[4,2,1] -1--4-
--
[- 3]
          123456
1:[1,2,4] -1--1-
2:[1,4,2] 11--11
3:[2,1,4] ------
4:[2,4,1] ----2-
5:[4,1,2] 11-444
6:[4,2,1] -1--4-
--
false.

?- findall( PP, (pp(PP), \+ member( [2,1,4], PP) ), D ),  swf( F,D), fig( swf, F ), fail.

          123456
1:[1,2,4] 12-122
2:[1,4,2] 22-222
3:[2,1,4] ------
4:[2,4,1] 12-456
5:[4,1,2] 22-555
6:[4,2,1] 22-656
--
          123456
1:[1,2,4] 12-456
2:[1,4,2] 22-656
3:[2,1,4] ------
4:[2,4,1] 12-456
5:[4,1,2] 22-656
6:[4,2,1] 22-656
--
          123456
1:[1,2,4] 12-122
2:[1,4,2] 22-222
3:[2,1,4] ------
4:[2,4,1] 46-466
5:[4,1,2] 55-555
6:[4,2,1] 66-666
--
          123456
1:[1,2,4] 12-456
2:[1,4,2] 22-656
3:[2,1,4] ------
4:[2,4,1] 46-466
5:[4,1,2] 55-656
6:[4,2,1] 66-666
--
false.

?- findall( PP, (pp(PP), \+ member( [2,1,4], PP) ), D ),  f( F,D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( _, F ), fig( scf, F ), fail.

          123456
1:[1,2,4] 11-111
2:[1,4,2] 11-111
3:[2,1,4] ------
4:[2,4,1] 11-244
5:[4,1,2] 11-444
6:[4,2,1] 11-444
--
          123456
1:[1,2,4] 11-244
2:[1,4,2] 11-444
3:[2,1,4] ------
4:[2,4,1] 11-244
5:[4,1,2] 11-444
6:[4,2,1] 11-444
--
          123456
1:[1,2,4] 11-111
2:[1,4,2] 11-111
3:[2,1,4] ------
4:[2,4,1] 24-244
5:[4,1,2] 44-444
6:[4,2,1] 44-444
--
          123456
1:[1,2,4] 11-244
2:[1,4,2] 11-444
3:[2,1,4] ------
4:[2,4,1] 24-244
5:[4,1,2] 44-444
6:[4,2,1] 44-444
--
false.

?- findall( PP, (s1(S), m1(M), pp( PP ), \+ member( PP,S), \+ member( PP, M ) ), D ),  f( F,D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( _, F ), fig( scf, F ).
false.

?- findall( PP, (s2(S), m1(M), pp( PP ), \+ member( PP,S), \+ member( PP, M ) ), D ),  f( F,D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( _, F ), fig( scf, F ).

          123456
1:[1,2,4] 11-1--
2:[1,4,2] 11111-
3:[2,1,4] 1-2212
4:[2,4,1] --224-
5:[4,1,2] 1---44
6:[4,2,1] 11-244

?-

?- chalt( [1,2,4] ),  findall( PP, ( pp(PP), PP \= [[2,1,4],_] ), D ), length(D,N), f( F, D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( _, F ), fig( scf, F ), fail.

          123456
1:[1,2,4] 111111
2:[1,4,2] 111111
3:[2,1,4] ------
4:[2,4,1] 242244
5:[4,1,2] 444444
6:[4,2,1] 444444
--
false.

?- chalt( [1,2,4] ),  findall( PP, ( pp(PP), PP \= [[2,1,4],_] ), D ), length(D,N), f( F, D, swf_axiom ), \+ dictatorial_swf( _, F ), fig( swf, F ), fail.

          123456
1:[1,2,4] 121122
2:[1,4,2] 222222
3:[2,1,4] ------
4:[2,4,1] 464466
5:[4,1,2] 555555
6:[4,2,1] 666666
--
false.

?- findall( PP, (s(S), m(M), pp( PP ), \+ member( PP,S), \+ member( PP, M ) ), D ),  f( F,D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( _, F ), fig( scf, F ).

          123456
1:[1,2,4] 22----
2:[1,4,2] 24----
3:[2,1,4] --11--
4:[2,4,1] --11--
5:[4,1,2] ----11
6:[4,2,1] ----11
--
D = [[[1, 2, 4], [1, 2, 4]], [[1, 2, 4], [1, 4, 2]], [[1, 4, 2], [1, 2, 4]], [[1, 4, 2], [1, 4, 2]], [[2, 1, 4], [2, 1|...]], [[2, 1|...], [2|...]], [[2|...], [...|...]], [[...|...]|...], [...|...]|...],
F = [[[1, 2, 4], [1, 2, 4]]-2, [[1, 2, 4], [1, 4, 2]]-2, [[1, 4, 2], [1, 2, 4]]-2, [[1, 4, 2], [1, 4|...]]-4, [[2, 1|...], [2|...]]-1, [[2|...], [...|...]]-1, [[...|...]|...]-1, [...|...]-1, ... - ...|...] .

?- findall( PP, (m1(S), m2(M), pp( PP ), \+ member( PP,S), \+ member( PP, M ) ), D ),  f( F,D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( _, F ), fig( scf, F ).

          123456
1:[1,2,4] 111--1
2:[1,4,2] 11-11-
3:[2,1,4] 1-221-
4:[2,4,1] -122-2
5:[4,1,2] -11-44
6:[4,2,1] 1--244
--
D = [[[1, 2, 4], [1, 2, 4]], [[1, 2, 4], [1, 4, 2]], [[1, 2, 4], [2, 1, 4]], [[1, 2, 4], [4, 2, 1]], [[1, 4, 2], [1, 2|...]], [[1, 4|...], [1|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
F = [[[1, 2, 4], [1, 2, 4]]-1, [[1, 2, 4], [1, 4, 2]]-1, [[1, 2, 4], [2, 1, 4]]-1, [[1, 2, 4], [4, 2|...]]-1, [[1, 4|...], [1|...]]-1, [[1|...], [...|...]]-1, [[...|...]|...]-1, [...|...]-1, ... - ...|...] .

?- findall( PP, (s1(S), s2(M), pp( PP ), \+ member( PP,S), \+ member( PP, M ) ), D ),  f( F,D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( _, F ), fig( scf, F ).

          123456
1:[1,2,4] 11-21-
2:[1,4,2] 111--1
3:[2,1,4] -122-2
4:[2,4,1] 2-222-
5:[4,1,2] 1--244
6:[4,2,1] -12-44
--
D = [[[1, 2, 4], [1, 2, 4]], [[1, 2, 4], [1, 4, 2]], [[1, 2, 4], [2, 4, 1]], [[1, 2, 4], [4, 1, 2]], [[1, 4, 2], [1, 2|...]], [[1, 4|...], [1|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
F = [[[1, 2, 4], [1, 2, 4]]-1, [[1, 2, 4], [1, 4, 2]]-1, [[1, 2, 4], [2, 4, 1]]-2, [[1, 2, 4], [4, 1|...]]-1, [[1, 4|...], [1|...]]-1, [[1|...], [...|...]]-1, [[...|...]|...]-1, [...|...]-1, ... - ...|...] .

?- 

*/

findall_greater_than_relation( L, G ):-
	findall( W, (
		 member( D, L ),
		 findall( X > Y, (
			 nth1( _, D, X ),
			 nth1( _, D, Y ),
			 X > Y
		 ), W )
	 ), G ).

findall_greater_than_frequencies( L, H, T ):-
	findall( W, (
		 member( D, L ),
		 findall( S, (
			 nth1( _, D, X ),
			 nth1( _, D, Y ),
			 ( X > Y -> S = 1 ; S = 0 )
		 ), W )
	 ), H ),
	 maplist( sum_list, H, T ).

findall_not_smaller_than_frequencies( L, H, T ):-
	findall( W, (
		 member( D, L ),
		 findall( S, (
			 nth1( _, D, X ),
			 nth1( _, D, Y ),
			 ( X >= Y -> S = 1 ; S = 0 )
		 ), W )
	 ), H ),
	 maplist( sum_list, H, T ).

findall_gt_frequencies_for_Q1( D, H, T ):-
	 findall( D, allais(_,_,'Q1',_,D ), L ),
	 findall_greater_than_frequencies( L, H, T ).

findall_nst_frequencies_for_Q1( D, H, T ):-
%	 findall( D, allais(_,_,'Q1',_,D ), L ),
	 D = [D1,D2,_,D4],
	 findall( [D1,D2,D4], allais(_,_,'Q1',_,D ), L ),
	 findall_not_smaller_than_frequencies( L, H, T ).
%	 findall_weak_order_frequencies( D, H, T ).

/*

?- findall_nst_frequencies_for_Q1( D, H, T ).
H = [[1, 1, 1, 1, 0, 1, 1, 0|...], [1, 0, 0, 0, 1, 1, 1|...], [1, 1, 1, 1, 0, 1|...], [1, 1, 1, 1, 0|...], [1, 1, 0, 0|...], [1, 1, 1|...], [1, 0|...], [1|...], [...|...]|...],
T = [12, 11, 13, 11, 11, 13, 10, 11, 12|...].


?- findall_gt_frequencies_for_Q1( D, H, T ), length( H, N ), length( T, M ).
H = [[0, 1, 1, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 1, 0, 0|...], [0, 1, 0, 0, 0, 0|...], [0, 1, 1, 0, 0|...], [0, 0, 0, 0|...], [0, 1, 0|...], [0, 0|...], [0|...], [...|...]|...],
T = [4, 5, 3, 5, 5, 3, 6, 5, 4|...],
N = M, M = 116.


?- Z=[1,2,4], chalt(Z), exclusive_dom_Q1( _,_,D,14 ), f( F, D, swf_axiom), findall( Q, ( member( _-S, F ) ), L ), findall( T, ( member( Q, L ), member( A, Z ), member( B, Z ), (r( [A,B], Q ) -> T = 1 ; T = 0 ) ), H ), nl, write( H ), length( H,N ).

[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
Z = [1, 2, 4],
D = [[[1, 2, 4], [1, 2, 4]], [[1, 2, 4], [1, 4, 2]], [[1, 2, 4], [4, 1, 2]], [[1, 4, 2], [1, 2, 4]], [[1, 4, 2], [1, 4|...]], [[1, 4|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
F = [[[1, 2, 4], [1, 2, 4]]-[1, 2, 4], [[1, 2, 4], [1, 4, 2]]-[1, 2, 4], [[1, 2, 4], [4, 1, 2]]-[1, 2, 4], [[1, 4, 2], [1, 2|...]]-[1, 2, 4], [[1, 4|...], [1|...]]-[1, 4, 2], [[1|...], [...|...]]-[1, 4|...], [[...|...]|...]-[1|...], [...|...]-[...|...], ... - ...|...],
L = [_, _, _, _, _, _, _, _, _|...],
H = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
N = 126 .

?- Z=[1,2,4], chalt(Z), exclusive_dom_Q1( _,_,D,14 ), findall( H, ( f( F, D, swf_axiom), findall( Q, ( member( _-S, F ) ), L ), findall( T, ( member( Q, L ), member( A, Z ), member( B, Z ), (r( [A,B], Q ) -> T = 1 ; T = 0 ) ), H ) ), I ), maplist( sum_list, I, Total ).
Z = [1, 2, 4],
D = [[[1, 2, 4], [1, 2, 4]], [[1, 2, 4], [1, 4, 2]], [[1, 2, 4], [4, 1, 2]], [[1, 4, 2], [1, 2, 4]], [[1, 4, 2], [1, 4|...]], [[1, 4|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
I = [[1, 1, 1, 1, 1, 1, 1, 1|...], [1, 1, 1, 1, 1, 1, 1|...], [1, 1, 1, 1, 1, 1|...], [1, 1, 1, 1, 1|...], [1, 1, 1, 1|...], [1, 1, 1|...], [1, 1|...], [1|...], [...|...]|...],
Total = [126, 126, 126, 126, 126, 126, 126, 126, 126|...].


*/

arrow_and_gs_rings_renamed( T, W ):-
	 s(S),
	 m(M),
	 union( S,M,V ),
	 findall( Y, (
		 member( X, V ),
		 pp_xyz_renamed( X, [a,b,c], T, Y )
	 ), W ).

dom_Q1_D14_ring( D ):-
	 xyz( 'Q1', T ),
	 arrow_and_gs_rings_renamed( T, W ),
	 exclusive_dom_Q1(_,_, D1,14),
	 findall( X, (
		 member( X, D1 ),
		 member( X, W )
	 ), D ).

dom_Q1_D14_ring_renamed( D ):-
	 s(S),
	 m(M),
	 union( S,M,V ),
	 exclusive_dom_Q1(_,_, D1,14),
	 findall( Y, (
		 xyz( 'Q1', T ),
		 member( X, D1 ),
		 pp_xyz_renamed( X, T, [a,b,c], Y ),
		 member( Y, V )
	 ), D ).

/*

?- [exclusive_dom_Q1_124].
true.

?- dom_Q1_D14_ring( D ).
D = [[[1, 2, 4], [4, 1, 2]], [[1, 4, 2], [4, 1, 2]], [[1, 4, 2], [4, 2, 1]], [[4, 1, 2], [1, 2, 4]], [[4, 1, 2], [1, 4|...]], [[4, 2|...], [1|...]]].

?- dom_Q1_D14_ring_renamed( D ).
D = [[[b, a, c], [c, b, a]], [[b, c, a], [c, b, a]], [[b, c, a], [c, a, b]], [[c, b, a], [b, a, c]], [[c, b, a], [b, c|...]], [[c, a|...], [b|...]]].

?- dom_Q1_D14_ring_renamed( D ), f( F, D, swf_axiom), fig(swf, F ).

          123456
1:[a,b,c] ------
2:[a,c,b] ------
3:[b,a,c] -----3
4:[b,c,a] ----44
5:[c,a,b] ---4--
6:[c,b,a] --34--
--
D = [[[b, a, c], [c, b, a]], [[b, c, a], [c, b, a]], [[b, c, a], [c, a, b]], [[c, b, a], [b, a, c]], [[c, b, a], [b, c|...]], [[c, a|...], [b|...]]],
F = [[[b, a, c], [c, b, a]]-[b, a, c], [[b, c, a], [c, b, a]]-[b, c, a], [[b, c, a], [c, a, b]]-[b, c, a], [[c, b, a], [b, a|...]]-[b, a, c], [[c, b|...], [b|...]]-[b, c, a], [[c|...], [...|...]]-[b, c|...]] .


?- chalt([1,2,4]), dom_Q1_D14_ring( D ), f( F, D, swf_axiom), fig(swf, F ).

          123456
1:[1,2,4] ----1-
2:[1,4,2] ----22
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 12----
6:[4,2,1] -2----
--
D = [[[1, 2, 4], [4, 1, 2]], [[1, 4, 2], [4, 1, 2]], [[1, 4, 2], [4, 2, 1]], [[4, 1, 2], [1, 2, 4]], [[4, 1, 2], [1, 4|...]], [[4, 2|...], [1|...]]],
F = [[[1, 2, 4], [4, 1, 2]]-[1, 2, 4], [[1, 4, 2], [4, 1, 2]]-[1, 4, 2], [[1, 4, 2], [4, 2, 1]]-[1, 4, 2], [[4, 1, 2], [1, 2|...]]-[1, 2, 4], [[4, 1|...], [1|...]]-[1, 4, 2], [[4|...], [...|...]]-[1, 4|...]] .

?- findall( 1, ( dom_Q1_D14_ring( D ),f( F, D, swf_axiom) ), L),length(L,N).
L = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
N = 16.

****


?- exclusive_dom_Q1(_,_, D,14), findall( QP, ( member( PP, D ), pp_extended_with( 3, PP, QP ) ), H ), length( H, N).
D = [[[1, 2, 4], [1, 2, 4]], [[1, 2, 4], [1, 4, 2]], [[1, 2, 4], [4, 1, 2]], [[1, 4, 2], [1, 2, 4]], [[1, 4, 2], [1, 4|...]], [[1, 4|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
H = [[[3, 1, 2, 4], [3, 1, 2, 4]], [[3, 1, 2, 4], [1, 3, 2, 4]], [[3, 1, 2, 4], [1, 2, 3, 4]], [[3, 1, 2, 4], [1, 2, 4|...]], [[1, 3, 2|...], [3, 1|...]], [[1, 3|...], [1|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 224.

?- exclusive_dom_Q1(_,_, D,14), findall( QP, ( member( PP, D ), pp_extended_with( 3, PP, QP ) ), Dx ), is_an_exclusive_domain_Q1( Dx ).

... so long.

?- dom_Q1_D14_ring( D ), findall( QP, ( member( PP, D ), pp_extended_with( 3, PP, QP ) ), H ), length( H, N).
D = [[[1, 2, 4], [4, 1, 2]], [[1, 4, 2], [4, 1, 2]], [[1, 4, 2], [4, 2, 1]], [[4, 1, 2], [1, 2, 4]], [[4, 1, 2], [1, 4|...]], [[4, 2|...], [1|...]]],
H = [[[3, 1, 2, 4], [3, 4, 1, 2]], [[3, 1, 2, 4], [4, 3, 1, 2]], [[3, 1, 2, 4], [4, 1, 3, 2]], [[3, 1, 2, 4], [4, 1, 2|...]], [[1, 3, 2|...], [3, 4|...]], [[1, 3|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 96.


*/





% 30 Jun 2024

% cite: allais_game_potential.pl(2021)
sub_list([], [], []).
sub_list([X|Y], [1|B], [X|A]) :-
	 sub_list(Y, B, A).
sub_list([_|Y], [0|B], A) :-
	 sub_list(Y, B, A).

choose_n_members( P, N, S ):-  
	 nth1( N, P, _ ),
	 length( S, N ),
	 sub_list( P, _, S ).

decreasingly_choose_n_members( P, K, H ):-  
	 length( P, N ),
	 length( S, N ),
	 nth1( J, P, _ ),
	 length( T, J ),
	 append( H, T, S ), 
	 length( H, K ),
	 sub_list( P, _, H ).

%-----------------------------------------------------------------
% generating exclusive domain
%-----------------------------------------------------------------
% 26,29-30 Jun 2024
% 2 Jul 2024

is_not_same_binary_ranking( [ A, B ], R, S ):-
	r( [ A, B ], R ),
	\+ r( [ A, B ] , S ),
	!.

is_not_same_binary_ranking( [ A, B ], R, S ):-
	r( [ A, B ], S ),
	\+ r( [ A, B ] , R ).

f_value_coincides_for_the_profile( F, XP, R, PP-S ):-
	member( PP - S, F ),
	member( R, XP ),
%	\+ is_not_same_binary_ranking( _, R, S ).
	partial_ranking_of( S, R ). 

domain_to_exclude( XP, D, F,  R, PP-S ):-
	 f( F, D, swf_axiom ),
	 f_value_coincides_for_the_profile( F, XP, R, PP-S ).

is_an_exclusive_domain( XP, D ):-
	 \+ domain_to_exclude( XP, D, _,  _, _ ).

is_an_exclusive_domain_Q1( D ):-
	 XP = [[2,1,4],[2,1,3],[2,3,4],[2,4,1]],
	 is_an_exclusive_domain( XP, D ).


exclusive_swf( F, D, XP ):-
	swf( F, D ),
	\+ f_value_coincides_for_the_profile( F, XP, _, _ ).


most_precedent( PP, H ):-
	 \+ (
		member( QP, H ),
		QP @=< PP
	 ).


exclusive_domain( _, D, D ).
exclusive_domain( XP, H, D ):-
	 pp( PP ),
	 most_precedent_in_list( PP, H ),
%	 is_an_exclusive_domain_Q1( [ PP | H ] ),
	 is_an_exclusive_domain( XP, [ PP | H ] ),
	 exclusive_domain( XP, [ PP | H ], D ).

exclusive_domain( XList, D ):-
	 exclusive_domain( XList, [ ], D ).

exclusive_triples( Q, XP ):-
	 question( Q ),
	 findall( R, xyz( Q, R ), XP ).


exclusive_domain_Q1( D ):-
	 XP = [[2,1,4],[2,1,3],[2,3,4],[2,4,1]],
	 exclusive_domain( XP, D ).

exclusive_domain_Q2( D ):-
	 exclusive_triples( 'Q2', XP ),
	 exclusive_domain( XP, D ).

exclusive_domain_Q3( D ):-
	 exclusive_triples( 'Q3', XP ),
	 exclusive_domain( XP, D ).

exclusive_domain_Q4( D ):-
	 exclusive_triples( 'Q4', XP ),
	 exclusive_domain( XP, D ).


allais_attention_chalt( Q ):-
	 question( Q ),
	 allais( _, _, Q, _, L ),
	 !,
	 findall( J, nth1( J, L, _ ), A ),
	 chalt( A ).

/*

?- allais_attention_chalt( 'Q3' ), alternatives(A).
A = [1, 2, 3, 4, 5, 6].

*/

exclusive_profile( Q, XP, PP ):-
	 exclusive_triples( Q, XP ),
	 pp( PP ),
	 \+ (
		 f( F, [ PP ], swf_axiom ),
		 f_value_coincides_for_the_profile( F, XP, _, _ )
	 ).

/*

?- allais_attention_chalt( 'Q3' ),exclusive_profile( 'Q3', XP, PP ).
XP = [[3, 1, 4], [3, 1, 5], [3, 1, 6], [4, 2, 5], [4, 3, 1], [4, 3, 5], [4, 3|...], [1|...], [...|...]|...],
PP = [[1, 2, 5, 4, 6, 3], [1, 2, 5, 4, 6, 3]] .

*/


ranking_chosen_over_K_times( Q, P, K ):-
	 findall( 1, attention( Q, _ ), L ),
	 findall( J, nth1( J, L, _ ), A ),
	 hist_b( (
		 permutation( A, P ),
		 allais_weak_partial_attentional_rank( Q, P, _, _ )
	 ), P, N ),
	 N  > K. 


inclusive_profile( Q, K, PP ):-
	 pp( PP ),
	 \+ \+ (
		 f( [ _-S ], [ PP ], swf_axiom ),
		 ranking_chosen_over_K_times( Q, S, K )
	 ).


/*


 ?- inclusive_profile( 'Q3', 32, PP ).PP = [[1, 2, 5, 4, 6, 3], [1, 2, 5, 4, 6, 3]] ;
PP = [[1, 2, 3, 4, 5, 6], [1, 2, 5, 4, 6, 3]] ;
PP = [[1, 2, 3, 4, 5, 6], [1, 2, 5, 6, 4, 3]] ;
PP = [[1, 2, 3, 4, 5, 6], [1, 2, 6, 5, 4, 3]] ;
PP = [[1, 2, 3, 4, 5, 6], [1, 5, 2, 4, 6, 3]] ;
PP = [[1, 2, 3, 4, 5, 6], [1, 5, 2, 6, 4, 3]] ....


*/

effective_profile( Q, K, PP ):-
	 allais_attention_chalt( Q ),
	 inclusive_profile( Q, K, PP ),
	 \+ exclusive_profile( Q, _, PP ).

/*

?- go.

データ-のデータを読み込みました。
データの準備ができました
true.

?- allais_attention_chalt( 'Q3' ),effective_profile( 'Q3', 32, PP ).
PP = [[1, 2, 3, 4, 5, 6], [1, 2, 5, 4, 6, 3]] ;
PP = [[1, 2, 3, 4, 5, 6], [1, 2, 5, 6, 4, 3]] ;
PP = [[1, 2, 3, 4, 5, 6], [1, 2, 6, 5, 4, 3]] ;
PP = [[1, 2, 3, 4, 5, 6], [1, 5, 2, 4, 6, 3]] ;
...

*/

swf_axiom_n_alt( N, X, Y, F ):-
	 pp_n_alt( N, _, Y ),
	 pareto( X - Y ),
	 iia( X - Y, F ).


scf_axiom_n_alt( X, Y, F ):-
	 x( Y ),
	 \+ manipulable( _, X - Y, F ).


allais_decomposition( 'Q1', [1,2], [3,4] ).
allais_decomposition( 'Q2', [1,2,5,6], [3,4,7,8] ).
allais_decomposition( 'Q3', [1,2,3], [4,5,6] ).
allais_decomposition( 'Q4', [1,2,5,6], [3,4,7,8] ).

decomposed_profile( Q, K, PP ):-
	 allais_attention_chalt( Q ),
	 inclusive_profile( Q, K, PP ),
	 \+ exclusive_profile( Q, _, PP ).

exclusive_domain_of( 'Q1', D ):- exclusive_domain_Q1( D ).
exclusive_domain_of( 'Q2', D ):- exclusive_domain_Q2( D ).
exclusive_domain_of( 'Q3', D ):- exclusive_domain_Q3( D ).
exclusive_domain_of( 'Q4', D ):- exclusive_domain_Q4( D ).

/*



?- xyz(Q,[A,B,C]), xyz(Q,[A,C,B]), writeln( Q;A-B-C),fail.
Q4;2-3-6
Q4;2-6-3
Q4;2-6-8
Q4;2-8-6
false.

?- xyz(Q,[A,B,C]), xyz(Q,[B,A,C]), writeln( Q;A-B-C),fail.
Q3;3-1-6
Q3;4-2-5
Q3;4-3-5
Q3;1-3-6
Q3;2-4-5
Q3;3-4-5
Q4;7-2-3
Q4;7-2-6
Q4;2-7-3
Q4;2-7-6
false.

?- xyz(Q,[A,B,C]), xyz(Q,[C,A,B]), writeln( Q;A-B-C),fail.
Q3;3-1-4
false.

?- xyz(Q,[A,B,C]), xyz(Q,[B,C,A]), writeln( Q;A-B-C),fail.
Q3;4-3-1
false.

*/

:- dynamic exclusive_dom_Q1/ 4.
:- dynamic exclusive_dom_Q2/ 4.
:- dynamic exclusive_dom_Q3/ 4.
:- dynamic exclusive_dom_Q4/ 4.

init_exclusive_dom_Q1:-
	 abolish( exclusive_dom_Q1/ 4 ),
	 abolish( time_at_level/ 2 ),
	 chpers( [ a, b ] ),
%	 chalt( [ 1, 2, 4 ] ).
	 chalt( [ 1, 2, 3, 4 ] ).

init_exclusive_dom_Q2:-
	 abolish( exclusive_dom_Q2/ 4 ),
	 abolish( time_at_level/ 2 ),
	 chpers( [ a, b ] ),
	 chalt( [ 1, 2, 3, 4, 5, 6, 7, 8 ] ).
%	 chalt( [ 1, 4, 7 ] ).
%	 chalt( [ 1, 2, 5 ] ).

init_exclusive_dom_Q3:-
	 abolish( exclusive_dom_Q3/ 4 ),
	 abolish( time_at_level/ 2 ),
	 chpers( [ a, b ] ),
	 chalt( [ 1, 2, 3, 4, 5, 6 ] ).
%	 chalt( [ 1, 3, 4, 5 ] ).
%	 chalt( [ 1, 3, 6 ] ). % decomposition 1-1
%	 chalt( [ 2, 4, 5 ] ). % decomposition 1-2



init_exclusive_dom_Q4:-
	 abolish( exclusive_dom_Q4/ 4 ),
	 abolish( time_at_level/ 2 ),
	 chpers( [ a, b ] ),
	 chalt( [ 1, 2, 3, 4, 5, 6, 7, 8 ] ).
%	 chalt( [ 2, 3, 6, 7, 8 ] ).

init_exclusive_dom( 'Q1' ):- init_exclusive_dom_Q1.
init_exclusive_dom( 'Q2' ):- init_exclusive_dom_Q2.
init_exclusive_dom( 'Q3' ):- init_exclusive_dom_Q3.
init_exclusive_dom( 'Q4' ):- init_exclusive_dom_Q4.

domain_predicate_allais( 'Q1', exclusive_dom_Q1 ).
domain_predicate_allais( 'Q2', exclusive_dom_Q2 ).
domain_predicate_allais( 'Q3', exclusive_dom_Q3 ).
domain_predicate_allais( 'Q4', exclusive_dom_Q4 ).

gen_exclusive_domain( Q ):-
	 tstamp( start, T0 ),
	 exclusive_domain_of( Q, D ),
	 length( D, N ),
	 tstamp( (Q,N), T1 ),
	 Arg = [ T0, T1, D, N ],
	 domain_predicate_allais( Q, H ),
	 G =.. [ H | Arg ],
	 assert( G ),
	 record_time_if_new_domain_size( N ),
	 fail.

gen_exclusive_domain( Q ):-
	 hist_exclusive_dom_of( Q ),
	 save_exclusive_domain( Q ).

save_exclusive_domain( Q ):-
	 domain_predicate_allais( Q, H ),
	 G =.. [ H, _,_,_,_ ],
	 atomic_concat( H, '.pl', File ),
	 tell_goal( 
		 File, 
		 forall,
		 G 
	 ).


allais_dom_of( Q, T0, T1, D, N ):-
	 domain_predicate_allais( Q, H ),
	 G =.. [ H, T0, T1, D, N ],
	 call( clause( G , _ ) ).


% 6 Nov 2025
%:- ensure_loaded( menu ).
:- ensure_loaded( lib2025 ). 
%
:- ensure_loaded( allais_xyz_exclusion ).

:- dynamic time_at_level/ 2.

record_time_if_new_domain_size( K ):-
	 \+ \+ clause( time_at_level( K, _ ), _ ),
	 !.
record_time_if_new_domain_size( K ):-
	 tstamp( start(K), TK ),
	 assert( time_at_level( K, TK ) ).

hist_exclusive_dom_of( Q ):-
	between( 0, 36, N ),
	findall( 1, allais_dom_of( Q, _,_,_,N ), L ),
	length( L, M ),
	M > 0,
	write( N ),
	write( '\t' ),
	writeln( M ),
	fail
	;
	tstamp( Q,[date(_),time(_)] ).

table_newcomer:-
	 setof( K:T,time_at_level( K, [_,time(T)] ), L ),
	 member( K:H-M-S, L ),
	 write( K ),
	 write( '\t' ), 
	 writeln( H:M:S ),
	 fail; true.

/*
?- init_exclusive_dom('Q1').
true.

?-  exclusive_domain_Q1.
...
(Q1,13),[date(2024/7/2),time(21-0-21)]
(Q1,14),[date(2024/7/2),time(21-0-22)]
start(14),[date(2024/7/2),time(21-0-22)]
0       1
1       14
2       91
3       364
4       1001
5       2002
6       3003
7       3432
8       3003
9       2002
10      1001
11      364
12      91
13      14
14      1
Q1,[date(2024/7/2),time(21-0-23)]
complete
true .

?- table_newcomer.
0       20:15:10
1       20:15:10
2       20:15:10
3       20:15:10
4       20:15:10
5       20:15:10
6       20:15:10
7       20:15:12
8       20:15:17
9       20:15:30
10      20:15:57
11      20:17:33
12      20:21:32
13      20:32:7
14      21:0:22
true.

?- fig_allais_scf( 'Q1', 14).


 1:(124,124) 2:(124,142) 3:(124,412) 4:(142,124) 5:(142,142) 6:(142,412) 7:(142,421) 8:(412,124) 9:(412,142) 10:(412,412) 11:(412,421) 12:(421,142) 13:(421,412) 14:(421,421)
[0,0] 1 1 1 1 1 1 1 1 1 1 1 1 1 1
[0,0] 1 1 1 1 1 1 1 1 1 1 1 1 1 2
[0,0] 1 1 1 1 1 1 2 1 1 1 2 1 1 2
[0,0] 1 1 1 1 1 1 1 1 1 1 1 2 2 2
[0,0] 1 1 1 1 1 1 2 1 1 1 2 2 2 2
[0,0] 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[0,0] 1 1 1 1 1 1 1 1 1 4 4 1 4 4
[2,0] 1 1 4 1 1 4 4 1 1 4 4 1 4 4
[0,0] 2 2 2 2 4 4 4 2 4 4 4 4 4 4
[0,0] 2 4 4 2 4 4 4 2 4 4 4 4 4 4
[1,0] 1 1 1 1 1 1 1 4 4 4 4 4 4 4
[0,0] 1 1 4 1 1 4 4 4 4 4 4 4 4 4
[0,0] 2 2 2 4 4 4 4 4 4 4 4 4 4 4
[0,0] 2 4 4 4 4 4 4 4 4 4 4 4 4 4
[0,0] 4 4 4 4 4 4 4 4 4 4 4 4 4 4
true.

?- fig_allais_dom( 'Q1', 14).


 1:(124,124) 2:(124,142) 3:(124,412) 4:(142,124) 5:(142,142) 6:(142,412) 7:(142,421) 8:(412,124) 9:(412,142) 10:(412,412) 11:(412,421) 12:(421,142)
 1 1 1 1 2 2 2 1 2 3 3 2
 1 2 2 1 2 2 2 1 2 3 3 2
 1 2 3 1 2 3 3 1 2 3 3 2
 1 1 1 2 2 2 2 2 2 3 3 2
 1 2 2 2 2 2 2 2 2 3 3 2
 1 2 3 2 2 3 3 2 2 3 3 2
 1 2 3 2 2 3 7 2 2 3 7 2
 1 1 1 2 2 2 2 3 3 3 3 3
 1 2 2 2 2 2 2 3 3 3 3 3
 1 2 3 2 2 3 3 3 3 3 3 3
 1 2 3 2 2 3 7 3 3 3 7 3
 1 2 2 2 2 2 2 3 3 3 3 7
 1 2 3 2 2 3 3 3 3 3 3 7
 1 2 3 2 2 3 7 3 3 3 7 7
true.


?- count((exclusive_dom_Q1( _,_,D,14), swf( F, D )), N ).
N = 14.

% earlier results
?- exclusive_dom_Q1( _,_,D,14), swf( F, D ), fig( swf, F ), fail.

          123456
1:[1,2,4] 11--1-
2:[1,4,2] 12--22
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 12--55
6:[4,2,1] -2--56
--
          123456
1:[1,2,4] 12--2-
2:[1,4,2] 12--22
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 12--55
6:[4,2,1] -2--56
--
          123456
1:[1,2,4] 12--5-
2:[1,4,2] 12--55
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 12--55
6:[4,2,1] -2--56
--
          123456
1:[1,2,4] 11--1-
2:[1,4,2] 22--22
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 22--55
6:[4,2,1] -2--56
--
          123456
1:[1,2,4] 12--2-
2:[1,4,2] 22--22
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 22--55
6:[4,2,1] -2--56
--
          123456
1:[1,2,4] 12--5-
2:[1,4,2] 22--55
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 22--55
6:[4,2,1] -2--56
--
          123456
1:[1,2,4] 12--5-
2:[1,4,2] 22--56
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 22--56
6:[4,2,1] -2--56
--
          123456
1:[1,2,4] 11--1-
2:[1,4,2] 22--22
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 55--55
6:[4,2,1] -5--56
--
          123456
1:[1,2,4] 12--2-
2:[1,4,2] 22--22
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 55--55
6:[4,2,1] -5--56
--
          123456
1:[1,2,4] 12--5-
2:[1,4,2] 22--55
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 55--55
6:[4,2,1] -5--56
--
          123456
1:[1,2,4] 12--5-
2:[1,4,2] 22--56
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 55--56
6:[4,2,1] -5--56
--
          123456
1:[1,2,4] 12--2-
2:[1,4,2] 22--22
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 55--55
6:[4,2,1] -6--66
--
          123456
1:[1,2,4] 12--5-
2:[1,4,2] 22--55
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 55--55
6:[4,2,1] -6--66
--
          123456
1:[1,2,4] 12--5-
2:[1,4,2] 22--56
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 55--56
6:[4,2,1] -6--66
--
false.



% Q2

?- hist_exclusive_dom_of('Q2').
0       1
1       13
2       73
3       241
4       528
5       820
6       936
7       794
8       495
9       220
10      66
11      12
12      1
Q2,[date(2024/7/2),time(22-38-56)]
true.


?- table_newcomer.
0       22:22:29
1       22:22:29
2       22:22:29
3       22:22:29
4       22:22:29
5       22:22:29
6       22:22:31
7       22:22:35
8       22:22:49
9       22:23:17
10      22:24:39
11      22:29:41
12      22:38:39
true.

?- fig_allais_dom('Q2',12).


 1:(1258,1258) 2:(1258,1528) 3:(1258,1582) 4:(1258,2158) 5:(1258,2518) 6:(1258,2581) 7:(1258,5128) 8:(1258,5182) 9:(1258,5218) 10:(1258,5281) 11:(1258,5812) 12:(1258,5821)
 1 2 2 1 1 1 2 2 2 2 2 2
 1 2 3 1 1 1 2 3 2 2 3 3
 1 1 1 4 4 4 1 1 4 4 1 4
 1 2 2 4 5 5 7 7 9 9 7 9
true.

?- fig_allais_scf('Q2',12).


 1:(1258,1258) 2:(1258,1528) 3:(1258,1582) 4:(1258,2158) 5:(1258,2518) 6:(1258,2581) 7:(1258,5128) 8:(1258,5182) 9:(1258,5218) 10:(1258,5281) 11:(1258,5812) 12:(1258,5821)
[1,0] 1 1 1 1 1 1 1 1 1 1 1 1
[0,0] 1 1 1 2 2 2 1 1 2 2 1 2
[0,0] 2 2 2 2 2 2 2 2 2 2 2 2
[2,0] 1 1 1 2 2 2 5 5 5 5 5 5
[0,0] 2 5 5 2 2 2 5 5 5 5 5 5
[0,0] 1 1 1 1 5 5 5 5 5 5 5 5
[0,0] 5 5 5 5 5 5 5 5 5 5 5 5
[0,0] 1 1 1 2 2 2 1 1 2 2 8 8
[0,0] 2 2 8 2 2 2 2 8 2 2 8 8
[0,0] 1 1 1 1 1 8 1 1 1 8 8 8
[0,0] 8 8 8 8 8 8 8 8 8 8 8 8
true.









?- m1(M1),m2(M2), member( D, [M1,M2] ), once(f( F, D, swf_axiom )), fig(swf, F ), fail.

          123456
1:[a,b,c] ----5-
2:[a,c,b] -----6
3:[b,a,c] -2----
4:[b,c,a] 1-----
5:[c,a,b] ---4--
6:[c,b,a] --3---
--
          123456
1:[a,b,c] ---1--
2:[a,c,b] --2---
3:[b,a,c] -----3
4:[b,c,a] ----4-
5:[c,a,b] 5-----
6:[c,b,a] -6----
--
false.

?- s1(S1),s2(S2), member( D, [S1,S2] ), once(f( F, D, swf_axiom )), fig(swf, F ), fail.

          123456
1:[a,b,c] ------
2:[a,c,b] ---12-
3:[b,a,c] 1---1-
4:[b,c,a] ------
5:[c,a,b] ------
6:[c,b,a] 1--4--
--
          123456
1:[a,b,c] --1--1
2:[a,c,b] ------
3:[b,a,c] ------
4:[b,c,a] -1---4
5:[c,a,b] -21---
6:[c,b,a] ------
--
false.

?- 

Q2.
?- init_exclusive_dom_Q2.
true.
?- gen_exclusive_domain('Q2').
start,[date(2024/7/1),time(11-7-13)]
0,[date(2024/7/1),time(11-7-13)]
start(0),[date(2024/7/1),time(11-7-13)]
1,[date(2024/7/1),time(11-7-15)]
start(1),[date(2024/7/1),time(11-7-15)]
...


?- table_newcomer.
0       14:46:38
1       14:46:38
2       14:46:38
3       14:46:38
4       14:46:39
5       14:46:39
6       14:46:40
7       14:46:45
8       14:46:57
9       14:47:37
10      14:49:41
11      14:54:10
12      15:4:24
13      15:43:43
14      17:44:46
15      19:58:59
true.

% walking around 12-13-14(including a sleep interval)



?- hist_exclusive_dom_of('Q2').
0       1
1       16
2       120
3       560
4       1818
5       4345
6       7887
7       11054
8       12038
9       10165
10      6586
11      3208
12      1135
13      277
14      42
15      3
Q2,[date(2024/7/2),time(0-20-4)]
true.


% a tentative result

?- allais_dom_of('Q2',_,_,D,K), K=12,!,\+ ( nth1( J,D,[_,Y]), atomic_list_concat(Y,Z), tab(1), \+ write(J:Z)), nl, swf(F,D), nl, member([P,Q]-X,F), ( nth1( W, D, [_,X] ) -> true;W=0 ), tab(1), \+ write(W).
 1:1258 2:1285 3:1528 4:1582 5:1825 6:1852 7:2158 8:2185 9:2518 10:2581 11:2815 12:2851

 1 1 3 3 1 3 1 1 1 1 1 1
 1 2 1 1 2 2 1 2 1 1 2 2
 1 2 3 4 5 6 1 2 1 1 2 2
 1 1 1 1 1 1 7 7 7 7 7 7
 1 1 3 3 1 3 7 7 7 7 7 7
 1 2 1 1 2 2 7 8 7 7 8 8
 1 2 3 4 5 6 7 8 7 7 8 8
 1 1 1 1 1 1 7 7 9 9 7 9
 1 1 3 3 1 3 7 7 9 9 7 9
 1 2 1 1 2 2 7 8 9 10 11 12
false.

?- allais_dom_of('Q2',_,_,D,K), K=13,!,\+ ( nth1( J,D,[_,Y]), atomic_list_concat(Y,Z), tab(1), \+ write(J:Z)), nl, swf(F,D), nl, member([P,Q]-X,F), ( nth1( W, D, [_,X] ) -> true;W=0 ), tab(1), \+ write(W).
 1:1258 2:1285 3:1528 4:1582 5:1825 6:1852 7:2158 8:2185 9:2518 10:2581 11:2815 12:2851 13:5128

 1 2 1 1 2 2 1 2 1 1 2 2 1
 1 1 1 1 1 1 7 7 7 7 7 7 1
 1 2 1 1 2 2 7 8 7 7 8 8 1
 1 1 3 3 1 3 1 1 1 1 1 1 3
 1 2 3 4 5 6 1 2 1 1 2 2 3
 1 1 3 3 1 3 7 7 7 7 7 7 3
 1 2 3 4 5 6 7 8 7 7 8 8 3
 1 1 3 3 1 3 7 7 9 9 7 9 13
false.

?- allais_dom_of('Q2',_,_,D,K), K=14, nl, \+ ( nth1( J,D,[X,Y]), atomic_list_concat(X,W),atomic_list_concat(Y,Z), tab(1), \+ write(J:(W,Z))), nl, swf(F,D), nl, member([P,Q]-S,F), ( nth1( W, D, [_,S] ) -> true;W=0 ), tab(1), \+ write(W).

 1:1258 2:1285 3:1528 4:1582 5:1825 6:1852 7:2158 8:2185 9:2518 10:2581 11:2815 12:2851 13:5128 14:5182

 1 2 1 1 2 2 1 2 1 1 2 2 1 1
 1 1 1 1 1 1 7 7 7 7 7 7 1 1
 1 2 1 1 2 2 7 8 7 7 8 8 1 1
 1 1 3 3 1 3 1 1 1 1 1 1 3 3
 1 1 3 3 1 3 7 7 7 7 7 7 3 3
 1 2 3 4 5 6 1 2 1 1 2 2 3 4
 1 2 3 4 5 6 7 8 7 7 8 8 3 4
 1 1 3 3 1 3 7 7 9 9 7 9 13 13
false.


?- allais_dom_of('Q2',_,_,D,K), K=14, nl, \+ ( nth1( J,D,[X,Y]), atomic_list_concat(X,W), atomic_list_concat(Y,Z), tab(1), \+ writeln(J:(W,Z))).

 1:(1258,1258)
 2:(1258,1285)
 3:(1258,1528)
 4:(1258,1582)
 5:(1258,1825)
 6:(1258,1852)
 7:(1258,2158)
 8:(1258,2185)
 9:(1258,2518)
 10:(1258,2581)
 11:(1258,2815)
 12:(1258,2851)
 13:(1258,5128)
 14:(1258,5182)
D = [[[1, 2, 5, 8], [1, 2, 5, 8]], [[1, 2, 5, 8], [1, 2, 8, 5]], [[1, 2, 5, 8], [1, 5, 2, 8]], [[1, 2, 5, 8], [1, 5, 8|...]], [[1, 2, 5|...], [1, 8|...]], [[1, 2|...], [1|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
K = 14 .

*/


hist_b_allais_dom( Q, K, D, W, H ):-
	 allais_dom_of( Q,_,_, D, K ), 
	 hist_b( (
		 swf( F, D ),
		 member( _ - X, F ),
		 atomic_list_concat( X, W )
	 ), W, H ).

/*

?- chalt([1,2,3,4]).
true.

?- exclusive_dom_Q1(_,_, D,16),findall( 1, f( F, D, swf_axiom ),L ).
D = [[[1, 2, 4, 3], [1, 2, 4, 3]], [[1, 2, 4, 3], [1, 4, 2, 3]], [[1, 2, 4, 3], [1, 4, 3, 2]], [[1, 2, 4, 3], [4, 1, 2|...]], [[1, 2, 4|...], [4, 1|...]], [[1, 2|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
L = [1, 1, 1, 1, 1, 1, 1, 1, 1|...] .

?- hist_b_allais_dom( 'Q1', 16, D, W, H).
D = [[[1, 2, 4, 3], [1, 2, 4, 3]], [[1, 2, 4, 3], [1, 4, 2, 3]], [[1, 2, 4, 3], [1, 4, 3, 2]], [[1, 2, 4, 3], [4, 1, 2|...]], [[1, 2, 4|...], [4, 1|...]], [[1, 2|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
W = '1243',
H = 15 .

?- bagof( W:H, hist_b_allais_dom( 'Q1', 16, D, W, H), L ), assert(tmp_hb( D, L ) ), fail.
false.

?- tmp_hb(_, L ).
L = ['1243':6, '1324':10, '1342':20, '1423':20, '1432':8] ;
L = ['1243':6, '1324':10, '1342':20, '1423':18, '1432':10] ;
L = ['1243':10, '1324':14, '1342':22, '1423':27, '1432':13, '4123':6, '4132':4] ;
L = ['1243':6, '1324':10, '1342':18, '1423':20, '1432':10] ;
L = ['1243':15, '1324':30, '1342':52, '1423':29, '1432':26, '3124':1, '3142':1, '3412':1, ... : ...|...].

?- 
*/

hist_allais_dom( Q, K ):-
	 allais_dom_of( Q,_,_, D, K ), 
	 nl,
	 nl,
	 \+ (
		 nth1( J,D,[ X,Y ]),
		 atomic_list_concat( X, V ),
		 atomic_list_concat( Y, Z ),
		 tab( 1 ),
		 \+ write(J:(V,Z))
	 ),
	 \+ hist1n( (
		 swf( F, D ),
		 member( _ - X, F ),
		 fig_allais_dom_pattern( X, D, W )
	 ), W:X ).

hist_allais_dom( _, _ ).

/*

?- chalt([1,2,3,4]).

?- tell('hist_allais_dom_Q1_D16.txt').
true.

?- hist_allais_dom( 'Q1', 16), told.

*/


fig_allais_dom_pattern( X, D, W ):-
	 nth1( W, D, [ _,X ] ),
	 !.
fig_allais_dom_pattern( _, _, 0 ).

fig_allais_dom( Q, K ):-
	 allais_dom_of( Q,_,_, D, K ), 
	 nl,
	 nl,
	 \+ (
		 nth1( J,D,[ X,Y ]),
		 atomic_list_concat( X, V ),
		 atomic_list_concat( Y, Z ),
		 tab( 1 ),
		 \+ write(J:(V,Z))
	 ),
	 swf( F, D ),
	 nl,
	 member( _ - X, F ),
	 fig_allais_dom_pattern( X, D, W ),
	 tab( 1 ),
	 \+ write( W ).

fig_allais_dom( _, _ ).

fig_swf( F ):-
	 findall( S, member( _ - S, F ), L ),
	 nl,
	 nl,
	 \+ (
		 nth1( J, L, X ),
		 atomic_list_concat( X, V ),
		 tab( 1 ),
		 \+ write(J:V)
	 ),
	 nl,
	 member( S, L ),
	 nth1( K, L, S ),
	 tab( 1 ),
	 \+ write( K ).

fig_swf( _ ).

:- chalt( [1,2,3,4] ).

/*

?- allais_dom_of('Q2',_,_,D,K), K=15, nl, \+ ( nth1( J,D,[X,Y]), atomic_list_concat(X,W),atomic_list_concat(Y,Z), tab(1), \+ write(J:(W,Z))), nl, f(F,D, scf_axiom), (dictatorial_scf( J, F) -> W=J;W=0 ),( non_imposed( F )-> V=1; V=0 ), nl, write([W,V]), member([P,Q]-S,F), tab(1), \+ write(S).

 1:(1258,1258) 2:(1258,1285) 3:(1258,1528) 4:(1258,1582) 5:(1258,1825) 6:(1258,1852) 7:(1258,2158) 8:(1258,2185) 9:(1258,2518) 10:(1258,2581) 11:(1258,2815) 12:(1258,2851) 13:(1258,5128) 14:(1258,5182) 15:(1258,5218)

[1,0] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
[0,0] 1 1 1 1 1 1 1 1 1 8 8 8 1 1 1
[0,0] 1 1 1 1 1 1 2 2 2 2 2 2 1 1 2
[0,0] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
[0,0] 2 2 2 8 8 8 2 2 2 2 2 2 2 8 2
[2,0] 1 1 1 1 1 1 2 2 2 2 2 2 5 5 5
[0,0] 2 2 5 5 2 5 2 2 2 2 2 2 5 5 5
[0,0] 2 2 5 5 8 8 2 2 2 2 2 2 5 5 5
[0,0] 1 1 1 1 1 1 1 1 5 5 1 5 5 5 5
[0,0] 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
[0,0] 1 1 1 1 1 1 1 1 5 5 8 8 5 5 5
[0,0] 5 8 5 5 8 8 5 8 5 5 8 8 5 5 5
[0,0] 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8
false.

?- fig_allais_scf( 'Q3', 16).


 1:(1345,1345) 2:(1345,1354) 3:(1345,1435) 4:(1345,1453) 5:(1345,1534) 6:(1345,1543) 7:(1345,3145) 8:(1345,3154) 9:(1345,3415) 10:(1345,3451) 11:(1345,3514) 12:(1345,3541) 13:(1345,4135) 14:(1345,4153) 15:(1345,4315) 16:(1345,4351)
[1,0] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
[0,0] 1 1 1 1 1 1 3 3 3 3 3 3 1 1 3 3
[0,0] 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3
[0,0] 3 3 3 5 5 5 3 3 3 3 3 3 3 5 3 3
[2,0] 1 1 1 1 1 1 3 3 3 3 3 3 4 4 4 4
[0,0] 3 3 4 4 3 4 3 3 3 3 3 3 4 4 4 4
[0,0] 3 3 4 4 5 5 3 3 3 3 3 3 4 4 4 4
[0,0] 1 1 1 1 1 1 1 1 4 4 1 4 4 4 4 4
[0,0] 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
[0,0] 1 1 1 1 1 1 1 1 4 4 5 5 4 4 4 4
[0,0] 4 5 4 4 5 5 4 5 4 4 5 5 4 4 4 4
[0,0] 1 1 1 1 1 1 1 1 1 5 5 5 1 1 1 5
[0,0] 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
true.


?- fig_allais_dom('Q2', 16).


 1:(1258,1258) 2:(1258,1285) 3:(1258,1528) 4:(1258,1582) 5:(1258,1825) 6:(1258,1852) 7:(1258,2158) 8:(1258,2185) 9:(1258,2518) 10:(1258,2581) 11:(1258,2815) 12:(1258,2851) 13:(1258,5128) 14:(1258,5182) 15:(1258,5218) 16:(1258,5281)
 1 2 1 1 2 2 1 2 1 1 2 2 1 1 1 1
 1 1 3 3 1 3 1 1 1 1 1 1 3 3 3 3
 1 2 3 4 5 6 1 2 1 1 2 2 3 4 3 3
 1 1 1 1 1 1 7 7 7 7 7 7 1 1 7 7
 1 2 1 1 2 2 7 8 7 7 8 8 1 1 7 7
 1 1 3 3 1 3 7 7 9 9 7 9 13 13 15 15
true.


?- fig_allais_dom( 'Q3', 16).


 1:(1345,1345) 2:(1345,1354) 3:(1345,1435) 4:(1345,1453) 5:(1345,1534) 6:(1345,1543) 7:(1345,3145) 8:(1345,3154) 9:(1345,3415) 10:(1345,3451) 11:(1345,3514) 12:(1345,3541) 13:(1345,4135) 14:(1345,4153) 15:(1345,4315) 16:(1345,4351)
 1 2 1 1 2 2 1 2 1 1 2 2 1 1 1 1
 1 1 3 3 1 3 1 1 1 1 1 1 3 3 3 3
 1 2 3 4 5 6 1 2 1 1 2 2 3 4 3 3
 1 1 1 1 1 1 7 7 7 7 7 7 1 1 7 7
 1 2 1 1 2 2 7 8 7 7 8 8 1 1 7 7
 1 1 3 3 1 3 7 7 9 9 7 9 13 13 15 15
true.


*/

fig_scf_dict_pattern( F, J ):-
	 dictatorial_scf( J, F ),
	 !.

fig_scf_dict_pattern( _, 0 ).

fig_scf_cs_pattern( F, 1 ):-
	 non_imposed( F ),
	 !.

fig_scf_cs_pattern( _, 0 ).

fig_scf_dict_pattern( dict, _, 0 ).

fig_allais_scf( Q, K ):-
	 allais_dom_of( Q,_,_, D, K ), 
	 nl,
	 nl,
	 \+ (
		 nth1( J,D,[ X,Y ]),
		 atomic_list_concat( X, V ),
		 atomic_list_concat( Y, Z ),
		 tab( 1 ),
		 \+ write(J:(V,Z))
	 ),
	 f( F, D, scf_axiom ),
	 fig_scf_dict_pattern( F, Dict ),
	 fig_scf_cs_pattern( F, CS ),
	 nl,
	 write( [ Dict, CS ] ),
	 member( _ - X, F ),
	 tab( 1 ),
	 \+ write( X ).

fig_allais_scf( _, _ ).





/*

?- between(1, 14, K ), allais_dom_of('Q2',_,_,D,K), findall( F, swf( F, D ), L ), length( L, N ), assert( tmp_Q2_swf_len( D, N ) ), fail.

?- hist1n( ( tmp_Q2_swf_len( D, N ), length( D, K ) ), K:N ).

 [1:0,4]
 [1:1,4]
 [1:2,2]
 [1:3,2]
 [1:4,2]
 [1:6,1]
 [2:0,3]
 [2:1,8]
 [2:2,9]
 [2:3,15]
 [2:4,17]
 [2:5,4]
 [2:6,15]
 [2:7,5]
 [2:8,4]
 [2:10,9]
 [2:11,2]
 [2:13,4]
 [2:14,1]
 [2:16,3]
 [2:18,1]
 [2:19,1]
 [2:22,3]
 [2:23,1]
 [3:1,4]
 [3:2,11]
 [3:3,33]
 [3:4,35]
 [3:5,21]
 [3:6,56]
 [3:7,16]
 [3:8,36]
 [3:9,5]
 [3:10,49]
 [3:11,21]
 [3:12,5]
 [3:13,33]
 [3:14,19]
 [3:15,2]
 [3:16,29]
 [3:17,4]
 [3:18,19]
 [3:19,19]
 [3:20,2]
 [3:21,1]
 [3:22,26]
 [3:23,8]
 [4:2,8]
 [4:3,31]
 [4:4,38]
 [4:5,42]
 [4:6,96]
 [4:7,22]
 [4:8,108]
 [4:9,28]
 [4:10,122]
 [4:11,90]
 [4:12,33]
 [4:13,119]
 [4:14,106]
 [4:15,32]
 [4:16,114]
 [4:17,36]
 [4:18,98]
 [4:19,102]
 [4:20,12]
 [4:21,5]
 [4:22,84]
 [4:23,26]
 [4:24,1]
 [5:2,6]
 [5:3,14]
 [5:4,38]
 [5:5,40]
 [5:6,102]
 [5:7,31]
 [5:8,190]
 [5:9,71]
 [5:10,226]
 [5:11,247]
 [5:12,111]
 [5:13,282]
 [5:14,319]
 [5:15,152]
 [5:16,281]
 [5:17,127]
 [5:18,238]
 [5:19,263]
 [5:20,30]
 [5:21,10]
 [5:22,136]
 [5:23,45]
 [5:24,4]
 [6:2,2]
 [6:3,4]
 [6:4,37]
 [6:5,18]
 [6:6,86]
 [6:7,59]
 [6:8,287]
 [6:9,133]
 [6:10,390]
 [6:11,505]
 [6:12,265]
 [6:13,536]
 [6:14,612]
 [6:15,352]
 [6:16,482]
 [6:17,251]
 [6:18,321]
 [6:19,380]
 [6:20,40]
 [6:21,10]
 [6:22,119]
 [6:23,45]
 [6:24,6]
 [7:3,1]
 [7:4,17]
 [7:5,3]
 [7:6,75]
 [7:7,97]
 [7:8,413]
 [7:9,277]
 [7:10,627]
 [7:11,834]
 [7:12,500]
 [7:13,822]
 [7:14,782]
 [7:15,460]
 [7:16,558]
 [7:17,275]
 [7:18,251]
 [7:19,321]
 [7:20,30]
 [7:21,5]
 [7:22,54]
 [7:23,26]
 [7:24,4]

true.

?- hist1n( ( tmp_Q2_swf_len( D, 1 ), length( D, K ) ), K ).

 [1,4]
 [2,8]
 [3,4]
total:16
true.

?- hist1n( ( tmp_Q2_swf_len( D, N ), N<3, length( D, K ) ), K ).

 [1,10]
 [2,20]
 [3,15]
 [4,8]
 [5,6]
 [6,1]
total:60
true.


*/



/*

?- allais_dom_of('Q2',_,_,D,K), K=12,!,swf(F,D), nl, last(F,X), \+ writeln(X).

[[1,2,5,8],[2,8,5,1]]-[1,2,5,8]

[[1,2,5,8],[2,8,5,1]]-[1,2,8,5]

[[1,2,5,8],[2,8,5,1]]-[1,2,8,5]

[[1,2,5,8],[2,8,5,1]]-[2,1,5,8]

[[1,2,5,8],[2,8,5,1]]-[2,1,5,8]

[[1,2,5,8],[2,8,5,1]]-[2,1,8,5]

[[1,2,5,8],[2,8,5,1]]-[2,1,8,5]

[[1,2,5,8],[2,8,5,1]]-[2,5,1,8]

[[1,2,5,8],[2,8,5,1]]-[2,5,1,8]

[[1,2,5,8],[2,8,5,1]]-[2,8,5,1]
false.




Q3. 1 Jul.

?- init_exclusive_dom_Q3.
true.
?- gen_exclusive_domain('Q3').


?- hist_exclusive_dom_of('Q3').
0       1
1       11
2       54
3       156
4       293
5       371
6       316
7       176
8       61
9       12
10      1
Q3,[date(2024/7/1),time(12-55-58)]
true.

?- table_newcomer.
0       11:50:22
1       11:50:22
2       11:50:23
3       11:50:24
4       11:50:29
5       11:50:40
6       11:51:12
7       11:52:40
8       11:56:14
9       12:6:46
10      12:35:28
true.

?- allais_dom_of('Q3',_,_,D,K), K=10,swf(F,D), !, member(X,F), \+ writeln(X).
[[1,2,3,4,5,6],[1,2,3,4,5,6]]-[1,2,3,4,5,6]
[[1,2,3,4,5,6],[1,2,3,4,6,5]]-[1,2,3,4,5,6]
[[1,2,3,4,5,6],[1,2,3,5,4,6]]-[1,2,3,5,4,6]
[[1,2,3,4,5,6],[1,2,3,5,6,4]]-[1,2,3,5,4,6]
[[1,2,3,4,5,6],[1,2,3,6,4,5]]-[1,2,3,4,5,6]
[[1,2,3,4,5,6],[1,2,3,6,5,4]]-[1,2,3,5,4,6]
[[1,2,3,4,5,6],[1,2,4,3,5,6]]-[1,2,3,4,5,6]
[[1,2,3,4,5,6],[1,2,4,3,6,5]]-[1,2,3,4,5,6]
[[1,2,3,4,5,6],[1,2,4,5,3,6]]-[1,2,3,4,5,6]
[[1,2,3,4,5,6],[1,2,4,5,6,3]]-[1,2,3,4,5,6]
false.

*/

exclusive_domain_Q1_another_version:-
	 chpers([a,b]),
	 chalt([1,2,4]),
	 XP=[[2,1,4],[2,1,3],[2,3,4],[2,4,1]],
	 tstamp( start, T0 ),
	 exclusive_domain( XP, D ),
/*	 f( F, D, scf_axiom ),
	 \+ dictatorial_scf( J, F ),
	 non_imposed( F ),
*/
	 length( D, N ),
	 tstamp( N, T1 ),
	 assert( tmp_exclusive_domain_allais_Q1( T0, T1, D, N ) ),
	 fail.


/*

?- chpers( [a,b] ), chalt( [1,2,3,4] ).

?- xyz( 'Q1',P ).
P = [2, 1, 4].

?- XP=[[4,1,2]], exclusive_domain( XP, D ).
XP = [[4, 1, 2]],
D = [] ;
XP = [[4, 1, 2]],
D = [[[1, 2, 3, 4], [1, 2, 3, 4]]] ;
XP = [[4, 1, 2]],
D = [[[1, 2, 3, 4], [1, 2, 4, 3]]] ;
XP = [[4, 1, 2]],
D = [[[1, 2, 3, 4], [1, 2, 3, 4]], [[1, 2, 3, 4], [1, 2, 4, 3]]] ;
XP = [[4, 1, 2]],
D = [[[1, 2, 3, 4], [1, 3, 2, 4]]] ;
XP = [[4, 1, 2]],
D = [[[1, 2, 3, 4], [1, 2, 3, 4]], [[1, 2, 3, 4], [1, 3, 2, 4]]] ;
XP = [[4, 1, 2]],
D = [[[1, 2, 3, 4], [1, 2, 4, 3]], [[1, 2, 3, 4], [1, 3, 2, 4]]] ;
XP = [[4, 1, 2]],
D = [[[1, 2, 3, 4], [1, 2, 3, 4]], [[1, 2, 3, 4], [1, 2, 4, 3]], [[1, 2, 3, 4], [1, 3, 2, 4]]] .


?- 
% the following goal seems difficult.
?- XP=[[4,1,2]], exclusive_domain( XP, D ), scf( F, D ).


% However, it is easy to do this.

?- XP=[[4,1,2]], exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), setof( Y, X^member( X-Y, F ), R ), sort(R,[_,_,_|_] ).
XP = [[4, 1, 2]],
D = [[[1, 2, 3, 4], [1, 2, 3, 4]], [[1, 2, 3, 4], [1, 3, 2, 4]], [[1, 2, 3, 4], [1, 4, 2, 3]]],
F = [[[1, 2, 3, 4], [1, 2, 3, 4]]-2, [[1, 2, 3, 4], [1, 3, 2, 4]]-3, [[1, 2, 3, 4], [1, 4, 2|...]]-4],
R = [2, 3, 4] .

?- XP=[[1,4,2]], time( ( exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), setof( Y, X^member( X-Y, F ), R ), sort(R,[_,_,_,_] ) ) ).
% 15,450,301,769 inferences, 923.281 CPU in 1019.226 seconds (91% CPU, 16734123 Lips)
XP = [[1, 4, 2]],
D = [[[1, 2, 3, 4], [1, 2, 4, 3]], [[1, 2, 3, 4], [2, 3, 1, 4]], [[1, 2, 3, 4], [2, 4, 1, 3]], [[1, 2, 4, 3], [1, 2, 3|...]]],
F = [[[1, 2, 3, 4], [1, 2, 4, 3]]-1, [[1, 2, 3, 4], [2, 3, 1, 4]]-3, [[1, 2, 3, 4], [2, 4, 1|...]]-4, [[1, 2, 4|...], [1, 2|...]]-2],
R = [1, 2, 3, 4] .

?- 
?- findall( Y, ( pp( P ), D=[P], f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), F=[X-Y] ), L ), sort( L, H ).
L = [2, 3, 4, 2, 3, 4, 2, 3, 4|...],
H = [1, 2, 3, 4].

% (above) added: 29 Jun 2024

% re-trial 30 Jun chalt([1,2,3,4]).


?- permutation([1,2,3],P), writeln( P ), XP=[P], time( ( exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), setof( Y, X^member( X-Y, F ), R ), sort(R,[_,_,_|_] ), ! ) ), fail.
[1,2,3]
% 3,625,072 inferences, 0.141 CPU in 0.177 seconds (80% CPU, 25778290 Lips)
[1,3,2]
% 3,625,072 inferences, 0.156 CPU in 0.181 seconds (86% CPU, 23200461 Lips)
[2,1,3]
% 3,625,072 inferences, 0.141 CPU in 0.182 seconds (77% CPU, 25778290 Lips)
[2,3,1]
% 3,625,072 inferences, 0.172 CPU in 0.202 seconds (85% CPU, 21091328 Lips)
[3,1,2]
% 3,625,072 inferences, 0.125 CPU in 0.194 seconds (64% CPU, 29000576 Lips)
[3,2,1]
% 3,625,072 inferences, 0.125 CPU in 0.184 seconds (68% CPU, 29000576 Lips)
false.

?- permutation([1,2,4],P), writeln( P ), XP=[P], time( ( exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), setof( Y, X^member( X-Y, F ), R ), sort(R,[_,_,_|_] ), ! ) ), fail.
[1,2,4]
% 3,625,072 inferences, 0.172 CPU in 0.205 seconds (84% CPU, 21091328 Lips)
[1,4,2]
% 3,625,072 inferences, 0.188 CPU in 0.202 seconds (93% CPU, 19333717 Lips)
[2,1,4]
% 3,625,072 inferences, 0.172 CPU in 0.181 seconds (95% CPU, 21091328 Lips)
[2,4,1]
% 3,625,072 inferences, 0.109 CPU in 0.178 seconds (62% CPU, 33143515 Lips)
[4,1,2]
% 3,625,072 inferences, 0.156 CPU in 0.202 seconds (77% CPU, 23200461 Lips)
[4,2,1]
% 3,625,072 inferences, 0.125 CPU in 0.187 seconds (67% CPU, 29000576 Lips)
false.


?-  XP=[[4,1,2]], time( ( exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), setof( Y, X^member( X-Y, F ), R ), sort(R,[_,_,_|_] ), ! ) ), fail.
% 3,625,072 inferences, 0.141 CPU in 0.175 seconds (80% CPU, 25778290 Lips)false.

?- permutation([1,2,3],P), writeln( P ), XP=[P], time( ( exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), setof( Y, X^member( X-Y, F ), R ), sort(R,[_,_,_,_] ), ! ) ), fail.
[1,2,3]

%not yet retried

% 70,029,636,240 inferences, 3652.266 CPU in 4086.455 seconds (89% CPU, 19174300 Lips)
[1,3,2]
% 14,930,675,057 inferences, 670.469 CPU in 999.334 seconds (67% CPU, 22269010 Lips)
[2,1,3]
% 14,093,866,781 inferences, 508.313 CPU in 876.440 seconds (58% CPU, 27726776 Lips)
[2,3,1]


---

?- chpers([a,b]), chalt([1,2,3]).
true.

?- permutation([1,2,3],P), writeln( P ), XP=[P], time( ( exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), setof( Y, X^member( X-Y, F ), R ), sort(R,[_,_,_|_] ), ! ) ), fail.
[1,2,3]
% 2,002,918 inferences, 0.094 CPU in 0.112 seconds (83% CPU, 21364459 Lips)
[1,3,2]
% 630,136 inferences, 0.016 CPU in 0.030 seconds (52% CPU, 40328704 Lips)
[2,1,3]
% 728,131 inferences, 0.016 CPU in 0.035 seconds (45% CPU, 46600384 Lips)
[2,3,1]
% 1,414,411 inferences, 0.062 CPU in 0.079 seconds (79% CPU, 22630576 Lips)
[3,1,2]
% 1,233,468 inferences, 0.062 CPU in 0.070 seconds (89% CPU, 19735488 Lips)
[3,2,1]
% 3,576,365 inferences, 0.156 CPU in 0.211 seconds (74% CPU, 22888736 Lips)
false.

?- chalt([1,2,3,4]).
true.
?- permutation([1,2,3],P), \+ member( P, [[1,2,3],[2,3,1]]), writeln( P ), XP=[P], time( ( exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), setof( Y, X^member( X-Y, F ), R ), sort(R,[_,_,_,_] ), !, assert( first_permu_123_exclusive_domain( P, D ) ) ) ), fail.
[1,3,2]


---

?- chpers( [a,b] ), chalt( [1,2,4] ).

?- findall( P, xyz( 'Q1',P ), XP ), exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), setof( Y, X^member( X-Y, F ), R ), sort(R,[1,_,_] ), length( F, N ), N>5, fig( scf, F ).

          123456
1:[1,2,4] 11-212
2:[1,4,2] -----4
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] ------
6:[4,2,1] ------
--
XP = [[2, 1, 4]],
D = [[[1, 2, 4], [1, 2, 4]], [[1, 2, 4], [1, 4, 2]], [[1, 2, 4], [2, 4, 1]], [[1, 2, 4], [4, 1, 2]], [[1, 2, 4], [4, 2|...]], [[1, 4|...], [4|...]]],
F = [[[1, 2, 4], [1, 2, 4]]-1, [[1, 2, 4], [1, 4, 2]]-1, [[1, 2, 4], [2, 4, 1]]-2, [[1, 2, 4], [4, 1|...]]-1, [[1, 2|...], [4|...]]-2, [[1|...], [...|...]]-4],
R = [1, 2, 4],
N = 6 .

?- findall( A-B-C, (allais(_,_,'Q1',_,[X,Y,_,Z]), min_list( [X,Y,Z], M ), A is X - M, B is Y - M, C is Z - M, sort( [A,B,C], [_,_,_ ] ) ), L ), sort( L, H ), length( H, N ).
L = [0-1-3, 0-1-3, 2-0-3, 4-0-1, 3-1-0, 1-0-2, 0-3-2, ... - ... - 1, ... - ...|...],
H = [0-1-2, 0-1-3, 0-2-3, 0-2-4, 0-3-2, 1-0-2, 1-0-3, ... - ... - 1, ... - ...|...],
N = 16.

?- findall( A-B-C, (allais(_,_,'Q1',_,[X,Y,_,Z]), min_list( [X,Y,Z], M ), A is X - M, B is Y - M, C is Z - M, sort( [A,B,C], [_,_,_ ] ) ), L ), sort( L, H ), length( H, N ), nth1( J, H, P ), nl, write( [J] ), write( P ), fail.

[1]0-1-2
[2]0-1-3
[3]0-2-3
[4]0-2-4
[5]0-3-2
[6]1-0-2
[7]1-0-3
[8]2-0-1
[9]2-0-3
[10]2-1-0
[11]3-0-1
[12]3-0-2
[13]3-1-0
[14]4-0-1
[15]4-0-2
[16]4-3-0
false.

?- findall( [A:1,B:2,C:4], (allais(_,_,'Q1',_,[X,Y,_,Z]), min_list( [X,Y,Z], M ), A is X - M, B is Y - M, C is Z - M, sort( [A,B,C], [_,_,_ ] ) ), L ), sort( L, H ), length( H, N ), nth1( J, H, P ), sort( P, Q ), reverse( Q, Q1 ), findall( K, member( _:K, Q1 ), R ), nl, write( [J:Q] ), write( R ), fail.

[1:[0:1,1:2,2:4]][4,2,1]
[2:[0:1,1:2,3:4]][4,2,1]
[3:[0:1,2:2,3:4]][4,2,1]
[4:[0:1,2:2,4:4]][4,2,1]
[5:[0:1,2:4,3:2]][2,4,1]
[6:[0:2,1:1,2:4]][4,1,2]
[7:[0:2,1:1,3:4]][4,1,2]
[8:[0:2,1:4,2:1]][1,4,2]
[9:[0:2,2:1,3:4]][4,1,2]
[10:[0:4,1:2,2:1]][1,2,4]
[11:[0:2,1:4,3:1]][1,4,2]
[12:[0:2,2:4,3:1]][1,4,2]
[13:[0:4,1:2,3:1]][1,2,4]
[14:[0:2,1:4,4:1]][1,4,2]
[15:[0:2,2:4,4:1]][1,4,2]
[16:[0:4,3:2,4:1]][1,2,4]
false.

?- chpers( [a,b] ), chalt( [1,2,4] ).
?- findall( P, xyz( 'Q1',P ), XP ), exclusive_domain( XP, D ), scf( F, D ).
XP = [[2, 1, 4]],
D = [[[1, 2, 4], [1, 4, 2]], [[1, 2, 4], [4, 1, 2]], [[1, 4, 2], [1, 2, 4]]],
F = [[[1, 2, 4], [1, 4, 2]]-1, [[1, 2, 4], [4, 1, 2]]-4, [[1, 4, 2], [1, 2, 4]]-2] .

% it will be difficult again, say, if not possible.
?- findall( P, xyz( 'Q1',P ), XP ), exclusive_domain( XP, D ), scf( F, D ), length(D, N), N >10.
؀XP = [[2, 1, 4]],
D = [[[1, 2, 4], [1, 2, 4]], [[1, 2, 4], [1, 4, 2]], [[1, 2, 4], [2, 4, 1]], [[1, 2, 4], [4, 1, 2]], [[1, 2, 4], [4, 2|...]], [[1, 4|...], [1|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
F = [[[1, 2, 4], [1, 2, 4]]-1, [[1, 2, 4], [1, 4, 2]]-1, [[1, 2, 4], [2, 4, 1]]-2, [[1, 2, 4], [4, 1|...]]-4, [[1, 2|...], [4|...]]-4, [[1|...], [...|...]]-1, [[...|...]|...]-1, [...|...]-4, ... - ...|...],
N = 11 .


?- chpers( [a,b] ), chalt( [1,2,3,4,5,6] ).

?- findall( P, xyz( 'Q3',P ), XP ), exclusive_domain( XP, D ), swf( F, D ), length(D, N), N>2.
XP = [[3, 1, 4], [3, 1, 5], [3, 1, 6], [4, 2, 5], [4, 3, 1], [4, 3, 5], [4, 3|...], [1|...], [...|...]|...],
D = [[[1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 5, 6]], [[1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 6|...]], [[1, 2, 3, 4, 5|...], [1, 2, 3, 5|...]]],
F = [[[1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 5|...]]-[1, 2, 3, 4, 5, 6], [[1, 2, 3, 4, 5|...], [1, 2, 3, 4|...]]-[1, 2, 3, 4, 6, 5], [[1, 2, 3, 4|...], [1, 2, 3|...]]-[1, 2, 3, 4, 5|...]],
N = 3 .

?- findall( P, xyz( 'Q3',P ), XP ), exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( _, F ), length(D, N), N >3.
XP = [[3, 1, 4], [3, 1, 5], [3, 1, 6], [4, 2, 5], [4, 3, 1], [4, 3, 5], [4, 3|...], [1|...], [...|...]|...],
D = [[[1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 5, 6]], [[1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 6|...]], [[1, 2, 3, 4, 5|...], [1, 2, 3, 5|...]], [[1, 2, 3, 4|...], [1, 2, 3|...]]],
F = [[[1, 2, 3, 4, 5, 6], [1, 2, 3, 4, 5|...]]-2, [[1, 2, 3, 4, 5|...], [1, 2, 3, 4|...]]-2, [[1, 2, 3, 4|...], [1, 2, 3|...]]-2, [[1, 2, 3|...], [1, 2|...]]-2],
N = 4 .

% difficult 
?- chpers( [a,b] ), chalt( [1,2,3,4,5,6,7,8] ).true.

?- findall( P, xyz( 'Q2',P ), XP ), exclusive_domain( XP, D ), f( F, D, scf_axiom ), length(D, N).
XP = [[3, 1, 7], [7, 2, 8], [6, 4, 1], [6, 4, 8], [6, 5, 8], [2, 3, 5], [2, 4|...], [2|...], [...|...]|...],
D = [[[1, 2, 3, 4, 5, 6, 7|...], [1, 2, 3, 4, 5, 6|...]], [[1, 2, 3, 4, 5, 6|...], [1, 2, 3, 4, 5|...]]],
F = [[[1, 2, 3, 4, 5, 6|...], [1, 2, 3, 4, 5|...]]-2, [[1, 2, 3, 4, 5|...], [1, 2, 3, 4|...]]-2],
N = 2 ;
XP = [[3, 1, 7], [7, 2, 8], [6, 4, 1], [6, 4, 8], [6, 5, 8], [2, 3, 5], [2, 4|...], [2|...], [...|...]|...],
D = [[[1, 2, 3, 4, 5, 6, 7|...], [1, 2, 3, 4, 5, 6|...]], [[1, 2, 3, 4, 5, 6|...], [1, 2, 3, 4, 5|...]]],
F = [[[1, 2, 3, 4, 5, 6|...], [1, 2, 3, 4, 5|...]]-3, [[1, 2, 3, 4, 5|...], [1, 2, 3, 4|...]]-3],
N = 2 ;
XP = [[3, 1, 7], [7, 2, 8], [6, 4, 1], [6, 4, 8], [6, 5, 8], [2, 3, 5], [2, 4|...], [2|...], [...|...]|...],
D = [[[1, 2, 3, 4, 5, 6, 7|...], [1, 2, 3, 4, 5, 6|...]], [[1, 2, 3, 4, 5, 6|...], [1, 2, 3, 4, 5|...]]],
F = [[[1, 2, 3, 4, 5, 6|...], [1, 2, 3, 4, 5|...]]-4, [[1, 2, 3, 4, 5|...], [1, 2, 3, 4|...]]-4],
N = 2 ;
XP = [[3, 1, 7], [7, 2, 8], [6, 4, 1], [6, 4, 8], [6, 5, 8], [2, 3, 5], [2, 4|...], [2|...], [...|...]|...],
D = [[[1, 2, 3, 4, 5, 6, 7|...], [1, 2, 3, 4, 5, 6|...]], [[1, 2, 3, 4, 5, 6|...], [1, 2, 3, 4, 5|...]]],
F = [[[1, 2, 3, 4, 5, 6|...], [1, 2, 3, 4, 5|...]]-5, [[1, 2, 3, 4, 5|...], [1, 2, 3, 4|...]]-5],
N = 2 .


% 30 Jun 2024

?- chpers([a,b]), chalt([1,2,3,4]).
true.

?- XP=[[2,1,4],[2,1,3],[2,3,4],[2,4,1]],   exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), setof( Y, X^member( X-Y, F ), R ), sort(R,[_,_,_|_] ), length( F, N ), fig( scf, F ).

          123456789101112131415161718192021222324
1:[1,2,3,4] ------------------------
2:[1,2,4,3] -2--4-------------------
3:[1,3,2,4] --1---------------------
4:[1,3,4,2] ------------------------
5:[1,4,2,3] ------------------------
6:[1,4,3,2] ------------------------
7:[2,1,3,4] ------------------------
8:[2,1,4,3] ------------------------
9:[2,3,1,4] ------------------------
10:[2,3,4,1] ------------------------
11:[2,4,1,3] ------------------------
12:[2,4,3,1] ------------------------
13:[3,1,2,4] ------------------------
14:[3,1,4,2] ------------------------
15:[3,2,1,4] ------------------------
16:[3,2,4,1] ------------------------
17:[3,4,1,2] ------------------------
18:[3,4,2,1] ------------------------
19:[4,1,2,3] ------------------------
20:[4,1,3,2] ------------------------
21:[4,2,1,3] ------------------------
22:[4,2,3,1] ------------------------
23:[4,3,1,2] ------------------------
24:[4,3,2,1] ------------------------
--
XP = [[2, 1, 4], [2, 1, 3], [2, 3, 4], [2, 4, 1]],
D = [[[1, 2, 4, 3], [1, 2, 4, 3]], [[1, 2, 4, 3], [1, 4, 2, 3]], [[1, 3, 2, 4], [1, 3, 2, 4]]],
F = [[[1, 2, 4, 3], [1, 2, 4, 3]]-2, [[1, 2, 4, 3], [1, 4, 2, 3]]-4, [[1, 3, 2, 4], [1, 3, 2|...]]-1],
R = [1, 2, 4],
N = 3 .

*/


/*

?- ndspcs_exclusive_domain_allais_Q1( T0, T1, XP, D, F , N, R ), N>9, write(+),fig( scf, F ), fail.
+
          123456
1:[1,2,4] 11--1-
2:[1,4,2] 11--12
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 11--4-
6:[4,2,1] ------
--+
          123456
1:[1,2,4] 11--1-
2:[1,4,2] 11--12
3:[2,1,4] ------
4:[2,4,1] ------
5:[4,1,2] 44--4-
6:[4,2,1] ------
--
false.

?- tell_goal( 'ndspcs_exclusive_domain_allais_Q1.pl',forall,ndspcs_exclusive_domain_allais_Q1( T0, T1, XP, D, F , N, R )).
complete
true .

?- all_profiles( U ), length( U, NU ), XP=[[2,1,4],[2,1,3],[2,3,4],[2,4,1]], between( 1, NU, K ), tstamp( non, T0 ), exclusive_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), non_imposed( F ), tstamp( non, T1 ), length( F, N ), assert( ndspcs_exclusive_domain_allais_Q1( T0, T1, XP, D, F , N, R ) ), fail.


*/




gen_exclusive_dom_Q1_another_version:-
	 tstamp( start, T0 ),
	 all_profiles( U ),
%	 list_projection( I, U, D ),
	 decreasingly_choose_n_members( U, K, D ),
	 record_time_if_new_domain_size( K ),
	 is_an_exclusive_domain_Q1( D ),
	 tstamp( K, T ),
	 assert( exclusive_dom_Q1( T0, T, D, K ) ),
	 fail
	 ;
	 hist_exclusive_dom_Q1.


/*

?- [menu].
true.

?- [lib2017].
true.

?- chalt([1,2,4]), chpers([a,b]).
true.

?- abolish( exclusive_poss_dom_Q1/4 ).
true.

?- gen_exclusive_pos_dom_Q1.

non,[date(2024/6/30),time(11-52-5)]


?- hist_exclude_dom.
1;3
2;26
3;78
4;124
5;121
6;73
7;25
8;4
9;1
10;1
11;1
12;1
13;1
14;1
36;1
false.

?- tell_goal( 'exclusive_pos_dom_Q1.pl', forall, exclusive_pos_dom_Q1( _,_,_,_ )).
complete
true .


?- between(0,36, N ), exclusive_pos_dom_Q1( _,_,D,N ), N=14,swf( F, D ), fig( swf, F ), fail.

          123456
1:[1,2,4] ------
2:[1,4,2] ------
3:[2,1,4] ------
4:[2,4,1] ----56
5:[4,1,2] 555555
6:[4,2,1] 556656
--
          123456
1:[1,2,4] ------
2:[1,4,2] ------
3:[2,1,4] ------
4:[2,4,1] ----56
5:[4,1,2] 556656
6:[4,2,1] 556656
--
          123456
1:[1,2,4] ------
2:[1,4,2] ------
3:[2,1,4] ------
4:[2,4,1] ----66
5:[4,1,2] 555555
6:[4,2,1] 666666
--
          123456
1:[1,2,4] ------
2:[1,4,2] ------
3:[2,1,4] ------
4:[2,4,1] ----44
5:[4,1,2] 556656
6:[4,2,1] 666666
--
          123456
1:[1,2,4] ------
2:[1,4,2] ------
3:[2,1,4] ------
4:[2,4,1] ----66
5:[4,1,2] 556656
6:[4,2,1] 666666
--
false.

% abort

?- between(0,36, N ), findall(1, exclusive_pos_dom_Q1( _,_,D,N ), L), length(L, M ), M>0, writeln( N; M ), fail.
0;25872
1;25875
2;30320
3;12986
4;3449
5;696
6;116
7;17
8;3
9;1
10;1
11;1
12;1
13;1
14;1
36;1
false.

% previous one

?- findall(1, exclusive_pos_dom_Q1( _,_,D,_ ), L), length(L, M ).
L = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
M = 151012.

?- findall(D,exclusive_pos_dom_Q1( T0,  XP, D, N  ),L),sort(L,H),length(H,M), nth1( J, H, D ), assert( exclusive_pos_dom_Q1( D ) ), fail.

?- findall(1, exclusive_pos_dom_Q1( _), L), length(L, M ).
L = [1, 1, 1, 1, 1, 1, 1, 1, 1|...],
M = 1331.


?- tell_goal( 'exclusive_pos_dom_Q1.pl', forall, exclusive_pos_dom_Q1( D )).
complete
true .

?- between(1,35,J), K is 36-J, length(D, K ), exclusive_pos_dom_Q1( D ), !, length( D1, K ), exclusive_pos_dom_Q1( D1 ), swf( F, D1 ), fig( swf, F ), fail.

          123456
1:[1,2,4] ------
2:[1,4,2] ------
3:[2,1,4] ------
4:[2,4,1] ----56
5:[4,1,2] 555555
6:[4,2,1] 556656
--
          123456
1:[1,2,4] ------
2:[1,4,2] ------
3:[2,1,4] ------
4:[2,4,1] ----56
5:[4,1,2] 556656
6:[4,2,1] 556656
--
          123456
1:[1,2,4] ------
2:[1,4,2] ------
3:[2,1,4] ------
4:[2,4,1] ----66
5:[4,1,2] 555555
6:[4,2,1] 666666
--
          123456
1:[1,2,4] ------
2:[1,4,2] ------
3:[2,1,4] ------
4:[2,4,1] ----44
5:[4,1,2] 556656
6:[4,2,1] 666666
--
          123456
1:[1,2,4] ------
2:[1,4,2] ------
3:[2,1,4] ------
4:[2,4,1] ----66
5:[4,1,2] 556656
6:[4,2,1] 666666
--
false.


?- XP=[[2,1,4],[2,1,3],[2,3,4],[2,4,1]],   tstamp( non, T0 ), exclusive_possiblity_domain( XP, D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ), non_imposed( F ), tstamp( non, T1 ), length( F, N ), assert( ndspcs_exclusive_possibility_domain_allais_Q1( T0, T1, XP, D, F , N, R ) ), fail.
non,[date(2024/6/30),time(2-28-8)]
non,[date(2024/6/30),time(2-28-34)]
non,[date(2024/6/30),time(2-28-42)]
non,[date(2024/6/30),time(2-28-49)]
non,[date(2024/6/30),time(2-28-55)]
non,[date(2024/6/30),time(2-29-0)]
non,[date(2024/6/30),time(2-29-0)]
non,[date(2024/6/30),time(2-29-5)]
non,[date(2024/6/30),time(2-29-5)]
non,[date(2024/6/30),time(2-29-14)]
non,[date(2024/6/30),time(2-29-17)]
non,[date(2024/6/30),time(2-29-24)]
non,[date(2024/6/30),time(2-29-24)]
non,[date(2024/6/30),time(2-29-31)]
non,[date(2024/6/30),time(2-29-31)]
non,[date(2024/6/30),time(2-29-31)]
non,[date(2024/6/30),time(2-29-33)]
non,[date(2024/6/30),time(2-29-33)]
non,[date(2024/6/30),time(2-29-33)]
non,[date(2024/6/30),time(2-29-36)]
non,[date(2024/6/30),time(2-29-37)]
non,[date(2024/6/30),time(2-29-37)]
non,[date(2024/6/30),time(2-29-37)]
non,[date(2024/6/30),time(2-29-38)]
non,[date(2024/6/30),time(2-29-38)]
non,[date(2024/6/30),time(2-29-39)]
non,[date(2024/6/30),time(2-29-39)]
false.

?- tell_goal( 'ndspcs_exclusive_possibility_domain_allais_Q1.pl',forall,ndspcs_exclusive_possibility_domain_allais_Q1( T0, T1, XP, D, F , N, R )).
complete
true .

?- ndspcs_exclusive_possiblity_domain_allais_Q1( T0, T1, XP, D, F , N, R ), N>30, write(+), fail.
+++
false.

?- ndspcs_exclusive_possiblity_domain_allais_Q1( T0, T1, XP, D, F , N, R ), N>30, write(+), fig( scf, F ), fail.
+
          123456
1:[1,2,4] ---222
2:[1,4,2] 111444
3:[2,1,4] 222222
4:[2,4,1] 222222
5:[4,1,2] 444444
6:[4,2,1] 444444
--+
          123456
1:[1,2,4] ----22
2:[1,4,2] 111444
3:[2,1,4] 222222
4:[2,4,1] 222222
5:[4,1,2] 444444
6:[4,2,1] 444444
--+
          123456
1:[1,2,4] -----2
2:[1,4,2] 111444
3:[2,1,4] 222222
4:[2,4,1] 222222
5:[4,1,2] 444444
6:[4,2,1] 444444
--
false.

*/


%-----------------------------------------------------------------
% a possibility: a product domain of minus one 
%-----------------------------------------------------------------
% 19 Jun 2024

/*


?- chalt([1,2,4]), chpers( [a,b] ).

?- alternatives(A).
A = [1, 2, 4].

?- persons(I).
I = [a, b].


?- findall(P, (pp(P),\+ member( [2,1,4], P ) ), D ), swf(F, D ), fig( swf, F), fail.

          123456
1:[1,2,4] 12-122
2:[1,4,2] 22-222
3:[2,1,4] ------
4:[2,4,1] 12-456
5:[4,1,2] 22-555
6:[4,2,1] 22-656
--
          123456
1:[1,2,4] 12-456
2:[1,4,2] 22-656
3:[2,1,4] ------
4:[2,4,1] 12-456
5:[4,1,2] 22-656
6:[4,2,1] 22-656
--
          123456
1:[1,2,4] 12-122
2:[1,4,2] 22-222
3:[2,1,4] ------
4:[2,4,1] 46-466
5:[4,1,2] 55-555
6:[4,2,1] 66-666
--
          123456
1:[1,2,4] 12-456
2:[1,4,2] 22-656
3:[2,1,4] ------
4:[2,4,1] 46-466
5:[4,1,2] 55-656
6:[4,2,1] 66-666
--
false.

?- findall(P, (pp(P),\+ member( [2,1,4], P ) ), D ), scf(F, D ), non_imposed( F ), fig( scf, F), fail.

          123456
1:[1,2,4] 11-111
2:[1,4,2] 11-111
3:[2,1,4] ------
4:[2,4,1] 11-244
5:[4,1,2] 11-444
6:[4,2,1] 11-444
--
          123456
1:[1,2,4] 11-244
2:[1,4,2] 11-444
3:[2,1,4] ------
4:[2,4,1] 11-244
5:[4,1,2] 11-444
6:[4,2,1] 11-444
--
          123456
1:[1,2,4] 11-111
2:[1,4,2] 11-111
3:[2,1,4] ------
4:[2,4,1] 24-244
5:[4,1,2] 44-444
6:[4,2,1] 44-444
--
          123456
1:[1,2,4] 11-244
2:[1,4,2] 11-444
3:[2,1,4] ------
4:[2,4,1] 24-244
5:[4,1,2] 44-444
6:[4,2,1] 44-444
--
false.

?- pp([P,Q]),r([2,1],P),r([1,4],Q), nl, write( P;Q),\+ (f([X-Y], [[P,Q]], swf_axiom ), Y=[2,1,4] ).

[2,1,4];[1,2,4]
[2,1,4];[1,4,2]
[2,1,4];[2,1,4]
[2,4,1];[1,2,4]
[2,4,1];[1,4,2]
[2,4,1];[2,1,4]
[4,2,1];[1,2,4]
[4,2,1];[1,4,2]
P = [4, 2, 1],
Q = [1, 4, 2] ;

[4,2,1];[2,1,4]
false.

?- chalt([1,3,4,5,6]), chpers( [a,b] ).

?- pp([P,Q]),[A,B]=[3,1], member( C, [4,5,6] ),r([A,B],P),r([B,C],Q), \+ ( f([X-Y], [[P,Q]], swf_axiom ), r([A,B],Y), member( C1, [4,5,6] ),r([B,C1],Y) ), assert(tmp_Q3_excluding_pp( [A,B,C], [P, Q]) ),fail.


?- findall( PP,tmp_Q3_excluding_pp( _, PP), [D1,D2,D3|D] ), length( [_,_,_|D], L ).
D1 = [[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]],
D2 = [[4, 3, 5, 6, 1], [6, 5, 1, 4, 3]],
D3 = [[4, 3, 6, 5, 1], [5, 6, 1, 4, 3]],
D = [[[4, 3, 6, 5, 1], [6, 5, 1, 4, 3]], [[4, 5, 3, 6, 1], [4, 6, 1, 5, 3]], [[4, 5, 3, 6, 1], [5, 6, 1, 4|...]], [[4, 5, 3, 6|...], [6, 1, 4|...]], [[4, 5, 3|...], [6, 1|...]], [[4, 5|...], [6|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
L = 276.


?- findall( PP,tmp_Q3_excluding_pp( _, PP), D ), f( F, D, scf_axiom ), non_imposed( F ).
false.

?- findall( PP,tmp_Q3_excluding_pp( _, PP), D ), f( F, D, scf_axiom ), dictatorial_scf( J, F ), nl, write(J ), fail.

2
1
false.


?- findall( PP,tmp_Q3_excluding_pp( _, PP), D ), f( F, D, scf_axiom ), \+ dictatorial_scf( J, F ).
D = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]], [[4, 3, 5, 6, 1], [6, 5, 1, 4, 3]], [[4, 3, 6, 5, 1], [5, 6, 1, 4|...]], [[4, 3, 6, 5|...], [6, 5, 1|...]], [[4, 5, 3|...], [4, 6|...]], [[4, 5|...], [5|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
F = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]]-1, [[4, 3, 5, 6, 1], [6, 5, 1, 4|...]]-1, [[4, 3, 6, 5|...], [5, 6, 1|...]]-1, [[4, 3, 6|...], [6, 5|...]]-1, [[4, 5|...], [4|...]]-1, [[4|...], [...|...]]-1, [[...|...]|...]-1, [...|...]-1, ... - ...|...] .

?- findall( PP,tmp_Q3_excluding_pp( _, PP), D ), f( F, D, swf_axiom ), \+ dictatorial_swf( J, F ).
, \+ dictatorial_swf( J, F ).

D = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]], [[1, 4, 5, 6, 3], [6, 5, 3, 1, 4]], [[1, 4, 6, 5, 3], [5, 6, 3, 1|...]], [[1, 4, 6, 5|...], [6, 5, 3|...]], [[1, 5, 4|...], [1, 6|...]], [[1, 5|...], [5|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
F = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]]-[5, 6, 1, 3, 4], [[1, 4, 5, 6, 3], [6, 5, 3, 1|...]]-[6, 5, 1, 3, 4], [[1, 4, 6, 5|...], [5, 6, 3|...]]-[5, 6, 1, 3, 4], [[1, 4, 6|...], [6, 5|...]]-[6, 5, 1, 3|...], [[1, 5|...], [1|...]]-[1, 6, 5|...], [[1|...], [...|...]]-[5, 6|...], [[...|...]|...]-[6|...], [...|...]-[...

*/


% using pp_extended_with/3
		 

/*

?- tmp_Q3_excluding_pp( _, PP), !, maplist(p_extended_with(2), PP, R ).
PP = [[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]],
R = [[2, 4, 3, 5, 6, 1], [2, 5, 6, 1, 4, 3]] .

?- tmp_Q3_excluding_pp( _, PP), !,pp_extended_with(2, PP, R ).
PP = [[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]],
R = [[2, 4, 3, 5, 6, 1], [2, 5, 6, 1, 4, 3]] .


?- findall( PP, ( tmp_Q3_excluding_pp( _, PP)), D ), length( D, N ), f( F, D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( J, F ).D = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]], [[4, 3, 5, 6, 1], [6, 5, 1, 4, 3]], [[4, 3, 6, 5, 1], [5, 6, 1, 4|...]], [[4, 3, 6, 5|...], [6, 5, 1|...]], [[4, 5, 3|...], [4, 6|...]], [[4, 5|...], [5|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 276,
F = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]]-c, [[4, 3, 5, 6, 1], [6, 5, 1, 4|...]]-b, [[4, 3, 6, 5|...], [5, 6, 1|...]]-a, [[4, 3, 6|...], [6, 5|...]]-a, [[4, 5|...], [4|...]]-a, [[4|...], [...|...]]-a, [[...|...]|...]-a, [...|...]-a, ... - ...|...] .

?- 

?- findall( PP, ( tmp_Q3_excluding_pp( _, PP0), pp_extended_with( 2, PP0, PP ) ), D ), length( D, N ), f( F, D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( J, F ).


D = [[[2, 4, 3, 5, 6, 1], [2, 5, 6, 1, 4, 3]], [[2, 4, 3, 5, 6, 1], [5, 2, 6, 1, 4|...]], [[2, 4, 3, 5, 6|...], [5, 6, 2, 1|...]], [[2, 4, 3, 5|...], [5, 6, 1|...]], [[2, 4, 3|...], [5, 6|...]], [[2, 4|...], [5|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 9936,
F = [[[2, 4, 3, 5, 6, 1], [2, 5, 6, 1, 4|...]]-c, [[2, 4, 3, 5, 6|...], [5, 2, 6, 1|...]]-b, [[2, 4, 3, 5|...], [5, 6, 2|...]]-a, [[2, 4, 3|...], [5, 6|...]]-a, [[2, 4|...], [5|...]]-a, [[2|...], [...|...]]-a, [[...|...]|...]-a, [...|...]-a, ... - ...|...] ;


?- findall( PP, ( tmp_Q3_excluding_pp( _, PP) ), D ), length( D, N ), f( F, D, swf_axiom ), \+ dictatorial_swf( J, F ).
D = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]], [[4, 3, 5, 6, 1], [6, 5, 1, 4, 3]], [[4, 3, 6, 5, 1], [5, 6, 1, 4|...]], [[4, 3, 6, 5|...], [6, 5, 1|...]], [[4, 5, 3|...], [4, 6|...]], [[4, 5|...], [5|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 276,
F = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]]-[a, b, c], [[4, 3, 5, 6, 1], [6, 5, 1, 4|...]]-[a, b, c], [[4, 3, 6, 5|...], [5, 6, 1|...]]-[a, b, c], [[4, 3, 6|...], [6, 5|...]]-[a, b, c], [[4, 5|...], [4|...]]-[a, b, c], [[4|...], [...|...]]-[a, b|...], [[...|...]|...]-[a|...], [...|...]-[...|...], ... - ...|...] .

% extended domainだと半日たっても見つからなかった(23 Jun 14:26)

?- pp([P,Q]),[A,B]=[4,3], member( C, [1,5,6] ),r([A,B],P),r([B,C],Q), \+ ( f([X-Y], [[P,Q]], swf_axiom ), r([A,B],Y), member( C1, [1,5,6] ),r([B,C1],Y) ), assert(tmp_Q3_excluding_pp_43_156( [A,B,C], [P, Q]) ),fail.

?- tell_goal( 'tmp_Q3_excluding_pp_43_156.pl',forall,tmp_Q3_excluding_pp_43_156( _, PP) ).
complete
true .


?- findall( PP,tmp_Q3_excluding_pp_43_156( _, PP), D ), f( F, D, swf_axiom ), \+ dictatorial_swf( J, F ).

D = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]], [[1, 4, 5, 6, 3], [6, 5, 3, 1, 4]], [[1, 4, 6, 5, 3], [5, 6, 3, 1|...]], [[1, 4, 6, 5|...], [6, 5, 3|...]], [[1, 5, 4|...], [1, 6|...]], [[1, 5|...], [5|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
F = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]]-[5, 6, 1, 3, 4], [[1, 4, 5, 6, 3], [6, 5, 3, 1|...]]-[6, 5, 1, 3, 4], [[1, 4, 6, 5|...], [5, 6, 3|...]]-[5, 6, 1, 3, 4], [[1, 4, 6|...], [6, 5|...]]-[6, 5, 1, 3|...], [[1, 5|...], [1|...]]-[1, 6, 5|...], [[1|...], [...|...]]-[5, 6|...], [[...|...]|...]-[6|...], [...|...]-[...|...], ... - ...|...] .

?- persons(I).
I = [a, b].

?- alternatives(I).
I = [1, 3, 4, 5, 6].

?- findall( PP,tmp_Q3_excluding_pp( _, PP), D1 ), findall( PP,tmp_Q3_excluding_pp_43_156( _, PP), D2 ), union( D1, D2, D ), length( D1, N1 ), length( D2, N2 ), length( D, N ), sort(D, Ds), length(Ds, Ns), f( F, Ds, swf_axiom ), \+ dictatorial_swf( J, F ).
D1 = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]], [[4, 3, 5, 6, 1], [6, 5, 1, 4, 3]], [[4, 3, 6, 5, 1], [5, 6, 1, 4|...]], [[4, 3, 6, 5|...], [6, 5, 1|...]], [[4, 5, 3|...], [4, 6|...]], [[4, 5|...], [5|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
D2 = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]], [[1, 4, 5, 6, 3], [6, 5, 3, 1, 4]], [[1, 4, 6, 5, 3], [5, 6, 3, 1|...]], [[1, 4, 6, 5|...], [6, 5, 3|...]], [[1, 5, 4|...], [1, 6|...]], [[1, 5|...], [5|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
D = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]], [[4, 3, 5, 6, 1], [6, 5, 1, 4, 3]], [[4, 3, 6, 5, 1], [5, 6, 1, 4|...]], [[4, 3, 6, 5|...], [6, 5, 1|...]], [[4, 5, 3|...], [4, 6|...]], [[4, 5|...], [5|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
N1 = N2, N2 = 276,
N = 552,
Ds = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]], [[1, 4, 5, 6, 3], [6, 5, 3, 1, 4]], [[1, 4, 6, 5, 3], [5, 6, 3, 1|...]], [[1, 4, 6, 5|...], [6, 5, 3|...]], [[1, 5, 4|...], [1, 6|...]], [[1, 5|...], [5|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
Ns = 312,
F = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]]-[5, 6, 1, 3, 4], [[1, 4, 5, 6, 3], [6, 5, 3, 1|...]]-[6, 5, 1, 3, 4], [[1, 4, 6, 5|...], [5, 6, 3|...]]-[5, 6, 1, 3, 4], [[1, 4, 6|...], [6, 5|...]]-[6, 5, 1, 3|...], [[1, 5|...], [1|...]]-[1, 6, 5|...], [[1|...], [...|...]]-[5, 6|...], [[...|...]|...]-[6|...], [...|...]-[...|...], ... - ...|...] 

?- findall( PP,tmp_Q3_excluding_pp_43_156( _, PP), D2 ), intersection( D1, D2, D ), length( D1, N1 ), length( D2, N2 ), length( D, N ).
D1 = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]], [[4, 3, 5, 6, 1], [6, 5, 1, 4, 3]], [[4, 3, 6, 5, 1], [5, 6, 1, 4|...]], [[4, 3, 6, 5|...], [6, 5, 1|...]], [[4, 5, 3|...], [4, 6|...]], [[4, 5|...], [5|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
D2 = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]], [[1, 4, 5, 6, 3], [6, 5, 3, 1, 4]], [[1, 4, 6, 5, 3], [5, 6, 3, 1|...]], [[1, 4, 6, 5|...], [6, 5, 3|...]], [[1, 5, 4|...], [1, 6|...]], [[1, 5|...], [5|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
D = [],
N1 = N2, N2 = 276,
N = 0.

?- pp([P,Q]),[A,B]=[1,3], member( C, [6] ),r([A,B],P),r([B,C],Q), \+ ( f([X-Y], [[P,Q]], swf_axiom ), r([A,B],Y), member( C1, [6] ),r([B,C1],Y) ), assert(tmp_Q3_excluding_pp_13_6( [A,B,C], [P, Q]) ),fail.
false.

?- findall( PP,tmp_Q3_excluding_pp( _, PP), D1 ), findall( PP,tmp_Q3_excluding_pp_43_156( _, PP), D2 ), intersection( D1, D2, D12 ),  findall( PP,tmp_Q3_excluding_pp_13_6( _, PP), D3 ), intersection( D2, D3, D23 ), intersection( D1, D3, D13 ).
D1 = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]], [[4, 3, 5, 6, 1], [6, 5, 1, 4, 3]], [[4, 3, 6, 5, 1], [5, 6, 1, 4|...]], [[4, 3, 6, 5|...], [6, 5, 1|...]], [[4, 5, 3|...], [4, 6|...]], [[4, 5|...], [5|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
D2 = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]], [[1, 4, 5, 6, 3], [6, 5, 3, 1, 4]], [[1, 4, 6, 5, 3], [5, 6, 3, 1|...]], [[1, 4, 6, 5|...], [6, 5, 3|...]], [[1, 5, 4|...], [1, 6|...]], [[1, 5|...], [5|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
D12 = D13, D13 = [],
D3 = [[[4, 5, 6, 1, 3], [3, 4, 5, 6, 1]], [[4, 5, 6, 1, 3], [3, 4, 6, 1, 5]], [[4, 5, 6, 1, 3], [3, 4, 6, 5|...]], [[4, 5, 6, 1|...], [3, 5, 4|...]], [[4, 5, 6|...], [3, 5|...]], [[4, 5|...], [3|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
D23 = [[[5, 6, 1, 4, 3], [3, 5, 6, 1, 4]], [[5, 6, 1, 4, 3], [3, 5, 6, 1, 4]], [[5, 6, 1, 4, 3], [3, 5, 6, 1|...]], [[5, 6, 1, 4|...], [3, 6, 1|...]], [[5, 6, 1|...], [3, 6|...]], [[5, 6|...], [3|...]], [[5|...], [...|...]], [[...|...]|...], [...|...]|...].

?- pp([P,Q]),[A,B]=[3,4], member( C, [5] ),r([A,B],P),r([B,C],Q), \+ ( f([X-Y], [[P,Q]], swf_axiom ), r([A,B],Y), member( C1, [5] ),r([B,C1],Y) ), assert(tmp_Q3_excluding_pp_3_45( [A,B,C], [P, Q]) ),fail.
false.


?- findall( PP,tmp_Q3_excluding_pp( _, PP), D1 ), findall( PP,tmp_Q3_excluding_pp_43_156( _, PP), D2 ), intersection( D1, D2, D12 ),  findall( PP,tmp_Q3_excluding_pp_3_45( _, PP), D3 ), intersection( D2, D3, D23 ), intersection( D1, D3, D13 ).
D1 = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]], [[4, 3, 5, 6, 1], [6, 5, 1, 4, 3]], [[4, 3, 6, 5, 1], [5, 6, 1, 4|...]], [[4, 3, 6, 5|...], [6, 5, 1|...]], [[4, 5, 3|...], [4, 6|...]], [[4, 5|...], [5|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
D2 = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]], [[1, 4, 5, 6, 3], [6, 5, 3, 1, 4]], [[1, 4, 6, 5, 3], [5, 6, 3, 1|...]], [[1, 4, 6, 5|...], [6, 5, 3|...]], [[1, 5, 4|...], [1, 6|...]], [[1, 5|...], [5|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
D12 = D23, D23 = [],
D3 = [[[1, 5, 3, 4, 6], [1, 4, 5, 3, 6]], [[1, 5, 3, 4, 6], [1, 4, 5, 6, 3]], [[1, 5, 3, 4, 6], [1, 4, 6, 5|...]], [[1, 5, 3, 4|...], [1, 6, 4|...]], [[1, 5, 3|...], [4, 1|...]], [[1, 5|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
D13 = [[[5, 3, 4, 6, 1], [4, 6, 1, 5, 3]], [[5, 3, 4, 6, 1], [6, 4, 1, 5, 3]], [[5, 3, 6, 4, 1], [4, 6, 1, 5|...]], [[5, 3, 6, 4|...], [6, 4, 1|...]], [[5, 6, 3|...], [4, 1|...]], [[5, 6|...], [4|...]], [[5|...], [...|...]], [[...|...]|...], [...|...]|...].

?- findall( PP,tmp_Q3_excluding_pp_43_156( _, PP), D2 ), findall( PP,tmp_Q3_excluding_pp_13_6( _, PP), D3 ), intersection( D2, D3, D ), length( D, N ), f( F, D, swf_axiom ), \+ dictatorial_swf( J, F ).
D2 = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]], [[1, 4, 5, 6, 3], [6, 5, 3, 1, 4]], [[1, 4, 6, 5, 3], [5, 6, 3, 1|...]], [[1, 4, 6, 5|...], [6, 5, 3|...]], [[1, 5, 4|...], [1, 6|...]], [[1, 5|...], [5|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
D3 = [[[4, 5, 6, 1, 3], [3, 4, 5, 6, 1]], [[4, 5, 6, 1, 3], [3, 4, 6, 1, 5]], [[4, 5, 6, 1, 3], [3, 4, 6, 5|...]], [[4, 5, 6, 1|...], [3, 5, 4|...]], [[4, 5, 6|...], [3, 5|...]], [[4, 5|...], [3|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
D = [[[5, 6, 1, 4, 3], [3, 5, 6, 1, 4]], [[5, 6, 1, 4, 3], [3, 5, 6, 1, 4]], [[5, 6, 1, 4, 3], [3, 5, 6, 1|...]], [[5, 6, 1, 4|...], [3, 6, 1|...]], [[5, 6, 1|...], [3, 6|...]], [[5, 6|...], [3|...]], [[5|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 35,
F = [[[5, 6, 1, 4, 3], [3, 5, 6, 1, 4]]-[3, 5, 6, 1, 4], [[5, 6, 1, 4, 3], [3, 5, 6, 1|...]]-[3, 5, 6, 1, 4], [[5, 6, 1, 4|...], [3, 5, 6|...]]-[3, 5, 6, 1, 4], [[5, 6, 1|...], [3, 6|...]]-[3, 5, 6, 1|...], [[5, 6|...], [3|...]]-[3, 5, 6|...], [[5|...], [...|...]]-[3, 5|...], [[...|...]|...]-[3|...], [...|...]-[...|...], ... - ...|...] .

?- findall( PP,tmp_Q3_excluding_pp_43_156( _, PP), D2 ), findall( PP,tmp_Q3_excluding_pp_13_6( _, PP), D3 ), intersection( D2, D3, D ), length( D, N ), f( F, D, swf_axiom ), \+ dictatorial_swf( J, F ).
D2 = [[[1, 4, 5, 6, 3], [5, 6, 3, 1, 4]], [[1, 4, 5, 6, 3], [6, 5, 3, 1, 4]], [[1, 4, 6, 5, 3], [5, 6, 3, 1|...]], [[1, 4, 6, 5|...], [6, 5, 3|...]], [[1, 5, 4|...], [1, 6|...]], [[1, 5|...], [5|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
D3 = [[[4, 5, 6, 1, 3], [3, 4, 5, 6, 1]], [[4, 5, 6, 1, 3], [3, 4, 6, 1, 5]], [[4, 5, 6, 1, 3], [3, 4, 6, 5|...]], [[4, 5, 6, 1|...], [3, 5, 4|...]], [[4, 5, 6|...], [3, 5|...]], [[4, 5|...], [3|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
D = [[[5, 6, 1, 4, 3], [3, 5, 6, 1, 4]], [[5, 6, 1, 4, 3], [3, 5, 6, 1, 4]], [[5, 6, 1, 4, 3], [3, 5, 6, 1|...]], [[5, 6, 1, 4|...], [3, 6, 1|...]], [[5, 6, 1|...], [3, 6|...]], [[5, 6|...], [3|...]], [[5|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 35,
F = [[[5, 6, 1, 4, 3], [3, 5, 6, 1, 4]]-[3, 5, 6, 1, 4], [[5, 6, 1, 4, 3], [3, 5, 6, 1|...]]-[3, 5, 6, 1, 4], [[5, 6, 1, 4|...], [3, 5, 6|...]]-[3, 5, 6, 1, 4], [[5, 6, 1|...], [3, 6|...]]-[3, 5, 6, 1|...], [[5, 6|...], [3|...]]-[3, 5, 6|...], [[5|...], [...|...]]-[3, 5|...], [[...|...]|...]-[3|...], [...|...]-[...|...], ... - ...|...] .


?- findall( PP,tmp_Q3_excluding_pp_43_156( _, PP), D2 ), findall( PP,tmp_Q3_excluding_pp_13_6( _, PP), D3 ), intersection( D2, D3, D ), length( D, N ), f( F, D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( J, F ).
false.

?- findall( PP,tmp_Q3_excluding_pp( _, PP), D1 ), findall( PP,tmp_Q3_excluding_pp_3_45( _, PP), D4 ), intersection( D1, D4, D ), length( D, N ), f( F, D, swf_axiom ), \+ dictatorial_swf( J, F ).
D1 = [[[4, 3, 5, 6, 1], [5, 6, 1, 4, 3]], [[4, 3, 5, 6, 1], [6, 5, 1, 4, 3]], [[4, 3, 6, 5, 1], [5, 6, 1, 4|...]], [[4, 3, 6, 5|...], [6, 5, 1|...]], [[4, 5, 3|...], [4, 6|...]], [[4, 5|...], [5|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...],
D4 = [[[1, 5, 3, 4, 6], [1, 4, 5, 3, 6]], [[1, 5, 3, 4, 6], [1, 4, 5, 6, 3]], [[1, 5, 3, 4, 6], [1, 4, 6, 5|...]], [[1, 5, 3, 4|...], [1, 6, 4|...]], [[1, 5, 3|...], [4, 1|...]], [[1, 5|...], [4|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
D = [[[5, 3, 4, 6, 1], [4, 6, 1, 5, 3]], [[5, 3, 4, 6, 1], [6, 4, 1, 5, 3]], [[5, 3, 6, 4, 1], [4, 6, 1, 5|...]], [[5, 3, 6, 4|...], [6, 4, 1|...]], [[5, 6, 3|...], [4, 1|...]], [[5, 6|...], [4|...]], [[5|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 18,
F = [[[5, 3, 4, 6, 1], [4, 6, 1, 5, 3]]-[4, 6, 1, 5, 3], [[5, 3, 4, 6, 1], [6, 4, 1, 5|...]]-[4, 6, 1, 5, 3], [[5, 3, 6, 4|...], [4, 6, 1|...]]-[4, 6, 1, 5, 3], [[5, 3, 6|...], [6, 4|...]]-[6, 4, 1, 5|...], [[5, 6|...], [4|...]]-[4, 1, 5|...], [[5|...], [...|...]]-[4, 1|...], [[...|...]|...]-[4|...], [...|...]-[...|...], ... - ...|...] .

?- findall( PP,tmp_Q3_excluding_pp( _, PP), D1 ), findall( PP,tmp_Q3_excluding_pp_34_5( _, PP), D4 ), intersection( D1, D4, D ), length( D, N ), f( F, D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( J, F ).
false.

% 23 Jun 2024

?- findall( PP, ( tmp_Q3_excluding_pp_43_156( _, PP0), pp_extended_with( 2, PP0, PP ),  tmp_Q3_excluding_pp_31_456( _, PP1 ), pp_extended_with( 2, PP1, PP ) ), D ), length( D, N ).
D = [],
N = 0.

?- 
*/

:- dynamic pp_excluding_ABC / 4.

init_pp_excluding_ABC:-
	abolish( pp_excluding_ABC / 4 ).


create_and_save_ABC_profiles( A, B, C ):-
	 alternatives( Alt ),
	 persons( Pers ),
	 Model = [ Alt, Pers, 'Q3' ], 
	 create_and_save_ABC_profiles( Model, A, B, C ).

model_ABC_profiles( Model, A, B, C, Xld ):-
	 Model = [ Alt, Pers, Q ],
	 chalt( Alt ),
	 Pers =[ a, b ],
	 chpers( Pers ),
 	 atomic_list_concat( [ Q,'_', A, B, C ], Xld ).

create_and_save_ABC_profiles( Model, A, B, C ):-
	 model_ABC_profiles( Model, A, B, C, Xld ),
	 pp( [ P, Q ] ),
	 %member( C, CL ),
	 %r([A,B],P),
	 %r([B,C],Q),
	 \+ (
		 f( [ _ - Y ], [ [ P, Q ] ], swf_axiom ),
		 r( [ A, B ], Y ),
		 %member( C1, CL ),
		 r( [ B, C ], Y )
	 ),
	 Model = [ Alt | _ ],
	 assert( pp_excluding_ABC( Xld, Alt, [A,B,C], [P, Q]) ),
	 fail.

create_and_save_ABC_profiles( Model,A,B,C ):-
	 ensure_loaded( menu ),
	 model_ABC_profiles( Model, A, B, C, Xld ),
	 alternatives( Alt ),
 	 atomic_list_concat( Alt, As ),
	 atomic_list_concat( [ Xld,'_', As,'.pl' ], F ),
	 tell_goal( F,forall,pp_excluding_ABC( Xld, _, _, _ ) ),
	 !.

/*

 ?- init_pp_excluding_ABC.
true.

  ?- create_and_save_ABC_profiles( [[2,4,5], _, 'Q3'], 2,4,5 ).
complete
true.

  ?- pp_excluding_ABC( Xld, _, _, _ ).
Xld = 'Q3_245'.

  ?- pp_excluding_ABC( Xld, A, B, C ).
Xld = 'Q3_245',
A = B, B = [2, 4, 5],
C = [[5, 2, 4], [4, 5, 2]].

 ?- create_and_save_ABC_profiles( [[2,4,5], _, 'Q3'], 4,2,5 ).
complete
true.

 ?- pp_excluding_ABC( Xld, A, B, C ).
Xld = 'Q3_245',
A = B, B = [2, 4, 5],
C = [[5, 2, 4], [4, 5, 2]] ;
Xld = 'Q3_425',
A = [2, 4, 5],
B = [4, 2, 5],
C = [[5, 4, 2], [2, 5, 4]].


*/


%-----------------------------------------------------------------
% maximal possibility domain of the SWF.
%-----------------------------------------------------------------
/*

?- % m1( C ), member( P, C ),
ppc( J, P ), nl, write( J; P ), fail.

[ 1, 5 ];[ [ a, c, b ], [ c, b, a ] ]
[ 2, 6 ];[ [ a, b, c ], [ c, a, b ] ]
[ 3, 1 ];[ [ b, a, c ], [ a, c, b ] ]
[ 4, 2 ];[ [ b, c, a ], [ a, b, c ] ]
[ 5, 3 ];[ [ c, b, a ], [ b, a, c ] ]
[ 6, 4 ];[ [ c, a, b ], [ b, c, a ] ]
false.

?- all_profiles( U ), ppc( [ 1, _ ], [ R1, R2 ] ), subtract( U, [ [ R1, R2 ], [ R2, R1 ] ], D ), f( F, D, swf_axiom ), fig( swf, F ), fail.

   123456
1:[ a, c, b ] 1233-1
2:[ a, b, c ] 223332
3:[ b, a, c ] 333333
4:[ b, c, a ] 333444
5:[ c, b, a ] -33455
6:[ c, a, b ] 123456
--
   123456
1:[ a, c, b ] 1234-6
2:[ a, b, c ] 123456
3:[ b, a, c ] 123456
4:[ b, c, a ] 123456
5:[ c, b, a ] -23456
6:[ c, a, b ] 123456
--
   123456
1:[ a, c, b ] 1111-1
2:[ a, b, c ] 222222
3:[ b, a, c ] 333333
4:[ b, c, a ] 444444
5:[ c, b, a ] -55555
6:[ c, a, b ] 666666
--
false.

?- all_profiles( U ), ppc( [ 1, _ ], [ R1, R2 ] ), subtract( U, [ [ R1, R2 ], [ R2, R1 ] ], D ), f( F, D, swf_axiom ), \+ dictatorial_swf( _, F ), fig( swf, F ), fail.

   123456
1:[ a, c, b ] 1233-1
2:[ a, b, c ] 223332
3:[ b, a, c ] 333333
4:[ b, c, a ] 333444
5:[ c, b, a ] -33455
6:[ c, a, b ] 123456
--
false.


*/


%-----------------------------------------------------------------
% strategy-proof non-imposed voting procedure
%(SCF; social choice function)
% -----------------------------------------------------------------
scf( F ):-
	 all_profiles( U ),
	 scf( F, U ).

scf( F, D ):-
	 f( F, D, scf_axiom ),
	 non_imposed( F ),
	 \+ dictatorial_scf( _, F ).

scf_axiom( X, Y, F ):-
	 x( Y ),
	 \+ manipulable( _, X - Y, F ).

scf_axiom_x( X, Y, F ):-
	 x( Y ),
	 \+ (
		 manipulable_2( J, X - Y, M, F ),
		 writeln( is_manipulable(  at_profile( X ), if_assign(Y), by(J), via(M) ) )
	 ).

% manipulable: 6 Jun 2019 generalized
% modified: 10 Aug 2024 

% 1 ) n=2

manipulable_2( 1, [ R, Q ] - S, [ P, Q ] - T, F ):-
	 member( [ P, Q ] - T, F ),
	 (
		 p( [ T, S ], R )
		 ;
		 p( [ S, T ], P )
	 ).

manipulable_2( 2, [ R, Q ] - S, [ R, W ] - T, F ):-
	 member( [ R, W ] - T, F ),
	 (
		 p( [ T, S ], Q )
		 ;
		 p( [ S, T ], W )
	 ).

manipulable_2( J, A, F ):-
	 manipulable_2( J, A, _, F ).

% 1 ) n>=1
/*
manipulable_n( J, PP0 - S, F ):-
	 member( PP - T, F ),
	 nth1( J, PP0, R ),
	 append( A, [ R | B ], PP0 ),
	 append( A, [ P | B ], PP ),
	 length( [ _ | A ], J ),
	 (
		 p( [ T, S ], R )
		 ;
		 p( [ S, T ], P )
	 ).
*/

% modified: 16 Dec 2025. debug 

manipulable_n( J, PP - S, PP1 -T, F ):-
 	member( PP - S, F ),
	append( A, [ R | B ], PP ),
	( p( [ T, S ], R ); p( [ S, T ], Q ) ),
	append( A, [ Q | B ], PP1 ),
 	member( PP1 - T, F ),
	length( [ _ | A ], J ).

/*

?- pp( P ), pp(Q), Q\=P, x(A), x(B), X=P-A, Y=Q-B, F=[X,Y],  manipulable_2( J, X, Y, F ), \+ manipulable_n( J, X, Y, F ), fig( scf, F ).
false.

?- pp( P ), pp(Q), Q\=P, x(A), x(B), X=P-A, Y=Q-B, F=[X,Y],  manipulable_n( J, X, Y, F ), \+ manipulable_2( J, X, Y, F ), fig( scf, F ).
false.

?- s1(D), ( f( F, D, scf_axiom ), non_imposed( F )), manipulable_2( J,X,Y, F ), \+ manipulable_n( J,X,Y, F ), fig( scf, F ).


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  -  -  
2:[a,c,b]  -  -  -  c  b  -  
3:[b,a,c]  a  -  -  -  a  -  
4:[b,c,a]  -  -  -  -  -  -  
5:[c,a,b]  -  -  -  -  -  -  
6:[c,b,a]  a  -  -  a  -  -  
--
D = [[[a, c, b], [b, c, a]], [[a, c, b], [c, a, b]], [[b, a, c], [a, b, c]], [[b, a, c], [c, a, b]], [[c, b, a], [a, b|...]], [[c, b|...], [b|...]]],
F = [[[a, c, b], [b, c, a]]-c, [[a, c, b], [c, a, b]]-b, [[b, a, c], [a, b, c]]-a, [[b, a, c], [c, a|...]]-a, [[c, b|...], [a|...]]-a, [[c|...], [...|...]]-a],
J = 1,
X = [[a, c, b], [b, c, a]]-b,
Y = [[a, c, b], [b, c, a]]-c .

?- X = [[a, c, b], [b, c, a]]-b,Y = [[a, c, b], [b, c, a]]-c, F=[X,Y],  manipulable_n( J, X, Y, F ).
X = [[a, c, b], [b, c, a]]-b,
Y = [[a, c, b], [b, c, a]]-c,
F = [[[a, c, b], [b, c, a]]-b, [[a, c, b], [b, c, a]]-c],
J = 1 .

?- X = [[a, c, b], [b, c, a]]-b,Y = [[a, c, b], [b, c, a]]-c, F=[X,Y],  manipulable_2( J, X, Y, F ).
X = [[a, c, b], [b, c, a]]-b,
Y = [[a, c, b], [b, c, a]]-c,
F = [[[a, c, b], [b, c, a]]-b, [[a, c, b], [b, c, a]]-c],
J = 1 .

?- 

% fix

?- s1(D), mapx( axiom(scf), D, F ), \+ ( f( F1, D, scf_axiom ), subtract(F1,F,[])), fig( scf, F ).
false.


*/

manipulable( J, PP - S, F ):-
	 %manipulable_2( J, PP - S, F ).
	 manipulable_n( J, PP - S, _, F ).


non_imposed( F ):-
	 \+ (
		 x( X ),
		 \+ member( _ - X, F )
	 ).

% 5-8 Aug 2024

imposed( F, S ):-
	 findall( X, (
		 x( X ),
		 \+ member( _ - X, F )
	 ), S ).

non_imposed_2( F ):- imposed( F, [ ] ).

% dictatorial_scf: 6 Jun 2019 corrected & generalized

% n = 2

% 18 Feb 2025 correction. 

dictatorial_scf_2( J, [ [ A, B ] - C | F ] ):-
	 nth1( J, [ A, B ], R1 ),
	 best( C, R1 ),  
	 \+ (
		 member( [ P, Q ] - X, F ),
		 nth1( J, [ P, Q ], R ),
		 \+ best( X, R )
	 ).

% n >= 1

dictatorial_scf_n( J, [ PP1 - A | F ] ):-
	 nth1( J, PP1, R1 ),
	 best( A, R1 ),
	 \+ (
		 member( PP - X, F ),
		 nth1( J, PP, R ),
		 \+ best( X, R )
	 ).

dictatorial_scf( J, F ):-
	 dictatorial_scf_n( J, F ),
	 \+ ( person( I ), I\= J, dictatorial_scf_n( I, F ) ).  % correct: 10 Nov 2025.


best( X, Q ):-
	 x( X ),
	 \+ (
		 x( Y ),
		 \+ r( [ X, Y ], Q )
	 ).

worst( X, Q ):-
	 x( X ),
	 \+ (
		 x( Y ),
		 \+ r( [ Y, X ], Q )
	 ).

medium( X, Q ):-
	 x( X ),
	 \+ best( X, Q ),
	 \+ worst( X, Q ).


%-----------------------------------------------------------------
% automated-proof of the Gibbard-Satterthwaite theorem
%-----------------------------------------------------------------
/*

 ?- scf( F ).
false.

 ?- all_profiles( U ), f( F, U, scf_axiom ), non_imposed( F ), fig( scf, F ), fail.

   123456
1:[ a, b, c ] aabbcc
2:[ a, c, b ] aabbcc
3:[ b, a, c ] aabbcc
4:[ b, c, a ] aabbcc
5:[ c, a, b ] aabbcc
6:[ c, b, a ] aabbcc
--
   123456
1:[ a, b, c ] aaaaaa
2:[ a, c, b ] aaaaaa
3:[ b, a, c ] bbbbbb
4:[ b, c, a ] bbbbbb
5:[ c, a, b ] cccccc
6:[ c, b, a ] cccccc
--
false.

*/


%-----------------------------------------------------------------
% monotone and unanimous SCF
%-----------------------------------------------------------------
mcf( F ):-
	 all_profiles( U ),
	 mcf( F, U ).

mcf( F, D ):-
	 f( F, D, mcf_axiom ),
	 \+ dictatorial_scf( _, F ).

% note: nondictatorship constraint is not active in the unrestricted domain.

mcf_axiom( X, Y, F ):-
	 x( Y ),
	 unanimity( X - Y ),
	 \+ nonmonotonic_change( X - Y, _, F ).

nonmonotonic_change_2( [ R1, R2 ] - C, [ Q1, Q2 ] - D, F ):-
	 member( [ Q1, Q2 ] - D, F ),
	 C \= D,
	 has_no_reversal( C, R1, Q1 ),
	 has_no_reversal( C, R2, Q2 ).

nonmonotonic_change_2( [ R1, R2 ] - C, [ Q1, Q2 ] - D, F ):-
	 member( [ Q1, Q2 ] - D, F ),
	 C \= D,
	 has_no_reversal( D, Q1, R1 ),
	 has_no_reversal( D, Q2, R2 ).

nonmonotonic_change_n( PP - C, SS - D, F ):-
	 member( SS - D, F ),
	 C \= D,
	 \+ (
		 nth1( J, PP, R ),
		 nth1( J, SS, Q ),
		 has_a_reversal( C, R, Q, 1 )
	 ).

nonmonotonic_change_n( PP - C, SS - D, F ):-
	 member( SS - D, F ),
	 C \= D,
	 \+ (
		 nth1( J, PP, R ),
		 nth1( J, SS, Q ),
		 has_a_reversal( D, R, Q, 2 )
	 ).

nonmonotonic_change( PP - C, SS - D, F ):-
	 nonmonotonic_change_2( PP - C, SS - D, F ).

% incorrect rule.
% ( A & - B )OR( A & - C ) =\= ( A & - ( B OR C ) )
% LHS = ( A & ( -B OR - C ) ) = ( A & - ( B & C ) ).


nonmonotonic_change_xx( PP - C, SS - D, F ):-
	 member( SS - D, F ),
	 C \= D,
	 \+ (
		 nth1( J, PP, R ),
		 nth1( J, SS, Q ),
		 member( X : K, [ C : 1, D : 2 ] ),
		 has_a_reversal( X, R, Q, K )
	 ).

has_a_reversal( X, R, Q, 1 ):-
	 lcc( X, R, Lr ),
	 lcc( X, Q, Lq ),
	 \+ subset( Lr, Lq ).

has_a_reversal( X, R, Q, 2 ):-
	 has_a_reversal( X, Q, R, 1 ).


has_no_reversal( X, R, Q ):-
	 lcc( X, R, Lr ),
	 lcc( X, Q, Lq ),
	 subset( Lr, Lq ).

lcc( X, R, L ):-
	 x( X ),
	 rc( _, R ),
	 append( _, [ X | L ], R ).

unanimity_2( [ [ X | _ ], [ X | _ ] ] - X ).
unanimity_2( [ [ X | _ ], [ Y | _ ] ] - _ ):- X \= Y.


unanimity_1( [ R1, R2 ] - D ):-
	 pp( [ R1, R2 ] ),
	 x( D ),
	 \+ (
		 x( C ),
		 C \= D,
		 p( [ C, D ], R1 ),
		 p( [ C, D ], R2 )
	 ).

unanimity_n( [ [ X | _ ] | PP ] - _ ):-
	 \+ \+ (
		 member( [ Y | _ ], PP ),
		 X \= Y
	 ).

unanimity_n( [ [ X | _ ] | PP ] - X ):-
	 \+ (
		 member( [ Y | _ ], PP ),
		 X \= Y
	 ).

unanimity( PP - D ):-
	 unanimity_n( PP - D ).

/*

% another automated-proof of the Gibbard-Satterthwaite theorem
% using Maskin-monotonicity ( the Muller-Satterthwaite theorem ).

 ?- all_profiles( U ), f( F, U, mcf_axiom ), fig( scf, F ), fail.

   123456
1:[ a, b, c ] aabbcc
2:[ a, c, b ] aabbcc
3:[ b, a, c ] aabbcc
4:[ b, c, a ] aabbcc
5:[ c, a, b ] aabbcc
6:[ c, b, a ] aabbcc
--
   123456
1:[ a, b, c ] aaaaaa
2:[ a, c, b ] aaaaaa
3:[ b, a, c ] bbbbbb
4:[ b, c, a ] bbbbbb
5:[ c, a, b ] cccccc
6:[ c, b, a ] cccccc
--
false.

?- all_profiles( 2, U ), f( F, U, mcf_axiom ), hr( 35 ), scf_xy( F, B, Y ), nl, write( B:Y ), fail.

-----------------------------------
[ a, a ]:[ [ *, * ]-a ]
[ a, b ]:[ [ a, a ]-a, [ a, b ]-b, [ b, a ]-a, [ b, b ]-b ]
[ a, c ]:[ [ a, a ]-a, [ a, c ]-c, [ c, a ]-a, [ c, c ]-c ]
[ b, a ]:[ [ a, a ]-a, [ a, b ]-b, [ b, a ]-a, [ b, b ]-b ]
[ b, b ]:[ [ *, * ]-b ]
[ b, c ]:[ [ b, b ]-b, [ b, c ]-c, [ c, b ]-b, [ c, c ]-c ]
[ c, a ]:[ [ a, a ]-a, [ a, c ]-c, [ c, a ]-a, [ c, c ]-c ]
[ c, b ]:[ [ b, b ]-b, [ b, c ]-c, [ c, b ]-b, [ c, c ]-c ]
[ c, c ]:[ [ *, * ]-c ]
-----------------------------------
[ a, a ]:[ [ *, * ]-a ]
[ a, b ]:[ [ a, a ]-a, [ a, b ]-a, [ b, a ]-b, [ b, b ]-b ]
[ a, c ]:[ [ a, a ]-a, [ a, c ]-a, [ c, a ]-c, [ c, c ]-c ]
[ b, a ]:[ [ a, a ]-a, [ a, b ]-a, [ b, a ]-b, [ b, b ]-b ]
[ b, b ]:[ [ *, * ]-b ]
[ b, c ]:[ [ b, b ]-b, [ b, c ]-b, [ c, b ]-c, [ c, c ]-c ]
[ c, a ]:[ [ a, a ]-a, [ a, c ]-a, [ c, a ]-c, [ c, c ]-c ]
[ c, b ]:[ [ b, b ]-b, [ b, c ]-b, [ c, b ]-c, [ c, c ]-c ]
[ c, c ]:[ [ *, * ]-c ]
false.

?- tmp_scf_domain_1( N, _, D, _ ), f( F, D, mcf_axiom ), non_imposed( F ), hr( 30 ), scf_xy( F, B, Y ), nl, write( B:Y ), fail.

------------------------------
[ a, a ]:[ [ *, * ]-a ]
[ a, b ]:[ [ a, b ]-b, [ b, a ]-a, [ b, b ]-b ]
[ a, c ]:[ [ a, a ]-a, [ a, c ]-c, [ c, a ]-a ]
[ b, a ]:[ [ a, b ]-b, [ b, a ]-a, [ b, b ]-b ]
[ b, b ]:[ [ *, * ]-b ]
[ b, c ]:[ [ b, c ]-c, [ c, b ]-b, [ c, c ]-c ]
[ c, a ]:[ [ a, a ]-a, [ a, c ]-c, [ c, a ]-a ]
[ c, b ]:[ [ b, c ]-c, [ c, b ]-b, [ c, c ]-c ]
[ c, c ]:[ [ *, * ]-c ]
------------------------------
[ a, a ]:[ [ *, * ]-a ]
[ a, b ]:[ [ a, a ]-a, [ a, b ]-a, [ b, a ]-b ]
[ a, c ]:[ [ a, c ]-a, [ c, a ]-c, [ c, c ]-c ]
[ b, a ]:[ [ a, a ]-a, [ a, b ]-a, [ b, a ]-b ]
[ b, b ]:[ [ *, * ]-b ]
[ b, c ]:[ [ b, b ]-b, [ b, c ]-b, [ c, b ]-c ]
[ c, a ]:[ [ a, c ]-a, [ c, a ]-c, [ c, c ]-c ]
[ c, b ]:[ [ b, b ]-b, [ b, c ]-b, [ c, b ]-c ]
[ c, c ]:[ [ *, * ]-c ]
false.

*/

%-----------------------------------------------------------------
% utilitiy: table display
%-----------------------------------------------------------------
hr( N ):-
	 nl,
	 between( 1, N, _ ),
	 write( '-' ),
	 fail; true.

fig_cell( swf, [ P, Q ], F ):-
	 member( [ P, Q ] - S, F ), !,
	 rc( I, S ),
	 write( I ),
	 ( I < 10 -> tab( 2 ); tab( 1 ) ).

fig_cell( scf, [ P, Q ], F ):-
	 member( [ P, Q ] - X, F ), !,
	 term_string( X, T ),
	 string_length( T, K ),
	 write( T ),
	 ( K < 2 -> tab( 2 ); tab( 1 ) ).

fig_cell( _, [ P, Q ], F ):-
	 \+ member( [ P, Q ] - _, F ), !,
	 write('-' ),
	 tab( 2 ).

fig_cell( _, _, _ ):- nl,write( '--' ).

fig( domain, D ):-
	 findall( P-J, nth1( J, D, P ), F ),
	 fig( scf,  F ),
	 !.

fig( _, _ ):-
	 nl, 
	 rc( 1, P ), nl, tab( 2 ),
	 term_string( 1 : P, A ), 
	 string_length( A, M ), tab( M ),
	 rc( K, _ ),
	 write( K ),
	 ( K < 10 -> tab( 2 ); tab( 1 ) ),
	 fail.
fig( _, _ ):-
	 rc( 1, P ), nl, tab( 2 ),
	 term_string( 1 : P, A ), % 行ヘッダ
	 string_length( A, M ), tab( M ),
	 findall( '---', rc( _, _ ), L ),
	 atomic_list_concat( L, H ),
	 write( H ),
	 fail.

fig( M, F ):-
	 rc( J, P ), nl, write( J : P ), tab( 1 ),
	 ( J < 10 -> tab( 1 ); true ),
	 rc( _, Q ),
	 fig_cell( M, [ P, Q ], F ),
	 fail.


fig( _, _ ):- nl, write( '--' ).


% added: 25 Dec 2024


fig_a( _, _, A ):-
	 nl, 
	 rc( 1, P ), nl, tab( 2 ),
	 term_string( 1 : P, A ), 
	 string_length( A, M ), tab( M ),
%	 rc( K, _ ),  % 18 Feb 2025
	 member( K, A ),
	 write( K ),
	 ( K < 10 -> tab( 2 ); tab( 1 ) ),
	 fail.
fig_a( _, _, _ ):-
	 rc( 1, P ), nl, tab( 2 ),
	 term_string( 1 : P, A ), % 行ヘッダ
	 string_length( A, M ), tab( M ),
	 findall( '---', rc( _, _ ), L ),
	 atomic_list_concat( L, H ),
	 write( H ),
	 fail.

fig_a( M, F, A ):-
	 member( J, A ),
	 rc( J, P ), nl, write( J : P ), tab( 1 ),
	 ( J < 10 -> tab( 1 ); true ),
	 rc( _, Q ), fig_cell( M, [ P, Q ], F ),
	 fail.

fig_a( _, _, _ ):- nl, write( '--' ).

% added: 20 Nov 2024 (modified: 8 Nov 2025)

fig( R, domain, D ):-  %added: 8 Nov 2025
	 findall( P-J, nth1( J, D, P ), F ),
	 fig( R, scf,  F ),
	 !.

fig( R, _, _ ):-
	 \+ var( R ),
	 nl, 
	 rc( 1, P ), nl, tab( 2 ),
	 term_string( 1 : P, A ), 
	 string_length( A, M ), tab( M ),
	 member( K, R ),
	 rc( K, _ ),
	 write( K ),
	 ( K < 10 -> tab( 2 ); tab( 1 ) ),
	 fail.
fig( R, _, _ ):-
	 \+ var( R ),
	 rc( 1, P ), nl, tab( 2 ),
	 term_string( 1 : P, A ), % 行ヘッダ
	 string_length( A, M ), tab( M ),
	 findall( '---', rc( _, _ ), L ),
	 atomic_list_concat( L, H ),
	 write( H ),
	 fail.

fig( R, M, F ):-
	 \+ var( R ),
	 member( J, R ),
	 rc( J, P ), nl, write( J : P ), tab( 1 ),
	 ( J < 10 -> tab( 1 ); true ),
	 member( K, R ), % correction: 8 Nov 2025
	 rc( K, Q ), fig_cell( M, [ P, Q ], F ),
	 fail.

fig( R, _, _ ):- 
	 \+ var( R ),
	 nl, write( '--' ).



%-----------------------------------------------------------------
% contracted figure
%-----------------------------------------------------------------
% added: 26-27 Sep 2024. fig_s/2,3

fig_s( domain, D ):-  %added: 9 Nov 2025
	 findall( P-J, nth1( J, D, P ), F ),
	 fig_s( scf,  F ),
	 !.

fig_s( _, F ):-
	 nl, 
	 rc( 1, P ), %順序１の記述長を調べる
	 nl, tab( 2 ),
	 term_string( 1 : P, A ), % 行ヘッダ分の空桁
	 string_length( A, M ), tab( M ),
	 rc( K, Q ),
	 \+ \+ member( [ _, Q ] -_, F ),
	 write( K ),
	 ( K < 10 -> tab( 2 ); tab( 1 ) ),
	 fail.
fig_s( _, F ):- 
	 rc( 1, P ), %順序１の記述長を調べる
	 nl, tab( 2 ),
	 term_string( 1 : P, A ), % 行ヘッダ分の空桁
	 string_length( A, M ), tab( M ),
	 findall( '---', (
		rc( _, Q ),
		\+ \+ member( [ _, Q ] -_, F )
	 ), L ),
	 atomic_list_concat( L, H ),
	 write( H ),
	 fail.

fig_s( M, F ):-
	 rc( J, P ), 
	 \+ \+ member( [ P, _ ] -_, F ),
	 nl, write( J : P ), tab( 1 ),
	 ( J < 10 -> tab( 1 ); true ),
	 rc( _, Q ),
	 \+ \+ member( [ _, Q ] -_, F ),
	 fig_cell( M, [ P, Q ], F ),
	 fail.

fig_s( _, _ ):- nl, write( '--' ).


/*

?- mo( O ), findall( P-X, nth1( X,O, P), F ), !, fig_s( scf, F ), fail.


           2  3  6  
           ---------
2:[1,3,2]  -  5  1  
3:[2,1,3]  2  -  6  
6:[3,2,1]  4  3  -  
--
false.

*/


% 範囲内のfig

fig_r( _, _, X ):-
	 nl, 
	 rc( 1, P ), %順序１の記述長を調べる
	 nl, tab( 2 ),
	 term_string( 1 : P, A ), % 行ヘッダ分の空桁
	 string_length( A, M ), tab( M ),
	 rc( K, Q ),
	 \+ \+ member( [ _, Q ], X ),
	 write( K ),
	 ( K < 10 -> tab( 2 ); tab( 1 ) ),
	 fail.
fig_r( _, _, X ):- 
	 rc( 1, P ), %順序１の記述長を調べる
	 nl, tab( 2 ),
	 term_string( 1 : P, A ), % 行ヘッダ分の空桁
	 string_length( A, M ), tab( M ),
	 findall( '---', (
		rc( _, Q ),
		\+ \+ member( [ _, Q ], X )
	 ), L ),
	 atomic_list_concat( L, H ),
	 write( H ),
	 fail.

fig_r( M, F, X ):-
	 rc( J, P ), 
	 \+ \+ member( [ P, _ ], X ),
	 nl, write( J : P ), tab( 1 ),
	 ( J < 10 -> tab( 1 ); true ),
	 rc( _, Q ),
	 \+ \+ member( [ _, Q ], X ),
	 fig_cell( M, [ P, Q ], F ),
	 fail.

fig_r( _, _, _ ):- nl, write( '--' ).

/*

?- s1( O ), select_n( D, O, 3), count(scf( L, D ), N), N<1, !, findall( P-J, (member(P,D),nth1( J,O,P)), F ), fig_r( scf, F, O ), fail.

           1  4  5  
           ---------
2:[1,3,2]  -  1  2  
3:[2,1,3]  -  -  4  
6:[3,2,1]  -  -  -  
--

*/


% added: 29 Sep 2024. fig_domain/1
% modified: 20 Nov 2024; 25 Dec 2024

fig_domain( D ):-
	 findall( P-J, nth1( J, D, P ), F ),
	 fig( scf,  F ).

fig_domain( R, D ):-
	 findall( P-J, nth1( J, D, P ), F ),
	 fig( R, scf,  F ).

fig_domain_a( D, A ):-
	 findall( P-J, nth1( J, D, P ), F ),
	 fig_a( scf,  F, A ).


/*

?- m( D ), fig_domain_a( D, [2,1,3,4,6,5] ), !, fail.

           1  2  3  4  5  6  
           ------------------
2:[1,3,2]  -  -  9  -  -  1  
1:[1,2,3]  -  -  -  10 2  -  
3:[2,1,3]  -  3  -  -  -  11 
4:[2,3,1]  4  -  -  -  12 -  
6:[3,2,1]  -  7  5  -  -  -  
5:[3,1,2]  8  -  -  6  -  -  
--
false.

?- m( D ), fig_domain( D ), !, fail.


           1  2  3  4  5  6  
           ------------------
1:[1,2,3]  -  -  -  10 2  -  
2:[1,3,2]  -  -  9  -  -  1  
3:[2,1,3]  -  3  -  -  -  11 
4:[2,3,1]  4  -  -  -  12 -  
5:[3,1,2]  8  -  -  6  -  -  
6:[3,2,1]  -  7  5  -  -  -  
--
false.

*/

%-----------------------------------------------------------------
% expanding scf domain
%-----------------------------------------------------------------
% added: 29 Sep 2024. fig_domain/1

% linear expansion

grow_scf_domain( _, A, A ).

grow_scf_domain( Dict, A, D ):- 
	 check_scf( _, A, Dict ), 
	 pp( X ),
	 \+ member( X, A ),
	 grow_scf_domain( Dict, [ X | A ], D ).

grow_scf_domain( Dict, D ):- 
	 grow_scf_domain( Dict, [ ], D ).


/*

?- s1( S ), length( D, 36 ), grow_scf_domain( Dict, S, D ), fig_domain( D ).


           1  2  3  4  5  6  
           ------------------
1:[1,2,3]  25 26 21 20 30 28 
2:[1,3,2]  24 23 22 31 32 29 
3:[2,1,3]  33 27 7  8  34 9  
4:[2,3,1]  19 18 6  5  11 10 
5:[3,1,2]  17 16 15 14 12 13 
6:[3,2,1]  35 4  3  36 2  1  
--
S = [[[1, 3, 2], [2, 3, 1]], [[1, 3, 2], [3, 1, 2]], [[2, 1, 3], [1, 2, 3]], [[2, 1, 3], [3, 1, 2]], [[3, 2, 1], [1, 2|...]], [[3, 2|...], [2|...]]],
D = [[[3, 2, 1], [3, 2, 1]], [[3, 2, 1], [3, 1, 2]], [[3, 2, 1], [2, 1, 3]], [[3, 2, 1], [1, 3, 2]], [[2, 3, 1], [2, 3|...]], [[2, 3|...], [2|...]], [[2|...], [...|...]], [[...|...]|...], [...|...]|...],
Dict = scf-dict .


*/

% parallel expansion

grow_scf_domain_in_parallel( _, _, A, A, F, F ).

grow_scf_domain_in_parallel( Dict, A, D, [ Q-Z | F0 ], F ):- 
	 all_profiles( L ),
	 subtract( L, A, R ), 
	 findall( PP, (
		 member( PP, R ),
		 append( A, [ PP ], C ),
		 check_scf( _, C, Dict )
	 ), B ),
	 append( B, D, D1 ),
	 Z1 is Z + 1,
	 findall( PP-Z1, member( PP, B ), Fx ),
	 append( Fx, [Q-Z | F0], F1 ),
	 grow_scf_domain_in_parallel( Dict, C, D1, F1, F ).

grow_scf_domain_in_parallel( Dict, A, D, F ):- 
	 check_scf( _, A, Dict ), 
	 findall( X-0, member( X, A ), B ),
	 grow_scf_domain_in_parallel( Dict, A, D, B, F ).


%-----------------------------------------------------------------
% binary representations of swf/scf
%-----------------------------------------------------------------
swf_xy( F, B, Fxy ):-
	 setof( Pxy - Sxy,
	 P ^ S ^ (
		 member( P - S, F ),
		 xy_profile_in_sign( Pxy, B, P ),
		 xy_profile_in_sign( [ Sxy ], B, [ S ] )
	 ), Fxy ).


scf_xy( F, B, Fxy ):-
	 setof( Pxy - C,
	 P ^ C ^ (
		 member( P - C, F ),
		 xy_profile( Pxy, B, P ),
		 member( C, B )
	 ), Fxy ).

% added: 12 Sep 2024

swf_xy( F, Hxy ):-
	 findall( B : Pxy - Sxy, (
		 member( P - S, F ),
		 xy_profile_in_sign( Pxy, B, P ),
		 xy_profile_in_sign( [ Sxy ], B, [ S ] )
	 ), Hxy ).

scf_xy( F, Hxy ):-
	 findall( B:Pxy - C,(
		 member( P - C, F ),
		 xy_profile( Pxy, B, P ),
		 member( C, B )
	 ), Hxy ).

/*


?- all_profiles( U ), f( F, U, swf_axiom ), hr( 35 ), swf_xy( F, B, Y ), nl, write( B:Y ), fail.

-----------------------------------
[a,a]:[[0,0]-0]
[a,b]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[a,c]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[b,a]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[b,b]:[[0,0]-0]
[b,c]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[c,a]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[c,b]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[c,c]:[[0,0]-0]
-----------------------------------
[a,a]:[[0,0]-0]
[a,b]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[a,c]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[b,a]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[b,b]:[[0,0]-0]
[b,c]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[c,a]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[c,b]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[c,c]:[[0,0]-0]
false.

?- m1( U ), f( F, U, swf_axiom ), hr( 35 ), swf_xy( F, B, Y ), nl, write( B:Y ), fail.

-----------------------------------
[a,a]:[[0,0]-0]
[a,b]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[a,c]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[b,a]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[b,b]:[[0,0]-0]
[b,c]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[c,a]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[c,b]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[c,c]:[[0,0]-0]
-----------------------------------
[a,a]:[[0,0]-0]
[a,b]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[a,c]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[b,a]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[b,b]:[[0,0]-0]
[b,c]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[c,a]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[c,b]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[c,c]:[[0,0]-0]
false.


?- all_profiles( 3, U ), f( F, U, swf_axiom ), hr( 35 ), swf_xy( F, B, Y ), nl, write( B:Y ), fail.

-----------------------------------
[a,a]:[[0,0,0]-0]
[a,b]:[[+,+,+]-(+),[+,+,-]-(-),[+,-,+]-(+),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(-),[-,-,+]-(+),[-,-,-]-(-)]
[a,c]:[[+,+,+]-(+),[+,+,-]-(-),[+,-,+]-(+),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(-),[-,-,+]-(+),[-,-,-]-(-)]
[b,a]:[[+,+,+]-(+),[+,+,-]-(-),[+,-,+]-(+),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(-),[-,-,+]-(+),[-,-,-]-(-)]
[b,b]:[[0,0,0]-0]
[b,c]:[[+,+,+]-(+),[+,+,-]-(-),[+,-,+]-(+),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(-),[-,-,+]-(+),[-,-,-]-(-)]
[c,a]:[[+,+,+]-(+),[+,+,-]-(-),[+,-,+]-(+),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(-),[-,-,+]-(+),[-,-,-]-(-)]
[c,b]:[[+,+,+]-(+),[+,+,-]-(-),[+,-,+]-(+),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(-),[-,-,+]-(+),[-,-,-]-(-)]
-----------------------------------
[a,a]:[[0,0,0]-0]
[a,b]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(-),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(+),[-,-,+]-(-),[-,-,-]-(-)]
[a,c]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(-),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(+),[-,-,+]-(-),[-,-,-]-(-)]
[b,a]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(-),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(+),[-,-,+]-(-),[-,-,-]-(-)]
[b,b]:[[0,0,0]-0]
[b,c]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(-),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(+),[-,-,+]-(-),[-,-,-]-(-)]
[c,a]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(-),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(+),[-,-,+]-(-),[-,-,-]-(-)]
[c,b]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(-),[+,-,-]-(-),[-,+,+]-(+),[-,+,-]-(+),[-,-,+]-(-),[-,-,-]-(-)]
[c,c]:[[0,0,0]-0]
-----------------------------------
[a,a]:[[0,0,0]-0]
[a,b]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(+),[+,-,-]-(+),[-,+,+]-(-),[-,+,-]-(-),[-,-,+]-(-),[-,-,-]-(-)]
[a,c]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(+),[+,-,-]-(+),[-,+,+]-(-),[-,+,-]-(-),[-,-,+]-(-),[-,-,-]-(-)]
[b,a]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(+),[+,-,-]-(+),[-,+,+]-(-),[-,+,-]-(-),[-,-,+]-(-),[-,-,-]-(-)]
[b,b]:[[0,0,0]-0]
[b,c]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(+),[+,-,-]-(+),[-,+,+]-(-),[-,+,-]-(-),[-,-,+]-(-),[-,-,-]-(-)]
[c,a]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(+),[+,-,-]-(+),[-,+,+]-(-),[-,+,-]-(-),[-,-,+]-(-),[-,-,-]-(-)]
[c,b]:[[+,+,+]-(+),[+,+,-]-(+),[+,-,+]-(+),[+,-,-]-(+),[-,+,+]-(-),[-,+,-]-(-),[-,-,+]-(-),[-,-,-]-(-)]
[c,c]:[[0,0,0]-0]
false.


?- m1( [ _ | C ] ), m2( [ _ | D ] ), append( C, D, U ), f( F, U, swf_axiom ), \+ dictatorial_swf( J, F ), hr( 35 ), swf_xy( F, B, Y ), nl, write( B:Y ), fail.

-----------------------------------
[a,a]:[[0,0]-0]
[a,b]:[[+,+]-(+),[+,-]-(-),[-,+]-(-),[-,-]-(-)]
[a,c]:[[+,+]-(+),[+,-]-(+),[-,+]-(+),[-,-]-(-)]
[b,a]:[[+,+]-(+),[+,-]-(+),[-,+]-(+),[-,-]-(-)]
[b,b]:[[0,0]-0]
[b,c]:[[+,+]-(+),[+,-]-(+),[-,+]-(+)]
[c,a]:[[+,+]-(+),[+,-]-(-),[-,+]-(-),[-,-]-(-)]
[c,b]:[[+,-]-(-),[-,+]-(-),[-,-]-(-)]
[c,c]:[[0,0]-0]
false.

*/

%-----------------------------------------------------------------
% select n elements given a list ( to create restricted domain )
%-----------------------------------------------------------------

% icaart2013.pl version 

/*
select_n( [ ], [ ], 0 ).

select_n( [ R | Q ], [ R | S ], A ):-
	 select_n( Q, S, B ),
	 A is B + 1.

select_n( Q, [ _ | S ], B ):-
	 select_n( Q, S, B ).
*/

/*

%  arrow2019x.pl version. invalid 

select_n( [ ], [ ], 0 ).

select_n( [ R | Q ], [ R | S ], A ):-
	 B is A - 1,
	 select_n( Q, S, B ).

select_n( Q, [ _ | S ], B ):-
	 select_n( Q, S, B ).

*/


% a version using list_projection/3 in lib2017

select_n_0( A, B, K ):-
	 length( B, N ),
	 between( 1, N, K ),
	 list_projection( _, B, A ),
	 length( A, K ).


% a version using list_projection_n/5.

select_n( A, B, K ):-
	 list_projection_n( _, B, A, 0, K ).


list_projection_n( [ ], [ ], [ ], N, N ).
list_projection_n( [ 0 | A ], [ _ | Y ], Z, K, N ) :-
	number( N ), K >= N, !,
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


/*

list_projection( [ ], [ ], [ ] ).
list_projection( [ 0 | A ], [ _ | Y ], Z ) :-
    list_projection( A, Y, Z ).
list_projection( [ 1 | A ], [ X | Y ], [ X | Z ]) :-
    list_projection( A, Y, Z ).

*/


/*

distribute_1( [ ], C, [ ], C ).

distribute_1( [ X | B ], Y, Z, C ):-
	 distribute_1( B, [ X | Y ], Z, C ).

distribute_1( [ 1 | B ], Y, Z, C ):-
	 distribute_1( [ 1 | B ], [ 0 | Y ], [ 1 | Z ], C ).

distribute_1( [ 0 | B ], Y, [ 1 | Z ], C ):-
	 distribute_1( [ 0 | B ], [ 1 | Y ], Z, C ).

select_n( A, B, K ):-
	 length( B, N ),
	 findall( 1, between( 1, K, J ), I ),
	 K1 is K + 1,
	 findall( 0, between( K1, N, J ), O ),
	 append( I, O, P ),
	 distribute_1( P, [ ], [ ], Q ),
	 list_projection( Q, B, A ).
*/


/*

?- select_n( A, [ a, b, c ], K ), nl, write( K: A ), fail.

3:[ a, b, c ]
2:[ a, b ]
2:[ a, c ]
1:[ a ]
2:[ b, c ]
1:[ b ]
1:[ c ]
0:[ ]
false.

*/


% test1 to test5

%-----------------------------------------------------------------
% test1: the cross-elimination of paired profiles
% with adjacent-indecies in the super-Arrovian domain
%-----------------------------------------------------------------
test1:-
	 test1( swf ),
	 test1( scf ),
	 test1( mcf ).

test1( Type ):-
	 type_of_social_rule( Type ),
	 test1_message( Type, Mes ),
	 nl,
	 write( Mes ),
	 all_profiles( L ),
	 m1( C ),
	 nth1( K, C, V ),
	 nl, write( [ K ] ), tab( 1 ),
	 m2( D ),
	 nth1( J, D, W ),
	 subtract( L, [ V, W ], H ),
	 Rule =.. [ Type, _, H ],
	 Rule,
	 write( J; ' ' ),
	 fail.
test1( _ ).

test1_message( swf, ' minimal ( cross- )elimination for Arrow-type swf:' ).
test1_message( scf, ' minimal ( cross- )elimination for strategy-proof scf:' ).
test1_message( mcf, ' minimal ( cross- )elimination for monotonic scf:' ).

/*

 minimal ( cross- )elimination for Arrow-type swf:
[ 1 ] 1; 2; 6;
[ 2 ] 1; 2; 3;
[ 3 ] 2; 3; 4;
[ 4 ] 3; 4; 5;
[ 5 ] 4; 5; 6;
[ 6 ] 1; 5; 6;
 minimal ( cross- )elimination for strategy-proof scf:
[ 1 ] 1; 2; 6;
[ 2 ] 1; 2; 3;
[ 3 ] 2; 3; 4;
[ 4 ] 3; 4; 5;
[ 5 ] 4; 5; 6;
[ 6 ] 1; 5; 6;
 minimal ( cross- )elimination for monotonic scf:
[ 1 ] 1; 2; 6;
[ 2 ] 1; 2; 3;
[ 3 ] 2; 3; 4;
[ 4 ] 3; 4; 5;
[ 5 ] 4; 5; 6;
[ 6 ] 1; 5; 6;
true.

?- m( C ), nth1( J, C, X ), m1( D ), findall( K:Y, ( member( K0, [ J-1, J, J+1 ] ), ( 0 is K0 mod 6 -> K =6; K is K0 ), nth1( K, D, Y ) ), L ), nl, write( J; X; L ), fail.

1;[[a,c,b],[c,b,a]];[6:[[c,a,b],[b,c,a]],1:[[a,c,b],[c,b,a]],2:[[a,b,c],[c,a,b]]]
2;[[a,b,c],[c,a,b]];[1:[[a,c,b],[c,b,a]],2:[[a,b,c],[c,a,b]],3:[[b,a,c],[a,c,b]]]
3;[[b,a,c],[a,c,b]];[2:[[a,b,c],[c,a,b]],3:[[b,a,c],[a,c,b]],4:[[b,c,a],[a,b,c]]]
4;[[b,c,a],[a,b,c]];[3:[[b,a,c],[a,c,b]],4:[[b,c,a],[a,b,c]],5:[[c,b,a],[b,a,c]]]
5;[[c,b,a],[b,a,c]];[4:[[b,c,a],[a,b,c]],5:[[c,b,a],[b,a,c]],6:[[c,a,b],[b,c,a]]]
6;[[c,a,b],[b,c,a]];[5:[[c,b,a],[b,a,c]],6:[[c,a,b],[b,c,a]]]
7;[[c,b,a],[a,c,b]];[6:[[c,a,b],[b,c,a]]]
8;[[c,a,b],[a,b,c]];[]
9;[[a,c,b],[b,a,c]];[]
10;[[a,b,c],[b,c,a]];[]
11;[[b,a,c],[c,b,a]];[6:[[c,a,b],[b,c,a]]]
12;[[b,c,a],[c,a,b]];[6:[[c,a,b],[b,c,a]]]
false.

?- m( C ), nth1( J, C, X ), ppc( A, X ), m1( D ), findall( B, ( member( K0, [ J-1, J, J+1 ] ), ( 0 is K0 mod 6 -> K =6; K is K0 ), nth1( K, D, Y ), ppc( B, Y ) ), L ), nl, write( A; L ), fail.

[ 1, 5 ];[ [ 6, 4 ], [ 1, 5 ], [ 2, 6 ] ]
[ 2, 6 ];[ [ 1, 5 ], [ 2, 6 ], [ 3, 1 ] ]
[ 3, 1 ];[ [ 2, 6 ], [ 3, 1 ], [ 4, 2 ] ]
[ 4, 2 ];[ [ 3, 1 ], [ 4, 2 ], [ 5, 3 ] ]
[ 5, 3 ];[ [ 4, 2 ], [ 5, 3 ], [ 6, 4 ] ]
[ 6, 4 ];[ [ 5, 3 ], [ 6, 4 ] ]
false.

rc( 1, [ a, c, b ] ).
rc( 2, [ a, b, c ] ).
rc( 3, [ b, a, c ] ).
rc( 4, [ b, c, a ] ).
rc( 5, [ c, b, a ] ).
rc( 6, [ c, a, b ] ).

*/

%an alternative 18 Nov 2024

/*

?- m1(M1), m2(M2),all_profiles( U ), nth1(I, M1, P ), findall( J, ( nth1( J, M2, Q ), subtract( U, [ P, Q ], D ), check_swf(F, D, swf-poss ) ), L ), nl, write( I-L ),fail.

1-[1,2,6]
2-[1,2,3]
3-[2,3,4]
4-[3,4,5]
5-[4,5,6]
6-[1,5,6]
false.

?- m1(M1), m2(M2),all_profiles( U ), nth1(I, M1, P ), findall( J, ( nth1( J, M2, Q ), subtract( U, [ P, Q ], D ), check_scf(F, D, scf-poss ) ), L ), nl, write( I-L ), fail.

1-[1,2,6]
2-[1,2,3]
3-[2,3,4]
4-[3,4,5]
5-[4,5,6]
6-[1,5,6]
false.

*/

%-----------------------------------------------------------------
% test2: pallarel generation of restricted SWFs and SCFs
% by eliminating profiles in the two super-Arrovian domains.
%-----------------------------------------------------------------
:- dynamic test2_data/4, test2_f/3.

test2:-
	 retractall( test2_data( _, _, _, _ ) ),
	 retractall( test2_f( _, _, _ ) ),
	 all_profiles( L ),
	 m( B ),
	 length( [ _ | B ], K ),
	 between( 0, K, N ),
	 M is N - 1,
	 test2_stat( swf, M ),
	 select_n( C, B, N ),
	 subtract( L, C, U ),
%	 findall( 1, f( F, U, swf_axiom ), H ),
	 findall( 1, (
		 f( F, U, swf_axiom ),
		 assert( test2_f( swf( N ), F, U ) )
	 ), H ),
	 length( H, I ),
%	 findall( 1, ( f( _, U, scf_axiom ), non_imposed( F ) ), G ),
	 findall( 1, (
		 f( F, U, scf_axiom ),
		 non_imposed( F ),
		 assert( test2_f( scf( N ), F, U ) )
	 ), G ),
	 length( G, J ),
	 assert( test2_data( N, C, I, J ) ),
	 fail.
test2.

test2_stat( F, K ):-
	 ( var( K ) -> true ; K >= 0 ),
	 nl,
	 write( [ K ] ),
	 tab( 1 ),
	 member( F, [ swf, scf ] ),
	 test2_stat( F, K, I, B ),
	 bagof( 1, B, W ),
	 length( W, S ),
	 write( I - S ;' ' ),
	 fail.
test2_stat( _, _ ).

test2_stat( swf, K, I, C^J^test2_data( K, C, I, J ) ).

test2_stat( scf, K, J, C^I^test2_data( K, C, I, J ) ).


/*

?- test2.
[ 0 ] 2-1;
[ 1 ] 2-12;
[ 2 ] 2-48; 3-18;
[ 3 ] 2-76; 3-108; 4-36;
[ 4 ] 2-48; 3-156; 4-225; 5-60; 6-6;
[ 5 ] 2-12; 3-60; 4-228; 5-348; 6-120; 7-24;
[ 6 ] 2-2; 4-54; 5-170; 6-390; 7-252; 8-50; 9-6;
[ 7 ] 5-12; 6-60; 7-228; 8-348; 9-120; 10-24;
[ 8 ] 8-48; 9-156; 10-225; 11-60; 12-6;
[ 9 ] 11-76; 12-108; 13-36;
[ 10 ] 14-48; 15-18;
[ 12 ] 20-1;

 ?- between( 0, 12, K ), test4_stat( swf, K ), fail.

[ 0 ] 2-1;
[ 1 ] 2-12;
[ 2 ] 2-48; 3-18;
[ 3 ] 2-76; 3-108; 4-36;
[ 4 ] 2-48; 3-156; 4-225; 5-60; 6-6;
[ 5 ] 2-12; 3-60; 4-228; 5-348; 6-120; 7-24;
[ 6 ] 2-2; 4-54; 5-170; 6-390; 7-252; 8-50; 9-6;
[ 7 ] 5-12; 6-60; 7-228; 8-348; 9-120; 10-24;
[ 8 ] 8-48; 9-156; 10-225; 11-60; 12-6;
[ 9 ] 11-76; 12-108; 13-36;
[ 10 ] 14-48; 15-18;
[ 11 ] 17-12;
[ 12 ] 20-1;
false.

 ?- between( 0, 12, K ), test2_stat( scf, K ), fail.
[ 0 ] 2-1;
[ 1 ] 2-12;
[ 2 ] 2-48; 3-18;
[ 3 ] 2-64; 3-120; 4-36;
[ 4 ] 2-30; 3-114; 4-255; 5-90; 6-6;
[ 5 ] 2-12; 4-144; 5-300; 6-252; 7-72; 8-12;
[ 6 ] 2-2; 5-62; 6-150; 7-294; 8-242; 9-78; 10-72; 12-18; 13-6;
[ 7 ] 6-12; 8-120; 9-132; 10-192; 11-48; 12-108; 13-48; 14-72; 15-12; 16-24; 19-24;
[ 8 ] 10-18; 11-36; 12-57; 13-30; 14-36; 15-36; 16-69; 17-36; 18-72; 19-12; 20-12; 22-36; 25-30; 28-3; 29-6; 30-6;
[ 9 ] 14-4; 17-12; 20-36; 21-12; 22-36; 23-12; 26-12; 28-24; 31-24; 34-12; 35-12; 38-12; 40-12;
[ 10 ] 37-12; 38-6; 40-6; 41-12; 46-6; 48-12; 50-6; 74-6;
[ 11 ] 88-12;
[ 12 ] 196-1;

?- [ menu ].

?- tell_goal( 'test2_data.pl', forall, test2_data( _, _, _, _ ) ).

?- tell_goal( 'test2_f.pl', forall, test2_f( _, _, _ ) ).

*/


%-----------------------------------------------------------------
% test3: the cross table of test2 data.
%-----------------------------------------------------------------
test3:-
	 setof( J, K^C^I^test2_data( K, C, I, J ), L ),
	 member( J, L ), nl, write( [ J ] ),
	 bagof( C, K^test2_data( K, C, I, J ), W ),
	 length( W, S ), tab( 1 ), write( I - S ;' ' ),
	 fail.
test3.


/*

 ?- test3.

[ 2 ] 2-169;
[ 3 ] 2-24; 3-228;
[ 4 ] 2-6; 3-84; 4-345;
[ 5 ] 3-6; 4-144; 5-302;
[ 6 ] 3-24; 4-24; 5-168; 6-204;
[ 7 ] 5-36; 6-192; 7-138;
[ 8 ] 4-24; 5-36; 6-78; 7-168; 8-68;
[ 9 ] 5-12; 6-12; 7-60; 8-96; 9-30;
[ 10 ] 5-36; 6-36; 7-18; 8-120; 9-60; 10-12;
[ 11 ] 7-24; 8-12; 9-24; 10-24;
[ 12 ] 6-30; 7-36; 8-30; 9-24; 10-48; 11-12; 12-3;
[ 13 ] 4-6; 7-24; 8-24; 10-12; 11-18;
[ 14 ] 7-24; 8-48; 10-30; 11-10;
[ 15 ] 8-12; 9-24; 11-12;
[ 16 ] 6-12; 8-18; 9-48; 10-12; 12-3;
[ 17 ] 9-12; 10-24; 13-12;
[ 18 ] 10-60; 11-12;
[ 19 ] 6-12; 7-12; 10-12;
[ 20 ] 9-6; 10-6; 11-24; 12-12;
[ 21 ] 12-12;
[ 22 ] 8-12; 9-24; 12-24; 13-12;
[ 23 ] 13-12;
[ 25 ] 9-24; 10-6;
[ 26 ] 12-12;
[ 28 ] 10-3; 11-24;
[ 29 ] 9-6;
[ 30 ] 8-6;
[ 31 ] 12-24;
[ 34 ] 12-12;
[ 35 ] 12-12;
[ 37 ] 14-12;
[ 38 ] 11-12; 15-6;
[ 40 ] 11-12; 14-6;
[ 41 ] 15-12;
[ 46 ] 14-6;
[ 48 ] 14-12;
[ 50 ] 14-6;
[ 74 ] 14-6;
[ 88 ] 17-12;
[ 196 ] 20-1;
true.

*/


%-----------------------------------------------------------------
% test4: a variant of test3 that replaces strategy-proofness with Maskin-monotonicity.
%-----------------------------------------------------------------
:- dynamic test4_data/4.

test4:-
	 retractall( test4_data( _, _, _, _ ) ),
	 all_profiles( L ),
	 m( B ),
	 length( [ _ | B ], K ),
	 between( 0, K, N ),
	 M is N - 1,
	 test4_stat( swf, M ),
	 select_n( C, B, N ),
	 subtract( L, C, U ),
	 findall( 1, f( _, U, swf_axiom ), H ),
	 length( H, I ),
	 findall( 1, f( _, U, mcf_axiom ), G ),
	 length( G, J ),
	 assert( test4_data( N, C, I, J ) ),
	 fail.
test4.

test4_stat( F, K ):-
	 ( var( K ) -> true ; K >= 0 ),
	 nl,
	 write( [ K ] ),
	 tab( 1 ),
	 member( F, [ swf, mcf ] ),
	 test4_stat( F, K, I, B ),
	 bagof( 1, B, W ),
	 length( W, S ),
	 write( I - S ;' ' ),
	 fail.
test4_stat( _, _ ).

test4_stat( swf, K, I, C^J^test4_data( K, C, I, J ) ).

test4_stat( mcf, K, J, C^I^test4_data( K, C, I, J ) ).


%-----------------------------------------------------------------
% test5: the cross table of test2 data.
%-----------------------------------------------------------------
test5:-
	 setof( J, K^C^I^test4_data( K, C, I, J ), L ),
	 member( J, L ), nl, write( [ J ] ),
	 bagof( C, K^test4_data( K, C, I, J ), W ),
	 length( W, S ), tab( 1 ), write( I - S ;' ' ),
	 fail.
test5.

/*

 ?- test4.

[ 0 ] 2-1;
[ 1 ] 2-12;
[ 2 ] 2-48; 3-18;
[ 3 ] 2-76; 3-108; 4-36;
[ 4 ] 2-48; 3-156; 4-225; 5-60; 6-6;
[ 5 ] 2-12; 3-60; 4-228; 5-348; 6-120; 7-24;
[ 6 ] 2-2; 4-54; 5-170; 6-390; 7-252; 8-50; 9-6;
[ 7 ] 5-12; 6-60; 7-228; 8-348; 9-120; 10-24;
[ 8 ] 8-48; 9-156; 10-225; 11-60; 12-6;
[ 9 ] 11-76; 12-108; 13-36;
[ 10 ] 14-48; 15-18;
[ 11 ] 17-12;
[ 12 ] 20-1;
true.

 ?- between( 0, 12, K ), test4_stat( swf, K ), fail.

[ 0 ] 2-1;
[ 1 ] 2-12;
[ 2 ] 2-48; 3-18;
[ 3 ] 2-76; 3-108; 4-36;
[ 4 ] 2-48; 3-156; 4-225; 5-60; 6-6;
[ 5 ] 2-12; 3-60; 4-228; 5-348; 6-120; 7-24;
[ 6 ] 2-2; 4-54; 5-170; 6-390; 7-252; 8-50; 9-6;
[ 7 ] 5-12; 6-60; 7-228; 8-348; 9-120; 10-24;
[ 8 ] 8-48; 9-156; 10-225; 11-60; 12-6;
[ 9 ] 11-76; 12-108; 13-36;
[ 10 ] 14-48; 15-18;
[ 11 ] 17-12;
[ 12 ] 20-1;
false.

 ?- between( 0, 12, K ), test4_stat( mcf, K ), fail.

[ 0 ] 2-1;
[ 1 ] 2-12;
[ 2 ] 2-48; 3-18;
[ 3 ] 2-76; 3-108; 4-36;
[ 4 ] 2-48; 3-156; 4-225; 5-60; 6-6;
[ 5 ] 2-12; 3-60; 4-228; 5-348; 6-120; 7-24;
[ 6 ] 2-2; 4-54; 5-170; 6-390; 7-252; 8-50; 9-6;
[ 7 ] 5-12; 6-60; 7-228; 8-348; 9-120; 10-24;
[ 8 ] 8-48; 9-156; 10-225; 11-60; 12-6;
[ 9 ] 11-76; 12-108; 13-36;
[ 10 ] 14-48; 15-18;
[ 11 ] 17-12;
[ 12 ] 20-1;
false.

?- test5.

[ 2 ] 2-199;
[ 3 ] 3-342;
[ 4 ] 4-543;
[ 5 ] 5-590;
[ 6 ] 6-576;
[ 7 ] 7-504;
[ 8 ] 8-446;
[ 9 ] 9-282;
[ 10 ] 10-249;
[ 11 ] 11-136;
[ 12 ] 12-114;
[ 13 ] 13-36;
[ 14 ] 14-48;
[ 15 ] 15-18;
[ 17 ] 17-12;
[ 20 ] 20-1;
true.

*/

%-----------------------------------------------------------------
% test6: simultaneously collects the three types of possibility results.
%-----------------------------------------------------------------
:- dynamic test6_data/4.

test6:-
	 retractall( test6_data( _, _, _, _ ) ),
	 all_profiles( L ),
	 m( B ),
	 length( [ _ | B ], K ),
	 between( 0, K, N ),
	 M is N - 1,
	 nl, write( [ 'complete level':M ] ),
	 select_n( C, B, N ),
	 subtract( L, C, U ),
	 test6( N, C, U, _ ),
	 fail.
test6.

test6( N, C, U, swf ):-
	 f( F, U, swf_axiom ),
	 assert( test6_data( N, C, U, swf:F ) ).
test6( N, C, U, scf ):-
	 f( F, U, scf_axiom ),
	 non_imposed( F ),
	 assert( test6_data( N, C, U, scf:F ) ).
test6( N, C, U, scf ):-
	 f( F, U, mcf_axiom ),
	 assert( test6_data( N, C, U, mcf:F ) ).

test6_stat:-
	 test6_stat( _, _ ), fail ; true.

test6_stat( F, K ):-
	 member( F, [ swf, scf, mcf ] ),
	 nl,
	 write( 'number of possible domains':F ),
	 between( 0, 12, K ),
	 nl,
	 write( [ K ] ),
	 tab( 1 ),
	 bagof( 1, C^test6_stat_part( F, K, C, I ), W ),
	 length( W, S ),
	 write( I - S ;' ' ),
	 fail.
test6_stat( _, _ ).

test6_stat_part( F, K, C, I ):-
	 bagof( C, H^test6_data( K, C, _U, F: H ), P ),
	 length( P, I ).


%-----------------------------------------------------------------
% test7: the cross table of test6 data.
%-----------------------------------------------------------------
test7:-
	 member( F, [ scf, mcf ] ),
	 nl,
	 write( 'cross table of swf and ' ), write( F ),
	 setof( J, K^C^
		 test6_stat_part( swf, K, C, J ),
	 L ),
	 member( J, L ), nl, write( [ J ] ),
	 setof( C, K^(
		 test6_stat_part( swf, K, C, J ),
		 test6_stat_part( F, K, C, I )
	 ), W ),
	 length( W, S ), tab( 1 ), write( I - S ;' ' ),
	 fail.
test7.


/*

?- test6.

 ?- test6_stat.

number of possible domains:swf
[ 0 ] 2-1;
[ 1 ] 2-12;
[ 2 ] 2-48; 3-18;
[ 3 ] 2-76; 3-108; 4-36;
[ 4 ] 2-48; 3-156; 4-225; 5-60; 6-6;
[ 5 ] 2-12; 3-60; 4-228; 5-348; 6-120; 7-24;
[ 6 ] 2-2; 4-54; 5-170; 6-390; 7-252; 8-50; 9-6;
[ 7 ] 5-12; 6-60; 7-228; 8-348; 9-120; 10-24;
[ 8 ] 8-48; 9-156; 10-225; 11-60; 12-6;
[ 9 ] 11-76; 12-108; 13-36;
[ 10 ] 14-48; 15-18;
[ 11 ] 17-12;
[ 12 ] 20-1;
number of possible domains:scf
[ 0 ] 2-1;
[ 1 ] 2-12;
[ 2 ] 2-48; 3-18;
[ 3 ] 2-64; 3-120; 4-36;
[ 4 ] 2-30; 3-114; 4-255; 5-90; 6-6;
[ 5 ] 2-12; 4-144; 5-300; 6-252; 7-72; 8-12;
[ 6 ] 2-2; 5-62; 6-150; 7-294; 8-242; 9-78; 10-72; 12-18; 13-6;
[ 7 ] 6-12; 8-120; 9-132; 10-192; 11-48; 12-108; 13-48; 14-72; 15-12; 16-24; 19-24;
[ 8 ] 10-18; 11-36; 12-57; 13-30; 14-36; 15-36; 16-69; 17-36; 18-72; 19-12; 20-12; 22-36; 25-30; 28-3; 29-6; 30-6;
[ 9 ] 14-4; 17-12; 20-36; 21-12; 22-36; 23-12; 26-12; 28-24; 31-24; 34-12; 35-12; 38-12; 40-12;
[ 10 ] 37-12; 38-6; 40-6; 41-12; 46-6; 48-12; 50-6; 74-6;
[ 11 ] 88-12;
[ 12 ] 196-1;
number of possible domains:mcf
[ 0 ] 2-1;
[ 1 ] 2-12;
[ 2 ] 2-48; 3-18;
[ 3 ] 2-76; 3-108; 4-36;
[ 4 ] 2-48; 3-156; 4-225; 5-60; 6-6;
[ 5 ] 2-12; 3-60; 4-228; 5-348; 6-120; 7-24;
[ 6 ] 2-2; 4-54; 5-170; 6-390; 7-252; 8-50; 9-6;
[ 7 ] 5-12; 6-60; 7-228; 8-348; 9-120; 10-24;
[ 8 ] 8-48; 9-156; 10-225; 11-60; 12-6;
[ 9 ] 11-76; 12-108; 13-36;
[ 10 ] 14-48; 15-18;
[ 11 ] 17-12;
[ 12 ] 20-1;
true.


?- [ menu ].

?- tell_goal( 'test6_data.pl', forall, test6_data( _, _, _, _ ) ).



*/


%-----------------------------------------------------------------
% proving dictatorships on the super-Arrovian domain
% i.e., the sufficiency of the impossibility result.
%-----------------------------------------------------------------
/*

 ?- m1( U ), f( F, U, swf_axiom ), fig( swf, F ), fail.

   123456
1:[ a, c, b ] ----5-
2:[ a, b, c ] -----6
3:[ b, a, c ] 1-----
4:[ b, c, a ] -2----
5:[ c, b, a ] --3---
6:[ c, a, b ] ---4--
--
   123456
1:[ a, c, b ] ----1-
2:[ a, b, c ] -----2
3:[ b, a, c ] 3-----
4:[ b, c, a ] -4----
5:[ c, b, a ] --5---
6:[ c, a, b ] ---6--
--
false.

*/

%-----------------------------------------------------------------
% automated proof of the super-Arrovian domain: yet another code
%-----------------------------------------------------------------
jv( M, K, J ):- between( 1, 6, M ), between( 1, 6, K ), J is mod( K + M, 6 ) + 1.

ppc( M, [ K, J ], [ P, Q ] ):- jv( M, K, J ), rc( K, P ), rc( J, Q ).

/*

?- ppc( J, P ), ppc( I, J, P ), nl, write( I; J; P ), fail.

3;[ 1, 5 ];[ [ a, c, b ], [ c, b, a ] ]
3;[ 2, 6 ];[ [ a, b, c ], [ c, a, b ] ]
3;[ 3, 1 ];[ [ b, a, c ], [ a, c, b ] ]
3;[ 4, 2 ];[ [ b, c, a ], [ a, b, c ] ]
3;[ 5, 3 ];[ [ c, b, a ], [ b, a, c ] ]
3;[ 6, 4 ];[ [ c, a, b ], [ b, c, a ] ]
false.

*/

m( M, D ):- setof( PP, K^J^ ppc( M, [ K, J ], PP ), D ).

/*

?- m1( A ), m( 3, B ), subtract( A, B, C ), subtract( B, A, D ).
A = [ [ [ a, c, b ], [ c, b, a ] ], [ [ a, b, c ], [ c, a, b ] ], [ [ b, a, c ], [ a, c, b ] ], [ [ b, c, a ], [ a, b, c ] ], [ [ c, b, a ], [ b, a | ... ] ], [ [ c, a | ... ], [ b | ... ] ] ],
B = [ [ [ a, b, c ], [ c, a, b ] ], [ [ a, c, b ], [ c, b, a ] ], [ [ b, a, c ], [ a, c, b ] ], [ [ b, c, a ], [ a, b, c ] ], [ [ c, a, b ], [ b, c | ... ] ], [ [ c, b | ... ], [ b | ... ] ] ],
C = D, D = [ ].

*/


test0:- m( M, D ), nl, write( [ M ] ), f( _F, D, swf_axiom ), write( * ), fail.

/*

% M should be either 1 or 3.

?- test0.

[1]**
[2]********************
[3]**
[4]****************************************************************
[5]*
[6]****************************************************************
false.

% What happen if M = 5.

 ?- M = 5, m( M, D ), f( F, D, swf_axiom ), fig( swf, F ), fail.

   123456
1:[ a, c, b ] 1-----
2:[ a, b, c ] -2----
3:[ b, a, c ] --3---
4:[ b, c, a ] ---4--
5:[ c, b, a ] ----5-
6:[ c, a, b ] -----6
--
false.

*/

%

%-----------------------------------------------------------------
% proving that the super-Arrovian domain is minimal,
% i.e., there is no substitutable profile external to that domain.
%-----------------------------------------------------------------
test0( M, X:P, Y:Q ):-
	 member( M, [ 1, 3 ] ),
	 m( M, [ P | D ] ),
	 ppc( M, X, P ),
	 ppc( M, Y, Q ),
	 findall( 1, f( _, [ Q | D ], swf_axiom ), [ 1, 1 ] ).

/*

 ?- test0( M, P, Q ).
M = 1,
P = Q, Q = [ 2, 4 ]:[ [ a, b, c ], [ b, c, a ] ] ;
M = 3,
P = Q, Q = [ 2, 6 ]:[ [ a, b, c ], [ c, a, b ] ] ;
false.

*/

%-----------------------------------------------------------------
% a maximal possibility domain of the strategy-proof SCF.
%-----------------------------------------------------------------
/*

?- all_profiles( U ), ppc( [ 1, _ ], [ R1, R2 ] ), subtract( U, [ [ R1, R2 ], [ R2, R1 ] ], D ), scf( F, D ), /* i.e., f( F, D, scf_axiom ), \+ dictatorial_scf( _, F ), non_imposed( F ), */ fig( scf, F ), fail.

   123456
1:[ a, c, b ] aabb-a
2:[ a, b, c ] aabbba
3:[ b, a, c ] bbbbbb
4:[ b, c, a ] bbbbbb
5:[ c, b, a ] -bbbcc
6:[ c, a, b ] aabbcc
--
false.

?- all_profiles( U0 ), m1( [ A | _ ] ), m2( [ B | _ ] ), subtract( U0, [ A, B ], U ), scf( F, U ), hr( 30 ), \+ ( scf_xy( F, W, Y ), nl, \+ write( W : Y ) ), fail.

------------------------------
[a,a]:[[*,*]-a]
[a,b]:[[a,a]-a,[a,b]-b,[b,a]-b,[b,b]-b]
[a,c]:[[a,a]-a,[a,c]-a,[c,a]-a,[c,c]-c]
[b,a]:[[a,a]-a,[a,b]-b,[b,a]-b,[b,b]-b]
[b,b]:[[*,*]-b]
[b,c]:[[b,b]-b,[b,c]-b,[c,b]-b,[c,c]-c]
[c,a]:[[a,a]-a,[a,c]-a,[c,a]-a,[c,c]-c]
[c,b]:[[b,b]-b,[b,c]-b,[c,b]-b,[c,c]-c]
[c,c]:[[*,*]-c]
false.


*/


%-----------------------------------------------------------------
% super Arrovian domain per se is not sufficient to GS type result
% and also not neccessary inpartial domains( see next section )
%-----------------------------------------------------------------
% 18 Dec 2019 added

/*

?- m( D ), scf( F, D ), fig( scf, F ).

          123456
1:[ a, c, b ] --a-a-
2:[ a, b, c ] ---a-a
3:[ b, a, c ] a---a-
4:[ b, c, a ] -a---a
5:[ c, b, a ] a-b---
6:[ c, a, b ] -a-c--
--
D = [ [ [ a, c, b ], [ c, b, a ] ], [ [ a, b, c ], [ c, a, b ] ], [ [ b, a, c ], [ a, c, b ] ], [ [ b, c, a ], [ a, b, c ] ], [ [ c, b, a ], [ b, a | ... ] ], [ [ c, a | ... ], [ b | ... ] ], [ [ c | ... ], [ ... | ... ] ], [ [ ... | ... ] | ... ], [ ... | ... ] | ... ],
F = [ [ [ a, c, b ], [ c, b, a ] ]-a, [ [ a, b, c ], [ c, a, b ] ]-a, [ [ b, a, c ], [ a, c, b ] ]-a, [ [ b, c, a ], [ a, b | ... ] ]-a, [ [ c, b | ... ], [ b | ... ] ]-b, [ [ c | ... ], [ ... | ... ] ]-c, [ [ ... | ... ] | ... ]-a, [ ... | ... ]-a, ... - ... | ... ] .

?- count( ( m( D ), scf( F, D ) ), N ).
N = 1375.


?- m( D ), mcf( F, D ), non_imposed( F ), fig( scf, F ).

          123456
1:[ a, c, b ] --a-a-
2:[ a, b, c ] ---a-a
3:[ b, a, c ] a---a-
4:[ b, c, a ] -a---a
5:[ c, b, a ] a-b---
6:[ c, a, b ] -a-c--
--
D = [ [ [ a, c, b ], [ c, b, a ] ], [ [ a, b, c ], [ c, a, b ] ], [ [ b, a, c ], [ a, c, b ] ], [ [ b, c, a ], [ a, b, c ] ], [ [ c, b, a ], [ b, a | ... ] ], [ [ c, a | ... ], [ b | ... ] ], [ [ c | ... ], [ ... | ... ] ], [ [ ... | ... ] | ... ], [ ... | ... ] | ... ],
F = [ [ [ a, c, b ], [ c, b, a ] ]-a, [ [ a, b, c ], [ c, a, b ] ]-a, [ [ b, a, c ], [ a, c, b ] ]-a, [ [ b, c, a ], [ a, b | ... ] ]-a, [ [ c, b | ... ], [ b | ... ] ]-b, [ [ c | ... ], [ ... | ... ] ]-c, [ [ ... | ... ] | ... ]-a, [ ... | ... ]-a, ... - ... | ... ] .


% union of a supper Arrow domain and all the remaining 24 profiles
% are sufficient (as shown in the earlier experiment)

?- all_profiles( U ), m1( R ), subtract( U, R, D ), f( F, D, scf_axiom ), non_imposed( F ), fig( scf, F ), fail.

          123456
1:[ a, c, b ] aabb-c
2:[ a, b, c ] aabbc-
3:[ b, a, c ] -abbcc
4:[ b, c, a ] a-bbcc
5:[ c, b, a ] aa-bcc
6:[ c, a, b ] aab-cc
--
          123456
1:[ a, c, b ] aaaa-a
2:[ a, b, c ] aaaaa-
3:[ b, a, c ] -bbbbb
4:[ b, c, a ] b-bbbb
5:[ c, b, a ] cc-ccc
6:[ c, a, b ] ccc-cc
--
false.


?- all_profiles( D ), f( F, D, scf_axiom ), non_imposed( F ), hr( 30 ), scf_xy( F, B, Y ), nl, write( B:Y ), fail.

------------------------------
[ a, a ]:[ [ *, * ]-a ]
[ a, b ]:[ [ a, a ]-a, [ a, b ]-b, [ b, a ]-a, [ b, b ]-b ]
[ a, c ]:[ [ a, a ]-a, [ a, c ]-c, [ c, a ]-a, [ c, c ]-c ]
[ b, a ]:[ [ a, a ]-a, [ a, b ]-b, [ b, a ]-a, [ b, b ]-b ]
[ b, b ]:[ [ *, * ]-b ]
[ b, c ]:[ [ b, b ]-b, [ b, c ]-c, [ c, b ]-b, [ c, c ]-c ]
[ c, a ]:[ [ a, a ]-a, [ a, c ]-c, [ c, a ]-a, [ c, c ]-c ]
[ c, b ]:[ [ b, b ]-b, [ b, c ]-c, [ c, b ]-b, [ c, c ]-c ]
[ c, c ]:[ [ *, * ]-c ]
------------------------------
[ a, a ]:[ [ *, * ]-a ]
[ a, b ]:[ [ a, a ]-a, [ a, b ]-a, [ b, a ]-b, [ b, b ]-b ]
[ a, c ]:[ [ a, a ]-a, [ a, c ]-a, [ c, a ]-c, [ c, c ]-c ]
[ b, a ]:[ [ a, a ]-a, [ a, b ]-a, [ b, a ]-b, [ b, b ]-b ]
[ b, b ]:[ [ *, * ]-b ]
[ b, c ]:[ [ b, b ]-b, [ b, c ]-b, [ c, b ]-c, [ c, c ]-c ]
[ c, a ]:[ [ a, a ]-a, [ a, c ]-a, [ c, a ]-c, [ c, c ]-c ]
[ c, b ]:[ [ b, b ]-b, [ b, c ]-b, [ c, b ]-c, [ c, c ]-c ]
[ c, c ]:[ [ *, * ]-c ]
false.

% note. scf/2 imposes non-dictatorship.


*/

%-----------------------------------------------------------------
% Chcking dictatorial/possible for SWF and SCF
%-----------------------------------------------------------------
% added: 12 Nov 2024 (moved from manipulanet.pl)

f_domain_and_values( F, D, V ):-
	 findall( Y, member( _-Y, F ), V ),
	 findall( X, member( X-_, F ), D ).


check_scf( F, D, Dict ):-
	( \+ scf( F, D )-> Dict = scf-dict; Dict = scf-poss ).

check_scf( F, D, Dict, SP, NI ):-
	f( F, D, scf_axiom ),
	SP = sp,
	( dictatorial_scf( J, F )-> Dict = d( J ); Dict =d( 0 ) ), 
	( \+ non_imposed( F )-> NI=i ; NI=ni ).

check_swf( F, D, Dict ):-
	( \+ ( swf( F, D ), \+ dictatorial_swf( _, F ) ) -> Dict = swf-dict; Dict = swf-poss ).


analyze_profiles( D, E, F ):-
	 check_scf( _, D, E ),
	 check_swf( _, D, F ).



%-----------------------------------------------------------------
% Finding dictatorial SCF domains
%-----------------------------------------------------------------
% added: 19 Dec 2019
% modified: 11 Nov 2025

indexed_pp( X, P ):-
	 ppc( X, P ).

indexed_profiles( L, U ):-
	 maplist( ppc,L, U ). 

indexed_profiles_old( L, U ):-
	 \+ var( L ),
	 !,
	 G = (
		 member( I, L ),
		 length( I, N ),
		 pp( N, I, R )
	 ),
	 findall( R, G, U ).

indexed_profiles_old( L, U ):-
	 \+ var( U ),
	 !,
	 G = (
		 member( R, U ),
		 length( R, N ),
		 pp( N, I, R )
	 ),
	 findall( I, G, L ).

%modified: 11 Nov 2025

/*
arrow_ring( ring_1, I ):-
	 m1( M ),
	 indexed_profiles( I, M ).

arrow_ring( ring_2, I ):-
	 m2( M ),
	 indexed_profiles( I, M ).

arrow_ring( double, I ):-
	 m( M ),
	 indexed_profiles( I, M ).

*/

indices_of_arrow_ring( ring_1, X ):-
	 findall( [ K, J ], jv( K, J ), X ). 

indices_of_arrow_ring( ring_2, X ):-
	 findall( [ J, K ], jv( K, J ), X ). 

indices_of_arrow_ring( double, Z ):-
	 indices_of_arrow_ring( ring_1, X ),
	 indices_of_arrow_ring( ring_2, Y ),
	 append( X, Y, Z ).

arrow_ring( Ring, M ):-
	 indices_of_arrow_ring( Ring, I ),
	 indexed_profiles( I, M ).


:- dynamic tmp_dict_scf_domain_together_with_m1/2.

test_dict_scf_domains:-
	 chalt([a,b,c]),
	 abolish( tmp_dict_scf_domain_together_with_m1 /2 ),
	 fail.

test_dict_scf_domains:-
	 all_profiles( U0 ),
	 m( M ), 
	 subtract( U0, M, U1 ), 
	 between( 1, 24, K ), 
	 nl, 
	 write( [ K ] ), 
	 sleep( 1 ),
	 select_n( U2, U1, K ), 
	 m1( C ), 
	 append( U2, C, U ), 
%	 \+ ( f( F, U, scf_axiom ), non_imposed( F ) ), 
	 \+ scf( _, U ), 
	 % m1と抱き合わせなので独裁領域はs1となる（s2は可能領域）．
	 assert( tmp_dict_scf_domain_together_with_m1( U2, K ) ), 
	 fail.
test_dict_scf_domains:-
	 hist1n( tmp_dict_scf_domain_together_with_m1( _, B ), B ).


:- dynamic tmp_scf_domain/2.


test_scf_domains:-
	 chalt([a,b,c]),
	 abolish( tmp_scf_domain /2 ),
	 abolish( tmp_dict_scf_domain /2 ),
	 fail.
test_scf_domains:-
	 all_profiles( U0 ),
	 between( 1, 6, K ),  % m1, m2, mo, meはγ可能とわかっている．
	 nl, 
	 write( [ K ] ), 
	 sleep( 1 ),
	 select_n( U, U0, K ), 
%	 \+ \+ ( f( F, U, scf_axiom ), non_imposed( F ) ), 
	 \+ (
		 \+ scf( _, U ), 
		 assert( tmp_dict_scf_domain( U, K ) )
	 ), 
	 assert( tmp_scf_domain( U, K ) ), 
	 fail.
test_scf_domains:-
	 nl,
	 write( scf:'' ),
	 hist1n( tmp_scf_domain( _, B ), B ),
	 nl,
	 write( dict:'' ),
	 hist1n( tmp_dict_scf_domain( _, B ), B ).



beep_if_newcommer( G ):-
	 % G = tmp_dictatorial_scf_domain_1( A, B, C, D ),
	 X = findall( 1, clause( G, _ ), _L ),
	 X,
	 repeat,
	 \+ X,
	 shell( 'rundll32 user32.dll, MessageBeep' ),
	 !,
	 fail.

/*

?- test_scf_domains.

[1]
[2]
[3]
[4]
[5]
[6]

?- hist1n(tmp_dict_scf_domain(A,B), B).
 [1,36]
 [2,630]
 [3,1068]
 [4,2424]
 [5,5694]
 [6,10940]
total:20792
true.

?- hist1n(tmp_scf_domain(A,B), B).

 [3,6072]
 [4,56481]
 [5,371298]
 [6,1936852]
total:2370703
true.


?- between( 1, 36, N ), between( 0, N, K ), combin( N, K, A ), B is abs( A - 6072 ), B < 100, nl, write( N-K-B ), fail.

21-4-87
21-17-87
34-3-88
34-31-88
false.

?- between( 0, 36, N ), between( 0, N, K ), between( 0,36,N1), between(0,N1, K1 ), combin( N, K, A ), combin( N1, K1, C ), B is abs( A * C - 6072 ), B < 6, nl, format( '~1f [~w,~w]*[~w,~w]', [B,N,K,N1,K1] ), fail.

0.0 [3,1]*[24,3]
0.0 [3,1]*[24,21]
0.0 [3,2]*[24,3]
0.0 [3,2]*[24,21]
0.0 [22,1]*[24,2]
0.0 [22,1]*[24,22]
0.0 [22,21]*[24,2]
0.0 [22,21]*[24,22]
0.0 [23,2]*[24,1]
0.0 [23,2]*[24,23]
0.0 [23,21]*[24,1]
0.0 [23,21]*[24,23]
0.0 [24,1]*[23,2]
0.0 [24,1]*[23,21]
0.0 [24,2]*[22,1]
0.0 [24,2]*[22,21]
0.0 [24,3]*[3,1]
0.0 [24,3]*[3,2]
0.0 [24,21]*[3,1]
0.0 [24,21]*[3,2]
0.0 [24,22]*[22,1]
0.0 [24,22]*[22,21]
0.0 [24,23]*[23,2]
0.0 [24,23]*[23,21]
false.

?- hist1n( ( s(S),m(M),o(O),member( P:X,[ s:S,m:M,o:O ] ), tmp_scf_domain(A,3 ), \+ ( member( Y, A ), \+ intersection(X,Y,[]) ) ), P ).

 [m,6072]
 [o,6072]
 [s,6072]
total:18216
true.

?- hist1n( ( s(S),m(M),o(O),member( P:X,[ s:S,m:M,o:O ] ), tmp_scf_domain(A,3 ), \+ ( member( Y, A ), \+ subset(Y,X) ) ), P ).

total:0
true.

?- hist1n( ( s(S),m(M),o(O), tmp_scf_domain(A,3 ), findall( P, ( member( P:X,[ s:S,m:M,o:O ] ), member( Y, A ), member(Y,X) ), Z ) ), Z ).

 [[m,m,m],220]
 [[m,m,o],702]
 [[m,o,o],624]
 [[o,o,o],208]
 [[s,m,m],672]
 [[s,m,o],1452]
 [[s,o,o],648]
 [[s,s,m],636]
 [[s,s,o],702]
 [[s,s,s],208]
total:6072
true.

?- hist1n( ( s(S),m(M),o(O), tmp_dict_scf_domain(A,3 ), findall( P, ( member( P:X,[ s:S,m:M,o:O ] ), member( Y, A ), member(Y,X) ), Z ) ), Z ).

 [[m,m,o],90]
 [[m,o,o],168]
 [[o,o,o],12]
 [[s,m,m],120]
 [[s,m,o],276]
 [[s,o,o],144]
 [[s,s,m],156]
 [[s,s,o],90]
 [[s,s,s],12]
total:1068
true.

?- hist1n( ( s(S),m(M),o(O), tmp_dict_scf_domain(A,3 ), findall( P, ( member( P:X,[ s:S,m:M,o:O ] ), member( Y, A ), member(Y,X) ), Z ), sort( Z, [_] ) ), Z ).

 [[o,o,o],12]
 [[s,s,s],12]
total:24
true.

?- hist1n( ( s(S),m(M),o(O), tmp_dict_scf_domain(A,3 ), findall( P, ( member( P:X,[ s:S,m:M,o:O ] ), member( Y, A ), member(Y,X) ), Z ), sort( Z, [_] ), indexed_profiles( B, A ) ), Z:B ).

 [[o,o,o]:[[1,1],[1,2],[2,1]],1]
 [[o,o,o]:[[1,1],[1,2],[2,2]],1]
 [[o,o,o]:[[1,1],[2,1],[2,2]],1]
 [[o,o,o]:[[1,2],[2,1],[2,2]],1]
 [[o,o,o]:[[3,3],[3,4],[4,3]],1]
 [[o,o,o]:[[3,3],[3,4],[4,4]],1]
 [[o,o,o]:[[3,3],[4,3],[4,4]],1]
 [[o,o,o]:[[3,4],[4,3],[4,4]],1]
 [[o,o,o]:[[5,5],[5,6],[6,5]],1]
 [[o,o,o]:[[5,5],[5,6],[6,6]],1]
 [[o,o,o]:[[5,5],[6,5],[6,6]],1]
 [[o,o,o]:[[5,6],[6,5],[6,6]],1]
 [[s,s,s]:[[1,3],[1,6],[4,6]],1]
 [[s,s,s]:[[1,3],[1,6],[5,3]],1]
 [[s,s,s]:[[1,3],[5,2],[5,3]],1]
 [[s,s,s]:[[1,6],[4,2],[4,6]],1]
 [[s,s,s]:[[2,4],[2,5],[3,5]],1]
 [[s,s,s]:[[2,4],[2,5],[6,4]],1]
 [[s,s,s]:[[2,4],[6,1],[6,4]],1]
 [[s,s,s]:[[2,5],[3,1],[3,5]],1]
 [[s,s,s]:[[3,1],[3,5],[6,1]],1]
 [[s,s,s]:[[3,1],[6,1],[6,4]],1]
 [[s,s,s]:[[4,2],[4,6],[5,2]],1]
 [[s,s,s]:[[4,2],[5,2],[5,3]],1]
total:24
true.


?- basic_component_symbols( H0 ), subtract( H0,[ mo, me ], H ), hist1n( ( s(S),m(M),o(O), tmp_dict_scf_domain(A,3 ), findall( P, ( member( P:X,[ s:S,m:M,o:O ] ), member( Y, A ), member(Y,X) ), Z ), sort( Z, [_] ), indexed_profiles( B, A ), findall( P, ( member( Y, A ), member(P,H), call(P,X), member( Y, X ) ), W ) ), Z:B-W ).

 [[o,o,o]:[[1,1],[1,2],[2,1]]-[o1,o1,o1],1]
 [[o,o,o]:[[1,1],[1,2],[2,2]]-[o1,o1,o1],1]
 [[o,o,o]:[[1,1],[2,1],[2,2]]-[o1,o1,o1],1]
 [[o,o,o]:[[1,2],[2,1],[2,2]]-[o1,o1,o1],1]
 [[o,o,o]:[[3,3],[3,4],[4,3]]-[o2,o2,o2],1]
 [[o,o,o]:[[3,3],[3,4],[4,4]]-[o2,o2,o2],1]
 [[o,o,o]:[[3,3],[4,3],[4,4]]-[o2,o2,o2],1]
 [[o,o,o]:[[3,4],[4,3],[4,4]]-[o2,o2,o2],1]
 [[o,o,o]:[[5,5],[5,6],[6,5]]-[o3,o3,o3],1]
 [[o,o,o]:[[5,5],[5,6],[6,6]]-[o3,o3,o3],1]
 [[o,o,o]:[[5,5],[6,5],[6,6]]-[o3,o3,o3],1]
 [[o,o,o]:[[5,6],[6,5],[6,6]]-[o3,o3,o3],1]
 [[s,s,s]:[[1,3],[1,6],[4,6]]-[s2,s2,s2],1]
 [[s,s,s]:[[1,3],[1,6],[5,3]]-[s2,s2,s2],1]
 [[s,s,s]:[[1,3],[5,2],[5,3]]-[s2,s2,s2],1]
 [[s,s,s]:[[1,6],[4,2],[4,6]]-[s2,s2,s2],1]
 [[s,s,s]:[[2,4],[2,5],[3,5]]-[s1,s1,s1],1]
 [[s,s,s]:[[2,4],[2,5],[6,4]]-[s1,s1,s1],1]
 [[s,s,s]:[[2,4],[6,1],[6,4]]-[s1,s1,s1],1]
 [[s,s,s]:[[2,5],[3,1],[3,5]]-[s1,s1,s1],1]
 [[s,s,s]:[[3,1],[3,5],[6,1]]-[s1,s1,s1],1]
 [[s,s,s]:[[3,1],[6,1],[6,4]]-[s1,s1,s1],1]
 [[s,s,s]:[[4,2],[4,6],[5,2]]-[s2,s2,s2],1]
 [[s,s,s]:[[4,2],[5,2],[5,3]]-[s2,s2,s2],1]
total:24
H0 = [s1, s2, m1, m2, o1, o2, o3, mo, me],
H = [s1, s2, m1, m2, o1, o2, o3].


?- basic_component_symbols( H0 ), subtract( H0,[ mo, me ], H ), hist1n( ( s(S),m(M),o(O), tmp_dict_scf_domain(A,3 ), findall( P, ( member( P:X,[ s:S,m:M,o:O ] ), member( Y, A ), member(Y,X) ), Z ), sort( Z, [_] ), indexed_profiles( B, A ), findall( I, ( member( Y, A ), member(P,H), call(P,X), nth1( I,X,Y ) ), W0 ), sort(W0,W) ), Z:B-W ).

 [[o,o,o]:[[1,1],[1,2],[2,1]]-[1,2,3],1]
 [[o,o,o]:[[1,1],[1,2],[2,2]]-[1,2,4],1]
 [[o,o,o]:[[1,1],[2,1],[2,2]]-[1,3,4],1]
 [[o,o,o]:[[1,2],[2,1],[2,2]]-[2,3,4],1]
 [[o,o,o]:[[3,3],[3,4],[4,3]]-[1,2,3],1]
 [[o,o,o]:[[3,3],[3,4],[4,4]]-[1,2,4],1]
 [[o,o,o]:[[3,3],[4,3],[4,4]]-[1,3,4],1]
 [[o,o,o]:[[3,4],[4,3],[4,4]]-[2,3,4],1]
 [[o,o,o]:[[5,5],[5,6],[6,5]]-[1,2,3],1]
 [[o,o,o]:[[5,5],[5,6],[6,6]]-[1,2,4],1]
 [[o,o,o]:[[5,5],[6,5],[6,6]]-[1,3,4],1]
 [[o,o,o]:[[5,6],[6,5],[6,6]]-[2,3,4],1]
 [[s,s,s]:[[1,3],[1,6],[4,6]]-[3,5,6],1]
 [[s,s,s]:[[1,3],[1,6],[5,3]]-[3,4,5],1]
 [[s,s,s]:[[1,3],[5,2],[5,3]]-[2,3,4],1]
 [[s,s,s]:[[1,6],[4,2],[4,6]]-[1,5,6],1]
 [[s,s,s]:[[2,4],[2,5],[3,5]]-[1,2,4],1]
 [[s,s,s]:[[2,4],[2,5],[6,4]]-[1,2,6],1]
 [[s,s,s]:[[2,4],[6,1],[6,4]]-[1,5,6],1]
 [[s,s,s]:[[2,5],[3,1],[3,5]]-[2,3,4],1]
 [[s,s,s]:[[3,1],[3,5],[6,1]]-[3,4,5],1]
 [[s,s,s]:[[3,1],[6,1],[6,4]]-[3,5,6],1]
 [[s,s,s]:[[4,2],[4,6],[5,2]]-[1,2,6],1]
 [[s,s,s]:[[4,2],[5,2],[5,3]]-[1,2,4],1]
total:24
H0 = [s1, s2, m1, m2, o1, o2, o3, mo, me],
H = [s1, s2, m1, m2, o1, o2, o3].

?- 


% test_dict_scf_domainsはm1と合併した独裁領域を探すと，s1だけが見つかる．
% 多様性が抑えられ，n＜6では独裁領域が存在しない．

?- test_dict_scf_domains.

[1]
[2]
[3]
[4]
[5]
[6]
...


% at another theread opened.

?- beep_if_newcommer( tmp_dict_scf_domain( A, B )).

% m1s1がγ独裁の唯一の最小領域．

?- tmp_dict_scf_domain( U, K ), indexed_profiles( G, U ).
U = [[[a, c, b], [b, c, a]], [[a, c, b], [c, a, b]], [[b, a, c], [a, b, c]], [[b, a, c], [c, a, b]], [[c, b, a], [a, b|...]], [[c, b|...], [b|...]]],
K = 6,
G = [[2, 4], [2, 5], [3, 1], [3, 5], [6, 1], [6, 4]].

?- s1( U ), indexed_profiles( G, U ).
U = [[[a, c, b], [b, c, a]], [[a, c, b], [c, a, b]], [[b, a, c], [a, b, c]], [[b, a, c], [c, a, b]], [[c, b, a], [a, b|...]], [[c, b|...], [b|...]]],
G = [[2, 4], [2, 5], [3, 1], [3, 5], [6, 1], [6, 4]].


?- tmp_dict_scf_domain(A,7), indexed_profiles( I, A ).
A = [[[a, b, c], [a, c, b]], [[a, c, b], [b, c, a]], [[a, c, b], [c, a, b]], [[b, a, c], [a, b, c]], [[b, a, c], [c, a|...]], [[c, b|...], [a|...]], [[c|...], [...|...]]],
I = [[1, 2], [2, 4], [2, 5], [3, 1], [3, 5], [6, 1], [6, 4]].


% earlier result (m2 case?)

?- tmp_scf_domain( U, K ), indexed_profiles( I, U ).
U = [[[a, c, b], [b, c, a]], [[a, c, b], [c, a, b]], [[b, a, c], [a, b, c]], [[b, a, c], [c, a, b]], [[c, b, a], [a, b|...]], [[c, b|...], [b|...]]],
K = 6,
I = [[1, 4], [1, 6], [3, 2], [3, 6], [5, 2], [5, 4]].

...

?- tmp_scf_domain( U, K ), indexed_profiles( I, U ), nl, write( K ; I ), fail.

6;[[1,4],[1,6],[3,2],[3,6],[5,2],[5,4]]
7;[[1,4],[1,6],[2,1],[3,2],[3,6],[5,2],[5,4]]
7;[[1,4],[1,6],[2,5],[3,2],[3,6],[5,2],[5,4]]
7;[[1,4],[1,6],[3,2],[3,6],[4,1],[5,2],[5,4]]
7;[[1,4],[1,6],[3,2],[3,6],[4,3],[5,2],[5,4]]
7;[[1,4],[1,6],[3,2],[3,6],[5,2],[5,4],[6,3]]
7;[[1,4],[1,6],[3,2],[3,6],[5,2],[5,4],[6,5]]
8;[[1,1],[1,4],[1,6],[2,1],[3,2],[3,6],[5,2],[5,4]]
false.

?- 

*/

%scf_dict( ring_1, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ] ] ).

%scf_dict( ring_2, [ [ 2, 3 ], [ 2, 5 ], [ 4, 1 ], [ 4, 5 ], [ 6, 1 ], [ 6, 3 ] ] ).



scf_dict( ring_1, D ):-
	 D = [[2, 4], [2, 5], [3, 1], [3, 5], [6, 1], [6, 4]].

scf_dict( ring_2, D ):-
	 D = [[4, 2], [5, 2], [1, 3], [5, 3], [1, 6], [4, 6]].


scf_dict( double, S ):-
	 scf_dict( ring_1, S1 ),
	 scf_dict( ring_2, S2 ),
	 append( S1, S2, S ).

/*

?- count( ( m1( D ), scf( F, D ) ), N ).
N = 538.

?- scf_dict( R, I ), indexed_profiles( I, D ), scf( F, D ).
false.


?- scf_dict( R, I ), indexed_profiles( I, D ), f( F, D, scf_axiom ), non_imposed( F ), dictatorial_scf( J, F ), fig( scf, F ), write( R; J ), !, fail.

          123456
1:[ a, c, b ] ---b-c
2:[ a, b, c ] ------
3:[ b, a, c ] -a---c
4:[ b, c, a ] ------
5:[ c, b, a ] -a-b--
6:[ c, a, b ] ------
--ring_1;2

?- scf_dict( ring_1, A ), scf_dict( ring_2, B ), union( A, B, C ), indexed_profiles( C, D ), f( F, D, scf_axiom ), non_imposed( F ), \+ dictatorial_scf( J, F ), fig( scf, F ), !, fail.

          123456
1:[ a, c, b ] ---b-c
2:[ a, b, c ] --a-a-
3:[ b, a, c ] -a---c
4:[ b, c, a ] a---a-
5:[ c, b, a ] -a-b--
6:[ c, a, b ] a-a---
--
false.

?- scf_dict( ring_1, A ), scf_dict( ring_2, B ), union( A, B, C ), indexed_profiles( C, D ), f( F, D, scf_axiom ), non_imposed( F ), dictatorial_scf( J, F ), fig( scf, F ), write( J ),  !, fail.

          123456
1:[ a, c, b ] ---b-c
2:[ a, b, c ] --b-c-
3:[ b, a, c ] -a---c
4:[ b, c, a ] a---c-
5:[ c, b, a ] -a-b--
6:[ c, a, b ] a-b---
--2
false.

*/


%-----------------------------------------------------------------
% proving the pallarel possibility results by using profile-elimination
%-----------------------------------------------------------------
% testx: 19-20 Dec 2019


/*

% remind.

?- m1( D ), nth1( J, D, Q ), ppc( K, A, Q ), nl, write( K; J; A; Q ), fail.

3;1;[1,5];[[a,c,b],[c,b,a]]
3;2;[2,6];[[a,b,c],[c,a,b]]
3;3;[3,1];[[b,a,c],[a,c,b]]
3;4;[4,2];[[b,c,a],[a,b,c]]
3;5;[5,3];[[c,b,a],[b,a,c]]
3;6;[6,4];[[c,a,b],[b,c,a]]
false.

 ?- m2( D ), nth1( J, D, Q ), ppc( K, A, Q ), nl, write( K; J; A; Q ), fail.

1;1;[5,1];[[c,b,a],[a,c,b]]
1;2;[6,2];[[c,a,b],[a,b,c]]
1;3;[1,3];[[a,c,b],[b,a,c]]
1;4;[2,4];[[a,b,c],[b,c,a]]
1;5;[3,5];[[b,a,c],[c,b,a]]
1;6;[4,6];[[b,c,a],[c,a,b]]
false.

*/

:- dynamic( tmp_x_domain/3 ).

init_x_domain:-
	 abolish( tmp_x_domain/3 ).

testx:-
	 init_x_domain,
	 all_profiles( L ),
	 m1( C ),
	 nth1( K, C, P ),
	 m2( D ),
	 nth1( J, D, Q ),
	 nl,
	 subtract( L, [ P, Q ], H ),
	 member( Type, [ swf, scf, mcf ] ),
	 Rule =.. [ Type, _, H ],
	 ( \+ Rule -> Z = 0 ; Z = 1 ),
	 write( [ K, J ] ),
	 write( ( Type, Z ) ),
	 tab( 1 ),
%	 Z = 1,
	 assertz( tmp_x_domain( ( Type, Z ), P, Q ) ),
	 fail.
testx.


/*

?- testx.

[1,1]swf,1 [1,1]scf,1 [1,1]mcf,1
[1,2]swf,1 [1,2]scf,1 [1,2]mcf,1
[1,3]swf,0 [1,3]scf,0 [1,3]mcf,0
[1,4]swf,0 [1,4]scf,0 [1,4]mcf,0
[1,5]swf,0 [1,5]scf,0 [1,5]mcf,0
[1,6]swf,1 [1,6]scf,1 [1,6]mcf,1
[2,1]swf,1 [2,1]scf,1 [2,1]mcf,1
[2,2]swf,1 [2,2]scf,1 [2,2]mcf,1
[2,3]swf,1 [2,3]scf,1 [2,3]mcf,1
[2,4]swf,0 [2,4]scf,0 [2,4]mcf,0
[2,5]swf,0 [2,5]scf,0 [2,5]mcf,0
[2,6]swf,0 [2,6]scf,0 [2,6]mcf,0
[3,1]swf,0 [3,1]scf,0 [3,1]mcf,0
[3,2]swf,1 [3,2]scf,1 [3,2]mcf,1
[3,3]swf,1 [3,3]scf,1 [3,3]mcf,1
[3,4]swf,1 [3,4]scf,1 [3,4]mcf,1
[3,5]swf,0 [3,5]scf,0 [3,5]mcf,0
[3,6]swf,0 [3,6]scf,0 [3,6]mcf,0
[4,1]swf,0 [4,1]scf,0 [4,1]mcf,0
[4,2]swf,0 [4,2]scf,0 [4,2]mcf,0
[4,3]swf,1 [4,3]scf,1 [4,3]mcf,1
[4,4]swf,1 [4,4]scf,1 [4,4]mcf,1
[4,5]swf,1 [4,5]scf,1 [4,5]mcf,1
[4,6]swf,0 [4,6]scf,0 [4,6]mcf,0
[5,1]swf,0 [5,1]scf,0 [5,1]mcf,0
[5,2]swf,0 [5,2]scf,0 [5,2]mcf,0
[5,3]swf,0 [5,3]scf,0 [5,3]mcf,0
[5,4]swf,1 [5,4]scf,1 [5,4]mcf,1
[5,5]swf,1 [5,5]scf,1 [5,5]mcf,1
[5,6]swf,1 [5,6]scf,1 [5,6]mcf,1
[6,1]swf,1 [6,1]scf,1 [6,1]mcf,1
[6,2]swf,0 [6,2]scf,0 [6,2]mcf,0
[6,3]swf,0 [6,3]scf,0 [6,3]mcf,0
[6,4]swf,0 [6,4]scf,0 [6,4]mcf,0
[6,5]swf,1 [6,5]scf,1 [6,5]mcf,1
[6,6]swf,1 [6,6]scf,1 [6,6]mcf,1
true.

?- tmp_x_domain( ( swf, 1 ), P, Q ), pp( 2, K, P ), pp( 2, J, Q ).
P = [[a, c, b], [c, b, a]],
Q = [[c, b, a], [a, c, b]],
K = [1, 5],
J = [5, 1] .


?- hist1n( tmp_x_domain( Type, P, Q ), Type ).

 [(mcf,0),18]
 [(mcf,1),18]
 [(scf,0),18]
 [(scf,1),18]
 [(swf,0),18]
 [(swf,1),18]
total:108
true.

?- hist1n( bagof( J, Q ^ ( tmp_x_domain( ( swf, 1 ), P, Q ), pp( 2, K, P ), pp( 2, J, Q ) ), L ), [ K, L ] ).

 [[[1,5],[[5,1],[6,2],[4,6]]],1]
 [[[2,6],[[5,1],[6,2],[1,3]]],1]
 [[[3,1],[[6,2],[1,3],[2,4]]],1]
 [[[4,2],[[1,3],[2,4],[3,5]]],1]
 [[[5,3],[[2,4],[3,5],[4,6]]],1]
 [[[6,4],[[5,1],[3,5],[4,6]]],1]
total:6
true.

*/



%-----------------------------------------------------------------
% pallarel possibility by cross profile-elimination: GS ring version
%-----------------------------------------------------------------
% testy: added 21 Dec 2019

s1( D ):-
	 scf_dict( ring_1, I ),
	 indexed_profiles( I, D ).

s2( D ):-
	 scf_dict( ring_2, I ),
	 indexed_profiles( I, D ).

s( D ):-
	 s1( D1 ),
	 s2( D2 ),
	 append( D1, D2, D ).

cross_profile_pair_of_dictatorial_scf_set( [ K, J ], [ I1, I2 ], [ P, Q ] ):-
	 s1( C ),
	 s2( D ),
	 nth1( K, C, P ),
	 nth1( J, D, Q ),
	 pp( I1, P ),
	 pp( I2, Q ).


/*

 ?- cross_profile_pair_of_dictatorial_scf_set( A, B, C ).
A = [1, 1],
B = [[1, 4], [2, 3]],
C = [[[a, c, b], [b, c, a]], [[a, b, c], [b, a, c]]] .

*/

:- dynamic( tmp_y_domain/3 ).

init_y_domain:-
	 abolish( tmp_y_domain/3 ).


testy:-
	 init_y_domain,
	 all_profiles( L ),
	 cross_profile_pair_of_dictatorial_scf_set( _, I, [ P, Q ] ),
/*
	 s1( C ),
	 nth1( K, C, P ),
	 s2( D ),
	 nth1( J, D, Q ),
*/
	 nl,
	 subtract( L, [ P, Q ], H ),
	 member( Type, [ swf, scf, mcf ] ),
	 Rule =.. [ Type, _, H ],
	 ( \+ Rule -> Z = 0 ; Z = 1 ),
	 write( I ),
	 write( ( Type, Z ) ),
	 tab( 1 ),
	 Z = 1,
	 assertz( tmp_y_domain( ( Type, Z ), P, Q ) ),
	 fail.
testy.

/*

 ?- testy.


[[1,4],[2,3]]swf,0 [[1,4],[2,3]]scf,0 [[1,4],[2,3]]mcf,0
[[1,4],[2,5]]swf,0 [[1,4],[2,5]]scf,0 [[1,4],[2,5]]mcf,0
[[1,4],[4,1]]swf,0 [[1,4],[4,1]]scf,0 [[1,4],[4,1]]mcf,0
[[1,4],[4,5]]swf,0 [[1,4],[4,5]]scf,0 [[1,4],[4,5]]mcf,0
[[1,4],[6,1]]swf,0 [[1,4],[6,1]]scf,0 [[1,4],[6,1]]mcf,0
[[1,4],[6,3]]swf,0 [[1,4],[6,3]]scf,0 [[1,4],[6,3]]mcf,0
[[1,6],[2,3]]swf,0 [[1,6],[2,3]]scf,1 [[1,6],[2,3]]mcf,1
[[1,6],[2,5]]swf,0 [[1,6],[2,5]]scf,0 [[1,6],[2,5]]mcf,0
[[1,6],[4,1]]swf,0 [[1,6],[4,1]]scf,0 [[1,6],[4,1]]mcf,0
[[1,6],[4,5]]swf,0 [[1,6],[4,5]]scf,1 [[1,6],[4,5]]mcf,1
[[1,6],[6,1]]swf,0 [[1,6],[6,1]]scf,1 [[1,6],[6,1]]mcf,1
[[1,6],[6,3]]swf,0 [[1,6],[6,3]]scf,0 [[1,6],[6,3]]mcf,0
[[3,2],[2,3]]swf,0 [[3,2],[2,3]]scf,1 [[3,2],[2,3]]mcf,1
[[3,2],[2,5]]swf,0 [[3,2],[2,5]]scf,0 [[3,2],[2,5]]mcf,0
[[3,2],[4,1]]swf,0 [[3,2],[4,1]]scf,0 [[3,2],[4,1]]mcf,0
[[3,2],[4,5]]swf,0 [[3,2],[4,5]]scf,1 [[3,2],[4,5]]mcf,1
[[3,2],[6,1]]swf,0 [[3,2],[6,1]]scf,1 [[3,2],[6,1]]mcf,1
[[3,2],[6,3]]swf,0 [[3,2],[6,3]]scf,0 [[3,2],[6,3]]mcf,0
[[3,6],[2,3]]swf,0 [[3,6],[2,3]]scf,0 [[3,6],[2,3]]mcf,0
[[3,6],[2,5]]swf,0 [[3,6],[2,5]]scf,0 [[3,6],[2,5]]mcf,0
[[3,6],[4,1]]swf,0 [[3,6],[4,1]]scf,0 [[3,6],[4,1]]mcf,0
[[3,6],[4,5]]swf,0 [[3,6],[4,5]]scf,0 [[3,6],[4,5]]mcf,0
[[3,6],[6,1]]swf,0 [[3,6],[6,1]]scf,0 [[3,6],[6,1]]mcf,0
[[3,6],[6,3]]swf,0 [[3,6],[6,3]]scf,0 [[3,6],[6,3]]mcf,0
[[5,2],[2,3]]swf,0 [[5,2],[2,3]]scf,0 [[5,2],[2,3]]mcf,0
[[5,2],[2,5]]swf,0 [[5,2],[2,5]]scf,0 [[5,2],[2,5]]mcf,0
[[5,2],[4,1]]swf,0 [[5,2],[4,1]]scf,0 [[5,2],[4,1]]mcf,0
[[5,2],[4,5]]swf,0 [[5,2],[4,5]]scf,0 [[5,2],[4,5]]mcf,0
[[5,2],[6,1]]swf,0 [[5,2],[6,1]]scf,0 [[5,2],[6,1]]mcf,0
[[5,2],[6,3]]swf,0 [[5,2],[6,3]]scf,0 [[5,2],[6,3]]mcf,0
[[5,4],[2,3]]swf,0 [[5,4],[2,3]]scf,1 [[5,4],[2,3]]mcf,1
[[5,4],[2,5]]swf,0 [[5,4],[2,5]]scf,0 [[5,4],[2,5]]mcf,0
[[5,4],[4,1]]swf,0 [[5,4],[4,1]]scf,0 [[5,4],[4,1]]mcf,0
[[5,4],[4,5]]swf,0 [[5,4],[4,5]]scf,1 [[5,4],[4,5]]mcf,1
[[5,4],[6,1]]swf,0 [[5,4],[6,1]]scf,1 [[5,4],[6,1]]mcf,1
[[5,4],[6,3]]swf,0 [[5,4],[6,3]]scf,0 [[5,4],[6,3]]mcf,0
true.

true.

 ?- bagof(C, tmp_y_domain( (scf,1), B, C ), D ).
B = [[a, c, b], [c, a, b]],
D = [[[a, b, c], [b, a, c]], [[b, c, a], [c, b, a]], [[c, a, b], [a, c, b]]] ;
B = [[b, a, c], [a, b, c]],
D = [[[a, b, c], [b, a, c]], [[b, c, a], [c, b, a]], [[c, a, b], [a, c, b]]] ;
B = [[c, b, a], [b, c, a]],
D = [[[a, b, c], [b, a, c]], [[b, c, a], [c, b, a]], [[c, a, b], [a, c, b]]].

 ?- cross_profile_pair_of_dictatorial_scf_set( I, J, [ B, C ] ), tmp_y_domain( (scf,1), B, C ).
I = [2, 1],
J = [[1, 6], [2, 3]],
B = [[a, c, b], [c, a, b]],
C = [[a, b, c], [b, a, c]] .

 ?- cross_profile_pair_of_dictatorial_scf_set( I, J, [ B, C ] ), \+ tmp_y_domain( (scf,1), B, C ).
I = [1, 1],
J = [[1, 4], [2, 3]],
B = [[a, c, b], [b, c, a]],
C = [[a, b, c], [b, a, c]] .

 ?- cross_profile_pair_of_dictatorial_scf_set( I, J, [ B, C ] ), tmp_y_domain( (scf,1), B, C ), nl, write( I; J ), fail.

[2,1];[[1,6],[2,3]]
[2,4];[[1,6],[4,5]]
[2,5];[[1,6],[6,1]]
[3,1];[[3,2],[2,3]]
[3,4];[[3,2],[4,5]]
[3,5];[[3,2],[6,1]]
[6,1];[[5,4],[2,3]]
[6,4];[[5,4],[4,5]]
[6,5];[[5,4],[6,1]]
false.

*/


:- dynamic( tmp_z_domain/3 ).

init_z_domain:-
	 abolish( tmp_z_domain/3 ).

testz:-
	 cross_profile_pair_of_dictatorial_scf_set( _, I, [ P, Q ] ),
	/*
	 s1( C ),
	 nth1( K, C, P ),
	 s2( D ),
	 nth1( J, D, Q ),
	*/
	 nl,
	 H = [ P, Q ],
	 member( Type, [ swf, scf, mcf ] ),
	 Rule =.. [ Type, _, H ],
	 ( \+ Rule -> Z = 0 ; Z = 1 ),
	 write( I ),
	 write( ( Type, Z ) ),
	 Z = 1,
	 assertz( tmp_z_domain( ( Type, Z ), P, Q ) ),
	 fail.
testz.

/*

?- testz.

[[1,4],[2,3]]swf,1[[1,4],[2,3]]scf,0[[1,4],[2,3]]mcf,1
[[1,4],[2,5]]swf,1[[1,4],[2,5]]scf,0[[1,4],[2,5]]mcf,1
[[1,4],[4,1]]swf,1[[1,4],[4,1]]scf,0[[1,4],[4,1]]mcf,1
[[1,4],[4,5]]swf,1[[1,4],[4,5]]scf,0[[1,4],[4,5]]mcf,1
[[1,4],[6,1]]swf,1[[1,4],[6,1]]scf,0[[1,4],[6,1]]mcf,1
[[1,4],[6,3]]swf,1[[1,4],[6,3]]scf,0[[1,4],[6,3]]mcf,1
[[1,6],[2,3]]swf,1[[1,6],[2,3]]scf,0[[1,6],[2,3]]mcf,1
[[1,6],[2,5]]swf,1[[1,6],[2,5]]scf,0[[1,6],[2,5]]mcf,1
[[1,6],[4,1]]swf,1[[1,6],[4,1]]scf,0[[1,6],[4,1]]mcf,1
[[1,6],[4,5]]swf,1[[1,6],[4,5]]scf,0[[1,6],[4,5]]mcf,1
[[1,6],[6,1]]swf,1[[1,6],[6,1]]scf,0[[1,6],[6,1]]mcf,1
[[1,6],[6,3]]swf,1[[1,6],[6,3]]scf,0[[1,6],[6,3]]mcf,1
[[3,2],[2,3]]swf,1[[3,2],[2,3]]scf,0[[3,2],[2,3]]mcf,1
[[3,2],[2,5]]swf,1[[3,2],[2,5]]scf,0[[3,2],[2,5]]mcf,1
[[3,2],[4,1]]swf,1[[3,2],[4,1]]scf,0[[3,2],[4,1]]mcf,1
[[3,2],[4,5]]swf,1[[3,2],[4,5]]scf,0[[3,2],[4,5]]mcf,1
...
[[5,4],[6,1]]swf,1[[5,4],[6,1]]scf,0[[5,4],[6,1]]mcf,1
[[5,4],[6,3]]swf,1[[5,4],[6,3]]scf,0[[5,4],[6,3]]mcf,1
true.

*/


%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Q. including all the 18 complementary profile pairs is neccessary and sufficient for the Arrovian dictatorial domain?
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%-----------------------------------------------------------------
% complementally selection from the 18 crossing profile pairs
%-----------------------------------------------------------------
% selection of representatives for each profile pair: i.e., a clutter.
% 21-24 Dec 2019

% select a transversal: a subset of profiles that intersects every profile pairs in the given set of paired profiles.

/*

x_domain( [ ], H, H ).

x_domain( [ [ P, Q ] | D ], A, H ):-
	 intersection( [ P, Q ], A, [ ] ),
	 member( S, [ P, Q ] ),
	 x_domain( D, [ S | A ], H ).

%x_domain( [ [ P, Q ] | D ], A, H ):-
%	 intersection( [ P, Q ], A, [ ] ),
%	 x_domain( D, [ P, Q | A ], H ).

x_domain( [ [ P, Q ] | D ], A, H ):-
	 \+ intersection( [ P, Q ], A, [ ] ),
	 x_domain( D, A, H ).

%x_domain( [ [ P, Q ] | D ], A, H ):-
%	 \+ intersection( [ P, Q ], A, [ ] ),
%	 member( [ S, T ], [ [ P, Q ], [ Q, P ] ] ),
%	 \+ member( S, A ),
%	 member( T, A ),
%	 x_domain( D, [ S | A ], H ).

*/



all_tmp_x_domain( Type, L ):-
	 G = tmp_x_domain( Type, P, Q ),
	 ( \+ clause( G, _ ) -> testx ; true ),
	 findall( [ P, Q ], G, L ).

/*

x_domain( Type, D ):-
	 Type = ( F, _ ),
	 type_of_social_rule( F ),
	 all_tmp_x_domain( Type, L ),
	 x_domain( L, [ ], D ).

x_domain_n( Type, D, N ):-
	 x_domain( Type, D ),
	 length( D, N ).

*/

x_domain( Type, D, N ):-
	 Type = ( F, _ ),
	 type_of_social_rule( F ),
	 m( X ),
	 length( X, K ),
	 between( 1, K, N ),
	 select_n( D, X, N ),
	 \+ (
		 tmp_x_domain( Type, P, Q ),
		 intersection( [ P, Q ], D, [ ] )
	 ).

/*

?- hist1n( x_domain( ( swf, 1 ), P, N ), N ).

 [6,2]
 [7,12]
 [8,48]
 [9,76]
 [10,48]
 [11,12]
 [12,1]
total:199
true.

?- hist1n( x_domain( ( swf, 0 ), P, N ), N ).

 [6,2]
 [7,12]
 [8,48]
 [9,76]
 [10,48]
 [11,12]
 [12,1]
total:199
true.

?- hist1n( ( x_domain( ( swf, 1 ), P, N ), \+ swf( _, P ) ), N ).

 [6,2]
 [7,12]
 [8,36]
 [9,40]
 [10,36]
 [11,12]
 [12,1]
total:139
true.

?- hist1n( ( x_domain( ( swf, 1 ), P, N ), \+ \+ swf( _, P ) ), N ).

 [8,12]
 [9,36]
 [10,12]
total:60
true.


 ?- hist1n( ( x_domain( ( swf, 0 ), P, N ), \+ swf( _, P ) ), N ).

 [6,2]
 [7,12]
 [8,30]
 [9,40]
 [10,30]
 [11,12]
 [12,1]
total:127
true.

?- hist1n( ( x_domain( ( swf, 0 ), P, N ), \+ \+ swf( _, P ) ), N ).

 [8,18]
 [9,36]
 [10,18]
total:72
true.


 ?- hist1n( ( x_domain( ( swf, 0 ), P, N ), \+ x_domain( ( swf, 1 ), P, N ) ), N ).

 [8,18]
 [9,36]
 [10,18]
total:72
true.

  ?- hist1n( ( x_domain( ( swf, 1 ), P, N ), x_domain( ( swf, 0 ), P, N ) , \+ \+ swf( _, P ) ), N ).

total:0
true.

?- count( ( x_domain( ( swf, 0 ), P, N ),  x_domain( ( swf, 1 ), P, N ) ), F ).

F = 127.

%%%%

?- all_profiles( A ), append( _, [ X | Z ], A ), member( Y, Z ), subtract( A, [ X, Y ] , H ), \+ \+ swf( _, H ), assertz( tmp_poss( X, Y ) ), fail.

?- tmp_poss( X, Y ), indexed_profiles( I, [ X, Y ] ), nl, write( I ), fail.

[[1,3],[2,6]]
[[1,3],[3,1]]
[[1,3],[4,2]]
[[1,5],[4,6]]
[[1,5],[5,1]]
[[1,5],[6,2]]
[[2,4],[3,1]]
[[2,4],[4,2]]
[[2,4],[5,3]]
[[2,6],[5,1]]
[[2,6],[6,2]]
[[3,1],[6,2]]
[[3,5],[4,2]]
[[3,5],[5,3]]
[[3,5],[6,4]]
[[4,6],[5,3]]
[[4,6],[6,4]]
[[5,1],[6,4]]
false.


re-run 24 Feb 2026

?- tmp_poss( X, Y ), indexed_profiles( I, [ X, Y ] ), nl, write( I ), fail.

[[1,4],[3,2]]
[[1,4],[4,1]]
[[1,4],[6,3]]
[[1,5],[2,3]]
[[1,5],[5,1]]
[[1,5],[6,2]]
[[2,3],[3,2]]
[[2,3],[4,1]]
[[2,6],[4,5]]
[[2,6],[5,1]]
[[2,6],[6,2]]
[[3,2],[5,1]]
[[3,6],[4,1]]
[[3,6],[5,4]]
[[3,6],[6,3]]
[[4,5],[5,4]]
[[4,5],[6,3]]
[[5,4],[6,2]]
false.

?- tmp_poss( X, Y ), nl, write( X:Y), fail.
[[a,b,c],[b,c,a]]:[[b,a,c],[a,c,b]]
[[a,b,c],[b,c,a]]:[[b,c,a],[a,b,c]]
[[a,b,c],[b,c,a]]:[[c,b,a],[b,a,c]]
[[a,b,c],[c,a,b]]:[[a,c,b],[b,a,c]]
[[a,b,c],[c,a,b]]:[[c,a,b],[a,b,c]]
[[a,b,c],[c,a,b]]:[[c,b,a],[a,c,b]]
[[a,c,b],[b,a,c]]:[[b,a,c],[a,c,b]]
[[a,c,b],[b,a,c]]:[[b,c,a],[a,b,c]]
[[a,c,b],[c,b,a]]:[[b,c,a],[c,a,b]]
[[a,c,b],[c,b,a]]:[[c,a,b],[a,b,c]]
[[a,c,b],[c,b,a]]:[[c,b,a],[a,c,b]]
[[b,a,c],[a,c,b]]:[[c,a,b],[a,b,c]]
[[b,a,c],[c,b,a]]:[[b,c,a],[a,b,c]]
[[b,a,c],[c,b,a]]:[[c,a,b],[b,c,a]]
[[b,a,c],[c,b,a]]:[[c,b,a],[b,a,c]]
[[b,c,a],[c,a,b]]:[[c,a,b],[b,c,a]]
[[b,c,a],[c,a,b]]:[[c,b,a],[b,a,c]]
[[c,a,b],[b,c,a]]:[[c,b,a],[a,c,b]]
false.

%%%%%%%%



 ?- hist1n( ( x_domain( ( swf, 1 ), P, N ), \+ x_domain( ( swf, 0 ), P, N ) ), N ).

 [8,18]
 [9,36]
 [10,18]
total:72
true.

 ?- N=10, x_domain( ( swf, 1 ), P, N ), \+ x_domain( ( swf, 0 ), P, N ), indexed_profiles( I, P ), m( M ), indexed_profiles( J, M ), subtract( J, I, D ), nl, write( N ; -D ), fail.

10;-[[6,4],[2,4]]
10;-[[6,4],[1,3]]
10;-[[6,4],[6,2]]
10;-[[5,3],[1,3]]
10;-[[5,3],[6,2]]
10;-[[5,3],[5,1]]
10;-[[4,2],[4,6]]
10;-[[4,2],[6,2]]
10;-[[4,2],[5,1]]
10;-[[3,1],[4,6]]
10;-[[3,1],[3,5]]
10;-[[3,1],[5,1]]
10;-[[2,6],[4,6]]
10;-[[2,6],[3,5]]
10;-[[2,6],[2,4]]
10;-[[1,5],[3,5]]
10;-[[1,5],[2,4]]
10;-[[1,5],[1,3]]
false.


 ?- x_domain( ( swf, 1 ), D, 6 ), indexed_profiles( I, D ), nl, write( I ), fail.

[[1,5],[2,6],[3,1],[4,2],[5,3],[6,4]]
[[5,1],[6,2],[1,3],[2,4],[3,5],[4,6]]
false.

?- x_domain( ( swf, 0 ), D, 6 ), indexed_profiles( I, D ), nl, write( I ), fail.

[[1,5],[2,6],[3,1],[4,2],[5,3],[6,4]]
[[5,1],[6,2],[1,3],[2,4],[3,5],[4,6]]
false.

 ?- x_domain( ( swf, 0 ), D, N ), length( D, N ), swf( F, D ), fig( swf, F ), write( [ N ] ), !, fail.

          123456
1:[a,c,b] --2-1-
2:[a,b,c] ---2-1
3:[b,a,c] 1-----
4:[b,c,a] -2----
5:[c,b,a] --3---
6:[c,a,b] -2----
--[8]
false.

 ?- x_domain( ( swf, 1 ), D, N ), length( D, N ), swf( F, D ), fig( swf, F ), write( [ N ] ), !, fail.

          123456
1:[a,c,b] ----1-
2:[a,b,c] -----2
3:[b,a,c] 3---3-
4:[b,c,a] -4---4
5:[c,b,a] 5-4---
6:[c,a,b] ------
--[8]
false.


*/


%-----------------------------------------------------------------
% a total test
%-----------------------------------------------------------------
:- dynamic( tmp_dict_domain /3 ).

find_minimal_length_dict_domain_swf( N ):-
	 between( 1, 12, N ),
	 \+ \+ tmp_dict_domain( swf( 0 ), _, N ),
	 !.

test_dict_domain_swf:-
	 abolish( tmp_dict_domain / 3 ),
	 fail.

test_dict_domain_swf:-
	 x_domain( ( swf, 1 ), D, N ),
	 ( \+ swf( _, D ) -> F = 0 ; F = 1 ),
	 assertz( tmp_dict_domain( swf( F ), D, N ) ),
	 fail.

test_dict_domain_swf:-
	 find_minimal_length_dict_domain_swf( N ),
	 nl,
	 write( 'minimal domain:' ),
	 tmp_dict_domain( swf( 0 ), D, N ),
	 indexed_profiles( I, D ),
	 nl,
	 write( N:I ),
	 fail.

test_dict_domain_swf:-
	 nl,
	 write( 'histogram:' ),
	 hist1n( tmp_dict_domain( swf( _ ), _, N ), all : N ),
	 hist1n( tmp_dict_domain( swf( 0 ), _, N ), dict : N ).

test_dict_domain_swf:-
	 nl,
	 write( 'save tmp_dict_swf/3 ? (y)' ),
	 read( y ),
	 save_dict_domain_swf.

save_dict_domain_swf:-
	 File = 'tmp_dict_domain_swf.pl',
	 Target = tmp_dict_domain( swf( _ ), _, _ ),
	 tell_goal( File, forall, Target ).

/*

 ?- test_dict_domain_swf.

minimal domain:
6:[[1,5],[2,6],[3,1],[4,2],[5,3],[6,4]]
6:[[5,1],[6,2],[1,3],[2,4],[3,5],[4,6]]
histogram:
 [all:6,2]
 [all:7,12]
 [all:8,48]
 [all:9,76]
 [all:10,48]
 [all:11,12]
 [all:12,1]
total:199
 [dict:6,2]
 [dict:7,12]
 [dict:8,36]
 [dict:9,40]
 [dict:10,36]
 [dict:11,12]
 [dict:12,1]
total:139
true ;

save tmp_dict_swf/3 ? (y)y.
complete
true .

?- count( ( tmp_dict_domain( swf( _ ), D, N ), \+ tmp_dict_domain( swf( 0 ), D, N ) ), H ).
H = 60.

?- N=8, tmp_dict_domain( swf( _ ), D, N ), \+ tmp_dict_domain( swf( 0 ), D, N ), indexed_profiles( I, D ), nl, write( I ), fail.

[[1,5],[2,6],[3,1],[4,2],[5,3],[5,1],[3,5],[4,6]]
[[1,5],[2,6],[3,1],[4,2],[6,4],[2,4],[3,5],[4,6]]
[[1,5],[2,6],[3,1],[5,3],[6,4],[1,3],[2,4],[3,5]]
[[1,5],[2,6],[3,1],[5,1],[1,3],[2,4],[3,5],[4,6]]
[[1,5],[2,6],[4,2],[5,3],[6,4],[6,2],[1,3],[2,4]]
[[1,5],[2,6],[6,4],[6,2],[1,3],[2,4],[3,5],[4,6]]
[[1,5],[3,1],[4,2],[5,3],[6,4],[5,1],[6,2],[1,3]]
[[1,5],[5,3],[6,4],[5,1],[6,2],[1,3],[2,4],[3,5]]
[[2,6],[3,1],[4,2],[5,3],[6,4],[5,1],[6,2],[4,6]]
[[2,6],[3,1],[4,2],[5,1],[6,2],[2,4],[3,5],[4,6]]
[[3,1],[4,2],[5,3],[5,1],[6,2],[1,3],[3,5],[4,6]]
[[4,2],[5,3],[6,4],[5,1],[6,2],[1,3],[2,4],[4,6]]
false.

?- N=8, tmp_dict_domain( swf( _ ), D, N ), \+ tmp_dict_domain( swf( 0 ), D, N ), m2( M2 ), subtract( D, M2, D1 ), indexed_profiles( I, D1 ), m1( M1 ), subtract( D, M1, D2 ), indexed_profiles( J, D2 ), nl, write( ( left:I + right:J ) ), fail.

left:[[1,5],[2,6],[3,1],[4,2],[5,3]]+right:[[5,1],[3,5],[4,6]]
left:[[1,5],[2,6],[3,1],[4,2],[6,4]]+right:[[2,4],[3,5],[4,6]]
left:[[1,5],[2,6],[3,1],[5,3],[6,4]]+right:[[1,3],[2,4],[3,5]]
left:[[1,5],[2,6],[3,1]]+right:[[5,1],[1,3],[2,4],[3,5],[4,6]]
left:[[1,5],[2,6],[4,2],[5,3],[6,4]]+right:[[6,2],[1,3],[2,4]]
left:[[1,5],[2,6],[6,4]]+right:[[6,2],[1,3],[2,4],[3,5],[4,6]]
left:[[1,5],[3,1],[4,2],[5,3],[6,4]]+right:[[5,1],[6,2],[1,3]]
left:[[1,5],[5,3],[6,4]]+right:[[5,1],[6,2],[1,3],[2,4],[3,5]]
left:[[2,6],[3,1],[4,2],[5,3],[6,4]]+right:[[5,1],[6,2],[4,6]]
left:[[2,6],[3,1],[4,2]]+right:[[5,1],[6,2],[2,4],[3,5],[4,6]]
left:[[3,1],[4,2],[5,3]]+right:[[5,1],[6,2],[1,3],[3,5],[4,6]]
left:[[4,2],[5,3],[6,4]]+right:[[5,1],[6,2],[1,3],[2,4],[4,6]]
false.

*/

show_bin_profiles( J ):-
%	 J = [[1,5],[2,6],[3,1],[4,2],[5,3]], 
	 indexed_profiles( J, D ),
	 write( ( 'indices of profiles':J ) ),
	 nth1( Jx, D, X ), 
	 nth1( Jx, J, Jxx ), 
	 Dom = [ [ a, b], [ b, c ], [ c, a ] ],
	 findall( B:S, ( 
		member( B, Dom ), 
		xy_profile_in_sign( S, B, X )
	 ), H ), 
	 nl, 
	 write( Jxx:X:H ), 
	 fail.
show_bin_profiles( _ ).

/*

?- show_profile_index( [[1,5],[2,6],[3,1],[4,2],[5,3]] ).
left:[[1,5],[2,6],[3,1],[4,2],[5,3]]
[1,5]:[[a,c,b],[c,b,a]]:[[a,b]:[+,-],[b,c]:[-,-],[c,a]:[-,+]]
[2,6]:[[a,b,c],[c,a,b]]:[[a,b]:[+,+],[b,c]:[+,-],[c,a]:[-,+]]
[3,1]:[[b,a,c],[a,c,b]]:[[a,b]:[-,+],[b,c]:[+,-],[c,a]:[-,-]]
[4,2]:[[b,c,a],[a,b,c]]:[[a,b]:[-,+],[b,c]:[+,+],[c,a]:[+,-]]
[5,3]:[[c,b,a],[b,a,c]]:[[a,b]:[-,-],[b,c]:[-,+],[c,a]:[+,-]]
true.

?- show_bin_profiles( [[5,1],[3,5],[4,6]] ).
indices of profiles:[[5,1],[3,5],[4,6]]
[5,1]:[[c,b,a],[a,c,b]]:[[a,b]:[-,+],[b,c]:[-,-],[c,a]:[+,-]]
[3,5]:[[b,a,c],[c,b,a]]:[[a,b]:[-,-],[b,c]:[+,-],[c,a]:[-,+]]
[4,6]:[[b,c,a],[c,a,b]]:[[a,b]:[-,+],[b,c]:[+,-],[c,a]:[+,+]]
true.

?- show_bin_profiles( [[6,4]] ).
indices of profiles:[[6,4]]
[6,4]:[[c,a,b],[b,c,a]]:[[a,b]:[+,-],[b,c]:[-,+],[c,a]:[+,+]]
true.

?- decisiveness_propagates_at( [6,4], P, B->C, J ).
P = [[c, a, b], [b, c, a]],
B = [a, b],
C = [c, b],
J = 1 ;
P = [[c, a, b], [b, c, a]],
B = [b, c],
C = [b, a],
J = 2 ;
false.

?- x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( A->B, [[a,b]->_ ] ), pp_in_sign( P,C, S ).X = a,
Y = b,
A = [a, b],
K = [5, 4],
P = [[c, a, b], [b, c, a]],
B = [c, b],
J = 1,
C = [[a, b], [b, c], [c, a]],
S = [[+, -], [-, +], [+, +]] .

?- 
?- hist1n(( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( A->B, [[a,b]->_ ] ), pp_in_sign( P,C, S ) ), S:P ).

 [[[+,-],[+,+],[-,+]]:[[a,b,c],[b,c,a]],1]
 [[[+,-],[-,+],[+,+]]:[[c,a,b],[b,c,a]],1]
 [[[-,+],[+,+],[+,-]]:[[b,c,a],[a,b,c]],1]
 [[[-,+],[+,-],[+,+]]:[[b,c,a],[c,a,b]],1]
total:4
true.

?- hist1n(( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( A->B, [[a,b]->_ ] ), pp_in_sign( P,C, S ), S=[Sab,Sbc,Sca] ), Sab:P ).

 [[+,-]:[[a,b,c],[b,c,a]],1]
 [[+,-]:[[c,a,b],[b,c,a]],1]
 [[-,+]:[[b,c,a],[a,b,c]],1]
 [[-,+]:[[b,c,a],[c,a,b]],1]
total:4
true.

?- hist1n( (setof( P, S^( pp(P), pp_in_sign( P, C, S ), nth1( J, S, Sx ), nth1( J, [ab,bc,ca], Y ) ), L ), indexed_profiles( X, L ) ), Y:Sx:X ).

 [ab:[+,+]:[[1,1],[1,2],[1,5],[2,1],[2,2],[2,5],[5,1],[5,2],[5,5]],1]
 [ab:[+,-]:[[1,3],[1,4],[1,6],[2,3],[2,4],[2,6],[5,3],[5,4],[5,6]],1]
 [ab:[-,+]:[[3,1],[3,2],[3,5],[4,1],[4,2],[4,5],[6,1],[6,2],[6,5]],1]
 [ab:[-,-]:[[3,3],[3,4],[3,6],[4,3],[4,4],[4,6],[6,3],[6,4],[6,6]],1]
 [bc:[+,+]:[[1,1],[1,3],[1,4],[3,1],[3,3],[3,4],[4,1],[4,3],[4,4]],1]
 [bc:[+,-]:[[1,2],[1,5],[1,6],[3,2],[3,5],[3,6],[4,2],[4,5],[4,6]],1]
 [bc:[-,+]:[[2,1],[2,3],[2,4],[5,1],[5,3],[5,4],[6,1],[6,3],[6,4]],1]
 [bc:[-,-]:[[2,2],[2,5],[2,6],[5,2],[5,5],[5,6],[6,2],[6,5],[6,6]],1]
 [ca:[+,+]:[[4,4],[4,5],[4,6],[5,4],[5,5],[5,6],[6,4],[6,5],[6,6]],1]
 [ca:[+,-]:[[4,1],[4,2],[4,3],[5,1],[5,2],[5,3],[6,1],[6,2],[6,3]],1]
 [ca:[-,+]:[[1,4],[1,5],[1,6],[2,4],[2,5],[2,6],[3,4],[3,5],[3,6]],1]
 [ca:[-,-]:[[1,1],[1,2],[1,3],[2,1],[2,2],[2,3],[3,1],[3,2],[3,3]],1]
total:12
true.

?- setof( P, S^( pp(P), pp_in_sign( P, C, S ), nth1( J, S, Sx ), nth1( J, [ab,bc,ca], Y ), Sx=[+,+] ), L ), fig( domain, L ), write(Y: Sx), fail.


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  2  -  -  3  -  
2:[a,c,b]  4  5  -  -  6  -  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  -  -  -  -  -  -  
5:[c,a,b]  7  8  -  -  9  -  
6:[c,b,a]  -  -  -  -  -  -  
--ab:[+,+]

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  -  2  3  -  -  
2:[a,c,b]  -  -  -  -  -  -  
3:[b,a,c]  4  -  5  6  -  -  
4:[b,c,a]  7  -  8  9  -  -  
5:[c,a,b]  -  -  -  -  -  -  
6:[c,b,a]  -  -  -  -  -  -  
--bc:[+,+]

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  -  -  
2:[a,c,b]  -  -  -  -  -  -  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  -  -  -  1  2  3  
5:[c,a,b]  -  -  -  4  5  6  
6:[c,b,a]  -  -  -  7  8  9  
--ca:[+,+]
false.

?- setof( P, S^( pp(P), pp_in_sign( P, C, S ), nth1( J, S, Sx ), nth1( J, [ab,bc,ca], Y ), Sx=[+,-] ), L ), fig( domain, L ), write(Y: Sx), fail.


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  1  2  -  3  
2:[a,c,b]  -  -  4  5  -  6  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  -  -  -  -  -  -  
5:[c,a,b]  -  -  7  8  -  9  
6:[c,b,a]  -  -  -  -  -  -  
--ab:[+,-]

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  1  -  -  2  3  
2:[a,c,b]  -  -  -  -  -  -  
3:[b,a,c]  -  4  -  -  5  6  
4:[b,c,a]  -  7  -  -  8  9  
5:[c,a,b]  -  -  -  -  -  -  
6:[c,b,a]  -  -  -  -  -  -  
--bc:[+,-]

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  -  -  
2:[a,c,b]  -  -  -  -  -  -  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  1  2  3  -  -  -  
5:[c,a,b]  4  5  6  -  -  -  
6:[c,b,a]  7  8  9  -  -  -  
--ca:[+,-]
false.

*/



%-----------------------------------------------------------------
% finding minimal strategy-proof nonimposed ( dictatorial ) domain
%-----------------------------------------------------------------
% 6-7 Jun 2019
% 18 Dec 2019 modified

left_super_arrovian_ring( M ):-
	 m1( M ).

right_super_arrovian_ring( M ):-
	 m2( M ).

union_of_super_arrovian_rings( M ):-
	 m( M ).

test_d_domain_0( D, N ):-
	 all_profiles( U0 ),
	 union_of_super_arrovian_rings( M ),
	 subtract( U0, M, U1 ),
	 append( U2, _, U1 ),
	 length( U2, N ),
%	 length( U1, K ),
%	 between( 1, K, N ),
%	 select_n( U2, U1, N ),
	 left_super_arrovian_ring( C ),
	 append( U2, C, D ).


find_dictatorial_scf_domain_0( N, O, D ):-
	 test_d_domain_0( D, N ),
	 \+ scf( _, D ),
	 findall( I, ( member( P, D ), pp( 2, I, P ) ), O ).


/*

?- find_dictatorial_scf_domain_0( N, D ).
D = [ [ [ a, c, b ], [ a, c, b ] ], [ [ a, c, b ], [ a, b, c ] ], [ [ a, c, b ], [ b, c, a ] ], [ [ a, c, b ], [ c, a, b ] ], [ [ a, b, c ], [ a, c | ... ] ], [ [ a, b | ... ], [ a | ... ] ], [ [ a | ... ], [ ... | ... ] ], [ [ ... | ... ] | ... ], [ ... | ... ] | ... ],
N = 23,

*/



%-----------------------------------------------------------------
% Utility: Finding multiple solutions
%-----------------------------------------------------------------
% 4-6 Jun & 18-19 Dec 2019

assert_clause_if_new( C ):-
	 \+ clause( C, _ ),
	 assert( C ).

seek_all_goal( G ):-
	 G,
	 fail
	 ;
	 true.


simple_count( Data, N ):-
	 findall( 1, clause( Data, _ ), L ),
	 length( L, N ).

simple_stat( Data ):-
	 simple_count( Data, N ),
	 nl,
	 Data =..[ Head | _ ],
	 write( N ),
	 atomic_list_concat( [ " \"", Head, "\"s " ], Y ),
	 write( Y ),
	 write( ' have been generated.' ).


find_and_memo_all( Find, Data ):-
	 Assert = assert_clause_if_new( Data ),
	 seek_all_goal( ( Find, Assert ) ),
	 simple_stat( Data ).

find_and_memo_nsol( N, Find, Data ):-
	 Assert = assert_clause_if_new( Data ),
	 Check = ( simple_count( Data, N ), ! ),
	 seek_all_goal( ( Find, Assert, Check ) ),
	 simple_stat( Data ).

:- dynamic( tmp_nsol / 1 ).

/*

?- find_and_memo_nsol( 10, between( 1, 100, X ), tmp_nsol( X ) ).

100 "tmp_nsol"s  have been generated.
true.

*/

%-----------------------------------------------------------------
% Finding possibility domains of SCF with a super Arrovian domain
% by removing a single profile from the outliers
%-----------------------------------------------------------------

test_scf_domain_0x( X, D ):-
	 all_profiles( U0 ),
	 union_of_super_arrovian_rings( M ),
	 subtract( U0, M, U1 ),
	 member( X, U1 ),
	 subtract( U1, [ X ], U2 ),
	 left_super_arrovian_ring( C ),
	 append( U2, C, D ).

find_scf_domain_0x( X, D, O ):-
	 test_scf_domain_0x( X, D ),
	 \+ \+ scf( _, D ),
	 findall( I, ( member( P, D ), pp( 2, I, P ) ), O ).


/*

?- find_scf_domain_0x( X, D, O ), pp( 2, I, X ), nl, write( X; I ), fail.

[[a,c,b],[c,a,b]];[1,6]
[[a,b,c],[c,b,a]];[2,5]
[[b,a,c],[a,b,c]];[3,2]
[[b,c,a],[a,c,b]];[4,1]
[[c,b,a],[b,c,a]];[5,4]
[[c,a,b],[b,a,c]];[6,3]
false.

% comparison: a super arrow domain: the six profiles

?- ppc( I, X ), nl, write( X; I ), fail.
[[a,c,b],[c,b,a]];[1,5]
[[a,b,c],[c,a,b]];[2,6]
[[b,a,c],[a,c,b]];[3,1]
[[b,c,a],[a,b,c]];[4,2]
[[c,b,a],[b,a,c]];[5,3]
[[c,a,b],[b,c,a]];[6,4]
false.


*/

% demo for finding nondictatorial domains
%-----------------------------------------------------------------

:- dynamic( tmp_scf_domain_0x / 3 ).

init_scf_domain_0x:-
	 abolish( tmp_scf_domain_0x / 3 ).

find_scf_domain_0x:-
	 Find = find_scf_domain_0x( X, D, O ),
	 Data = tmp_scf_domain_0x( X, D, O ),
	 find_and_memo_all( Find, Data ).

/*

?- find_scf_domain_0x.

6 "tmp_scf_domain_0x"s  have been generated.
true.


?- tmp_scf_domain_0x( X, D, _ ), pp( 2, I, X ), nl, write( X; I ), fail.

[[a,c,b],[c,a,b]];[1,6]
[[a,b,c],[c,b,a]];[2,5]
[[b,a,c],[a,b,c]];[3,2]
[[b,c,a],[a,c,b]];[4,1]
[[c,b,a],[b,c,a]];[5,4]
[[c,a,b],[b,a,c]];[6,3]
false.

?- ppc( I, X ), nl, write( X; I ), fail.
[[a,c,b],[c,b,a]];[1,5]
[[a,b,c],[c,a,b]];[2,6]
[[b,a,c],[a,c,b]];[3,1]
[[b,c,a],[a,b,c]];[4,2]
[[c,b,a],[b,a,c]];[5,3]
[[c,a,b],[b,c,a]];[6,4]
false.

*/


%-----------------------------------------------------------------
% Preference profile domains with a single minimal Arrow ring and k profiles remaining after delation of both Arrow rings.
%-----------------------------------------------------------------

k_profiles_out_of_the_super_arrovian( K, O, U ):-
	 all_profiles( U0 ),
	 union_of_super_arrovian_rings( M ),
	 subtract( U0, M, U1 ),
	 length( U1, N ),
	 between( 1, N, K ),
	 select_n( U, U1, K ),
	 findall( I, ( member( P, U ), pp( 2, I, P ) ), O ).

/*

?- k_profiles_out_of_the_super_arrovian( K, O, D ), ( \+ swf( _, D ) -> P=1 ; P = 0 ), ( \+ scf( _, D ) -> Q = 1 ; Q = 0 ), assertz( tmp_cross_possibility( K, O, D, P, Q ) ), fail.

?- between( 0, 24, K ), count( k_profiles_out_of_the_super_arrovian( K, O, U ), N ), nl, write( K; N ), fail.

0:0
1;24
2;276
3;2024
4;10626
5;42504
6;134596
7;346104
8;735471
9;1307504
10;1961256
11;2496144
12;2704156
13;2496144
...
23:24
24:1

*/


k_profiles_out_of_the_super_arrovian_nonimposed( K, O, D ):-
	 k_profiles_out_of_the_super_arrovian( K, O, D ),
	 \+ \+ (
		 f( F, D, scf_axiom ),
		 non_imposed( F )
	 ).

/*

?- k_profiles_out_of_the_super_arrovian_nonimposed( K, O, D ).

K = 3,
O = [ [ 1, 1 ], [ 1, 2 ], [ 2, 3 ] ],
D = [ [ [ a, c, b ], [ a, c, b ] ], [ [ a, c, b ], [ a, b, c ] ], [ [ a, b, c ], [ b, a, c ] ] ] .

?- between( 0, 24, K ), count( k_profiles_out_of_the_super_arrovian_nonimposed( K, O, U ), N ), nl, write( K; N ), fail.

0;0
1;0
2;0
3;1874
4;10398
5;42234



*/




%-----------------------------------------------------------------
% Finding dictatorial SCF domains
%-----------------------------------------------------------------
% added: 19 Dec 2019
% modified: 23 Dec 2019
% modified: 27 Dec 2019

% with a single super arrovian

find_dictatorial_scf_domain_1( K, O, U, D ):-
	 k_profiles_out_of_the_super_arrovian( K, O, U ),
	 left_super_arrovian_ring( C ),
	 append( U, C, D ),
%	 \+ \+ ( scf( F, D ), non_imposed( F ) ),
	 \+ scf( _, D ).


:- dynamic( tmp_dictatorial_scf_domain_1 / 4 ).

init_dictatorial_scf_domain_1:-
	 abolish( tmp_dictatorial_scf_domain_1 / 4 ).

find_dictatorial_scf_domain_1:-
	 Find = find_dictatorial_scf_domain_1( K, O, U, D ),
	 Data = tmp_dictatorial_scf_domain_1( K, O, U, D ),
	 find_and_memo_nsol( 3, Find, Data ).

/*

?- find_dictatorial_scf_domain_1.

% in a new thread, waiting for the first solution found.

?- G = tmp_dictatorial_scf_domain_1( A, B, C, D ), repeat, clause( G, _ ), shell( 'rundll32 user32.dll, MessageBeep' ), !, fail.


?- tmp_dictatorial_scf_domain_1( N, O, U, D ).

N = 6,
O = [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ] ],
U = [ [ [ a, c, b ], [ b, c, a ] ], [ [ a, c, b ], [ c, a, b ] ], [ [ b, a, c ], [ a, b, c ] ], [ [ b, a, c ], [ c, a, b ] ], [ [ c, b, a ], [ a, b | ... ] ], [ [ c, b | ... ], [ b | ... ] ] ],
D = [ [ [ a, c, b ], [ b, c, a ] ], [ [ a, c, b ], [ c, a, b ] ], [ [ b, a, c ], [ a, b, c ] ], [ [ b, a, c ], [ c, a, b ] ], [ [ c, b, a ], [ a, b | ... ] ], [ [ c, b | ... ], [ b | ... ] ], [ [ a | ... ], [ ... | ... ] ], [ [ ... | ... ] | ... ], [ ... | ... ] | ... ].

*/


% Swapping between Arrow rings

find_dictatorial_scf_domain_2( K, O, U, D ):-
	 k_profiles_out_of_the_super_arrovian( K, O, U ),
	 right_super_arrovian_ring( C ),
	 append( U, C, D ),
	 \+ scf( _, D ).


:- dynamic( tmp_dictatorial_scf_domain_2 / 4 ).

init_dictatorial_scf_domain_2:-
	 abolish( tmp_dictatorial_scf_domain_2 / 4 ).

find_dictatorial_scf_domain_2:-
	 Find = find_dictatorial_scf_domain_2( K, O, U, D ),
	 Data = tmp_dictatorial_scf_domain_2( K, O, U, D ),
	 find_and_memo_all( Find, Data ).



/*

?- find_dictatorial_scf_domain_2( N, O, D ).

?- tmp_dictatorial_scf_domain_2( A, B, _, _ ).
A = 6,
B = [ [ 2, 3 ], [ 2, 5 ], [ 4, 1 ], [ 4, 5 ], [ 6, 1 ], [ 6, 3 ] ].



*/

% versions

% without super arrovian

find_dictatorial_scf_domain_1( K, O, D ):-
	 k_profiles_out_of_the_super_arrovian( K, O, D ),
%	 \+ \+ ( scf( F, D ), non_imposed( F ) ),
	 \+ scf( _, D ).

% with full super arrovian

find_dictatorial_scf_domain_1b( K, O, U, D ):-
	 k_profiles_out_of_the_super_arrovian( K, O, U ),
	 union_of_super_arrovian_rings( C ),
	 append( U, C, D ),
%	 \+ \+ ( scf( F, D ), non_imposed( F ) ),
	 \+ scf( _, D ).


:- dynamic( tmp_dictatorial_scf_domain_1 / 3 ).
:- dynamic( tmp_dictatorial_scf_domain_1b / 4 ).

:- dynamic( tmp_dictatorial_scf_domain_1 / 4 ).

init_dictatorial_scf_domain_1( 3 ):-
	 abolish( tmp_dictatorial_scf_domain_1 / 3 ).

init_dictatorial_scf_domain_1b:-
	 abolish( tmp_dictatorial_scf_domain_1b / 4 ).

find_dictatorial_scf_domain_1( 3 ):-
	 Find = find_dictatorial_scf_domain_1( K, O, D ),
	 Data = tmp_dictatorial_scf_domain_1( K, O, D ),
%	 find_and_memo_all( Find, Data ).
	 find_and_memo_nsol( 3, Find, Data ).


find_dictatorial_scf_domain_1( b ):-
	 Find = find_dictatorial_scf_domain_1b( K, O, U, D ),
	 Data = tmp_dictatorial_scf_domain_1b( K, O, U, D ),
	 find_and_memo_nsol( 2, Find, Data ).



/*

?- tmp_dictatorial_scf_domain_1( N, O, U, D ).

N = 6,
O = [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ] ],
U = [ [ [ a, c, b ], [ b, c, a ] ], [ [ a, c, b ], [ c, a, b ] ], [ [ b, a, c ], [ a, b, c ] ], [ [ b, a, c ], [ c, a, b ] ], [ [ c, b, a ], [ a, b | ... ] ], [ [ c, b | ... ], [ b | ... ] ] ],
D = [ [ [ a, c, b ], [ b, c, a ] ], [ [ a, c, b ], [ c, a, b ] ], [ [ b, a, c ], [ a, b, c ] ], [ [ b, a, c ], [ c, a, b ] ], [ [ c, b, a ], [ a, b | ... ] ], [ [ c, b | ... ], [ b | ... ] ], [ [ a | ... ], [ ... | ... ] ], [ [ ... | ... ] | ... ], [ ... | ... ] | ... ] ;
N = 7,
O = [ [ 1, 4 ], [ 1, 6 ], [ 2, 1 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ] ],
U = [ [ [ a, c, b ], [ b, c, a ] ], [ [ a, c, b ], [ c, a, b ] ], [ [ a, b, c ], [ a, c, b ] ], [ [ b, a, c ], [ a, b, c ] ], [ [ b, a, c ], [ c, a | ... ] ], [ [ c, b | ... ], [ a | ... ] ], [ [ c | ... ], [ ... | ... ] ] ],
D = [ [ [ a, c, b ], [ b, c, a ] ], [ [ a, c, b ], [ c, a, b ] ], [ [ a, b, c ], [ a, c, b ] ], [ [ b, a, c ], [ a, b, c ] ], [ [ b, a, c ], [ c, a | ... ] ], [ [ c, b | ... ], [ a | ... ] ], [ [ c | ... ], [ ... | ... ] ], [ [ ... | ... ] | ... ], [ ... | ... ] | ... ].


?- F = tmp_dictatorial_scf_domain_1, G =.. [ F, N, O, U, D ], G, nl, write( ( N, O ) ), fail.

6, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ] ]
7, [ [ 1, 4 ], [ 1, 6 ], [ 2, 1 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ] ]
7, [ [ 1, 4 ], [ 1, 6 ], [ 2, 5 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ] ]
7, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 4, 1 ], [ 5, 2 ], [ 5, 4 ] ]
7, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 4, 3 ], [ 5, 2 ], [ 5, 4 ] ]
7, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ], [ 6, 3 ] ]
7, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ], [ 6, 5 ] ]
8, [ [ 1, 1 ], [ 1, 4 ], [ 1, 6 ], [ 2, 1 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 2, 1 ], [ 2, 2 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 2, 1 ], [ 2, 5 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 2, 1 ], [ 3, 2 ], [ 3, 6 ], [ 4, 1 ], [ 5, 2 ], [ 5, 4 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 2, 1 ], [ 3, 2 ], [ 3, 6 ], [ 4, 3 ], [ 5, 2 ], [ 5, 4 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 2, 1 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ], [ 6, 3 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 2, 1 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ], [ 6, 5 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 2, 5 ], [ 3, 2 ], [ 3, 6 ], [ 4, 1 ], [ 5, 2 ], [ 5, 4 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 2, 5 ], [ 3, 2 ], [ 3, 6 ], [ 4, 3 ], [ 5, 2 ], [ 5, 4 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 2, 5 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ], [ 6, 3 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 2, 5 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ], [ 6, 5 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 3 ], [ 3, 6 ], [ 4, 3 ], [ 5, 2 ], [ 5, 4 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 4, 1 ], [ 4, 3 ], [ 5, 2 ], [ 5, 4 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 4, 1 ], [ 5, 2 ], [ 5, 4 ], [ 6, 3 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 4, 1 ], [ 5, 2 ], [ 5, 4 ], [ 6, 5 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 4, 3 ], [ 4, 4 ], [ 5, 2 ], [ 5, 4 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 4, 3 ], [ 5, 2 ], [ 5, 4 ], [ 6, 3 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 4, 3 ], [ 5, 2 ], [ 5, 4 ], [ 6, 5 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ], [ 5, 5 ], [ 6, 5 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ], [ 6, 3 ], [ 6, 5 ] ]
8, [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ], [ 6, 5 ], [ 6, 6 ] ]
false.

?- F = tmp_dictatorial_scf_domain_1, G =.. [ F, 6, O, _, _ ], G, G1 =.. [ F, 7, O1, _, _ ], G1, subtract( O1, O, D ), nl, write( D ), fail.

[ [ 2, 1 ] ]
[ [ 2, 5 ] ]
[ [ 4, 1 ] ]
[ [ 4, 3 ] ]
[ [ 6, 3 ] ]
[ [ 6, 5 ] ]
false.

?- tmp_dictatorial_scf_domain_1( 7, _, _, D ), f( F, D, scf_axiom ), dictatorial_scf( J, F ), non_imposed( F ), write( J ), fail.
212121212121
false.

?- F = tmp_dictatorial_scf_domain_1, G =.. [ F, 6, O, _, _ ], G, G1 =.. [ F, 8, O1, _, _ ], G1, subtract( O1, O, D ), nl, write( D ), fail.

[ [ 1, 1 ], [ 2, 1 ] ]
[ [ 2, 1 ], [ 2, 2 ] ]
[ [ 2, 1 ], [ 2, 5 ] ]
[ [ 2, 1 ], [ 4, 1 ] ]
[ [ 2, 1 ], [ 4, 3 ] ]
[ [ 2, 1 ], [ 6, 3 ] ]
[ [ 2, 1 ], [ 6, 5 ] ]
[ [ 2, 5 ], [ 4, 1 ] ]
[ [ 2, 5 ], [ 4, 3 ] ]
[ [ 2, 5 ], [ 6, 3 ] ]
[ [ 2, 5 ], [ 6, 5 ] ]
[ [ 3, 3 ], [ 4, 3 ] ]
[ [ 4, 1 ], [ 4, 3 ] ]
[ [ 4, 1 ], [ 6, 3 ] ]
[ [ 4, 1 ], [ 6, 5 ] ]
[ [ 4, 3 ], [ 4, 4 ] ]
[ [ 4, 3 ], [ 6, 3 ] ]
[ [ 4, 3 ], [ 6, 5 ] ]
[ [ 5, 5 ], [ 6, 5 ] ]
[ [ 6, 3 ], [ 6, 5 ] ]
[ [ 6, 5 ], [ 6, 6 ] ]
false.

?- F = tmp_dictatorial_scf_domain_1, G1 =.. [ F, 8, O1, _, _ ], simple_count( G1, N ).

F = tmp_dictatorial_scf_domain_1,
G1 = tmp_dictatorial_scf_domain_1( 8, O1, _3138, _3144 ),
N = 21.

?- F = tmp_dictatorial_scf_domain_1, atom_concat( F, '.pl', File ), tell( File ), G =.. [ F, N, O, U, D ], G, nl, write( G ), write( '.' ), fail ; told.
true.


?- tmp_dictatorial_scf_domain_1( N, _, _, D ), !, f( F, D, scf_axiom ),  non_imposed( F ), hr( 30 ), fig( scf, F ), fail.

------------------------------
          123456
1:[ a, c, b ] ---bcc
2:[ a, b, c ] -----c
3:[ b, a, c ] aa---c
4:[ b, c, a ] -a----
5:[ c, b, a ] -abb--
6:[ c, a, b ] ---b--
--
------------------------------
          123456
1:[ a, c, b ] ---aaa
2:[ a, b, c ] -----a
3:[ b, a, c ] bb---b
4:[ b, c, a ] -b----
5:[ c, b, a ] -ccc--
6:[ c, a, b ] ---c--
--
false.

% the super Arrovian ring is not neccessary.

?- tmp_dictatorial_scf_domain_1( N, _, D, _ ), !, nl, write( [ additional:N-profiles ] ), f( F, D, scf_axiom ), non_imposed( F ), hr( 30 ), fig( scf, F ), fail.

[ additional:6-profiles ]
------------------------------
          123456
1:[ a, c, b ] ---b-c
2:[ a, b, c ] ------
3:[ b, a, c ] -a---c
4:[ b, c, a ] ------
5:[ c, b, a ] -a-b--
6:[ c, a, b ] ------
--
------------------------------
          123456
1:[ a, c, b ] ---a-a
2:[ a, b, c ] ------
3:[ b, a, c ] -b---b
4:[ b, c, a ] ------
5:[ c, b, a ] -c-c--
6:[ c, a, b ] ------
--
false.

?- tmp_dictatorial_scf_domain_1( N, _, _, D ), f( F, D, scf_axiom ), non_imposed( F ), !, hr( 30 ), scf_xy( F, B, Y ), nl, write( B:Y ), fail.

------------------------------
[ a, a ]:[ [ *, * ]-a ]
[ a, b ]:[ [ a, b ]-b, [ b, a ]-a, [ b, b ]-b ]
[ a, c ]:[ [ a, a ]-a, [ a, c ]-c, [ c, a ]-a ]
[ b, a ]:[ [ a, b ]-b, [ b, a ]-a, [ b, b ]-b ]
[ b, b ]:[ [ *, * ]-b ]
[ b, c ]:[ [ b, c ]-c, [ c, b ]-b, [ c, c ]-c ]
[ c, a ]:[ [ a, a ]-a, [ a, c ]-c, [ c, a ]-a ]
[ c, b ]:[ [ b, c ]-c, [ c, b ]-b, [ c, c ]-c ]
[ c, c ]:[ [ *, * ]-c ]
------------------------------
[ a, a ]:[ [ *, * ]-a ]
[ a, b ]:[ [ a, a ]-a, [ a, b ]-a, [ b, a ]-b ]
[ a, c ]:[ [ a, c ]-a, [ c, a ]-c, [ c, c ]-c ]
[ b, a ]:[ [ a, a ]-a, [ a, b ]-a, [ b, a ]-b ]
[ b, b ]:[ [ *, * ]-b ]
[ b, c ]:[ [ b, b ]-b, [ b, c ]-b, [ c, b ]-c ]
[ c, a ]:[ [ a, c ]-a, [ c, a ]-c, [ c, c ]-c ]
[ c, b ]:[ [ b, b ]-b, [ b, c ]-b, [ c, b ]-c ]
[ c, c ]:[ [ *, * ]-c ]
false.


?- tmp_dictatorial_scf_domain_1( N, _, D, _ ), !, f( F, D, scf_axiom ), non_imposed( F ), hr( 30 ), scf_xy( F, B, Y ), nl, write( B:Y ), fail.

------------------------------
[ a, a ]:[ [ *, * ]-a ]
[ a, b ]:[ [ a, b ]-b, [ b, a ]-a, [ b, b ]-b ]
[ a, c ]:[ [ a, a ]-a, [ a, c ]-c, [ c, a ]-a ]
[ b, a ]:[ [ a, b ]-b, [ b, a ]-a, [ b, b ]-b ]
[ b, b ]:[ [ *, * ]-b ]
[ b, c ]:[ [ b, c ]-c, [ c, b ]-b, [ c, c ]-c ]
[ c, a ]:[ [ a, a ]-a, [ a, c ]-c, [ c, a ]-a ]
[ c, b ]:[ [ b, c ]-c, [ c, b ]-b, [ c, c ]-c ]
[ c, c ]:[ [ *, * ]-c ]
------------------------------
[ a, a ]:[ [ *, * ]-a ]
[ a, b ]:[ [ a, a ]-a, [ a, b ]-a, [ b, a ]-b ]
[ a, c ]:[ [ a, c ]-a, [ c, a ]-c, [ c, c ]-c ]
[ b, a ]:[ [ a, a ]-a, [ a, b ]-a, [ b, a ]-b ]
[ b, b ]:[ [ *, * ]-b ]
[ b, c ]:[ [ b, b ]-b, [ b, c ]-b, [ c, b ]-c ]
[ c, a ]:[ [ a, c ]-a, [ c, a ]-c, [ c, c ]-c ]
[ c, b ]:[ [ b, b ]-b, [ b, c ]-b, [ c, b ]-c ]
[ c, c ]:[ [ *, * ]-c ]
false.




*/



/*


?- tmp_dictatorial_scf_domain_1( K, O, U, D ),  scf_dict( A, B ), indexed_profiles( B, D1 ), m1( D2 ), union( D1, D2, Dx ), D == Dx.

K = 6,
O = B, B = [ [ 1, 4 ], [ 1, 6 ], [ 3, 2 ], [ 3, 6 ], [ 5, 2 ], [ 5, 4 ] ],
U = D1, D1 = [ [ [ a, c, b ], [ b, c, a ] ], [ [ a, c, b ], [ c, a, b ] ], [ [ b, a, c ], [ a, b, c ] ], [ [ b, a, c ], [ c, a, b ] ], [ [ c, b, a ], [ a, b | ... ] ], [ [ c, b | ... ], [ b | ... ] ] ],
D = Dx, Dx = [ [ [ a, c, b ], [ b, c, a ] ], [ [ a, c, b ], [ c, a, b ] ], [ [ b, a, c ], [ a, b, c ] ], [ [ b, a, c ], [ c, a, b ] ], [ [ c, b, a ], [ a, b | ... ] ], [ [ c, b | ... ], [ b | ... ] ], [ [ a | ... ], [ ... | ... ] ], [ [ ... | ... ] | ... ], [ ... | ... ] | ... ],
A = ring_1,
D2 = [ [ [ a, c, b ], [ c, b, a ] ], [ [ a, b, c ], [ c, a, b ] ], [ [ b, a, c ], [ a, c, b ] ], [ [ b, c, a ], [ a, b, c ] ], [ [ c, b, a ], [ b, a | ... ] ], [ [ c, a | ... ], [ b | ... ] ] ] .


?- tmp_dictatorial_scf_domain_1( K, O, U, D ),  scf_dict( A, B ), indexed_profiles( B, D1 ), m1( D2 ), union( D1, D2, Dx ), D == Dx, scf( F, Dx ).
false.

?- tmp_dictatorial_scf_domain_1( K, O, U, D ),  scf_dict( A, B ), indexed_profiles( B, D1 ), m2( D2 ), union( D1, D2, Dx ), D == Dx, scf( F, Dx ).
false.


*/




%-----------------------------------------------------------------
% rule induction for scfs using the five profile classes
% m1, m2, s1, s2, and o
%-----------------------------------------------------------------
% 21 Dec 2019
% modified: 27 Dec 2019 (use s1/1 and s2/1 )

prj_x_domain( P, D ):-
	 all_profiles( O ),
	 m1( M1 ),
	 m2( M2 ),
	 s1( S1 ),
	 s2( S2 ),
	 m( M ),
	 subtract( O, M, O1 ),
	 subtract( O1, S1, O2 ),
	 subtract( O2, S2, O3 ),
	 list_projection( P, [ M1, M2, S1, S2, O3 ], G ),
	 findall( X, ( member( Y, G ), member( X, Y ) ), D0 ),
	 sort( D0, D ).

/*

 ?- prj_x_domain( P, D ), \+ swf( F, D ), nl, write( P ), fail.

[0,1,0,0,0]
[0,1,0,0,1]
[0,1,0,1,0]
[0,1,0,1,1]
[0,1,1,0,0]
[0,1,1,0,1]
[0,1,1,1,0]
[0,1,1,1,1]
[1,0,0,0,0]
[1,0,0,0,1]
[1,0,0,1,0]
[1,0,0,1,1]
[1,0,1,0,0]
[1,0,1,0,1]
[1,0,1,1,0]
[1,0,1,1,1]
[1,1,0,0,0]
[1,1,0,0,1]
[1,1,0,1,0]
[1,1,0,1,1]
[1,1,1,0,0]
[1,1,1,0,1]
[1,1,1,1,0]
[1,1,1,1,1]
false.


?- setof( [P3,P4,Q], D^( prj_x_domain( [P1,P2,P3,P4,Q], D ), \+ swf( F, D ) ), L ), nl, write( P1- P2 - L  ), fail.

0-1-[[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]]
1-0-[[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]]
1-1-[[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]]
false.

 ?- setof( [P3,P4,Q], D^( prj_x_domain( [P1,P2,P3,P4,Q], D ), \+ \+ swf( F, D ) ), L ), nl, write( P1- P2 - L  ), fail.

0-0-[[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]]
false.


 ?- setof( [P3,P4,Q], D^( prj_x_domain( [P1,P2,P3,P4,Q], D ), \+ scf( F, D ) ), L ), nl, write( P1- P2 - L  ), fail.

0-0-[[0,0,0],[0,1,0],[1,0,0]]
0-1-[[0,1,0],[0,1,1],[1,1,1]]
1-0-[[1,0,0],[1,0,1],[1,1,1]]
1-1-[[0,1,1],[1,0,1],[1,1,1]]
false.


 ?- setof( [P3,P4,Q], D^( prj_x_domain( [P1,P2,P3,P4,Q], D ), \+ \+ scf( F, D ) ), L ), nl, write( P1- P2 - L  ), fail.

0-0-[[0,0,1],[0,1,1],[1,0,1],[1,1,0],[1,1,1]]
0-1-[[0,0,0],[0,0,1],[1,0,0],[1,0,1],[1,1,0]]
1-0-[[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,1,0]]
1-1-[[0,0,0],[0,0,1],[0,1,0],[1,0,0],[1,1,0]]
false.

?- setof( [P3,P4], D^( prj_x_domain( [P1,P2,P3,P4,Q], D ), \+ scf( F, D ) ), L ), nl, write( P1- P2 - Q - L  ), fail.

0-0-0-[[0,0],[0,1],[1,0]]
0-1-0-[[0,1]]
0-1-1-[[0,1],[1,1]]
1-0-0-[[1,0]]
1-0-1-[[1,0],[1,1]]
1-1-1-[[0,1],[1,0],[1,1]]
false.

 ?- setof( [P3,P4], D^( prj_x_domain( [P1,P2,P3,P4,Q], D ), \+ scf( _, D ),  \+ \+ ( f( F, D, scf_axiom ), non_imposed( F ), dictatorial_scf( _, F ) ) ), L ), nl, write( P1- P2 - Q - L  ), fail.

0-0-0-[[0,1],[1,0]]
0-1-0-[[0,1]]
0-1-1-[[0,1],[1,1]]
1-0-0-[[1,0]]
1-0-1-[[1,0],[1,1]]
1-1-1-[[0,1],[1,0],[1,1]]
false.


 ?- setof( F1, F^P^D^( prj_x_domain( P, D ), \+ scf( F, D ), list_projection( P, [ m1, m2, s1, s2, o ], F  ), member( M, F ), subtract( F, [ M ], F1 )  ), L ), nl, write( M :L  ), fail.

m1:[[m2,s1,o],[m2,s1,s2,o],[m2,s2,o],[s1],[s1,o],[s1,s2,o]]
m2:[[m1,s1,o],[m1,s1,s2,o],[m1,s2,o],[s1,s2,o],[s2],[s2,o]]
o:[[m1,m2,s1],[m1,m2,s1,s2],[m1,m2,s2],[m1,s1],[m1,s1,s2],[m2,s1,s2],[m2,s2]]
s1:[[],[m1],[m1,m2,o],[m1,m2,s2,o],[m1,o],[m1,s2,o],[m2,s2,o]]
s2:[[],[m1,m2,o],[m1,m2,s1,o],[m1,s1,o],[m2],[m2,o],[m2,s1,o]]
false.


 ?- setof( F1, F^P^D^( prj_x_domain( P, D ), \+ \+ scf( F, D ), list_projection( P, [ m1, m2, s1, s2, o ], F  ), member( M, F ), subtract( F, [ M ], F1 )  ), L ), nl, write( M :L  ), fail.

m1:[[],[m2],[m2,o],[m2,s1],[m2,s1,s2],[m2,s2],[o],[s1,s2],[s2],[s2,o]]
m2:[[],[m1],[m1,o],[m1,s1],[m1,s1,s2],[m1,s2],[o],[s1],[s1,o],[s1,s2]]
o:[[],[m1],[m1,m2],[m1,s2],[m2],[m2,s1],[s1],[s1,s2],[s2]]
s1:[[m1,m2],[m1,m2,s2],[m1,s2],[m2],[m2,o],[m2,s2],[o],[s2],[s2,o]]
s2:[[m1],[m1,m2],[m1,m2,s1],[m1,o],[m1,s1],[m2,s1],[o],[s1],[s1,o]]
false.

% on-outlier possibility results.

?- prj_x_domain( [M1,M2,S1,S2,1], D ), \+ \+ scf( _, D ), nl, write( [ M1, M2, S1, S2 ]  ), fail.

[0,0,0,0]
[0,0,0,1]
[0,0,1,0]
[0,0,1,1]
[0,1,0,0]
[0,1,1,0]
[1,0,0,0]
[1,0,0,1]
[1,1,0,0]
false.

% off-outlier possibility results.

?- prj_x_domain( [M1,M2,S1,S2,0], D ), \+ \+ scf( _, D ), nl, write( [ M1, M2, S1, S2 ]  ), fail.

[0,0,1,1]
[0,1,0,0]
[0,1,1,0]
[0,1,1,1]
[1,0,0,0]
[1,0,0,1]
[1,0,1,1]
[1,1,0,0]
[1,1,0,1]
[1,1,1,0]
[1,1,1,1]
false.


 ?- bagof( [ M1, M2, O ], D^( prj_x_domain( [M1,M2,S1,S2,O], D ), ( \+ scf( _, D ) -> F = 0 ; F = 1 ) ), L ), nl, write( [ S1, S2 ] ; F ; L ), fail.

[0,0];0;[[0,0,0]]
[0,0];1;[[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]]
[0,1];0;[[0,0,0],[0,1,0],[0,1,1],[1,1,1]]
[0,1];1;[[0,0,1],[1,0,0],[1,0,1],[1,1,0]]
[1,0];0;[[0,0,0],[1,0,0],[1,0,1],[1,1,1]]
[1,0];1;[[0,0,1],[0,1,0],[0,1,1],[1,1,0]]
[1,1];0;[[0,1,1],[1,0,1],[1,1,1]]
[1,1];1;[[0,0,0],[0,0,1],[0,1,0],[1,0,0],[1,1,0]]
false.

% 4 Aug 2024
?- chpers([1,2]), chalt([a,b,c]).
true.

?- bagof( s(S1,S2), D^( prj_x_domain( [M1,M2,S1,S2,1], D ), \+ \+ scf( _, D ) ), L ), nl, write( m(M1,M2)->L ), fail.

m(0,0)->[s(0,0),s(0,1),s(1,0),s(1,1)]
m(0,1)->[s(0,0),s(1,0)]
m(1,0)->[s(0,0),s(0,1)]
m(1,1)->[s(0,0)]
false.

?- bagof( s(S1,S2), D^( prj_x_domain( [M1,M2,S1,S2,0], D ), \+ \+ scf( _, D ) ), L ), nl, write( m(M1,M2)->L ), fail.

m(0,0)->[s(1,1)]
m(0,1)->[s(0,0),s(1,0),s(1,1)]
m(1,0)->[s(0,0),s(0,1),s(1,1)]
m(1,1)->[s(0,0),s(0,1),s(1,0),s(1,1)]
false.

?- bagof( o(O):s(S1,S2), D^( prj_x_domain( [M1,M2,S1,S2,O], D ), \+ scf( _, D ) ), L ), nl, write( m(M1,M2)->L ), fail.

m(0,0)->[o(0):s(0,0),o(0):s(0,1),o(0):s(1,0)]
m(0,1)->[o(0):s(0,1),o(1):s(0,1),o(1):s(1,1)]
m(1,0)->[o(0):s(1,0),o(1):s(1,0),o(1):s(1,1)]
m(1,1)->[o(1):s(0,1),o(1):s(1,0),o(1):s(1,1)]
false.


% on-outlier dictatorial results

?- prj_x_domain( [M1,M2,S1,S2,1], D ), \+ scf( _, D ), nl, write( [ M1, M2, S1, S2 ]  ), fail.

[0,1,0,1]
[0,1,1,1]
[1,0,1,0]
[1,0,1,1]
[1,1,0,1]
[1,1,1,0]
[1,1,1,1]
false.

% off-outlier dictatorial results

?- prj_x_domain( [M1,M2,S1,S2,0], D ), \+ scf( _, D ), nl, write( [ M1, M2, S1, S2 ]  ), fail.

[0,0,0,0]
[0,0,0,1]
[0,0,1,0]
[0,1,0,1]
[1,0,1,0]
false.

 ?- tell('prj_x_domain.csv'),  prj_x_domain( [M1,M2,S1,S2,O], D ), ( \+ scf( _, D ) -> F = 0 ; F = 1 ), nl, write( prj_x_domain(s, F, M1, M2, S1, S2, O, e) ), fail ; told.
true.

*/

%-----------------------------------------------------------------
% another rule induction for scfs
%-----------------------------------------------------------------
% 21 Dec 2019

:- dynamic( tmp_scf_prj /2 ).

gen_scf_prj:-
	 prj_x_domain( P, D ),
	 ( \+ scf( _, D ) -> F = 0 ; F = 1 ),
	 assertz( tmp_scf_prj( F, P ) ),
	 fail
	 ;
	 true.


scf_prj_rule_induction( F, X ):-
	 X = [ M1, M2, S1, S2, O ],
	 member( M1, [ M1, 0, 1 ] ),
	 member( M2, [ M2, 0, 1 ] ),
	 member( S1, [ S1, 0, 1 ] ),
	 member( S2, [ S2, 0, 1 ] ),
	 member( O, [ O, 0, 1 ] ),
	 member( F, [ 0, 1 ] ),
	 \+ (
		 tmp_scf_prj( F1, [ M1, M2, S1, S2, O ] ),
		 F1 \= F
	 ).

indecies_of_vars_in_list( Y, Z ):-
	 findall( J, ( nth1( J, Y, I ), var( I ) ), Z ).

/*
larger_unifiable_term_within( X, H, Y ):-
	 member( Y, H ), Y == Y0,
	 \+ ( nth1( J, X, I ), \+ var( I ), \+ nth1( J, Y, I ) ),
	 \+ \+ ( nth1( J, X, I ), \+ var( I ), nth1( J, Y, U ), var( U ) ).

*/

larger_unifiable_term_within( X, H, [ Y, Z1 ] ):-
	 indecies_of_vars_in_list( X, Z ),
	 member( Y, H ),
	 \+ ( X \= Y ),
	 indecies_of_vars_in_list( Y, Z1 ),
	 Z \= Z1,
	 subset( Z, Z1 ).


maximal_scf_prj_rule_induction( F, X ):-
	 member( F, [ 0, 1 ] ),
	 findall( X, scf_prj_rule_induction( F, X ), H ),
	 member( X, H ),
	 \+ larger_unifiable_term_within( X, H, _ ).

replace_vars_in_list_as_symbols( X, Y ):-
	 L = [ m1, m2, s1, s2, o ],
	 findall( Z, (
		 nth1( J, X, A ),
		 nth1( J, L, B ),
		 ( var( A ) -> atom_concat( '_', B, Z ) ; Z = A )

	 ), Y ).

maximal_scf_prj_rule_induction( F ):-
	 member( F, [ 0, 1 ] ),
	 !,
	 maximal_scf_prj_rule_induction( F, X ),
	 replace_vars_in_list_as_symbols( X, Y ),
	 nl,
	 write( scf = F : Y ),
	 fail
	 ;
	 true.


/*

 ?- maximal_scf_prj_rule_induction( 1 ).

scf=1:[_m1,_m2,0,0,1]
scf=1:[_m1,_m2,1,1,0]
scf=1:[_m1,0,0,_s2,1]
scf=1:[_m1,1,_s1,0,0]
scf=1:[_m1,1,0,0,_o]
scf=1:[_m1,1,1,_s2,0]
scf=1:[0,_m2,_s1,0,1]
scf=1:[0,0,_s1,_s2,1]
scf=1:[0,0,1,1,_o]
scf=1:[0,1,_s1,0,_o]
scf=1:[1,_m2,_s1,1,0]
scf=1:[1,_m2,0,_s2,0]
scf=1:[1,_m2,0,0,_o]
scf=1:[1,0,0,_s2,_o]
scf=1:[1,1,_s1,_s2,0]
false.


?- maximal_scf_prj_rule_induction( 0 ).

scf=0:[_m1,0,1,0,0]
scf=0:[_m1,1,_s1,1,1]
scf=0:[0,_m2,0,1,0]
scf=0:[0,0,_s1,0,0]
scf=0:[0,0,0,_s2,0]
scf=0:[0,1,0,1,_o]
scf=0:[1,_m2,1,_s2,1]
scf=0:[1,0,1,0,_o]
false.


 ?- maximal_scf_prj_rule_induction( 0, [ M1, M2, S1, S2, O ] ),  \+ ( prj_x_domain( [ M1, M2, S1, S2, O ], D ), \+ scf( F, D ) ).
false.

 ?-  prj_x_domain( [ M1, M2, S1, S2, O ], D ), \+ scf( F, D ),  \+ maximal_scf_prj_rule_induction( 0, [ M1, M2, S1, S2, O ] ).


*/





%-----------------------------------------------------------------
% Visualizing decisiveness propagation in the super Arrovian domain
%-----------------------------------------------------------------
% 22-23, 25, 28 Dec 2019
% modified: 15 Dec 2024 ( almost same of  pp_in_sign today)

profile_as_sign_pattern( K, X, Y ):-
	 pp( K, X ),
%	 L = [ [ a, b ], [ b, c ], [ c, a ] ],
	 alternatives( [ A, B, C ] ),
	 L = [ [ A, B ], [ B, C ], [ C, A ] ],
	 findall( Pair: S, (
		 member( Pair, L ),
		 xy_profile_in_sign( S, Pair, X ) 
	 ), Y ).

profile_as_sign_pattern( I, K, X, Y ):-
	 pp( K, X ),
%	 L = [ [ a, b ], [ b, c ], [ c, a ] ],
	 alternatives( [ A, B, C ] ),
	 L = [ [ A, B ], [ B, C ], [ C, A ] ],
	 findall( S, ( 
	 	 member( Pair, L ), 
		 xy_profile_in_sign( H, Pair, X ), 
		 nth1( I, H, S ) 
	 ), Y ).

/*

?- profile_as_sign_pattern( K, X, C ).
K = [1, 1],
X = [[a, c, b], [a, c, b]],
C = [[a, b]:[+, +], [b, c]:[-, -], [c, a]:[-, -]] ;
K = [1, 2],
X = [[a, c, b], [a, b, c]],
C = [[a, b]:[+, +], [b, c]:[-, +], [c, a]:[-, -] ].


?- m1( A ), nth1( J, A, X ), profile_as_sign_pattern( K, X, C ), nl, write( J : C ), fail.

1:[[a,b]:[+,-],[b,c]:[-,-],[c,a]:[-,+]]
2:[[a,b]:[+,+],[b,c]:[+,-],[c,a]:[-,+]]
3:[[a,b]:[-,+],[b,c]:[+,-],[c,a]:[-,-]]
4:[[a,b]:[-,+],[b,c]:[+,+],[c,a]:[+,-]]
5:[[a,b]:[-,-],[b,c]:[-,+],[c,a]:[+,-]]
6:[[a,b]:[+,-],[b,c]:[-,+],[c,a]:[+,+]]
false.

?- m1( A ), nth1( J, A, X ), nl, write( X ), between( 1, 2, I ), tab( 1 ), profile_as_sign_pattern( I, K, X, C ), write( J : C ), fail.

[[a,c,b],[c,b,a]] 1:[+,-,-] 1:[-,-,+]
[[a,b,c],[c,a,b]] 2:[+,+,-] 2:[+,-,+]
[[b,a,c],[a,c,b]] 3:[-,+,-] 3:[+,-,-]
[[b,c,a],[a,b,c]] 4:[-,+,+] 4:[+,+,-]
[[c,b,a],[b,a,c]] 5:[-,-,+] 5:[-,+,-]
[[c,a,b],[b,c,a]] 6:[+,-,+] 6:[-,+,+]
false.


% note. decisiveness vertically propagetes between singular signs.


?- pp(P), f( F, [P], swf_axiom), fig(swf, F ), F=[P-X], profile_as_sign_pattern( K, [X|P], C ).


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  -  -  -  -  -  
2:[a,c,b]  -  -  -  -  -  -  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  -  -  -  -  -  -  
5:[c,a,b]  -  -  -  -  -  -  
6:[c,b,a]  -  -  -  -  -  -  
--
P = [[a, b, c], [a, b, c]],
F = [[[a, b, c], [a, b, c]]-[a, b, c]],
X = [a, b, c],
K = 3,
C = [[a, b]:[+, +, +], [b, c]:[+, +, +], [c, a]:[-, -, -]] .

?- 


*/


/*


?- pp( K, P ), xy_profile( S, [ X, Y ], P ), nth1( J, P, Q ), p( [ Z, X ], Q ).
K = [1, 1],
P = [[a, c, b], [a, c, b]],
S = [c, c],
X = c,
Y = b,
J = 1,
Q = [a, c, b],
Z = a .

?- pp( K, P ), agree( S, [ X, Y ], P ).
K = [1, 1],
P = [[a, c, b], [a, c, b]],
S =  (+),
X = a,
Y = c .


*/

/*

agree_except_for_an_agent( [ X, Y ], P, J ):-
	 nth1( J, P, Q ),
	 p( [ X, Y ], Q ),
	 \+ (
		 nth1( I, P, R ),
		 I \= J,
		 p( [ X, Y ], R )
	 ).

*/

% modifed: 9 Nov 2025

agree_except_for_an_agent( [ X, Y ], P, J ):-
	 nth1( J, P, Q ),
	 p( [ X, Y ], Q ),
	 \+ (
		 nth1( I, P, R ),
		 I \= J,
		 p( [ X, Y ], R )
	 ).

decisiveness_propagates_at( K, P, [ Y, Z ] -> [ X, Z ], J ):-
	 ppc( K, P ),  % 6 Nov 2025
	 agree( +, [ X, Y ], P ),
%	 \+ agree( _, [ Y, Z ], P ),
% コメントアウトするとA->BのAまたはBを後付け指定したとき次のルールのみ成功する
	 agree_except_for_an_agent( [ X, Z ], P, J ),
	 agree_except_for_an_agent( [ Y, Z ], P, J ). %, writeln(rule(1)).


decisiveness_propagates_at( K, P, [ Z, X ] -> [ Z, Y ], J ):-
	 ppc( K, P ),
	 agree( +, [ X, Y ], P ),
%	 \+ agree( _, [ Z, X ], P ),
	 agree_except_for_an_agent( [ Z, Y ], P, J ),
	 agree_except_for_an_agent( [ Z, X ], P, J ).%, writeln(rule(2)).

% added: 19 Nov 2025

decisiveness_propagates_at_full( K, P, A -> B, J ):-
	x( X ),
	x( Y ),
	Y \= X,
	A = [ X, Y ],
	decisiveness_propagates_at( K, P, A -> B, J ).

% 30 Nov 2025
/*

?- x( Z ), between( 1, 2, J ), member( G, [ [ Z, X ] -> [ Y, X ], [ X, Y ]->[ X, Z] ] ), findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), G=( A->B) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ),  swf( F, D ), nl, indexed_profiles( IX, H ), write( J-Z-N:IX ), fail.

1-a-34:[[5,4],[3,6]]
1-a-34:[[6,3],[4,5]]
2-a-34:[[6,3],[4,5]]
2-a-34:[[5,4],[3,6]]
1-b-34:[[6,2],[1,5]]
1-b-34:[[5,1],[2,6]]
2-b-34:[[5,1],[2,6]]
2-b-34:[[6,2],[1,5]]
1-c-34:[[4,1],[2,3]]
1-c-34:[[3,2],[1,4]]
2-c-34:[[3,2],[1,4]]
2-c-34:[[4,1],[2,3]]
false.

?- x( X ), x( Y ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [Y, X ] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ),  swf( F, D ), nl, indexed_profiles( IX, H ), write( J-Y-N:IX ), fail.

1-b-34:[[4,1],[1,4]]
2-b-34:[[1,4],[4,1]]
1-c-34:[[6,2],[2,6]]
2-c-34:[[2,6],[6,2]]
1-a-34:[[2,3],[3,2]]
2-a-34:[[3,2],[2,3]]
1-c-34:[[5,4],[4,5]]
2-c-34:[[4,5],[5,4]]
1-a-34:[[1,5],[5,1]]
2-a-34:[[5,1],[1,5]]
1-b-34:[[3,6],[6,3]]
2-b-34:[[6,3],[3,6]]
false.


?-  time( ( p( [X,Y,Z|_] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), swf(F, D),  indexed_profiles(IX,H), nl, write(J-X-Y-Z:N:IX), fail; true ) ).

1-a-b-c:34:[[4,1],[1,4]]
2-a-b-c:34:[[1,4],[4,1]]
1-a-c-b:34:[[6,2],[2,6]]
2-a-c-b:34:[[2,6],[6,2]]
1-b-a-c:34:[[2,3],[3,2]]
2-b-a-c:34:[[3,2],[2,3]]
1-c-a-b:34:[[1,5],[5,1]]
2-c-a-b:34:[[5,1],[1,5]]
1-b-c-a:34:[[5,4],[4,5]]
2-b-c-a:34:[[4,5],[5,4]]
1-c-b-a:34:[[3,6],[6,3]]
2-c-b-a:34:[[6,3],[3,6]]
% 50,063,501 inferences, 3.438 CPU in 3.453 seconds (100% CPU, 14563928 Lips)
true.


?- p( [X,Y,Z|_] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), indexed_profiles( IX, H ), Data=[X-Y-Z-W-N;IX], numbervars(Data), writeln( Data), fig( domain, D ), !, fail.
[(a-b-c-A-34;[[4,1],[1,4]])]


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  2  3  -  4  5  
2:[a,c,b]  6  7  8  9  10 11 
3:[b,a,c]  12 13 14 15 16 17 
4:[b,c,a]  -  18 19 20 21 22 
5:[c,a,b]  23 24 25 26 27 28 
6:[c,b,a]  29 30 31 32 33 34 
--
false.


?- p( [X,Y,Z|_] ), between( 1, 2, J ), G =[ [ X, Y ]-> [ X, Z ], [ Z, X] -> [Z,W ], [W,Z]->[W,X] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), indexed_profiles( IX, H ), Data=[X-Y-Z-W-N;IX], numbervars(Data), writeln( Data), fig( domain, D ), !, fail.
[(a-b-c-A-33;[[5,1],[1,4],[4,5]])]


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  2  3  -  4  5  
2:[a,c,b]  6  7  8  9  10 11 
3:[b,a,c]  12 13 14 15 16 17 
4:[b,c,a]  18 19 20 21 -  22 
5:[c,a,b]  -  23 24 25 26 27 
6:[c,b,a]  28 29 30 31 32 33 
--
false.

?- p( [X,Y,Z|_] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ], [X,W]->[Y,W] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), indexed_profiles( IX, H ), Data=[X-Y-Z-W-N;IX], numbervars(Data), writeln( Data), fig( domain, D ), !, fail.
[(a-b-c-A-33;[[4,1],[3,6],[1,4]])]


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  2  3  -  4  5  
2:[a,c,b]  6  7  8  9  10 11 
3:[b,a,c]  12 13 14 15 16 -  
4:[b,c,a]  -  17 18 19 20 21 
5:[c,a,b]  22 23 24 25 26 27 
6:[c,b,a]  28 29 30 31 32 33 
--
false.

?- p( [X,Y|_] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), indexed_profiles( IX, H ), Data=[X-Y-Z-W-N;IX], numbervars(Data), writeln( Data), fig( domain, D ), !, fail.
[(a-b-A-B-33;[[4,1],[6,2],[1,4]])]


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  2  3  -  4  5  
2:[a,c,b]  6  7  8  9  10 11 
3:[b,a,c]  12 13 14 15 16 17 
4:[b,c,a]  -  18 19 20 21 22 
5:[c,a,b]  23 24 25 26 27 28 
6:[c,b,a]  29 -  30 31 32 33 
--
false.


?- p( [X,Y,Z|_] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), indexed_profiles( IX, H ), Data=[X-Y-Z-W-N;IX], numbervars(Data), writeln( Data), !, fail.
[(a-b-c-A-532;[[9,1],[10,1],[12,1],[22,1],[9,2],[10,2],[12,2],[12,2],[22,2],[22,2],[23,2],[24,2],[9,5],[10,5],[12,5],[12,5],[22,5],[22,5],[23,5],[24,5],[12,6],[22,6],[23,6],[24,6],[12,8],[22,8],[23,8],[24,8],[9,19],[10,19],[12,19],[22,19],[1,9],[2,9],[5,9],[19,9],[1,10],[2,10],[5,10],[19,10],[1,12],[2,12],[5,12],[19,12],[1,22],[2,22],[5,22],[19,22]])]




?- p( [X,Y,Z,_] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ], [X,W]->[Y,W] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), indexed_profiles( IX, H ), Data=[X-Y-Z-W-N;IX], numbervars(Data), writeln( Data), !, fail.
[(a-b-c-A-504;[[9,1],[10,1],[12,1],[22,1],[9,2],[10,2],[12,2],[12,2],[22,2],[22,2],[23,2],[24,2],[9,5],[10,5],[12,5],[12,5],[22,5],[22,5],[23,5],[24,5],[12,6],[22,6],[23,6],[24,6],[12,8],[22,8],[23,8],[24,8],[7,15],[8,15],[11,15],[21,15],[7,16],[8,16],[11,16],[21,16],[7,18],[7,18],[8,18],[8,18],[9,18],[11,18],[15,18],[21,18],[9,19],[10,19],[12,19],[22,19],[7,21],[8,21],[9,21],[15,21],[7,22],[8,22],[9,22],[15,22],[7,24],[7,24],[8,24],[8,24],[9,24],[11,24],[15,24],[21,24],[1,9],[2,9],[5,9],[19,9],[1,10],[2,10],[5,10],[19,10],[1,12],[2,12],[5,12],[19,12],[1,22],[2,22],[5,22],[19,22]])]
false.

?- [X,Y,Z,W] =[a,b,c,d], between( 1, 2, J ), G = [ [ X, Y ]-> [ Z, Y ], [ Y, Z ] -> [ Y, X ], [Z,Y]->[W,Y], [Y,W]->[Y,Z], [W,Y]->[X,Y], [Y,X]->[Y,W] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), Data=[X-Y-Z-W-N], numbervars(Data), writeln( Data-> G ), swf( F, D ), fig( swf, F ), !, fail.
[a-b-c-d-486]->[([a,b]->[c,b]),([b,c]->[b,a]),([c,b]->[d,b]),([b,d]->[b,c]),([d,b]->[a,b]),([b,a]->[b,d])]
[a-b-c-d-486]->[([a,b]->[c,b]),([b,c]->[b,a]),([c,b]->[d,b]),([b,d]->[b,c]),([d,b]->[a,b]),([b,a]->[b,d])]
false.

?- 


?- p( [X,Y,Z,d] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ], [X,W]->[Y,W] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), Data=[X-Y-Z-W-N], numbervars(Data), writeln( Data), swf( F, D ), fig( swf, F ), !, fail.
[a-b-c-A-504]
[a-b-c-A-504]
[a-c-b-A-504]
[a-c-b-A-504]
[b-a-c-A-504]
[b-a-c-A-504]
...

?- 
?- p( [X,Y,Z,_] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ], [X,W]->[Y,W] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), writeln([X-Y-Z-W-N]), !, fail.
[a-b-c-_8732-504]
false.

?- p( [X,Y,_,W] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ], [X,W]->[Y,W] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), writeln([X-Y-Z-W-N]), !, fail.
[a-b-_12364-d-504]
false.

?- p( [X,_,Z,W] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ], [X,W]->[Y,W] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), writeln([X-Y-Z-W-N]), !, fail.
[a-_16016-c-d-506]
false.

?- p( [_,Y,Z,W] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ], [X,W]->[Y,W] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), writeln([X-Y-Z-W-N]), !, fail.
[_22-b-c-d-493]
false.

?- p( [X,Y,Z,_] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [Z,W ], [W,Z]->[W,X] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), writeln([X-Y-Z-W-N]), time(swf( F, D)), fig( swf, F ), !, fail.
[a-b-c-_5112-504]
% 136,130,195 inferences, 9.125 CPU in 9.154 seconds (100% CPU, 14918378 Lips)
[a-b-c-_22-504]
% 145,684,062 inferences, 9.969 CPU in 10.040 seconds (99% CPU, 14614075 Lips)
[a-b-d-_22-504]


?- p( [_,Y,_,W|_] ), between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X ] -> [ W, X ] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ), writeln([X-Y-Z-W-N]), time(swf( F, D)), fig( swf, F ), !, fail.
[_213254-b-_213274-d-438]
% 73,579,211 inferences, 5.016 CPU in 5.036 seconds (100% CPU, 14669998 Lips)


             1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
             ------------------------------------------------------------------------
1:[a,b,c,d]  1  2  3  4  5  6  1  2  -  -  -  -  13 14 13 -  17 17 19 20 19 -  23 23 
2:[a,b,d,c]  1  2  3  4  5  6  1  2  -  -  -  -  13 14 13 -  17 17 19 20 19 -  23 23 
3:[a,c,b,d]  3  -  3  4  6  6  3  -  13 -  -  -  13 14 13 -  17 17 20 20 20 23 23 23 
4:[a,c,d,b]  4  6  4  4  6  6  4  6  14 17 20 23 14 14 14 17 17 17 20 20 20 23 23 23 
5:[a,d,b,c]  -  5  4  -  5  6  -  5  -  -  19 -  14 -  14 17 -  -  19 20 19 -  23 23 
6:[a,d,c,b]  4  -  4  4  6  6  4  -  14 17 -  -  14 14 14 17 17 17 20 20 20 23 23 23 
7:[b,a,c,d]  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
8:[b,a,d,c]  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
9:[b,c,a,d]  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
10:[b,c,d,a] 1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
11:[b,d,a,c] 1  2  3  4  5  6  7  8  9  -  11 12 13 14 15 -  -  -  19 20 21 22 23 24 
12:[b,d,c,a] 1  -  3  4  -  -  7  -  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
13:[c,a,b,d] 3  -  3  4  6  6  3  -  13 -  -  -  13 14 13 -  17 17 20 20 20 23 23 23 
14:[c,a,d,b] 4  6  4  4  6  6  4  6  14 17 20 23 14 14 14 17 17 17 20 20 20 23 23 23 
15:[c,b,a,d] 3  -  3  4  6  6  -  -  15 16 -  -  13 14 15 16 17 18 20 20 -  24 23 24 
16:[c,b,d,a] 3  -  3  4  6  6  -  -  15 16 -  -  13 14 15 16 17 18 20 20 -  24 23 24 
17:[c,d,a,b] 4  6  4  4  6  6  4  6  14 -  -  -  14 14 14 -  17 17 20 20 20 23 23 23 
18:[c,d,b,a] 4  6  4  -  -  -  -  -  -  18 -  24 14 -  -  18 17 18 20 20 -  24 23 24 
19:[d,a,b,c] -  5  4  -  5  6  -  5  -  -  -  -  14 -  14 -  -  -  19 20 19 -  23 23 
20:[d,a,c,b] 4  -  4  4  6  6  4  -  14 -  -  -  14 14 14 -  -  -  20 20 20 23 23 23 
21:[d,b,a,c] -  5  4  -  -  -  -  -  -  -  21 22 14 -  -  -  -  -  19 20 21 22 23 24 
22:[d,b,c,a] -  -  4  -  -  -  -  -  -  -  21 22 14 -  -  18 -  -  19 20 21 22 23 24 
23:[d,c,a,b] 4  -  4  4  -  -  4  -  14 -  -  -  14 14 14 -  17 17 20 20 20 23 23 23 
24:[d,c,b,a] 4  -  4  -  -  -  -  -  -  18 -  -  14 -  -  18 17 18 20 20 -  24 23 24 
--


?- tell('jikken_4alt_pair_del_new.txt'), x( X ), x( Y ), x(Z),between( 1, 2, J ), G = [ [ X, Y ]-> [ X, Z ], [ Z, X] -> [W, X ], [Z,W]->[X,Y] ], findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), member( ( A->B ), G ) ),  H ), all_profiles( U ), subtract( U, H, D ), length( D, N ),  time( swf( F, D ) ), fig( swf, F ), indexed_profiles( IX, H ), write( J-Y-N:IX ), fail; told.
% 147,693,077 inferences, 9.781 CPU in 9.797 seconds (100% CPU, 15099612 Lips)
% 147,693,077 inferences, 9.938 CPU in 9.930 seconds (100% CPU, 14862196 Lips)
% 152,315,476 inferences, 10.328 CPU in 10.360 seconds (100% CPU, 14747641 Lips)
% 145,422,766 inferences, 11.469 CPU in 11.541 seconds (99% CPU, 12679914 Lips)
% 146,936,061 inferences, 12.312 CPU in 12.347 seconds (100% CPU, 11933893 Lips)
% 143,725,954 inferences, 14.156 CPU in 14.258 seconds (99% CPU, 10152827 Lips)
% 142,085,702 inferences, 13.312 CPU in 13.342 seconds (100% CPU, 10673104 Lips)
% 143,705,463 inferences, 10.578 CPU in 10.637 seconds (99% CPU, 13585155 Lips)
...


*/


%22 Nov 2025
/*

?- chalt([a,b,c]).
true.

?- findall( P, ( A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( [b,c], [A] ) ), C ), all_profiles( U ), subtract( U, C, D ), length(D,N),  hist1n( (J=2, setof( B, K^P^( decisiveness_propagates_at( K, P, A->B, J ), member( P, D ) ), L ) ), A->L:J ).

 [([a,b]->[[a,c]]:2),1]
 [([a,c]->[[a,b]]:2),1]
 [([b,a]->[[b,c]]:2),1]
 [([c,a]->[[c,b]]:2),1]
 [([c,b]->[[c,a]]:2),1]
total:5
C = [[[c, a, b], [b, c, a]], [[b, c, a], [c, a, b]]],
U = [[[a, b, c], [a, b, c]],...
D = [[[a, b, c], [a, b, c]], ...
N = 34.

?- findall( P, ( A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( [b,c], [A] ) ), C ), all_profiles( U ), subtract( U, C, D ), length(D,N),  hist1n( (J=2, setof( B, K^P^( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( P, D ) ), L ) ), A->L:J ).

 [([a,b]->[[a,c]]:2),1]
 [([a,c]->[[a,b],[b,c]]:2),1]
 [([b,a]->[[b,c],[c,a]]:2),1]
 [([b,c]->[[a,c]]:2),1]
 [([c,a]->[[b,a],[c,b]]:2),1]
 [([c,b]->[[a,b],[c,a]]:2),1]
total:6
C = [[[c, a, b], [b, c, a]], [[b, c, a], [c, a, b]]],
U = [[[a, b, c], [a, b, c]], [[a, b, c], [a, c, b]], [[a, b, c], [b, a, c]], [[a, b, c], [b, c, a]], [[a, b, c], [c, a|...]], [[a, b|...], [c|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
D = [[[a, b, c], [a, b, c]], [[a, b, c], [a, c, b]], [[a, b, c], [b, a, c]], [[a, b, c], [b, c, a]], [[a, b, c], [c, a|...]], [[a, b|...], [c|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 34.


?- findall( P, ( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( A->B, [[a,b]->[c,b], [b,c]->[b,a]] ) ), C ), all_profiles( U ), subtract( U, C, D ), length(D,N),  hist1n( (J=2, setof( B, K^P^( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( P, D ) ), L ) ), A->L:J ).

 [([a,b]->[[a,c]]:2),1]
 [([a,c]->[[a,b],[b,c]]:2),1]
 [([b,a]->[[b,c],[c,a]]:2),1]
 [([b,c]->[[a,c]]:2),1]
 [([c,a]->[[b,a],[c,b]]:2),1]
 [([c,b]->[[a,b],[c,a]]:2),1]
total:6
C = [[[c, a, b], [b, c, a]], [[b, c, a], [c, a, b]], [[c, a, b], [b, c, a]], [[b, c, a], [c, a, b]]],
U = [[[a, b, c], [a, b, c]], [[a, b, c], [a, c, b]], [[a, b, c], [b, a, c]], [[a, b, c], [b, c, a]], [[a, b, c], [c, a|...]], [[a, b|...], [c|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
D = [[[a, b, c], [a, b, c]], [[a, b, c], [a, c, b]], [[a, b, c], [b, a, c]], [[a, b, c], [b, c, a]], [[a, b, c], [c, a|...]], [[a, b|...], [c|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 34.

?- chalt([a,b,c,d]).
true.

?- findall( P, ( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( A->B, [[a,b]->[c,b], [b,c]->[b,a]] ) ), C ), all_profiles( U ), subtract( U, C, D ), length(D,N),  hist1n( (J=2, setof( B, K^P^( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( P, D ) ), L ) ), A->L:J ).

 [([a,b]->[[a,c],[a,d],[d,b]]:2),1]
 [([a,c]->[[a,b],[a,d],[b,c],[d,c]]:2),1]
 [([a,d]->[[a,b],[a,c],[b,d],[c,d]]:2),1]
 [([b,a]->[[b,c],[b,d],[c,a],[d,a]]:2),1]
 [([b,c]->[[a,c],[b,d],[d,c]]:2),1]
 [([b,d]->[[a,d],[b,a],[b,c],[c,d]]:2),1]
 [([c,a]->[[b,a],[c,b],[c,d],[d,a]]:2),1]
 [([c,b]->[[a,b],[c,a],[c,d],[d,b]]:2),1]
 [([c,d]->[[a,d],[b,d],[c,a],[c,b]]:2),1]
 [([d,a]->[[b,a],[c,a],[d,b],[d,c]]:2),1]
 [([d,b]->[[a,b],[c,b],[d,a],[d,c]]:2),1]
 [([d,c]->[[a,c],[b,c],[d,a],[d,b]]:2),1]
total:12

...
N = 544.

?- findall( P, ( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( A->B, [[a,b]->[b,c], [c,b]->[b,a]] ) ), C ), all_profiles( U ), subtract( U, C, D ), length(D,N), time( swf( F, D ) ), fig( swf, F ).
% 7,728,155,175 inferences, 685.922 CPU in 689.173 seconds (100% CPU, 11266815 Lips)
false.


*/


% 5 Nov 2025
/*

?- hist1n((ppc( A, P ), ppc( B, Q ), A @<B, D=[P,Q], count(swf( F, D ),N)), N ).

 [0,99]
 [1,120]
 [2,72]
 [3,36]
 [4,168]
 [7,60]
 [8,6]
 [10,36]
 [16,30]
 [34,3]
total:630
true.

?- time( ( all_profiles(L),select_n([P,Q], L, 2 ), subtract(L,[P,Q],D), \+ \+ swf( _, D ), assert( tmp_max_swf( [P,Q], D ) ), fail ; true ) ).

% 11,112,809,693 inferences, 388.531 CPU in 390.266 seconds (100% CPU, 28602100 Lips)
true.

?- hist1n( ( tmp_max_swf( P, D ), indexed_profiles( X, P ) ), X ).

 [[[1,4],[3,2]],1]
 [[[1,4],[4,1]],1]
 [[[1,4],[6,3]],1]
 [[[1,5],[2,3]],1]
 [[[1,5],[5,1]],1]
 [[[1,5],[6,2]],1]
 [[[2,3],[3,2]],1]
 [[[2,3],[4,1]],1]
 [[[2,6],[4,5]],1]
 [[[2,6],[5,1]],1]
 [[[2,6],[6,2]],1]
 [[[3,2],[5,1]],1]
 [[[3,6],[4,1]],1]
 [[[3,6],[5,4]],1]
 [[[3,6],[6,3]],1]
 [[[4,5],[5,4]],1]
 [[[4,5],[6,3]],1]
 [[[5,4],[6,2]],1]
total:18
true.

?- hist1n(( tmp_max_swf( [P,Q], D ), count( swf( _, [P,Q] ), N ) ), N ).
 [7,18]
total:18
true.

?- hist1n( (decisiveness_propagates_at( K, P, A->B, J ) ), A->B:J:K=P ).

 [([a,b]->[a,c]:1:[1,4]=[[a,b,c],[b,c,a]]),1]
 [([a,b]->[a,c]:2:[4,1]=[[b,c,a],[a,b,c]]),1]
 [([a,c]->[a,b]:1:[2,6]=[[a,c,b],[c,b,a]]),1]
 [([a,c]->[a,b]:2:[6,2]=[[c,b,a],[a,c,b]]),1]
 [([b,a]->[b,c]:1:[3,2]=[[b,a,c],[a,c,b]]),1]
 [([b,a]->[b,c]:2:[2,3]=[[a,c,b],[b,a,c]]),1]
 [([b,c]->[b,a]:1:[4,5]=[[b,c,a],[c,a,b]]),1]
 [([b,c]->[b,a]:2:[5,4]=[[c,a,b],[b,c,a]]),1]
 [([c,a]->[c,b]:1:[5,1]=[[c,a,b],[a,b,c]]),1]
 [([c,a]->[c,b]:2:[1,5]=[[a,b,c],[c,a,b]]),1]
 [([c,b]->[c,a]:1:[6,3]=[[c,b,a],[b,a,c]]),1]
 [([c,b]->[c,a]:2:[3,6]=[[b,a,c],[c,b,a]]),1]
total:12
true.

?- 

?- chalt([a,b,c,d]).

?- hist1n( (J=1, decisiveness_propagates_at( K, P, A->B, J ) ), A->B:J ).

 [([a,b]->[a,c]:1),16]
 [([a,b]->[a,d]:1),16]
 [([a,c]->[a,b]:1),16]
 [([a,c]->[a,d]:1),16]
 [([a,d]->[a,b]:1),16]
 [([a,d]->[a,c]:1),16]
 [([b,a]->[b,c]:1),16]
 [([b,a]->[b,d]:1),16]
 [([b,c]->[b,a]:1),16]
 [([b,c]->[b,d]:1),16]
 [([b,d]->[b,a]:1),16]
 [([b,d]->[b,c]:1),16]
 [([c,a]->[c,b]:1),16]
 [([c,a]->[c,d]:1),16]
 [([c,b]->[c,a]:1),16]
 [([c,b]->[c,d]:1),16]
 [([c,d]->[c,a]:1),16]
 [([c,d]->[c,b]:1),16]
 [([d,a]->[d,b]:1),16]
 [([d,a]->[d,c]:1),16]
 [([d,b]->[d,a]:1),16]
 [([d,b]->[d,c]:1),16]
 [([d,c]->[d,a]:1),16]
 [([d,c]->[d,b]:1),16]
total:384
true.

?- hist1n( (J=1, setof( B, K^P^decisiveness_propagates_at( K, P, A->B, J ), L ) ), A->L:J ).

 [([a,b]->[[a,c],[a,d]]:1),1]
 [([a,c]->[[a,b],[a,d]]:1),1]
 [([a,d]->[[a,b],[a,c]]:1),1]
 [([b,a]->[[b,c],[b,d]]:1),1]
 [([b,c]->[[b,a],[b,d]]:1),1]
 [([b,d]->[[b,a],[b,c]]:1),1]
 [([c,a]->[[c,b],[c,d]]:1),1]
 [([c,b]->[[c,a],[c,d]]:1),1]
 [([c,d]->[[c,a],[c,b]]:1),1]
 [([d,a]->[[d,b],[d,c]]:1),1]
 [([d,b]->[[d,a],[d,c]]:1),1]
 [([d,c]->[[d,a],[d,b]]:1),1]
total:12
true.

?- hist1n( (J=2, setof( B, K^P^decisiveness_propagates_at( K, P, A->B, J ), L ) ), A->L:J ).

 [([a,b]->[[a,c],[a,d]]:2),1]
 [([a,c]->[[a,b],[a,d]]:2),1]
 [([a,d]->[[a,b],[a,c]]:2),1]
 [([b,a]->[[b,c],[b,d]]:2),1]
 [([b,c]->[[b,a],[b,d]]:2),1]
 [([b,d]->[[b,a],[b,c]]:2),1]
 [([c,a]->[[c,b],[c,d]]:2),1]
 [([c,b]->[[c,a],[c,d]]:2),1]
 [([c,d]->[[c,a],[c,b]]:2),1]
 [([d,a]->[[d,b],[d,c]]:2),1]
 [([d,b]->[[d,a],[d,c]]:2),1]
 [([d,c]->[[d,a],[d,b]]:2),1]
total:12
true.

?- findall( P, ( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), A = [a,b] ), C ), all_profiles( U ), subtract( U, C, D ), length(D,N), time( swf( F, D ) ), fig( swf, F ).
% 6,417,071,389 inferences, 557.766 CPU in 559.269 seconds (100% CPU, 11504960 Lips)
false.


?- findall( P, ( decisiveness_propagates_at( K, P, A->B, J ),  A = [a,b] ), C ), all_profiles( U ), subtract( U, C, D ), length(D,N), time( swf( F, D ) ), fig( swf, F ).
% 7,517,799,665 inferences, 662.422 CPU in 664.656 seconds (100% CPU, 11348960 Lips)
false.

?- findall( C, (  member( M, [ [a,b], [a,c], [a,d] ] ), findall( P, ( decisiveness_propagates_at( K, P, A->B, J ), A= M ), C ) ), [H1, H2, H3 ] ), append( H1, H2, H12 ), append( H12, H3, H ), all_profiles( U ), subtract( U, H, D ), length(D,N), nl, write( domain_size=N ), time( swf( F, D ) ), fig( swf, F ).

domain_size=432
% 5,425,735,059 inferences, 524.328 CPU in 526.559 seconds (100% CPU, 10347976 Lips)
false.


?- findall( C, (  member( M, [ [a,b], [a,c], [a,d] ] ), findall( P, ( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), A= M ), C ) ), [H1, H2, H3 ] ), append( H1, H2, H12 ), append( H12, H3, H ), all_profiles( U ), subtract( U, H, D ), length(D,N), nl, write( domain_size=N ), time( swf( F, D ) ), fig( swf, F ).

N = 318,
F = [[[a, b, c, d], [a, b, c, d]]-[a, b, c, d], [[a, b, c, d], [a, b, d, c]]-[a, b, d, c], [[a, b, c, d], [a, c, b|...]]-[a, c, b, d], [[a, b, c|...], [a, c

domain_size=318
% 725,561,593 inferences, 50.969 CPU in 51.136 seconds (100% CPU, 14235421 Lips)


             1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
             ------------------------------------------------------------------------
1:[a,b,c,d]  1  2  3  4  5  6  1  2  -  -  -  -  3  4  3  -  -  -  5  6  5  -  6  6  
2:[a,b,d,c]  1  2  3  4  5  6  1  2  -  -  -  -  3  4  3  -  4  4  5  6  5  -  -  -  
3:[a,c,b,d]  1  2  3  4  5  6  1  2  1  -  -  -  3  4  -  -  -  -  5  6  5  5  6  -  
4:[a,c,d,b]  1  2  3  4  5  6  1  2  1  -  2  2  3  4  -  -  -  -  5  6  -  -  6  -  
5:[a,d,b,c]  1  2  3  4  5  6  1  2  -  -  2  -  3  4  3  3  4  -  5  6  -  -  -  -  
6:[a,d,c,b]  1  2  3  4  5  6  1  2  1  1  2  -  3  4  -  -  4  -  5  6  -  -  -  -  
7:[b,a,c,d]  1  2  3  4  5  6  7  8  7  -  8  8  3  4  -  -  -  -  5  6  -  -  6  -  
8:[b,a,d,c]  1  2  3  4  5  6  7  8  7  7  8  -  3  4  -  -  4  -  5  6  -  -  -  -  
9:[b,c,a,d]  -  -  3  4  -  6  7  8  9  9  8  -  -  -  15 15 -  -  -  6  -  -  -  -  
10:[b,c,d,a] -  -  -  -  -  6  -  8  9  10 -  12 -  -  15 16 -  18 -  -  -  22 -  24 
11:[b,d,a,c] -  -  -  4  5  6  7  8  7  -  11 11 -  4  -  -  -  -  -  -  21 21 -  -  
12:[b,d,c,a] -  -  -  4  -  -  7  -  -  10 11 12 -  -  -  16 -  18 -  -  21 22 -  24 
13:[c,a,b,d] 1  2  3  4  5  6  1  2  -  -  -  -  13 14 13 -  14 14 5  6  5  -  -  -  
14:[c,a,d,b] 1  2  3  4  5  6  1  2  -  -  2  -  13 14 13 13 14 -  5  6  -  -  -  -  
15:[c,b,a,d] 1  2  -  -  5  -  -  -  9  9  -  -  13 14 15 15 14 -  5  -  -  -  -  -  
16:[c,b,d,a] -  -  -  -  5  -  -  -  9  10 -  12 -  14 15 16 -  18 -  -  -  22 -  24 
17:[c,d,a,b] -  2  -  -  5  6  -  2  -  -  -  -  13 14 13 -  17 17 -  -  -  -  23 23 
18:[c,d,b,a] -  2  -  -  -  -  -  -  -  10 -  12 13 -  -  16 17 18 -  -  -  22 23 24 
19:[d,a,b,c] 1  2  3  4  5  6  1  2  -  -  -  -  3  4  3  -  -  -  19 20 19 -  20 20 
20:[d,a,c,b] 1  2  3  4  5  6  1  2  1  -  -  -  3  4  -  -  -  -  19 20 19 19 20 -  
21:[d,b,a,c] 1  2  3  -  -  -  -  -  -  -  11 11 3  -  -  -  -  -  19 20 21 21 20 -  
22:[d,b,c,a] -  -  3  -  -  -  -  -  -  10 11 12 -  -  -  16 -  18 -  20 21 22 -  24 
23:[d,c,a,b] 1  -  3  4  -  -  1  -  -  -  -  -  -  -  -  -  17 17 19 20 19 -  23 23 
24:[d,c,b,a] 1  -  -  -  -  -  -  -  -  10 -  12 -  -  -  16 17 18 19 -  -  22 23 24 
--
H1 = [[[c, a, b, d], [b, c, a, d]], [[c, a, d, b], [b, c, a, d]], [[c, d, a, b], [b, c, a, d]], [[d, c, a, b], [b, c, a|...]], [[c, a, b|...], [b, c|...]], [[c, a|...




?- tell('gen_swf_alt4_sym_remove_triad_ab_ac_ad.txt'), findall( C, (  member( M, [ [a,b], [a,c], [a,d] ] ), findall( P, ( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), A= M ), C ) ), [H1, H2, H3 ] ), append( H1, H2, H12 ), append( H12, H3, H ), all_profiles( U ), subtract( U, H, D ), length(D,N), nl, write( domain_size=N ), time( swf( F, D ) ), fig( swf, F ),fail; told.

% 725,561,593 inferences, 51.219 CPU in 51.457 seconds (100% CPU, 14165937 Lips)
% 2,521,576,918 inferences, 214.109 CPU in 215.017 seconds (100% CPU, 11777050 Lips)
% 3,603,179,684 inferences, 328.094 CPU in 328.992 seconds (100% CPU, 10982165 Lips)
true.


?- between( 1, 3, Z ), select_n( M, [ [a,b], [a,c], [a,d] ] , Z ), nl, write( Z:M ), J=1, findall( P, ( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( A, M ) ),  H ), all_profiles( U ), subtract( U, H, D ), length(D,N), tab(1), write( (domain_size=N) ), fail.

1:[[a,b]] domain_size=524
1:[[a,c]] domain_size=524
1:[[a,d]] domain_size=524
2:[[a,b],[a,c]] domain_size=480
2:[[a,b],[a,d]] domain_size=480
2:[[a,c],[a,d]] domain_size=480
3:[[a,b],[a,c],[a,d]] domain_size=444
false.

?- 

?- between( 1, 3, Z ), select_n( M, [ [a,b], [a,c], [a,d] ] , Z ), nl, write( Z:M ), J=1, findall( P, ( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( A, M ) ),  H ), all_profiles( U ), subtract( U, H, D ), length(D,N), tab(1), write( (domain_size=N) ), time( swf( F, D  )), fig( swf, F  ); write( dict ).






?- decisiveness_propagates_at( K, P, B, J ), profile_as_sign_pattern( K, P, S ).
K = [1, 3],
P = [[a, c, b], [b, a, c]],
B =  ([b, a]->[b, c]),
J = 2,
S = [[a, b]:[+, -], [b, c]:[-, +], [c, a]:[-, -]] ;
K = [1, 5],
P = [[a, c, b], [c, b, a]],
B =  ([a, c]->[a, b]),
J = 1,
S = [[a, b]:[+, -], [b, c]:[-, -], [c, a]:[-, +]] .


?- decisiveness_propagates_at( K, P, B, J ), indexed_profiles( X, [P] ).
K = [4, 1],
P = [[a, c, d, b], [a, b, c, d]],
B = ([b, c]->[b, d]),
J = 2,
X = [[4, 1]] .

?- hist1n((decisiveness_propagates_at( K, P, B, J )), B ).

 [([a,b]->[a,c]),32]
 [([a,b]->[a,d]),32]
 [([a,c]->[a,b]),32]
 [([a,c]->[a,d]),32]
 [([a,d]->[a,b]),32]
 [([a,d]->[a,c]),32]
 [([b,a]->[b,c]),32]
 [([b,a]->[b,d]),32]
 [([b,c]->[b,a]),32]
 [([b,c]->[b,d]),32]
 [([b,d]->[b,a]),32]
 [([b,d]->[b,c]),32]
 [([c,a]->[c,b]),32]
 [([c,a]->[c,d]),32]
 [([c,b]->[c,a]),32]
 [([c,b]->[c,d]),32]
 [([c,d]->[c,a]),32]
 [([c,d]->[c,b]),32]
 [([d,a]->[d,b]),32]
 [([d,a]->[d,c]),32]
 [([d,b]->[d,a]),32]
 [([d,b]->[d,c]),32]
 [([d,c]->[d,a]),32]
 [([d,c]->[d,b]),32]
total:768
true.

?- chalt([a,b,c]).
true.

?- hist1n((decisiveness_propagates_at( K, P, B, J )), B ).

 [([a,b]->[a,c]),2]
 [([a,c]->[a,b]),2]
 [([b,a]->[b,c]),2]
 [([b,c]->[b,a]),2]
 [([c,a]->[c,b]),2]
 [([c,b]->[c,a]),2]
total:12
true.

?- hist1n(( A=[X,Y], x(X), x(Y), decisiveness_propagates_at( K, P, A->B, J )), A->B ).

 [([a,b]->[a,c]),2]
 [([a,b]->[c,b]),2]
 [([a,c]->[a,b]),2]
 [([a,c]->[b,c]),2]
 [([b,a]->[b,c]),2]
 [([b,a]->[c,a]),2]
 [([b,c]->[a,c]),2]
 [([b,c]->[b,a]),2]
 [([c,a]->[b,a]),2]
 [([c,a]->[c,b]),2]
 [([c,b]->[a,b]),2]
 [([c,b]->[c,a]),2]
total:24
true.

?- X=a,Y=b, hist1n(( A=[X,Y], x(X), x(Y), decisiveness_propagates_at( K, P, A->B, J )), A->B:P ).

 [([a,b]->[a,c]:[[a,b,c],[b,c,a]]),1]
 [([a,b]->[a,c]:[[b,c,a],[a,b,c]]),1]
 [([a,b]->[c,b]:[[b,c,a],[c,a,b]]),1]
 [([a,b]->[c,b]:[[c,a,b],[b,c,a]]),1]
total:4
X = a,
Y = b.

?- X=a,Y=b, findall( P, ( A=[X,Y], x(X), x(Y), decisiveness_propagates_at( K, P, A->B, J )), D ), fig( domain, D ).


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  4  -  -  
2:[a,c,b]  -  -  -  -  -  -  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  3  -  -  -  2  -  
5:[c,a,b]  -  -  -  1  -  -  
6:[c,b,a]  -  -  -  -  -  -  
--
X = a,
Y = b,
D = [[[c, a, b], [b, c, a]], [[b, c, a], [c, a, b]], [[b, c, a], [a, b, c]], [[a, b, c], [b, c, a]]].

?-  hist1n(( A=[X,Y], x(X), x(Y), decisiveness_propagates_at( K, P, A->B, J ), B=[a,b]), A->B:P ).

 [([a,c]->[a,b]:[[a,c,b],[c,b,a]]),1]
 [([a,c]->[a,b]:[[c,b,a],[a,c,b]]),1]
 [([c,b]->[a,b]:[[a,c,b],[b,a,c]]),1]
 [([c,b]->[a,b]:[[b,a,c],[a,c,b]]),1]
total:4
true.


?- findall( P, ( A=[X,Y], x(X), x(Y), decisiveness_propagates_at( K, P, A->B, J ), B=[a,b] ), C ), fig( domain, C ).


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  -  -  
2:[a,c,b]  -  -  4  -  -  2  
3:[b,a,c]  -  3  -  -  -  -  
4:[b,c,a]  -  -  -  -  -  -  
5:[c,a,b]  -  -  -  -  -  -  
6:[c,b,a]  -  1  -  -  -  -  
--
C = [[[c, b, a], [a, c, b]], [[a, c, b], [c, b, a]], [[b, a, c], [a, c, b]], [[a, c, b], [b, a, c]]].

?- 

?- hist1n((decisiveness_propagates_at( K, P, B->C, J )), B ).

 [[a,b],64]
 [[a,c],64]
 [[a,d],64]
 [[b,a],64]
 [[b,c],64]
 [[b,d],64]
 [[c,a],64]
 [[c,b],64]
 [[c,d],64]
 [[d,a],64]
 [[d,b],64]
 [[d,c],64]
total:768
true.

?- chalt([a,b,c]).
true.

?- hist1n((decisiveness_propagates_at( K, P, B->C, J )), B ).

 [[a,b],2]
 [[a,c],2]
 [[b,a],2]
 [[b,c],2]
 [[c,a],2]
 [[c,b],2]
total:12
true.

?- chalt([a,b,c,d]).
true.

?- J=1, hist1n((decisiveness_propagates_at( K, P, B, J ) ),  J:B).

 [1:([a,b]->[a,c]),16]
 [1:([a,b]->[a,d]),16]
 [1:([a,c]->[a,b]),16]
 [1:([a,c]->[a,d]),16]
 [1:([a,d]->[a,b]),16]
 [1:([a,d]->[a,c]),16]
 [1:([b,a]->[b,c]),16]
 [1:([b,a]->[b,d]),16]
 [1:([b,c]->[b,a]),16]
 [1:([b,c]->[b,d]),16]
 [1:([b,d]->[b,a]),16]
 [1:([b,d]->[b,c]),16]
 [1:([c,a]->[c,b]),16]
 [1:([c,a]->[c,d]),16]
 [1:([c,b]->[c,a]),16]
 [1:([c,b]->[c,d]),16]
 [1:([c,d]->[c,a]),16]
 [1:([c,d]->[c,b]),16]
 [1:([d,a]->[d,b]),16]
 [1:([d,a]->[d,c]),16]
 [1:([d,b]->[d,a]),16]
 [1:([d,b]->[d,c]),16]
 [1:([d,c]->[d,a]),16]
 [1:([d,c]->[d,b]),16]
total:384
J = 1.

?- J=2, hist1n((decisiveness_propagates_at( K, P, B, J ) ),  J:B).

 [2:([a,b]->[a,c]),16]
 [2:([a,b]->[a,d]),16]
 [2:([a,c]->[a,b]),16]
 [2:([a,c]->[a,d]),16]
 [2:([a,d]->[a,b]),16]
 [2:([a,d]->[a,c]),16]
 [2:([b,a]->[b,c]),16]
 [2:([b,a]->[b,d]),16]
 [2:([b,c]->[b,a]),16]
 [2:([b,c]->[b,d]),16]
 [2:([b,d]->[b,a]),16]
 [2:([b,d]->[b,c]),16]
 [2:([c,a]->[c,b]),16]
 [2:([c,a]->[c,d]),16]
 [2:([c,b]->[c,a]),16]
 [2:([c,b]->[c,d]),16]
 [2:([c,d]->[c,a]),16]
 [2:([c,d]->[c,b]),16]
 [2:([d,a]->[d,b]),16]
 [2:([d,a]->[d,c]),16]
 [2:([d,b]->[d,a]),16]
 [2:([d,b]->[d,c]),16]
 [2:([d,c]->[d,a]),16]
 [2:([d,c]->[d,b]),16]
total:384
J = 2
?- 

?- J=2, hist1n((x(X),x(Y),A=[X,Y], setof( B, K^P^decisiveness_propagates_at( K, P, A->B, J ), W ) ),  J:A->W).

 [(2:[a,b]->[[a,c],[a,d],[c,b],[d,b]]),1]
 [(2:[a,c]->[[a,b],[a,d],[b,c],[d,c]]),1]
 [(2:[a,d]->[[a,b],[a,c],[b,d],[c,d]]),1]
 [(2:[b,a]->[[b,c],[b,d],[c,a],[d,a]]),1]
 [(2:[b,c]->[[a,c],[b,a],[b,d],[d,c]]),1]
 [(2:[b,d]->[[a,d],[b,a],[b,c],[c,d]]),1]
 [(2:[c,a]->[[b,a],[c,b],[c,d],[d,a]]),1]
 [(2:[c,b]->[[a,b],[c,a],[c,d],[d,b]]),1]
 [(2:[c,d]->[[a,d],[b,d],[c,a],[c,b]]),1]
 [(2:[d,a]->[[b,a],[c,a],[d,b],[d,c]]),1]
 [(2:[d,b]->[[a,b],[c,b],[d,a],[d,c]]),1]
 [(2:[d,c]->[[a,c],[b,c],[d,a],[d,b]]),1]
total:12
J = 2.

?- hist1n((x(X),x(Y),A=[X,Y], setof( B, K^P^decisiveness_propagates_at( K, P, A->B, J ), W ) ),  A->W).

 [([a,b]->[[a,c],[a,d],[c,b],[d,b]]),2]
 [([a,c]->[[a,b],[a,d],[b,c],[d,c]]),2]
 [([a,d]->[[a,b],[a,c],[b,d],[c,d]]),2]
 [([b,a]->[[b,c],[b,d],[c,a],[d,a]]),2]
 [([b,c]->[[a,c],[b,a],[b,d],[d,c]]),2]
 [([b,d]->[[a,d],[b,a],[b,c],[c,d]]),2]
 [([c,a]->[[b,a],[c,b],[c,d],[d,a]]),2]
 [([c,b]->[[a,b],[c,a],[c,d],[d,b]]),2]
 [([c,d]->[[a,d],[b,d],[c,a],[c,b]]),2]
 [([d,a]->[[b,a],[c,a],[d,b],[d,c]]),2]
 [([d,b]->[[a,b],[c,b],[d,a],[d,c]]),2]
 [([d,c]->[[a,c],[b,c],[d,a],[d,b]]),2]
total:24
true.

?- findall( P-S, (A=([a,b]->[a,c]), decisiveness_propagates_at( K, P, A, J ), S=o), C ), fig( scf, C ), fail.


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  o  -  -  
2:[a,c,b]  -  -  -  -  -  -  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  o  -  -  -  -  -  
5:[c,a,b]  -  -  -  -  -  -  
6:[c,b,a]  -  -  -  -  -  -  
--
false.

?- findall( P-S, ( x(X), x(Y), A=[X,Y], decisiveness_propagates_at( K, P, A->B, J ), member( A->B, [[a,b]->_ ] ), atomic_list_concat( B, S ) ), C ), fig( scf, C ).


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  ac -  -  
2:[a,c,b]  -  -  -  -  -  -  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  ac -  -  -  cb -  
5:[c,a,b]  -  -  -  cb -  -  
6:[c,b,a]  -  -  -  -  -  -  
--
C = [[[c, a, b], [b, c, a]]-cb, [[b, c, a], [c, a, b]]-cb, [[b, c, a], [a, b, c]]-ac, [[a, b, c], [b, c|...]]-ac].

?- chalt([a,b,c,d]).

?- findall( P-S, (A=([a,b]->[a,c]), decisiveness_propagates_at( K, P, A, J ), S=o), C ), fig_s( scf, C ), fail.


             1  2  5  9  10 12 19 22 
             ------------------------
1:[a,b,c,d]  -  -  -  o  o  o  -  o  
2:[a,b,d,c]  -  -  -  o  o  o  -  o  
5:[a,d,b,c]  -  -  -  o  o  o  -  o  
9:[b,c,a,d]  o  o  o  -  -  -  o  -  
10:[b,c,d,a] o  o  o  -  -  -  o  -  
12:[b,d,c,a] o  o  o  -  -  -  o  -  
19:[d,a,b,c] -  -  -  o  o  o  -  o  
22:[d,b,c,a] o  o  o  -  -  -  o  -  
--
false.



?- findall( P, (A=([a,b]->[a,c]), decisiveness_propagates_at( K, P, A, J )), C ), all_profiles( U ), subtract( U, C, D ), swf( F, D ), fig_s( swf, F ), fail.
false.


?- chalt([a,b,c]).

?- findall( P, (decisiveness_propagates_at( K, P, A->B, J ),B=[a,b]), C ), all_profiles( U ), subtract( U, C, D ), fig( domain, C ),  time(swf( F, D )), fig_s( swf, F ), fail.


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  -  -  
2:[a,c,b]  -  -  -  -  -  2  
3:[b,a,c]  -  -  -  -  -  -  
4:[b,c,a]  -  -  -  -  -  -  
5:[c,a,b]  -  -  -  -  -  -  
6:[c,b,a]  -  1  -  -  -  -  
--
% 8,605,808 inferences, 0.578 CPU in 0.587 seconds (99% CPU, 14885722 Lips)


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  1  3  3  1  3  
2:[a,c,b]  1  2  3  3  2  -  
3:[b,a,c]  3  3  3  3  3  3  
4:[b,c,a]  3  3  3  4  4  4  
5:[c,a,b]  1  2  3  4  5  6  
6:[c,b,a]  3  -  3  4  6  6  
--
% 14,346,563 inferences, 0.984 CPU in 0.973 seconds (101% CPU, 14574286 Lips)
false.

?- hist1n(( x(X), x(Y),findall( P, (decisiveness_propagates_at( K, P, A->B, J ),B=[X,Y]), C ), all_profiles( U ), subtract( U, C, D ), count(swf( F, D ),N) ), X:Y:N ).

 [a:a:0,1]
 [a:b:1,1]
 [a:c:1,1]
 [b:a:1,1]
 [b:b:0,1]
 [b:c:1,1]
 [c:a:1,1]
 [c:b:1,1]
 [c:c:0,1]
total:9
true.


?- tell('dflow3.txt'), setof( P, ( x(V),x(W),B=[V,W],decisiveness_propagates_at( K, P, A->B, J ), atomic_list_concat( K, '-', X), atomic_list_concat( [J|A], Y ), atomic_list_concat( [J|B], Z ) ), _ ), nl, write( (X,Y,Z)), fail; told.
true.

?- tell('dflow3_pp.txt'), setof( P, ( x(V),x(W),B=[V,W],decisiveness_propagates_at( K, P, A->B, J ), decisiveness_propagates_at( K1, P1, B->C, J ), atomic_list_concat( [J|K],'-', X), atomic_list_concat( [J|K1], '-', Y ), atomic_list_concat( B, Z ) ), _ ),  nl, write( (Z,X,Y)), fail; told.
true.


?- tell('dflow4_pp.csv'), setof( P, ( x(V),x(W),A=[V,W],decisiveness_propagates_at( K, P, A->B, J ), P=[P1,P2], atomic_list_concat( [J|A], X), atomic_list_concat( [J|B], Y ),  atomic_list_concat( P1, Z1 ), atomic_list_concat( P2, Z2 ) ), _ ), nl, write( (Z1-Z2,X,Y)), fail; told.
true.



?- chalt([a,b,c,d]).


?- hist1n(( X=a, Y=b,findall( P, (decisiveness_propagates_at( K, P, A->B, J ),B=[X,Y]), C ), all_profiles( U ), subtract( U, C, D ), count(swf( F, D ),N) ), X:Y:N ).

?- 



?- findall( P-S, (decisiveness_propagates_at( K, P, A->B, J ), atomic_list_concat( A,S ),A=[a,b]), D ), fig_s( scf, D ).


             1  2  3  5  9  10 11 12 13 16 19 22 
             ------------------------------------
1:[a,b,c,d]  -  -  -  -  ab ab ab ab -  ab -  ab 
2:[a,b,d,c]  -  -  -  -  ab ab ab ab -  ab -  ab 
3:[a,c,b,d]  -  -  -  -  -  ab ab ab -  ab -  -  
5:[a,d,b,c]  -  -  -  -  ab ab -  ab -  -  -  ab 
9:[b,c,a,d]  ab ab -  ab -  -  -  -  -  -  ab -  
10:[b,c,d,a] ab ab ab ab -  -  -  -  ab -  ab -  
11:[b,d,a,c] ab ab ab -  -  -  -  -  ab -  -  -  
12:[b,d,c,a] ab ab ab ab -  -  -  -  ab -  ab -  
13:[c,a,b,d] -  -  -  -  -  ab ab ab -  ab -  -  
16:[c,b,d,a] ab ab ab -  -  -  -  -  ab -  -  -  
19:[d,a,b,c] -  -  -  -  ab ab -  ab -  -  -  ab 
22:[d,b,c,a] ab ab -  ab -  -  -  -  -  -  ab -  
--
D = [[[b, c, a, d], [a, b, c, d]]-ab, [[b, c, d, a], [a, b, c, d]]-ab, [[b, c, d, a], [a, b, c|...]]-ab, [[b, d, a|...], [a, b|...]]-ab, [[b, d|...], [a|...]]-ab, [[b|...], [...|...]]-ab, [[...|...]|...]-ab, [...|...]-ab, ... - ...|...].

?- findall( P, (decisiveness_propagates_at( K, P, A->B, J ), atomic_list_concat( A,S ),A=[a,b]), D ), swf( F, D ), fig_s( swf, F ), fail.
false.

% 9 Nov 2025

?- findall( P-S, (decisiveness_propagates_at( K, P, A->B, J ), atomic_list_concat( B,S ), B=[a,b]), D ), fig_s( scf, D ).


             3  4  5  6  14 15 16 18 20 21 22 24 
             ------------------------------------
3:[a,c,b,d]  -  -  -  -  -  ab ab ab -  -  -  ab 
4:[a,c,d,b]  -  -  -  -  -  ab ab ab -  ab ab ab 
5:[a,d,b,c]  -  -  -  -  -  -  -  ab -  ab ab ab 
6:[a,d,c,b]  -  -  -  -  -  ab ab ab -  ab ab ab 
14:[c,a,d,b] -  -  -  -  -  -  -  ab -  ab ab ab 
15:[c,b,a,d] ab ab -  ab -  -  -  -  ab -  -  -  
16:[c,b,d,a] ab ab -  ab -  -  -  -  ab -  -  -  
18:[c,d,b,a] ab ab ab ab ab -  -  -  ab -  -  -  
20:[d,a,c,b] -  -  -  -  -  ab ab ab -  -  -  ab 
21:[d,b,a,c] -  ab ab ab ab -  -  -  -  -  -  -  
22:[d,b,c,a] -  ab ab ab ab -  -  -  -  -  -  -  
24:[d,c,b,a] ab ab ab ab ab -  -  -  ab -  -  -  
--
D = [[[c, b, a, d], [a, c, b, d]]-ab, [[c, b, d, a], [a, c, b, d]]-ab, [[c, d, b, a], [a, c, b|...]]-ab, [[d, c, b|...], [a, c|...]]-ab, [[c, b|...], [a|...]]-ab, [[c|...], [...|...]]-ab, [[...|...]|...]-ab, [...|...]-ab, ... - ...|...].


?-  findall( P, (B=([a,b]), decisiveness_propagates_at( K, P, A->B, J )), C ), all_profiles( U ), subtract( U, C, D ), time(swf( F, D )), fig_s( swf, F ), fail.
% 6,789,379,419 inferences, 1490.016 CPU in 1510.483 seconds (99% CPU, 4556583 Lips)
false.

% Yesterday

?- findall( P, (decisiveness_propagates_at( K, P, A->B, J ), atomic_list_concat( A,S ),A=[a,b]), C ), all_profiles( U ), subtract( U, C, D ), length(C, N), sort(C, C1), length(C1,N1).
C = [[[b, c, a, d], [a, b, c, d]], [[b, c, d, a], [a, b, c, d]], [[b, c, d, a], [a, b, c, d]], [[b, d, a, c], [a, b, c|...]], [[b, d, c|...], [a, b|...]], [[b, d|...], [a|...]], [[c|...], [...|...]], [[...|...]|...], [...|...]|...],
U = [[[a, b, c, d], [a, b, c, d]], [[a, b, c, d], [a, b, d, c]], [[a, b, c, d], [a, c, b, d]], [[a, b, c, d], [a, c, d|...]], [[a, b, c|...], [a, d|...]], [[a, b|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
D = [[[a, b, c, d], [a, b, c, d]], [[a, b, c, d], [a, b, d, c]], [[a, b, c, d], [a, c, b, d]], [[a, b, c, d], [a, c, d|...]], [[a, b, c|...], [a, d|...]], [[a, b|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 64,
C1 = [[[a, b, c, d], [b, c, a, d]], [[a, b, c, d], [b, c, d, a]], [[a, b, c, d], [b, d, a, c]], [[a, b, c, d], [b, d, c|...]], [[a, b, c|...], [c, b|...]], [[a, b|...], [d|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
N1 = 56.

?- findall( P, (decisiveness_propagates_at( K, P, A->B, J ), atomic_list_concat( A,S ),A=[a,b]), C ), all_profiles( U ), subtract( U, C, D ), time(swf( F, D )), fig_s( swf, F ), fail.
% 7,517,799,628 inferences, 742.844 CPU in 744.990 seconds (100% CPU, 10120297 Lips)
false.


*/

% a bug (in may brain) 9 Nov 2025
/*

?- findall( P, ( A=([a,b]), decisiveness_propagates_at( K, P, A->B, J )), C ), all_profiles( U ), subtract( U, C, D ),  fig( domain, D ), findall( P, (decisiveness_propagates_at( K, P, A->B, J ), A=[a,b]), C1 ), subtract( U, C1, D1 ),  fig( domain, D1 ).


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  2  3  -  4  5  
2:[a,c,b]  6  7  8  9  10 11 
3:[b,a,c]  12 13 14 15 16 17 
4:[b,c,a]  -  18 19 20 -  21 
5:[c,a,b]  22 23 24 -  25 26 
6:[c,b,a]  27 28 29 30 31 32 
--

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  2  3  -  4  5  
2:[a,c,b]  6  7  8  9  10 11 
3:[b,a,c]  12 13 14 15 16 17 
4:[b,c,a]  -  18 19 20 21 22 
5:[c,a,b]  23 24 25 26 27 28 
6:[c,b,a]  29 30 31 32 33 34 
--
C = [[[c, a, b], [b, c, a]], [[b, c, a], [c, a, b]], [[b, c, a], [a, b, c]], [[a, b, c], [b, c, a]]],
U = [[[a, b, c], [a, b, c]], [[a, b, c], [a, c, b]], [[a, b, c], [b, a, c]], [[a, b, c], [b, c, a]], [[a, b, c], [c, a|...]], [[a, b|...], [c|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],

?- findall( P, (B=([a,b]), decisiveness_propagates_at( K, P, A->B, J )), C ), all_profiles( U ), subtract( U, C, D ),  fig( domain, D ), findall( P, (decisiveness_propagates_at( K, P, A->B, J ),B=[a,b]), C1 ), subtract( U, C1, D1 ),  fig( domain, D1 ).


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  2  3  4  5  6  
2:[a,c,b]  7  8  -  9  10 -  
3:[b,a,c]  11 -  12 13 14 15 
4:[b,c,a]  16 17 18 19 20 21 
5:[c,a,b]  22 23 24 25 26 27 
6:[c,b,a]  28 -  29 30 31 32 
--

           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  1  2  3  4  5  6  
2:[a,c,b]  7  8  9  10 11 -  
3:[b,a,c]  12 13 14 15 16 17 
4:[b,c,a]  18 19 20 21 22 23 
5:[c,a,b]  24 25 26 27 28 29 
6:[c,b,a]  30 -  31 32 33 34 


?- hist1n((pp(P), \+ agree( _, [ Y, Z ], P ),  [Y,Z]=[a,b]),P).

 [[[a,b,c],[c,b,a]],1]
 [[[a,c,b],[b,c,a]],1]
 [[[b,a,c],[c,a,b]],1]
 [[[b,c,a],[a,c,b]],1]
 [[[c,a,b],[b,a,c]],1]
 [[[c,b,a],[a,b,c]],1]
total:6
true.

?- hist1n((  [Y,Z]=[a,b], pp(P), \+ agree( _, [ Y, Z ], P )),P).

 [[[a,b,c],[b,a,c]],1]
 [[[a,b,c],[b,c,a]],1]
 [[[a,b,c],[c,b,a]],1]
 [[[a,c,b],[b,a,c]],1]
 [[[a,c,b],[b,c,a]],1]
 [[[a,c,b],[c,b,a]],1]
 [[[b,a,c],[a,b,c]],1]
 [[[b,a,c],[a,c,b]],1]
 [[[b,a,c],[c,a,b]],1]
 [[[b,c,a],[a,b,c]],1]
 [[[b,c,a],[a,c,b]],1]
 [[[b,c,a],[c,a,b]],1]
 [[[c,a,b],[b,a,c]],1]
 [[[c,a,b],[b,c,a]],1]
 [[[c,a,b],[c,b,a]],1]
 [[[c,b,a],[a,b,c]],1]
 [[[c,b,a],[a,c,b]],1]
 [[[c,b,a],[c,a,b]],1]
total:18
true.


*/



/*



?- J=1, findall( P- X, (decisiveness_propagates_at( K, P, A->B, J ), atomic_list_concat( A, X ) ),  F), fig( scf, F ).


             1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
             ------------------------------------------------------------------------
1:[a,b,c,d]  -  -  -  bc -  -  -  -  ab ab ab ab -  bc -  ab ac ac -  -  -  ab -  -  
2:[a,b,d,c]  -  -  -  -  -  bd -  -  ab ab ab ab -  -  -  ab -  -  -  bd -  ab ad ad 
3:[a,c,b,d]  -  cb -  -  -  -  -  cb -  ac ab ab -  -  ac ac ac ac -  -  -  -  -  ac 
4:[a,c,d,b]  -  -  -  -  cd -  -  -  -  ac -  -  -  -  ac ac ac ac cd -  ad ad -  ac 
5:[a,d,b,c]  db -  -  -  -  -  db -  ab ab -  ad -  -  -  -  -  ad -  -  ad ad ad ad 
6:[a,d,c,b]  -  -  dc -  -  -  -  -  -  -  -  ad dc -  ac ac -  ad -  -  ad ad ad ad 
7:[b,a,c,d]  -  -  ba ba ba ba -  -  -  ac -  -  -  ba -  ac bc bc -  ba -  -  -  -  
8:[b,a,d,c]  -  -  ba ba ba ba -  -  -  -  -  ad -  ba -  -  -  -  -  ba -  ad bd bd 
9:[b,c,a,d]  -  ca -  bc ba ba -  ca -  -  -  -  bc bc -  -  bc bc -  -  -  -  bc -  
10:[b,c,d,a] -  -  -  bc -  -  -  -  -  -  cd -  bc bc -  -  bc bc bd bd cd -  bc -  
11:[b,d,a,c] da -  ba ba -  bd da -  -  -  -  -  -  -  -  -  bd -  bd bd -  -  bd bd 
12:[b,d,c,a] -  -  -  -  -  bd -  -  dc -  -  -  bc bc dc -  bd -  bd bd -  -  bd bd 
13:[c,a,b,d] ca ca -  -  ca ca -  ca -  ab cb cb -  -  -  ab -  -  ca -  -  -  -  -  
14:[c,a,d,b] ca ca -  -  ca ca -  ca -  -  -  -  -  -  -  -  -  ad ca -  cd cd -  ad 
15:[c,b,a,d] -  cb -  ba ca ca cb cb -  -  cb cb -  ba -  -  -  -  -  -  cb -  -  -  
16:[c,b,d,a] -  cb -  -  -  -  cb cb -  -  cb cb -  -  -  -  bd -  cd cd cb -  bd -  
17:[c,d,a,b] ca ca da -  cd -  -  -  -  -  cd -  da -  -  -  -  -  cd cd cd cd -  -  
18:[c,d,b,a] -  -  -  -  cd -  cb cb db -  cd -  -  -  db -  -  -  cd cd cd cd -  -  
19:[d,a,b,c] da da da da -  -  da -  db db -  ab da -  -  -  -  -  -  -  -  ab -  -  
20:[d,a,c,b] da da da da -  -  da -  -  -  -  -  da -  dc dc -  ac -  -  -  -  -  ac 
21:[d,b,a,c] db -  da da -  ba db db db db -  -  -  -  db -  -  -  -  ba -  -  -  -  
22:[d,b,c,a] db -  -  -  -  -  db db db db -  -  dc dc db -  bc -  -  -  -  -  bc -  
23:[d,c,a,b] da da dc -  ca -  -  -  dc -  -  -  dc dc dc dc -  -  ca -  -  -  -  -  
24:[d,c,b,a] -  -  dc -  -  -  db db dc -  cb -  dc dc dc dc -  -  -  -  cb -  -  -  
--
J = 1,
F = [[[a, d,...

?- J=1, findall( P- Y, (decisiveness_propagates_at( K, P, A->B, J ), atomic_list_concat( B, Y ) ),  F), fig( scf, F ).


             1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
             ------------------------------------------------------------------------
1:[a,b,c,d]  -  -  -  bd -  -  -  -  ac ac ad ac -  bd -  ad ad ad -  -  -  ac -  -  
2:[a,b,d,c]  -  -  -  -  -  bc -  -  ac ad ad ad -  -  -  ad -  -  -  bc -  ac ac ac 
3:[a,c,b,d]  -  cd -  -  -  -  -  cd -  ad ad ad -  -  ab ab ad ab -  -  -  -  -  ab 
4:[a,c,d,b]  -  -  -  -  cb -  -  -  -  ad -  -  -  -  ab ad ad ad cb -  ab ab -  ab 
5:[a,d,b,c]  dc -  -  -  -  -  dc -  ac ac -  ac -  -  -  -  -  ab -  -  ab ab ac ab 
6:[a,d,c,b]  -  -  db -  -  -  -  -  -  -  -  ac db -  ab ab -  ab -  -  ab ac ac ac 
7:[b,a,c,d]  -  -  bc bc bd bc -  -  -  ad -  -  -  bd -  ad bd bd -  bc -  -  -  -  
8:[b,a,d,c]  -  -  bc bd bd bd -  -  -  -  -  ac -  bd -  -  -  -  -  bc -  ac bc bc 
9:[b,c,a,d]  -  cd -  bd bd bd -  cd -  -  -  -  ba ba -  -  ba bd -  -  -  -  ba -  
10:[b,c,d,a] -  -  -  bd -  -  -  -  -  -  ca -  ba bd -  -  bd bd ba ba ca -  ba -  
11:[b,d,a,c] dc -  bc bc -  bc dc -  -  -  -  -  -  -  -  -  ba -  ba ba -  -  ba bc 
12:[b,d,c,a] -  -  -  -  -  bc -  -  da -  -  -  ba ba da -  ba -  ba bc -  -  bc bc 
13:[c,a,b,d] cb cb -  -  cb cd -  cd -  ad cd cd -  -  -  ad -  -  cb -  -  -  -  -  
14:[c,a,d,b] cb cd -  -  cd cd -  cd -  -  -  -  -  -  -  -  -  ab cb -  cb cb -  ab 
15:[c,b,a,d] -  cd -  bd cd cd ca ca -  -  ca cd -  bd -  -  -  -  -  -  ca -  -  -  
16:[c,b,d,a] -  cd -  -  -  -  ca cd -  -  cd cd -  -  -  -  ba -  ca ca ca -  ba -  
17:[c,d,a,b] cb cb db -  cb -  -  -  -  -  ca -  db -  -  -  -  -  ca ca ca cb -  -  
18:[c,d,b,a] -  -  -  -  cb -  ca ca da -  ca -  -  -  da -  -  -  cb ca cb cb -  -  
19:[d,a,b,c] db db db dc -  -  dc -  dc dc -  ac db -  -  -  -  -  -  -  -  ac -  -  
20:[d,a,c,b] dc db dc dc -  -  dc -  -  -  -  -  db -  db db -  ab -  -  -  -  -  ab 
21:[d,b,a,c] dc -  dc dc -  bc da da da dc -  -  -  -  da -  -  -  -  bc -  -  -  -  
22:[d,b,c,a] dc -  -  -  -  -  dc da dc dc -  -  da da da -  ba -  -  -  -  -  ba -  
23:[d,c,a,b] db db db -  cb -  -  -  da -  -  -  da da da db -  -  cb -  -  -  -  -  
24:[d,c,b,a] -  -  db -  -  -  da da da -  ca -  db da db db -  -  -  -  ca -  -  -  
--
J = 1,
F = [[[a, d, b, c], ...

?- J=1, findall( P-S, (pp(P), findall( X->Y, (decisiveness_propagates_at( K, P, A->B, J ), atomic_list_concat( B, Y ), atomic_list_concat( A, X ) ), Z ), length( Z, S ), S \=[]),  F), fig( scf, F ).


             1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
             ------------------------------------------------------------------------
1:[a,b,c,d]  0  0  0  1  0  0  0  0  1  3  1  2  0  1  0  2  2  2  0  0  0  1  0  0  
2:[a,b,d,c]  0  0  0  0  0  1  0  0  1  2  1  3  0  0  0  1  0  0  0  1  0  2  2  2  
3:[a,c,b,d]  0  1  0  0  0  0  0  1  0  2  2  2  0  0  1  3  1  2  0  0  0  0  0  1  
4:[a,c,d,b]  0  0  0  0  1  0  0  0  0  1  0  0  0  0  1  2  1  3  1  0  2  2  0  2  
5:[a,d,b,c]  1  0  0  0  0  0  1  0  2  2  0  2  0  0  0  0  0  1  0  0  1  3  1  2  
6:[a,d,c,b]  0  0  1  0  0  0  0  0  0  0  0  1  1  0  2  2  0  2  0  0  1  2  1  3  
7:[b,a,c,d]  0  0  1  3  1  2  0  0  0  1  0  0  0  2  0  1  2  2  0  1  0  0  0  0  
8:[b,a,d,c]  0  0  1  2  1  3  0  0  0  0  0  1  0  1  0  0  0  0  0  2  0  1  2  2  
9:[b,c,a,d]  0  1  0  2  2  2  0  1  0  0  0  0  1  3  0  0  2  1  0  0  0  0  1  0  
10:[b,c,d,a] 0  0  0  1  0  0  0  0  0  0  1  0  1  2  0  0  3  1  2  2  1  0  2  0  
11:[b,d,a,c] 1  0  2  2  0  2  1  0  0  0  0  0  0  0  0  0  1  0  1  3  0  0  2  1  
12:[b,d,c,a] 0  0  0  0  0  1  0  0  1  0  0  0  2  2  1  0  2  0  1  2  0  0  3  1  
13:[c,a,b,d] 1  3  0  0  2  1  0  2  0  1  2  2  0  0  0  1  0  0  1  0  0  0  0  0  
14:[c,a,d,b] 1  2  0  0  3  1  0  1  0  0  0  0  0  0  0  0  0  1  2  0  2  2  0  1  
15:[c,b,a,d] 0  2  0  1  2  2  1  3  0  0  2  1  0  1  0  0  0  0  0  0  1  0  0  0  
16:[c,b,d,a] 0  1  0  0  0  0  1  2  0  0  3  1  0  0  0  0  1  0  2  2  2  0  1  0  
17:[c,d,a,b] 2  2  1  0  2  0  0  0  0  0  1  0  1  0  0  0  0  0  3  1  2  1  0  0  
18:[c,d,b,a] 0  0  0  0  1  0  2  2  1  0  2  0  0  0  1  0  0  0  2  1  3  1  0  0  
19:[d,a,b,c] 3  1  2  1  0  0  2  0  2  2  0  1  1  0  0  0  0  0  0  0  0  1  0  0  
20:[d,a,c,b] 2  1  3  1  0  0  1  0  0  0  0  0  2  0  2  2  0  1  0  0  0  0  0  1  
21:[d,b,a,c] 2  0  2  2  0  1  3  1  2  1  0  0  0  0  1  0  0  0  0  1  0  0  0  0  
22:[d,b,c,a] 1  0  0  0  0  0  2  1  3  1  0  0  2  2  2  0  1  0  0  0  0  0  1  0  
23:[d,c,a,b] 2  2  2  0  1  0  0  0  1  0  0  0  3  1  2  1  0  0  1  0  0  0  0  0  
24:[d,c,b,a] 0  0  1  0  0  0  2  2  2  0  1  0  2  1  3  1  0  0  0  0  1  0  0  0  
--
J = 1,
F = [[[a, b, c, d], [a, b, c, d]]-0, ...

?- 

?- tmp_mdc(J,B,C,W,X), indexed_profiles( X, D ), \+ swf( _, D ), fig( domain, D ), length(C, N ).


             1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
             ------------------------------------------------------------------------
1:[1,2,3,4]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
2:[1,2,4,3]  -  -  -  -  -  -  -  -  8  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
3:[1,3,2,4]  -  -  -  -  -  2  12 -  -  -  -  -  -  -  9  -  -  -  -  -  -  -  -  -  
4:[1,3,4,2]  11 -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
5:[1,4,2,3]  -  -  -  7  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
6:[1,4,3,2]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
7:[2,1,3,4]  -  -  6  -  -  -  -  -  -  -  -  -  -  -  -  -  -  1  -  -  -  -  -  -  
8:[2,1,4,3]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
9:[2,3,1,4]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
10:[2,3,4,1] 5  -  -  -  -  -  -  -  -  -  3  -  -  -  -  -  -  -  -  -  -  -  -  -  
11:[2,4,1,3] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
12:[2,4,3,1] -  4  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
13:[3,1,2,4] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
14:[3,1,4,2] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
15:[3,2,1,4] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
16:[3,2,4,1] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
17:[3,4,1,2] -  -  -  -  -  -  -  -  -  10 -  -  -  -  -  -  -  -  -  -  -  -  -  -  
18:[3,4,2,1] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
19:[4,1,2,3] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
20:[4,1,3,2] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
21:[4,2,1,3] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
22:[4,2,3,1] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
23:[4,3,1,2] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
24:[4,3,2,1] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
--
J = 1,
B = [a, b],
C = [[c, d], [c, a], [d, a], [b, a], [b, c], [d, c], [a, c], [a|...], [...|...]|...],
W = [a, d],
X = [[7, 18], [3, 6], [10, 11], [12, 2], [10, 1], [7, 3], [5, 4], [2|...], [...|...]|...],
D = [[[2, 1, 3, 4], [3, 4, 2, 1]], [[1, 3, 2, 4], [1, 4, 3, 2]], [[2, 3, 4, 1], [2, 4, 1, 3]], [[2, 4, 3, 1], [1, 2, 4|...]], [[2, 3, 4|...], [1, 2|...]], [[2, 1|...], [1|...]], [[1|...], [...|...]], [[...|...]|...], [...|...]|...],
N = 10 

?- hist1n( (tmp_mdc(J,B,C,W,X),length(X,N), nth1( K, C, B )), K:N:B:W:C ).

 [8:12:[a,b]:[a,d]:[[c,d],[c,a],[d,a],[b,a],[b,c],[d,c],[a,c],[a,b],[d,b],[c,b]],112932]
 [8:12:[a,b]:[b,d]:[[c,d],[c,a],[d,a],[b,a],[b,c],[d,c],[a,c],[a,b],[d,b],[c,b]],113379]
total:226311
true.

?- findall( W:X:B:C, tmp_mdc(J,B,C,W,X), L ), length( P, 100), append( P,_, L ), hist1n(( member( W:X:B:C, P ), length(X,N), nth1( K, C, B ), indexed_profiles( X, D ), \+ swf( _, D ) ), K:N:B:W:C ).

 [8:12:[a,b]:[a,d]:[[c,d],[c,a],[d,a],[b,a],[b,c],[d,c],[a,c],[a,b],[d,b],[c,b]],4]
 [8:12:[a,b]:[b,d]:[[c,d],[c,a],[d,a],[b,a],[b,c],[d,c],[a,c],[a,b],[d,b],[c,b]],6]
total:10

?- tell_goal('tmp_mdc_d.pl',forall, tmp_mdc_d( _, _,_,_,_)).
complete
true .

?- hist1n( (tmp_mdc_d(J,B,C,W,X),length(X,N), nth1( K, C, B )), K:N:B:W:C ).

 [8:12:[a,b]:[a,d]:[[c,d],[c,a],[d,a],[b,a],[b,c],[d,c],[a,c],[a,b],[d,b],[c,b]],2282]
 [8:12:[a,b]:[b,d]:[[c,d],[c,a],[d,a],[b,a],[b,c],[d,c],[a,c],[a,b],[d,b],[c,b]],3718]
total:6000
true.

?- findall( W:X:B:C, tmp_mdc(J,B,C,W,X), L ), length( P, 1000), append( P,_, L ), hist1n(( member( W:X:B:C, P ), length(X,N), nth1( K, C, B ), indexed_profiles( X, D ), \+ swf( _, D ) ), K:N:B:W:C ).

 [8:12:[a,b]:[a,d]:[[c,d],[c,a],[d,a],[b,a],[b,c],[d,c],[a,c],[a,b],[d,b],[c,b]],124]
 [8:12:[a,b]:[b,d]:[[c,d],[c,a],[d,a],[b,a],[b,c],[d,c],[a,c],[a,b],[d,b],[c,b]],138]
total:262

*/


% added: 6 Nov 2023

decisiveness_locally_propagates_pp_indices( J, L ):-
	 member( J, [ 1, 2 ] ),
	 G = decisiveness_propagates_at( K, P, B, J ),
	 setof( K, P ^ B ^ G, L ).

profiles_decisiveness_locally_propagates( J, L, D ):-
	 decisiveness_locally_propagates_pp_indices( J, L ),
	 indexed_profiles( L, D ).

/*

?- chalt([a,b,c]).

?- profiles_decisiveness_locally_propagates( 1, L, D ), fig( domain, D ).


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  1  -  -  
2:[a,c,b]  -  -  -  -  -  2  
3:[b,a,c]  -  3  -  -  -  -  
4:[b,c,a]  -  -  -  -  4  -  
5:[c,a,b]  5  -  -  -  -  -  
6:[c,b,a]  -  -  6  -  -  -  
--
L = [[1, 4], [2, 6], [3, 2], [4, 5], [5, 1], [6, 3]],
D = [[[a, b, c], [b, c, a]], [[a, c, b], [c, b, a]], [[b, a, c], [a, c, b]], [[b, c, a], [c, a, b]], [[c, a, b], [a, b|...]], [[c, b|...], [b|...]]] .


?- chalt([a,b,c,d]).

?- decisiveness_locally_propagates( 1, B,L ).
B = ([a, b]->[a, c]),
L = [[1, 9], [1, 10], [1, 12], [1, 22], [2, 9], [2, 10], [2, 12], [2|...], [...|...]|...] .

*/



% modified: 6 Nov 2023
 
decisiveness_locally_propagates( J, B, L ):-
	 member( J, [ 1, 2 ] ),
	 G = decisiveness_propagates_at( K, P, B, J ),
	 setof( K, P ^ G, L ).

show_decisiveness_locally_propagates( J ):-
	 decisiveness_locally_propagates( J, B, L ),
	 nl,
	 write( B; L ),
	 fail
	 ;
	 true.

/*


?- chalt([a,b,c]).

?- show_decisiveness_locally_propagates( 1 ).

[a,b]->[a,c];[[2,4]]
[a,c]->[a,b];[[1,5]]
[b,a]->[b,c];[[3,1]]
[b,c]->[b,a];[[4,6]]
[c,a]->[c,b];[[6,2]]
[c,b]->[c,a];[[5,3]]
true.

?- show_decisiveness_locally_propagates( 2 ).

[a,b]->[a,c];[[4,2]]
[a,c]->[a,b];[[5,1]]
[b,a]->[b,c];[[1,3]]
[b,c]->[b,a];[[6,4]]
[c,a]->[c,b];[[2,6]]
[c,b]->[c,a];[[3,5]]
true.

*/




% modified: 28 Dec 2019
% modified: 31 Dec 2019 renamed decisiveness_ring/6 to decisiveness_chain/6. 


decisiveness_chain( _, _, C, C, L, L ).

decisiveness_chain( J, B, C, D, L, R ):-
	 decisiveness_propagates_at( K, _, A -> B, J ),
	 \+ member( A, C ),
	 \+ member( K, L ),
	 decisiveness_chain( J, A, [ A | C ], D, [ K | L ], R ).
	 %decisiveness_chain( J, A, [ B | C ], D, [ K | L ], R ).  % wrong

decisiveness_ring( J, B, [ B | C ], L ):-
%	 R = [ [ 1, _ ] | _ ],
	 decisiveness_chain( J, B, [  ], [ B | C ], [ ], L ).


/*

?- [arrow2024x].
true.

?- chalt([a,b,c]).
true.

?- decisiveness_sat( 1, [a,b], B, X, Y ), length( B, N ).
B = X, X = [],
Y = [[a, b], [a, c], [b, a], [b, c], [c, a], [c, b]],
N = 0 ;
B = [[c, b]],
X = [[2, 3]],
Y = [[a, b], [a, c], [b, a], [b, c], [c, a]],
N = 1 ;
B = [[c, a], [c, b]],
X = [[5, 1], [2, 3]],
Y = [[a, b], [a, c], [b, a], [b, c]],
N = 2 ;
B = [[b, a], [c, a], [c, b]],
X = [[6, 2], [5, 1], [2, 3]],
Y = [[a, b], [a, c], [b, c]],
N = 3 ;
B = [[b, c], [b, a], [c, a], [c, b]],
X = [[4, 5], [6, 2], [5, 1], [2, 3]],
Y = [[a, b], [a, c]],
N = 4 ;
B = [[a, c], [b, c], [b, a], [c, a], [c, b]],
X = [[3, 6], [4, 5], [6, 2], [5, 1], [2, 3]],
Y = [[a, b]],
N = 5 ;
B = [[a, c]],
X = [[2, 6]],
Y = [[a, b], [b, a], [b, c], [c, a], [c, b]],
N = 1 ;
B = [[b, c], [a, c]],
X = [[1, 5], [2, 6]],
Y = [[a, b], [b, a], [c, a], [c, b]],
N = 2 ;
B = [[b, a], [b, c], [a, c]],
X = [[3, 2], [1, 5], [2, 6]],
Y = [[a, b], [c, a], [c, b]],
N = 3 ;
B = [[c, a], [b, a], [b, c], [a, c]],
X = [[4, 1], [3, 2], [1, 5], [2, 6]],
Y = [[a, b], [c, b]],
N = 4 ;
B = [[c, b], [c, a], [b, a], [b, c], [a, c]],
X = [[6, 3], [4, 1], [3, 2], [1, 5], [2, 6]],
Y = [[a, b]],
N = 5 ;
false.


?- decisiveness_ring( 1, [ a, b ], B, R ), indexed_profiles( R, D ), \+ swf( F, D ), nl, write( R ), fail.

[[5,4],[2,3]]
[[1,4],[3,6],[4,5],[6,2],[5,1],[2,3]]
[[5,4],[6,3],[4,1],[3,2],[1,5],[2,6]]
[[1,4],[2,6]]
false.

?- decisiveness_ring( 1, [ a, b ], B, R ), indexed_profiles( R, D ), swf( F, D ).
false.


?- time(decisiveness_ring( 1, [ a, b ], B, Y )),indexed_profiles( Y, D ), fig_s( domain, D ), count( swf( _,D), N ), write( N ), fail.
% 13,475 inferences, 0.000 CPU in 0.001 seconds (0% CPU, Infinite Lips)


           3  4  
           ------
2:[a,c,b]  2  -  
5:[c,a,b]  -  1  
--0
% 181,454 inferences, 0.016 CPU in 0.010 seconds (162% CPU, 11613056 Lips)


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  1  -  -  
2:[a,c,b]  -  -  6  -  -  -  
3:[b,a,c]  -  -  -  -  -  2  
4:[b,c,a]  -  -  -  -  3  -  
5:[c,a,b]  5  -  -  -  -  -  
6:[c,b,a]  -  4  -  -  -  -  
--0
% 138,077 inferences, 0.000 CPU in 0.007 seconds (0% CPU, Infinite Lips)


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  5  -  
2:[a,c,b]  -  -  -  -  -  6  
3:[b,a,c]  -  4  -  -  -  -  
4:[b,c,a]  3  -  -  -  -  -  
5:[c,a,b]  -  -  -  1  -  -  
6:[c,b,a]  -  -  2  -  -  -  
--0
% 86,286 inferences, 0.016 CPU in 0.004 seconds (387% CPU, 5522304 Lips)


           4  6  
           ------
1:[a,b,c]  1  -  
2:[a,c,b]  -  2  
--0
% 122,161 inferences, 0.016 CPU in 0.007 seconds (238% CPU, 7818304 Lips)
false.



?- chalt([a,b,c,d]).
true.

?- decisiveness_ring( 1, [ a, b ], B, R ), indexed_profiles( R, D ), swf( F, D ).
...



?- time((decisiveness_ring( 1, [ a, b ], B, X ))), assert(tmp_sad( 1,[a,b],B,X)),indexed_profiles( X, D ), fig_s( domain, D ).
% 233,124 inferences, 0.016 CPU in 0.013 seconds (124% CPU, 14919936 Lips)


             1  7  10 
             ---------
3:[a,c,b,d]  -  3  -  
4:[a,c,d,b]  2  -  -  
17:[c,d,a,b] -  -  1  
--
B = [[a, b], [d, b], [c, b]],
X = [[17, 10], [4, 1], [3, 7]],
D = [[[c, d, a, b], [b, c, d, a]], [[a, c, d, b], [a, b, c, d]], [[a, c, b, d], [b, a, c, d]]] ;

?- 

?- decisiveness_ring( 1, [ a, b ], B, R ), indexed_profiles( R, D ), swf( F, D ).

false.

?- 

*/


% added: 6 Nov 2025
% modified: 18 Nov 2025

decisiveness_sat( J, B, C, L, Z ):-
	 decisiveness_chain( J, B, [ ], C, [ ], L ), 
	 %\+ member( B, C ),
	 % unvisited pairs
	 %setof( [X,Y], ( x( X ), x( Y ), X \= Y, \+ member( [X,Y], C ) ), Z ).
	 undecided_pairs( C, Z ).  

% added: 18 Nov 2025

undecided_pairs( C, Z ):-
	 findall( [X,Y], (
		 x( X ), x( Y ), X \= Y
	 ), L ),
	 subtract( L, C, Z ).


/*

?- chalt([a,b,c]).

?- hist1n((decisiveness_sat( 1, A, B, X, Y ),Y=[A],indexed_profiles( X, D ), count( swf( _, D ), N ) ),  N;Y ), fail.

 [(5;[[a,b]]),1]
 [(5;[[a,c]]),1]
 [(5;[[b,a]]),1]
 [(5;[[b,c]]),1]
 [(5;[[c,a]]),1]
 [(5;[[c,b]]),1]
total:6
false.

?- between( 0,10, N ), decisiveness_sat( 1, [a,b], B, X, Y ), length( Y, N ).
N = 1,
B = [[b, a], [b, c], [a, c], [a, b], [c, b]],
X = [[3, 2], [1, 5], [2, 6], [5, 4], [2, 3]],
Y = [[c, a]] .

?- 

?- W=[a,b],J=1,decisiveness_sat( J, W, C, L, [Z] ).
W = [a, b],
J = 1,
C = [[b, a], [b, c], [a, c], [a, b], [c, b]],
L = [[3, 2], [1, 5], [2, 6], [5, 4], [2, 3]],
Z = [c, a] ;
W = Z, Z = [a, b],
J = 1,
C = [[a, c], [b, c], [b, a], [c, a], [c, b]],
L = [[3, 6], [4, 5], [6, 2], [5, 1], [2, 3]] ;
W = Z, Z = [a, b],
J = 1,
C = [[c, b], [c, a], [b, a], [b, c], [a, c]],
L = [[6, 3], [4, 1], [3, 2], [1, 5], [2, 6]] ;
W = [a, b],
J = 1,
C = [[b, a], [c, a], [c, b], [a, b], [a, c]],
L = [[6, 2], [5, 1], [2, 3], [1, 4], [2, 6]],
Z = [b, c] ;
false.


?- hist1n((decisiveness_sat( 1, A, B, X, Y ),Y=[Z],indexed_profiles( X, D ), count( swf( _, D ), N )), N ).

 [3,6]
 [5,6]
total:12
true.


?- decisiveness_sat( 1, [a,b], B, X, Y ),Y=[Z],indexed_profiles( X, D ), swf( F, D ), fig( swf, F ).


           1  2  3  4  5  6  
           ------------------
1:[a,b,c]  -  -  -  -  1  -  
2:[a,c,b]  -  -  2  -  -  2  
3:[b,a,c]  -  1  -  -  -  -  
4:[b,c,a]  -  -  -  -  -  -  
5:[c,a,b]  -  -  -  5  -  -  
6:[c,b,a]  -  -  -  -  -  -  
--
B = [[b, a], [b, c], [a, c], [a, b], [c, b]],
X = [[3, 2], [1, 5], [2, 6], [5, 4], [2, 3]],
Y = [[c, a]],
Z = [c, a],
D = [[[b, a, c], [a, c, b]], [[a, b, c], [c, a, b]], [[a, c, b], [c, b, a]], [[c, a, b], [b, c, a]], [[a, c, b], [b, a|...]]],
F = [[[b, a, c], [a, c, b]]-[a, b, c], [[a, b, c], [c, a, b]]-[a, b, c], [[a, c, b], [c, b, a]]-[a, c, b], [[c, a, b], [b, c|...]]-[c, a, b], [[a, c|...], [b|...]]-[a, c, b]] .

?- 

?- chalt([a,b,c,d]).
true.

?- between( 1,10, N ), decisiveness_sat( 1, [a,b], B, X, Y ), length( Y, N ).
N = 1,
B = [[a, d], [b, d], [c, d], [c, a], [b, a], [b, c], [d, c], [a|...], [...|...]|...],
X = [[7, 18], [3, 6], [10, 11], [9, 1], [7, 3], [5, 4], [2, 9], [3|...], [...|...]|...],
Y = [[d, a]] .


?- decisiveness_sat( 1, [a,b], B, X, Y ),Y=[Z],indexed_profiles( X, D ), swf( F, D ), fig_s( swf, F ).


             1  3  4  6  7  9  10 11 15 18 
             ------------------------------
2:[a,b,d,c]  -  -  -  -  -  2  -  -  -  -  
3:[a,c,b,d]  -  -  -  6  3  -  -  -  3  -  
4:[a,c,d,b]  4  -  -  -  -  -  -  -  -  -  
5:[a,d,b,c]  -  -  5  -  -  -  -  -  -  -  
7:[b,a,c,d]  -  1  -  -  -  -  -  -  -  -  
8:[b,a,d,c]  -  -  -  -  -  -  -  -  -  21 
9:[b,c,a,d]  1  -  -  -  -  -  -  -  -  -  
10:[b,c,d,a] -  -  -  -  -  -  -  11 -  -  
17:[c,d,a,b] -  -  -  -  -  -  17 -  -  -  
--
B = [[a, d], [b, d], [c, d], [c, a], [b, a], [b, c], [d, c], [a|...], [...|...]|...],
X = [[8, 18], [3, 6], [10, 11], [9, 1], [7, 3], [5, 4], [2, 9], [3|...], [...|...]|...],
Y = [[d, a]],
Z = [d, a],
D = [[[b, a, d, c], [c, d, b, a]], [[a, c, b, d], [a, d, c, b]], [[b, c, d, a], [b, d, a, c]], [[b, c, a, d], [a, b, c|...]], [[b, a, c|...], [a, c|...]], [[a, d|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
F = [[[b, a, d, c], [c, d, b, a]]-[d, b, a, c], [[a, c, b, d], [a, d, c, b]]-[a, d, c, b], [[b, c, d, a], [b, d, a|...]]-[b, d, a, c], [[b, c, a|...], [a, b|...]]-[a, b, c, d], [[b, a|...], [a|...]]-[a, b, c|...], [[a|...], [...|...]]-[a, d|...], [[...|...]|...]-[a|...], [...|...]-[...|...], ... - ...|...] .


*/


% revised: 18 Nov 2025

dasgupta_domain_pp( [ [ 1,2,3,4 ], [ 3,4,1,2 ] ] ).
dasgupta_domain_pp( [ [ 2,4,1,3 ], [ 1,3,2,4 ] ] ).
dasgupta_domain_pp( [ [ 3,1,4,2 ], [ 4,2,3,1 ] ] ).
dasgupta_domain_pp( [ [ 4,3,2,1 ], [ 2,1,4,3 ] ] ).

dasgupta_domain_pp_index( K, P ):-
	 dasgupta_domain_pp( P ),
	 indexed_profiles( [K], [P] ).

/*

?- findall(P, dasgupta_domain_pp(P), D ), fig_s( domain, D ), swf( _, D ).


             3  8  17 22 
             ------------
1:[1,2,3,4]  -  -  1  -  
11:[2,4,1,3] 2  -  -  -  
14:[3,1,4,2] -  -  -  3  
24:[4,3,2,1] -  4  -  -  
--
false.

?- hist1n((dasgupta_domain_pp_index(I, P), x(X), x(Y), A=[X,Y], decisiveness_propagates_at( I, _, A, 1 )), A:X ).

 [([1,3]->[1,4]):[1,17],1]
 [([1,4]->[1,2]):[14,22],1]
 [([2,1]->[2,3]):[11,3],1]
 [([2,3]->[2,4]):[1,17],1]
 [([3,2]->[3,1]):[24,8],1]
 [([3,4]->[3,2]):[14,22],1]
 [([4,1]->[4,3]):[11,3],1]
 [([4,2]->[4,1]):[24,8],1]
total:8
true.

?- hist1n((dasgupta_domain_pp_index(I, P), decisiveness_propagates_at_full( I, _, A->B, 1 )), A->B:I ).

 [([1,2]->[3,2]:[14,22]),1]
 [([1,3]->[1,4]:[1,17]),1]
 [([1,4]->[1,2]:[14,22]),1]
 [([1,4]->[3,4]:[14,22]),1]
 [([2,1]->[2,3]:[11,3]),1]
 [([2,3]->[1,3]:[1,17]),1]
 [([2,3]->[2,4]:[1,17]),1]
 [([2,4]->[1,4]:[1,17]),1]
 [([3,1]->[4,1]:[24,8]),1]
 [([3,2]->[3,1]:[24,8]),1]
 [([3,2]->[4,2]:[24,8]),1]
 [([3,4]->[3,2]:[14,22]),1]
 [([4,1]->[2,1]:[11,3]),1]
 [([4,1]->[4,3]:[11,3]),1]
 [([4,2]->[4,1]:[24,8]),1]
 [([4,3]->[2,3]:[11,3]),1]
total:16
true.

?- between(0,10, K ), dasgupta_span_tree( 1, [1,3], C, L, Z ), length( Z, K ), length( L, N ), \+ ( nth1( J, L, X ), nth1( J, C, Y ), nl, \+ write( [J]:X;Y ) ) .

[1]:[24,8];[4,2]
[2]:[14,22];[3,4]
[3]:[1,17];[2,4]
[4]:[1,17];[1,3]
[5]:[14,22];[1,4]
[6]:[14,22];[1,2]
[7]:[24,8];[3,2]
[8]:[11,3];[4,3]
[9]:[24,8];[3,1]
[10]:[11,3];[4,1]
[11]:[11,3];[2,1]
[12]:[1,17];[2,3]
K = 0,
C = [[4, 2], [3, 4], [2, 4], [1, 3], [1, 4], [1, 2], [3, 2], [4|...], [...|...]|...],
L = [[24, 8], [14, 22], [1, 17], [1, 17], [14, 22], [14, 22], [24, 8], [11|...], [...|...]|...],
Z = [],
N = 12 .

 12 -> 32 :③
 13 -> 14 :①
 14 -> 12 :③
 14 -> 34 :③
 21 -> 23 :②
 23 -> 13 :①
 23 -> 24 :①
 24 -> 14 :①
 31 -> 41 :④
 32 -> 31 :④
 32 -> 42 :④
 34 -> 32 :③
 41 -> 21 :②
 41 -> 43 :②
 42 -> 41 :④
 43 -> 23 :②


?- 

*/


dasgupta_span_tree( _, _, C, C, L, L ).

dasgupta_span_tree( J, _, C, D, L, R ):-
	 dasgupta_domain_pp_index( K, _ ),
	 \+ \+ member( K, L ),
	 decisiveness_propagates_at_full( K, _, A -> B, J ),
	 \+ \+ member( B, C ),
	 \+ member( A, C ),
	 dasgupta_span_tree( J, A, [ A | C ], D, [ K | L ], R ).

dasgupta_span_tree( J, B, C, D, L, R ):-
	 dasgupta_domain_pp_index( K, _ ),
	 decisiveness_propagates_at_full( K, _, A -> B, J ),
	 \+ member( A, C ),
	 dasgupta_span_tree( J, A, [ A | C ], D, [ K | L ], R ).

dasgupta_span_tree( J, B, C, L, Z ):-
	 dasgupta_span_tree( J, B, [ ], C, [ ], L ),
 	 undecided_pairs( [B|C], Z ).


fast_dasgupta_span_tree( J, B, C, L, Z, K ):-
	 between( 0, 10, K ),
	 dasgupta_span_tree( J, B, C, L, Z ),
	 length( Z, K ).

dasgupta_span_tree_ex( J, B, C + C_add, L, Z -> Zx, Add ):-
	 fast_dasgupta_span_tree( J, B, C, L, Z, _ ),
	 findall( K:A->Bx, (
		 member( A, Z ),
		 once( (
			 dasgupta_domain_pp_index( K, _ ),
			 decisiveness_propagates_at_full( K, _, A -> Bx, J ),
			 member( Bx, C )
		 ) )
	 ), Add ),
	 findall( A, member( K: A->Bx, Add ), C_add ),
	 subtract( Z, C_add, Zx ).

/*


?- [arrow2024x].
true.

?-  between(1,10, K ), dasgupta_span_tree( J, B, C, L, Z ), length( Z, K ), indexed_profiles( L, D ), fig_s( domain, D ), hist1n( bagof( V, nth1( V, D, P ), H ), P:H ).


             3  8  17 22 
             ------------
1:[1,2,3,4]  -  -  2  -  
11:[2,4,1,3] 6  -  -  -  
14:[3,1,4,2] -  -  -  1  
24:[4,3,2,1] -  5  -  -  
--
 [[[1,2,3,4],[3,4,1,2]]:[2,10,11],1]
 [[[2,4,1,3],[1,3,2,4]]:[6,8,9],1]
 [[[3,1,4,2],[4,2,3,1]]:[1,3,4],1]
 [[[4,3,2,1],[2,1,4,3]]:[5,7],1]
total:4
K = J, J = 1,
B = [1, 4],
C = [[3, 4], [2, 4], [1, 4], [1, 2], [3, 2], [4, 3], [3, 1], [4|...], [...|...]|...],
L = [[14, 22], [1, 17], [14, 22], [14, 22], [24, 8], [11, 3], [24, 8], [11|...], [...|...]|...],
Z = [[4, 2]],
D = [[[3, 1, 4, 2], [4, 2, 3, 1]], [[1, 2, 3, 4], [3, 4, 1, 2]], [[3, 1, 4, 2], [4, 2, 3, 1]], [[3, 1, 4, 2], [4, 2, 3|...]], [[4, 3, 2|...], [2, 1|...]], [[2, 4|...], [1|...]], [[4|...], [...|...]], [[...|...]|...], [...|...]|...] .


?- directed_spanning_tree(23, Tree).


?- directed_spanning_tree(13, Tree).
Tree = [(13->14), (14->12), (14->34), (34->32), (32->31), (32->42), (42->41), (41->21), (... -> ...)|...] .

?- directed_spanning_tree(13, Tree), member( X, Tree), nl, write( X ), fail.

13->14
14->12
14->34
34->32
32->31
32->42
42->41
41->21
41->43
43->23
23->24
false.

?- 



debug

?- between(1,10, K ), dasgupta_span_tree( J, B, C, L, Z ), length( Z, K ), indexed_profiles( L, D ), fig_s( domain, D ), hist1n( bagof( V, nth1( V, D, P ), H ), P:H ),  findall( I:A->Bx, ( member( A, Z ), dasgupta_domain_pp_index( I, _ ), decisiveness_propagates_at_full( I, _, A->Bx, 1 ) ), S ).


             3  8  17 22 
             ------------
1:[1,2,3,4]  -  -  1  -  
11:[2,4,1,3] 6  -  -  -  
14:[3,1,4,2] -  -  -  2  
24:[4,3,2,1] -  4  -  -  
--
 [[[1,2,3,4],[3,4,1,2]]:[1,8],1]
 [[[2,4,1,3],[1,3,2,4]]:[6,7],1]
 [[[3,1,4,2],[4,2,3,1]]:[2,3],1]
 [[[4,3,2,1],[2,1,4,3]]:[4,5],1]
total:4
K = 3,
J = 1,
B = [1, 3],
C = [[2, 4], [1, 4], [1, 2], [3, 2], [3, 1], [4, 1], [2, 1], [2|...], [...|...]],
L = [[1, 17], [14, 22], [14, 22], [24, 8], [24, 8], [11, 3], [11, 3], [1|...]],
Z = [[3, 4], [4, 2], [4, 3]],
D = [[[1, 2, 3, 4], [3, 4, 1, 2]], [[3, 1, 4, 2], [4, 2, 3, 1]], [[3, 1, 4, 2], [4, 2, 3, 1]], [[4, 3, 2, 1], [2, 1, 4|...]], [[4, 3, 2|...], [2, 1|...]], [[2, 4|...], [1|...]], [[2|...], [...|...]], [[...|...]|...]],
S = [([14, 22]:[3, 4]->[3, 2]), ([24, 8]:[4, 2]->[4, 1]), ([11, 3]:[4, 3]->[2, 3])] .


?- Z = [[3, 4], [4, 2], [4, 3]], findall( I:A->B, ( member( A, Z ), dasgupta_domain_pp_index( I, _ ), decisiveness_propagates_at_full( I, _, A->B, 1 ) ), S ), subtract( S, Z, W ).
Z = [[3, 4], [4, 2], [4, 3]],
S = W, W = [([14, 22]:[3, 4]->[3, 2]), ([24, 8]:[4, 2]->[4, 1]), ([11, 3]:[4, 3]->[2, 3])].


?- findall( I, dasgupta_domain_pp_index( I, _ ), D ).
D = [[1, 17], [11, 3], [14, 22], [24, 8]].


?- dasgupta_span_tree_ex( J, B, C,  L, Z, Add ).
J = 2,
B = [4, 2],
C = [[3, 1], [3, 2], [3, 4], [1, 4], [1, 3], [2, 3], [2|...], [...|...]|...]+[[1, 2], [2, 4], [4, 3]],
L = [[1, 17], [11, 3], [11, 3], [24, 8], [24, 8], [14, 22], [14, 22], [1|...]],
Z = ([[1, 2], [2, 4], [4, 3]]->[]),
Add = [([11, 3]:[1, 2]->[1, 4]), ([24, 8]:[2, 4]->[2, 3]), ([14, 22]:[4, 3]->[4, 1])] .

?- 


?- K=0, dasgupta_span_tree( J, B, C, L, Z ), length( Z, K ), indexed_profiles( L, D ), fig_s( domain, D ), hist1n( bagof( V, nth1( V, D, P ), H ), P:H ).
false.


%??

?- dasgupta_domain_pp(P), indexed_profiles([X], [P]), decisiveness_propagates_at( X, _, [4,1] -> [4,3], J ).
P = [[2, 4, 1, 3], [1, 3, 2, 4]],
X = [11, 3],
J = 1 .


*/


span_decisive_tree( _, _, C, C, L, L ).

span_decisive_tree( J, _, C, D, L, R ):-
	 decisiveness_propagates_at_full( K, _, A -> B, J ),
	 \+ \+ member( K, L ),
	 \+ \+ member( B, C ),
	 \+ member( A, C ),
	 dasgupta_span_tree( J, A, [ A | C ], D, [ K | L ], R ).

span_decisive_tree( J, B, C, D, L, R ):-
	 decisiveness_propagates_at( K, _, A -> B, J ),
	 \+ member( K, L ), 
	 \+ member( A, C ), 
	 span_decisive_tree( J, A, [ A | C ], D, [ K | L ], R ).

span_decisive_tree( J, B, C, L, Z ):-
	 span_decisive_tree( J, B, [ ], C, [ ], L ), 
	 %\+ member( B, C ),  % already checked
	 % unvisited pairs
	 %setof( [X,Y], ( x( X ), x( Y ), X \= Y, \+ member( [X,Y], C ) ), Z ).
 	 undecided_pairs( [B|C], Z ).


/*

?- [arrow2024x].
true.

?- N=0, span_decisive_tree( J, B, C, L, Z ), length(Z,N), indexed_profiles( L, D ), fig_s( domain, D ).


             1  2  3  4  9  10 11 12 15 17 
             ------------------------------
1:[1,2,3,4]  -  -  -  7  -  -  -  -  -  6  
2:[1,2,4,3]  -  -  -  -  -  -  -  5  -  -  
3:[1,3,2,4]  -  11 -  -  -  -  -  -  4  -  
4:[1,3,4,2]  12 -  -  -  -  -  -  -  -  -  
5:[1,4,2,3]  2  -  -  -  -  -  -  -  -  -  
7:[2,1,3,4]  -  -  8  -  -  -  -  -  -  -  
9:[2,3,1,4]  9  -  -  -  -  -  -  -  -  -  
10:[2,3,4,1] -  -  -  -  -  -  10 -  -  -  
12:[2,4,3,1] -  -  -  -  1  -  -  -  -  -  
17:[3,4,1,2] -  -  -  -  -  3  -  -  -  -  
--
N = 0,
J = 2,
B = [2, 4],
C = [[1, 4], [3, 4], [2, 4], [2, 1], [3, 1], [4, 1], [4, 2], [3|...], [...|...]|...],
L = [[12, 9], [5, 1], [17, 10], [3, 15], [2, 12], [1, 17], [1, 4], [7|...], [...|...]|...],
Z = [],
D = [[[2, 4, 3, 1], [2, 3, 1, 4]], [[1, 4, 2, 3], [1, 2, 3, 4]], [[3, 4, 1, 2], [2, 3, 4, 1]], [[1, 3, 2, 4], [3, 2, 1|...]], [[1, 2, 4|...], [2, 4|...]], [[

*/



% wrong?

minimal_decisive_chain( J, W, C, Z, [K|L] ):-
	 decisiveness_sat( J, W, [B|C], L, [Z] ),
	 decisiveness_propagates_at( K, _, A -> B, J ),
	 \+ member( A, C ),
	 \+ member( K, L ).


/*


?- chalt([a,b,c,d]).
true.

?- minimal_decisive_chain( 1, [a,b], C, Z, L ), assert( tmp_mdc( 1,[a,b],C,Z,L) ), fail.

% long after

?- hist1n( tmp_mdc( J,W,B,X,Y), X ).
 [[a,d],112932]
 [[b,d],113379]
total:226311
true.

?- 

?- tmp_mdc( 1,[a,b],C,Z,X), indexed_profiles( Z, D ), count( swf(_,D), 0 ), fig( domain, D ).


             1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
             ------------------------------------------------------------------------
1:[a,b,c,d]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
2:[a,b,d,c]  -  -  -  -  -  -  -  -  8  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
3:[a,c,b,d]  -  -  -  -  -  2  12 -  -  -  -  -  -  -  9  -  -  -  -  -  -  -  -  -  
4:[a,c,d,b]  11 -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
5:[a,d,b,c]  -  -  -  7  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
6:[a,d,c,b]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
7:[b,a,c,d]  -  -  6  -  -  -  -  -  -  -  -  -  -  -  -  -  -  1  -  -  -  -  -  -  
8:[b,a,d,c]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
9:[b,c,a,d]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
10:[b,c,d,a] 5  -  -  -  -  -  -  -  -  -  3  -  -  -  -  -  -  -  -  -  -  -  -  -  
11:[b,d,a,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
12:[b,d,c,a] -  4  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
13:[c,a,b,d] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
14:[c,a,d,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
15:[c,b,a,d] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
16:[c,b,d,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
17:[c,d,a,b] -  -  -  -  -  -  -  -  -  10 -  -  -  -  -  -  -  -  -  -  -  -  -  -  
18:[c,d,b,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
19:[d,a,b,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
20:[d,a,c,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
21:[d,b,a,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
22:[d,b,c,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
23:[d,c,a,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
24:[d,c,b,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
--
B = [[c, d], [c, a], [d, a], [b, a], [b, c], [d, c], [a, c], [a|...], [...|...]|...],
X = [a, d],
Y = [[7, 18], [3, 6], [10, 11], [12, 2], [10, 1], [7, 3], [5, 4], [2|...], [...|...]|...],
D = [[[b, a, c, d], [c, d, b, a]], [[a, c, b, d], [a, d, c, b]], [[b, c, d, a], [b, d, a, c]], [[b, d, c, a], [a, b, d|...]], [[b, c, d|...], [a, b|...]], [[b, a|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...] ;


             1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
             ------------------------------------------------------------------------
1:[a,b,c,d]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
2:[a,b,d,c]  -  -  -  -  -  -  -  -  8  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
3:[a,c,b,d]  -  -  -  -  -  -  12 -  -  -  -  -  -  -  9  -  -  -  -  -  -  -  -  -  
4:[a,c,d,b]  11 -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
5:[a,d,b,c]  -  -  -  7  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
6:[a,d,c,b]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
7:[b,a,c,d]  -  -  6  -  -  -  -  -  -  -  -  -  -  -  -  -  -  1  -  -  -  -  -  -  
8:[b,a,d,c]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
9:[b,c,a,d]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
10:[b,c,d,a] 5  -  -  -  -  -  -  -  -  -  3  -  -  -  -  -  -  -  -  -  -  -  -  -  
11:[b,d,a,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
12:[b,d,c,a] -  4  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
13:[c,a,b,d] -  -  -  -  -  2  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
14:[c,a,d,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
15:[c,b,a,d] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
16:[c,b,d,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
17:[c,d,a,b] -  -  -  -  -  -  -  -  -  10 -  -  -  -  -  -  -  -  -  -  -  -  -  -  
18:[c,d,b,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
19:[d,a,b,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
20:[d,a,c,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
21:[d,b,a,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
22:[d,b,c,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
23:[d,c,a,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
24:[d,c,b,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
--
B = [[c, d], [c, a], [d, a], [b, a], [b, c], [d, c], [a, c], [a|...], [...|...]|...],
X = [a, d],
Y = [[7, 18], [13, 6], [10, 11], [12, 2], [10, 1], [7, 3], [5, 4], [2|...], [...|...]|...],
D = [[[b, a, c, d], [c, d, b, a]], [[c, a, b, d], [a, d, c, b]], [[b, c, d, a], [b, d, a, c]], [[b, d, c, a], [a, b, d|...]], [[b, c, d|...], [a, b|...]], [[b, a|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...] ;
,,,

?- tmp_mdc( 1,[a,b],B,X,Y), indexed_profiles( Y, D ), count( swf(_,D), 0 ), nth1( J, B, [a,b] ).
B = [[c, d], [c, a], [d, a], [b, a], [b, c], [d, c], [a, c], [a|...], [...|...]|...],
X = [a, d],
Y = [[7, 18], [3, 6], [10, 11], [12, 2], [10, 1], [7, 3], [5, 4], [2|...], [...|...]|...],
D = [[[b, a, c, d], [c, d, b, a]], [[a, c, b, d], [a, d, c, b]], [[b, c, d, a], [b, d, a, c]], [[b, d, c, a], [a, b, d|...]], [[b, c, d|...], [a, b|...]], [[b, a|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
J = 8 ;
B = [[c, d], [c, a], [d, a], [b, a], [b, c], [d, c], [a, c], [a|...], [...|...]|...],
X = [a, d],
Y = [[7, 18], [13, 6], [10, 11], [12, 2], [10, 1], [7, 3], [5, 4], [2|...], [...|...]|...],
D = [[[b, a, c, d], [c, d, b, a]], [[c, a, b, d], [a, d, c, b]], [[b, c, d, a], [b, d, a, c]], [[b, d, c, a], [a, b, d|...]], [[b, c, d|...], [a, b|...]], [[b, a|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
J = 8 ;
B = [[c, d], [c, a], [d, a], [b, a], [b, c], [d, c], [a, c], [a|...], [...|...]|...],
X = [a, d],
Y = [[7, 18], [15, 6], [10, 11], [12, 2], [10, 1], [7, 3], [5, 4], [2|...], [...|...]|...],
D = [[[b, a, c, d], [c, d, b, a]], [[c, b, a, d], [a, d, c, b]], [[b, c, d, a], [b, d, a, c]], [[b, d, c, a], [a, b, d|...]], [[b, c, d|...], [a, b|...]], [[b, a|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
J = 8 


% 

?- tmp_mdc( 1,[a,b],B,X,Y), indexed_profiles( Y, D ), count( swf(_,D), 0 ), length(A,9),append( A, C, D ), count( swf(_,C), N ), fig( domain, C ).


             1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
             ------------------------------------------------------------------------
1:[a,b,c,d]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
2:[a,b,d,c]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
3:[a,c,b,d]  -  -  -  -  -  -  3  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
4:[a,c,d,b]  2  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
5:[a,d,b,c]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
6:[a,d,c,b]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
7:[b,a,c,d]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
8:[b,a,d,c]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
9:[b,c,a,d]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
10:[b,c,d,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
11:[b,d,a,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
12:[b,d,c,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
13:[c,a,b,d] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
14:[c,a,d,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
15:[c,b,a,d] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
16:[c,b,d,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
17:[c,d,a,b] -  -  -  -  -  -  -  -  -  1  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
18:[c,d,b,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
19:[d,a,b,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
20:[d,a,c,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
21:[d,b,a,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
22:[d,b,c,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
23:[d,c,a,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
24:[d,c,b,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
--
B = [[c, d], [c, a], [d, a], [b, a], [b, c], [d, c], [a, c], [a|...], [...|...]|...],
X = [a, d],
Y = [[7, 18], [3, 6], [10, 11], [12, 2], [10, 1], [7, 3], [5, 4], [2|...], [...|...]|...],
D = [[[b, a, c, d], [c, d, b, a]], [[a, c, b, d], [a, d, c, b]], [[b, c, d, a], [b, d, a, c]], [[b, d, c, a], [a, b, d|...]], [[b, c, d|...], [a, b|...]], [[b, a|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
A = [[[b, a, c, d], [c, d, b, a]], [[a, c, b, d], [a, d, c, b]], [[b, c, d, a], [b, d, a, c]], [[b, d, c, a], [a, b, d|...]], [[b, c, d|...], [a, b|...]], [[b, a|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]],
C = [[[c, d, a, b], [b, c, d, a]], [[a, c, d, b], [a, b, c, d]], [[a, c, b, d], [b, a, c, d]]],
N = 0 .

?- 

?- tmp_mdc( 1,[a,b],B,X,Y), indexed_profiles( Y, D ), count( swf(_,D), 0 ), length(A,9),append( A, C, D ), count( swf(_,C), N ), fig( domain, A ).


             1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 
             ------------------------------------------------------------------------
1:[a,b,c,d]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
2:[a,b,d,c]  -  -  -  -  -  -  -  -  8  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
3:[a,c,b,d]  -  -  -  -  -  2  -  -  -  -  -  -  -  -  9  -  -  -  -  -  -  -  -  -  
4:[a,c,d,b]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
5:[a,d,b,c]  -  -  -  7  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
6:[a,d,c,b]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
7:[b,a,c,d]  -  -  6  -  -  -  -  -  -  -  -  -  -  -  -  -  -  1  -  -  -  -  -  -  
8:[b,a,d,c]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
9:[b,c,a,d]  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
10:[b,c,d,a] 5  -  -  -  -  -  -  -  -  -  3  -  -  -  -  -  -  -  -  -  -  -  -  -  
11:[b,d,a,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
12:[b,d,c,a] -  4  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
13:[c,a,b,d] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
14:[c,a,d,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
15:[c,b,a,d] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
16:[c,b,d,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
17:[c,d,a,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
18:[c,d,b,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
19:[d,a,b,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
20:[d,a,c,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
21:[d,b,a,c] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
22:[d,b,c,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
23:[d,c,a,b] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
24:[d,c,b,a] -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  
--
B = [[c, d], [c, a], [d, a], [b, a], [b, c], [d, c], [a, c], [a|...], [...|...]|...],
X = [a, d],
Y = [[7, 18], [3, 6], [10, 11], [12, 2], [10, 1], [7, 3], [5, 4], [2|...], [...|...]|...],
D = [[[b, a, c, d], [c, d, b, a]], [[a, c, b, d], [a, d, c, b]], [[b, c, d, a], [b, d, a, c]], [[b, d, c, a], [a, b, d|...]], [[b, c, d|...], [a, b|...]], [[b, a|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]|...],
A = [[[b, a, c, d], [c, d, b, a]], [[a, c, b, d], [a, d, c, b]], [[b, c, d, a], [b, d, a, c]], [[b, d, c, a], [a, b, d|...]], [[b, c, d|...], [a, b|...]], [[b, a|...], [a|...]], [[a|...], [...|...]], [[...|...]|...], [...|...]],
C = [[[c, d, a, b], [b, c, d, a]], [[a, c, d, b], [a, b, c, d]], [[a, c, b, d], [b, a, c, d]]],
N = 0 .

?- 

*/




% visualizing how decisiveness propagates


show_decisiveness_propagates( Agent, H, I ):-
	 member( Agent, [ 1, 2 ] ),
	 nth1( V, I, K ), 
	 nth1( V, H, B ),
	 decisiveness_propagates_at( K, P, B->C, Agent ), 
	 pp( K, P ), 
	 nl, 
	 write( Agent : K ; P ; B->C; V ),
	 fail
	 ;
	 true.


/*

?- decisiveness_ring( J, [ a, b ], B, R ), length( R, N ), indexed_profiles( R, D ), \+ swf( F, D ),  !, show_decisiveness_propagates( J, B, R ), fail.

1:[6,4];[[c,a,b],[b,c,a]];[a,b]->[c,b];1
1:[1,3];[[a,c,b],[b,a,c]];[c,b]->[a,b];2
false.

*/

show_decisiveness_propagates_pattern( B, R ):-
	 nl,
	 write( B ),
	 nl,
	 write( R ),
	 hr( 35 ).

show_decisiveness_propagates_in_a_dictatorial_profiles:-
	 decisiveness_ring( J, [ a, b ], B, R ),
	 length( R, N ), 
	 indexed_profiles( R, D ), 
	 \+ swf( _, D ), 
	 N = 6, 
	 !, 
	 show_decisiveness_propagates_pattern( B, R ),
	 show_decisiveness_propagates( J, B, R ), 
	 fail
	 ;
	 true.

/*

?- show_decisiveness_propagates_in_a_dictatorial_profiles.

[[a,b],[a,c],[b,c],[b,a],[c,a],[c,b]]
[[2,4],[3,5],[4,6],[5,1],[6,2],[1,3]]
-----------------------------------
1:[2,4];[[a,b,c],[b,c,a]];[a,b]->[a,c];1
1:[3,5];[[b,a,c],[c,b,a]];[a,c]->[b,c];2
1:[4,6];[[b,c,a],[c,a,b]];[b,c]->[b,a];3
1:[5,1];[[c,b,a],[a,c,b]];[b,a]->[c,a];4
1:[6,2];[[c,a,b],[a,b,c]];[c,a]->[c,b];5
1:[1,3];[[a,c,b],[b,a,c]];[c,b]->[a,b];6
false.

*/

show_decisiveness_propagates_in_a_possible_profiles:-
	 decisiveness_ring( J, [ a, b ], B, R ),
	 length( R, N ), 
	 indexed_profiles( R, D ), 
	 \+ \+ swf( _, D ), 
	 N = 6, 
	 !, 
	 show_decisiveness_propagates_pattern( B, R ),
	 show_decisiveness_propagates( J, B, R ), 
	 fail
	 ;
	 true.

/*

?- show_decisiveness_propagates_in_a_possible_profiles.

true.

*/

show_an_swf_on_decisive_ring_in_sign_pattern:-
	 decisiveness_ring( 1, [ a, b ], B, R ), 
	 length( R, N ), 
	 indexed_profiles( R, D ), 
	 swf( F, D ), 
	 N = 6, 
	 !, 
	 show_decisiveness_propagates_pattern( B, R ),
	 swf_xy( F, U, H ), 
	 nl, 
	 write( U:H ), 
	 fail
	 ;
	 true.

/*

?- show_an_swf_on_decisive_ring_in_sign_pattern.

true.

*/


/*

% results of the earlier code
% what if decisiveness_propagates_at/4 
% permits the "LHS" profile unanimous, 

?- show_an_swf_on_decisive_ring_in_sign_pattern.

[[a,b],[a,c],[b,c],[b,a],[c,a],[c,b]]
[[2,4],[3,5],[4,6],[5,1],[1,2],[1,3]]
-----------------------------------
[a,a]:[[0,0]-0]
[a,b]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[a,c]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[b,a]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[b,b]:[[0,0]-0]
[b,c]:[[+,+]-(+),[+,-]-(+),[-,+]-(+),[-,-]-(-)]
[c,a]:[[+,+]-(+),[+,-]-(+),[-,+]-(-),[-,-]-(-)]
[c,b]:[[+,+]-(+),[+,-]-(-),[-,+]-(-),[-,-]-(-)]
[c,c]:[[0,0]-0]
false.

?- count( decisiveness_ring( 1, _, D, R ), N ).
N = 72.

?- hist1n( ( decisiveness_ring( 1, [ a, b ], D, I ), I \= [ _, _ ], indexed_profiles( I, P ), count( swf( _, P ), N ) ),  N ).

 [0,2]
 [5,6]
 [13,6]
 [25,2]
total:16
true.

?- decisiveness_ring( 1, [a,b], D, I ), indexed_profiles( I, P ), count( swf( _, P ), N ), N =5, nl, member( X, I ), write( X ), \+ ( ppc( X, _ ) ; X = [ A, B ], Y = [ B, A ], ppc( Y, _ ) ), write( * ), fail.

[2,4][3,5][4,6][5,1][1,2]*[1,3]
[3,4]*[3,5][4,6][5,1][6,2][1,3]
[2,4][3,5][5,6]*[5,1][6,2][1,3]
[6,4][5,3][4,2][2,1]*[2,6][1,5]
[6,4][4,3]*[4,2][3,1][2,6][1,5]
[6,4][5,3][4,2][3,1][2,6][6,5]*
false.

*/



test_decisive_ring_decomposed_profiles( R, X1, X2, Y ):-
	 m1( M1 ), 
	 m2( M2 ), 
	 indexed_profiles( I1, M1 ), 
	 indexed_profiles( I2, M2 ), 
	 intersection( R, I1, X1 ), 
	 intersection( R, I2, X2 ), 
	 m( M ), 
	 indexed_profiles( I, M ), 
	 subtract( R, I, Y ). 

test_decisive_ring_1( J, B, R, X1, X2, Y ):-
	 decisiveness_ring( J, B, _, R0 ),
	 sort( R0, R ),
	 test_decisive_ring_decomposed_profiles( R, X1, X2, Y ).

test_decisive_ring_1( J, B ):-
	 ( var( B ) -> B = [a,b] ; true ),
	 ( var( J ) -> J = 1 ; true ),
	 test_decisive_ring_1( J, B, R, X1, X2, Y ),
	 length( R, N ),
	 nl, 
	 write( J; B ; N; m1:X1; m2:X2; outer:Y ), 
	 fail
	 ;
	 true.


/*

?- test_decisive_ring_1( J, B, R, X1, X2, Y ).
J = 2,
B = [b, c],
R = X2, X2 = [[1, 3], [2, 4], [3, 5], [4, 6], [5, 1], [6, 2]],
X1 = Y, Y = [] .


*/


test_decisive_ring_2( J, B ):-
	 findall( J : B : R0, ( 
		 decisiveness_ring( J, B, _, R ),
		 sort( R, R0 )
	 ), F ), 
	 sort( F, F0 ), 
	 member( J : B: R, F0 ), 
	 indexed_profiles( R, G ), 
	 \+ swf( _, G ), 
	 test_decisive_ring_decomposed_profiles( R, X1, X2, Y ),
	 length( R, N ), 
	 nl, 
	 write( N; m1:X1; m2:X2; outer:Y ), 
	 fail
	 ;
	 true.

test_decisive_ring_2:-
	 test_decisive_ring_2( _, _ ).


/*

?- test_decisive_ring_2( 1, [a,b] ). 

6;m1:[];m2:[[1,3],[2,4],[3,5],[4,6],[5,1],[6,2]];outer:[]
2;m1:[[6,4]];m2:[[1,3]];outer:[]
2;m1:[[1,5]];m2:[[2,4]];outer:[]
6;m1:[[1,5],[2,6],[3,1],[4,2],[5,3],[6,4]];m2:[];outer:[]
true.

*/

/*

% some aditional tests using test_decisive_ring_1.
% results of the earlier code
% what if decisiveness_propagates_at/4 permits 
% the "RHS" profile unanimous, 


?- hist1n( ( test_decisive_ring_1( 1, [a,b], R, X1, X2, Y ), length( R, N ), length( X1, K1 ), length( X2, K2 ), length( Y, L ) ), N; K1; K2; L ).

 [(2;0;0;2),2]
 [(2;0;1;1),2]
 [(2;1;0;1),2]
 [(2;1;1;0),2]
 [(6;0;0;6),2]
 [(6;0;1;5),6]
 [(6;0;2;4),15]
 [(6;0;3;3),20]
 [(6;0;4;2),15]
 [(6;0;5;1),6]
 [(6;0;6;0),1]
 [(6;1;0;5),6]
 [(6;2;0;4),15]
 [(6;3;0;3),20]
 [(6;4;0;2),15]
 [(6;5;0;1),6]
 [(6;6;0;0),1]
total:136

true.
?- hist1n( ( test_decisive_ring_1( 1, [a,b], R, X1, X2, Y ), length( Y, 6 ) ), Y ).

 [[[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]],1]
 [[[1,6],[2,1],[3,2],[4,3],[5,4],[6,5]],1]
total:2
true.


*/

outer_ring( ring_1,
 [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]]
).

outer_ring( ring_2, 
 [[1,6],[2,1],[3,2],[4,3],[5,4],[6,5]]
).



/*

?- I = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]], indexed_profiles( I, D ), swf( F, D ), fig( swf, F ).

          123456
1:[a,c,b] -1----
2:[a,b,c] --2---
3:[b,a,c] ---3--
4:[b,c,a] ----4-
5:[c,b,a] -----5
6:[c,a,b] 1-----
--
I = [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 1]],


?- scf_dict( A, B ).
A = ring_1,
B = [[1, 4], [1, 6], [3, 2], [3, 6], [5, 2], [5, 4]] ;
A = ring_2,
B = [[2, 3], [2, 5], [4, 1], [4, 5], [6, 1], [6, 3]] .

?- arrow_ring( A, B ).
A = ring_1,
B = [[1, 5], [2, 6], [3, 1], [4, 2], [5, 3], [6, 4]] ;
A = ring_2,
B = [[5, 1], [6, 2], [1, 3], [2, 4], [3, 5], [4, 6]] .


?- hist1n( ( test_decisive_ring_1( 1, [a,b], R, X1, X2, Y ), length( R, N ), length( Y, L ), scf_dict( double, S ), intersection( S, Y, P ), length( P, F ) ), N; L; F ).

 [(6;0;0),2]
 [(6;1;0),6]
 [(6;1;1),6]
 [(6;2;0),6]
 [(6;2;1),18]
 [(6;2;2),6]
 [(6;3;0),2]
 [(6;3;1),18]
 [(6;3;2),18]
 [(6;3;3),2]
 [(6;4;1),6]
 [(6;4;2),18]
 [(6;4;3),6]
 [(6;5;2),6]
 [(6;5;3),6]
 [(6;6;3),2]
total:128
true.

?- test_decisive_ring_1( 1, [a,b], R, X1, X2, Y ), length( Y, 6 ), indexed_profiles( R, D ), swf( F, D ), fig( swf, F ), !, hr( 35 ), swf_xy( F, B, H ), nl, write( B:H ), fail.

          123456
1:[a,c,b] -----1
2:[a,b,c] 1-----
3:[b,a,c] -2----
4:[b,c,a] --3---
5:[c,b,a] ---4--
6:[c,a,b] ----5-
--
-----------------------------------
[a,a]:[[0,0]-0]
[a,b]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[a,c]:[[+,+]-(+),[+,-]-(+),[-,+]-(+),[-,-]-(-)]
[b,a]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[b,b]:[[0,0]-0]
[b,c]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[c,a]:[[+,+]-(+),[+,-]-(-),[-,+]-(-),[-,-]-(-)]
[c,b]:[[+,+]-(+),[+,-]-(-),[-,+]-(+),[-,-]-(-)]
[c,c]:[[0,0]-0]
false.

?- test_decisive_ring_1( 1, [a,b], R, _, _, Y ), length( Y, 6 ), indexed_profiles( R, D ), count( swf( F, D ), N ).

R = Y, Y = [[1, 6], [2, 1], [3, 2], [4, 3], [5, 4], [6, 5]],
D = [[[a, c, b], [c, a, b]], [[a, b, c], [a, c, b]], [[b, a, c], [a, b, c]], [[b, c, a], [b, a, c]], [[c, b, a], [b, c|...]], [[c, a|...], [c|...]]],
N = 62 ;
R = Y, Y = [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 1]],
D = [[[a, c, b], [a, b, c]], [[a, b, c], [b, a, c]], [[b, a, c], [b, c, a]], [[b, c, a], [c, b, a]], [[c, b, a], [c, a|...]], [[c, a|...], [a|...]]],
N = 62 ;
false.

*/


% end of program file.



