function [ loudspeakersPositions ] = getloudspeakersPositions( numberOfLoudspeakers )

loudspeakersPositions = [ 0.234	5.5645	2.2695;
                          0.269	5.579	1.718;
                          0.594	0.8325	2.0115;
                          0.24	2.926	1.6445;
                          0.281	2.951	0.987;
                          4.593	3.0365	1.608;
                          4.593	3.0405	1.0015;
                          2.4515	0.6925	1.1805;
                          4.497	5.4535	2.268;
                          4.435	5.456	1.696;
                          4.214	0.8255	2.02];
                          
loudspeakersPositions = loudspeakersPositions( 1 : numberOfLoudspeakers , : );