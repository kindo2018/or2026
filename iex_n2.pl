iex_n2( F, R, X ):-
	count((member( [P,_]->S, F ), P\=S ), K1), 
	count((member( [_,P]->S, F ), P\=S ), K2),
	R = K1 /(K1+K2),
	X is R.

