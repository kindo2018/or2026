/*

?-  N=2, B=[a,b,c,d,e], length( B, M ), L is 2^(N-1) * M*(M-1), time( ( mapz( transitive(B, []), [ ], F:C ), length( F, I ), I> L - 1, length(C, K), K = 9, assert( tmp_n2m5_min_cut( C ) ), fail; true ) ).
% 31,643,425,336 inferences, 1326.438 CPU in 1859.215 seconds (71% CPU, 23855949 Lips)
N = 2,
B = [a, b, c, d, e],
M = 5,
L = 40.


?- tell('n2m5_min_cut.pl'), C =  tmp_n2m5_min_cut( _ ), call( C ), write( C ), writeln( '.' ), fail ; told.
true.

*/

tmp_n2m5_min_cut([[bca,abc],[bca,acb],[bca,cab],[bda,abd],[bda,adb],[bda,dab],[bea,abe],[bea,aeb],[bea,eab]]).
tmp_n2m5_min_cut([[cba,abc],[cba,acb],[cba,bac],[cda,acd],[cda,adc],[cda,dac],[cea,ace],[cea,aec],[cea,eac]]).
tmp_n2m5_min_cut([[cab,abc],[cab,bac],[cab,bca],[cdb,bcd],[cdb,bdc],[cdb,dbc],[ceb,bce],[ceb,bec],[ceb,ebc]]).
tmp_n2m5_min_cut([[dba,abd],[dba,adb],[dba,bad],[dca,acd],[dca,adc],[dca,cad],[dea,ade],[dea,aed],[dea,ead]]).
tmp_n2m5_min_cut([[dab,abd],[dab,bad],[dab,bda],[dcb,bcd],[dcb,bdc],[dcb,cbd],[deb,bde],[deb,bed],[deb,ebd]]).
tmp_n2m5_min_cut([[dac,acd],[dac,cad],[dac,cda],[dbc,bcd],[dbc,cbd],[dbc,cdb],[dec,cde],[dec,ced],[dec,ecd]]).
tmp_n2m5_min_cut([[eba,abe],[eba,aeb],[eba,bae],[eca,ace],[eca,aec],[eca,cae],[eda,ade],[eda,aed],[eda,dae]]).
tmp_n2m5_min_cut([[eab,abe],[eab,bae],[eab,bea],[ecb,bce],[ecb,bec],[ecb,cbe],[edb,bde],[edb,bed],[edb,dbe]]).
tmp_n2m5_min_cut([[eac,ace],[eac,cae],[eac,cea],[ebc,bce],[ebc,cbe],[ebc,ceb],[edc,cde],[edc,ced],[edc,dce]]).
tmp_n2m5_min_cut([[ead,ade],[ead,dae],[ead,dea],[ebd,bde],[ebd,dbe],[ebd,deb],[ecd,cde],[ecd,dce],[ecd,dec]]).
tmp_n2m5_min_cut([[dae,aed],[dae,ead],[dae,eda],[dbe,bed],[dbe,ebd],[dbe,edb],[dce,ced],[dce,ecd],[dce,edc]]).
tmp_n2m5_min_cut([[cae,aec],[cae,eac],[cae,eca],[cbe,bec],[cbe,ebc],[cbe,ecb],[cde,dec],[cde,ecd],[cde,edc]]).
tmp_n2m5_min_cut([[cad,adc],[cad,dac],[cad,dca],[cbd,bdc],[cbd,dbc],[cbd,dcb],[ced,dce],[ced,dec],[ced,edc]]).
tmp_n2m5_min_cut([[bae,aeb],[bae,eab],[bae,eba],[bce,ceb],[bce,ebc],[bce,ecb],[bde,deb],[bde,ebd],[bde,edb]]).
tmp_n2m5_min_cut([[bad,adb],[bad,dab],[bad,dba],[bcd,cdb],[bcd,dbc],[bcd,dcb],[bed,dbe],[bed,deb],[bed,edb]]).
tmp_n2m5_min_cut([[bac,acb],[bac,cab],[bac,cba],[bdc,cbd],[bdc,cdb],[bdc,dcb],[bec,cbe],[bec,ceb],[bec,ecb]]).
tmp_n2m5_min_cut([[abe,bea],[abe,eab],[abe,eba],[ace,cea],[ace,eac],[ace,eca],[ade,dea],[ade,ead],[ade,eda]]).
tmp_n2m5_min_cut([[abd,bda],[abd,dab],[abd,dba],[acd,cda],[acd,dac],[acd,dca],[aed,dae],[aed,dea],[aed,eda]]).
tmp_n2m5_min_cut([[abc,bca],[abc,cab],[abc,cba],[adc,cad],[adc,cda],[adc,dca],[aec,cae],[aec,cea],[aec,eca]]).
tmp_n2m5_min_cut([[abc,bca],[abd,bda],[abe,bea],[acb,bca],[adb,bda],[aeb,bea],[cab,bca],[dab,bda],[eab,bea]]).
tmp_n2m5_min_cut([[acb,bac],[acb,bca],[acb,cba],[adb,bad],[adb,bda],[adb,dba],[aeb,bae],[aeb,bea],[aeb,eba]]).
tmp_n2m5_min_cut([[abc,cba],[acb,cba],[acd,cda],[ace,cea],[adc,cda],[aec,cea],[bac,cba],[dac,cda],[eac,cea]]).
tmp_n2m5_min_cut([[abd,dba],[acd,dca],[adb,dba],[adc,dca],[ade,dea],[aed,dea],[bad,dba],[cad,dca],[ead,dea]]).
tmp_n2m5_min_cut([[abe,eba],[ace,eca],[ade,eda],[aeb,eba],[aec,eca],[aed,eda],[bae,eba],[cae,eca],[dae,eda]]).
tmp_n2m5_min_cut([[abc,cab],[bac,cab],[bca,cab],[bcd,cdb],[bce,ceb],[bdc,cdb],[bec,ceb],[dbc,cdb],[ebc,ceb]]).
tmp_n2m5_min_cut([[abd,dab],[bad,dab],[bcd,dcb],[bda,dab],[bdc,dcb],[bde,deb],[bed,deb],[cbd,dcb],[ebd,deb]]).
tmp_n2m5_min_cut([[abe,eab],[bae,eab],[bce,ecb],[bde,edb],[bea,eab],[bec,ecb],[bed,edb],[cbe,ecb],[dbe,edb]]).
tmp_n2m5_min_cut([[acd,dac],[bcd,dbc],[cad,dac],[cbd,dbc],[cda,dac],[cdb,dbc],[cde,dec],[ced,dec],[ecd,dec]]).
tmp_n2m5_min_cut([[ace,eac],[bce,ebc],[cae,eac],[cbe,ebc],[cde,edc],[cea,eac],[ceb,ebc],[ced,edc],[dce,edc]]).
tmp_n2m5_min_cut([[ade,ead],[bde,ebd],[cde,ecd],[dae,ead],[dbe,ebd],[dce,ecd],[dea,ead],[deb,ebd],[dec,ecd]]).
tmp_n2m5_min_cut([[aed,dae],[bed,dbe],[ced,dce],[ead,dae],[ebd,dbe],[ecd,dce],[eda,dae],[edb,dbe],[edc,dce]]).
tmp_n2m5_min_cut([[aec,cae],[bec,cbe],[dec,cde],[eac,cae],[ebc,cbe],[eca,cae],[ecb,cbe],[ecd,cde],[edc,cde]]).
tmp_n2m5_min_cut([[aeb,bae],[ceb,bce],[deb,bde],[eab,bae],[eba,bae],[ebc,bce],[ebd,bde],[ecb,bce],[edb,bde]]).
tmp_n2m5_min_cut([[bea,abe],[cea,ace],[dea,ade],[eab,abe],[eac,ace],[ead,ade],[eba,abe],[eca,ace],[eda,ade]]).
tmp_n2m5_min_cut([[adc,cad],[bdc,cbd],[dac,cad],[dbc,cbd],[dca,cad],[dcb,cbd],[dce,ced],[dec,ced],[edc,ced]]).
tmp_n2m5_min_cut([[adb,bad],[cdb,bcd],[dab,bad],[dba,bad],[dbc,bcd],[dbe,bed],[dcb,bcd],[deb,bed],[edb,bed]]).
tmp_n2m5_min_cut([[bda,abd],[cda,acd],[dab,abd],[dac,acd],[dae,aed],[dba,abd],[dca,acd],[dea,aed],[eda,aed]]).
tmp_n2m5_min_cut([[acb,bac],[cab,bac],[cba,bac],[cbd,bdc],[cbe,bec],[cdb,bdc],[ceb,bec],[dcb,bdc],[ecb,bec]]).
tmp_n2m5_min_cut([[bca,abc],[cab,abc],[cad,adc],[cae,aec],[cba,abc],[cda,adc],[cea,aec],[dca,adc],[eca,aec]]).
tmp_n2m5_min_cut([[bac,acb],[bad,adb],[bae,aeb],[bca,acb],[bda,adb],[bea,aeb],[cba,acb],[dba,adb],[eba,aeb]]).
