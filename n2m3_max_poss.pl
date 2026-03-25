/*

tell('n2m3_max_poss.pl'), A= [a,b,c], time(( mapz( transitive(A, []), [ ], F:C ), length( F, N ), N>11, length(C, K), K=2, write( n2m3_max_poss( F ) ), writeln('.'), fail; told ) ).

*/

n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->b>c),([c>a,c>a]->c>a),([c>a,a>c]->a>c),([b>c,c>b]->b>c),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->a>b),([a>c,c>a]->a>c),([a>c,a>c]->a>c),([a>b,b>a]->a>b),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->c>b),([c>a,c>a]->c>a),([c>a,a>c]->a>c),([b>c,c>b]->b>c),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->a>b),([a>c,c>a]->a>c),([a>c,a>c]->a>c),([a>b,b>a]->a>b),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->b>c),([c>a,c>a]->c>a),([c>a,a>c]->a>c),([b>c,c>b]->c>b),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->a>b),([a>c,c>a]->a>c),([a>c,a>c]->a>c),([a>b,b>a]->a>b),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->c>b),([c>a,c>a]->c>a),([c>a,a>c]->a>c),([b>c,c>b]->c>b),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->a>b),([a>c,c>a]->a>c),([a>c,a>c]->a>c),([a>b,b>a]->a>b),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->c>b),([c>a,c>a]->c>a),([c>a,a>c]->c>a),([b>c,c>b]->c>b),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->a>b),([a>c,c>a]->a>c),([a>c,a>c]->a>c),([a>b,b>a]->a>b),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->b>c),([c>a,c>a]->c>a),([c>a,a>c]->a>c),([b>c,c>b]->b>c),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->b>a),([a>c,c>a]->a>c),([a>c,a>c]->a>c),([a>b,b>a]->a>b),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->c>b),([c>a,c>a]->c>a),([c>a,a>c]->a>c),([b>c,c>b]->c>b),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->a>b),([a>c,c>a]->c>a),([a>c,a>c]->a>c),([a>b,b>a]->a>b),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->c>b),([c>a,c>a]->c>a),([c>a,a>c]->c>a),([b>c,c>b]->c>b),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->a>b),([a>c,c>a]->c>a),([a>c,a>c]->a>c),([a>b,b>a]->a>b),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->c>b),([c>a,c>a]->c>a),([c>a,a>c]->c>a),([b>c,c>b]->c>b),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->b>a),([a>c,c>a]->c>a),([a>c,a>c]->a>c),([a>b,b>a]->a>b),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->b>c),([c>a,c>a]->c>a),([c>a,a>c]->a>c),([b>c,c>b]->b>c),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->a>b),([a>c,c>a]->a>c),([a>c,a>c]->a>c),([a>b,b>a]->b>a),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->b>c),([c>a,c>a]->c>a),([c>a,a>c]->a>c),([b>c,c>b]->b>c),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->b>a),([a>c,c>a]->a>c),([a>c,a>c]->a>c),([a>b,b>a]->b>a),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->b>c),([c>a,c>a]->c>a),([c>a,a>c]->c>a),([b>c,c>b]->b>c),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->b>a),([a>c,c>a]->a>c),([a>c,a>c]->a>c),([a>b,b>a]->b>a),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->c>b),([c>a,c>a]->c>a),([c>a,a>c]->c>a),([b>c,c>b]->c>b),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->a>b),([a>c,c>a]->c>a),([a>c,a>c]->a>c),([a>b,b>a]->b>a),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->b>c),([c>a,c>a]->c>a),([c>a,a>c]->a>c),([b>c,c>b]->b>c),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->b>a),([a>c,c>a]->c>a),([a>c,a>c]->a>c),([a>b,b>a]->b>a),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->b>c),([c>a,c>a]->c>a),([c>a,a>c]->c>a),([b>c,c>b]->b>c),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->b>a),([a>c,c>a]->c>a),([a>c,a>c]->a>c),([a>b,b>a]->b>a),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->c>b),([c>a,c>a]->c>a),([c>a,a>c]->c>a),([b>c,c>b]->b>c),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->b>a),([a>c,c>a]->c>a),([a>c,a>c]->a>c),([a>b,b>a]->b>a),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->b>c),([c>a,c>a]->c>a),([c>a,a>c]->c>a),([b>c,c>b]->c>b),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->b>a),([a>c,c>a]->c>a),([a>c,a>c]->a>c),([a>b,b>a]->b>a),([a>b,a>b]->a>b)]).
n2m3_max_poss([([c>b,c>b]->c>b),([c>b,b>c]->c>b),([c>a,c>a]->c>a),([c>a,a>c]->c>a),([b>c,c>b]->c>b),([b>c,b>c]->b>c),([b>a,b>a]->b>a),([b>a,a>b]->b>a),([a>c,c>a]->c>a),([a>c,a>c]->a>c),([a>b,b>a]->b>a),([a>b,a>b]->a>b)]).
