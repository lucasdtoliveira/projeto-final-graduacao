function [ resultado ] = crossover( candidate_1 , candidate_2 , crossoverPoint )

resultado = zeros( 2 , 24);
candidate_1_cross = zeros( size( candidate_1 ) );
candidate_2_cross = zeros( size( candidate_2 ) );

candidate_1_cross( 1:crossoverPoint ) = candidate_1( 1:crossoverPoint );
candidate_1_cross( (crossoverPoint+1):end ) = candidate_2( (crossoverPoint+1):end );

candidate_2_cross( 1:crossoverPoint ) = candidate_2( 1:crossoverPoint );
candidate_2_cross( (crossoverPoint+1):end ) = candidate_1( (crossoverPoint+1):end );

resultado = [ candidate_1_cross ;
              candidate_2_cross ];