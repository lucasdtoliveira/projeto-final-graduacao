function [ gBestP ] = particleSwarmAlgorithm( numberOfIterations , numberOfParticles , roomDimensions , Delta , loudspeakersPositions , c , estimatedTOF , c1 , c2 , constrainPositions )

    numberOfLoudspeakers = size( loudspeakersPositions , 1 );
    
    % Inicialização das partículas
    p = [ rand( 1 , numberOfParticles ) * roomDimensions( 1 );
          rand( 1 , numberOfParticles ) * roomDimensions( 2 );
          rand( 1 , numberOfParticles ) * roomDimensions( 3 )];
    v = zeros( 3 , numberOfParticles );
    bestP = p; % melhores posições de cada partícula até o momento
    
    currentFp = zeros( numberOfParticles , 1 );      
    bestFp = zeros( numberOfParticles , 1 );
    
    for particle = 1 : numberOfParticles,

        currentFp( particle ) = evaluateFglobal( p( : , particle )' , Delta , numberOfLoudspeakers , loudspeakersPositions , c , estimatedTOF );

    end
    bestFp = currentFp;
    
    indexGBest = find( currentFp == max( currentFp ) );
    indexGBest = indexGBest( 1 );
    gBestP = p( : , indexGBest );
    gBestFP = currentFp( indexGBest ); % melhor valor global até o momento

    for iterationNumber = 1 : numberOfIterations,
    
        % Avaliação da função objetivo
        for particle = 1 : numberOfParticles,

            currentFp( particle ) = evaluateFglobal( p( : , particle )' , Delta , numberOfLoudspeakers , loudspeakersPositions , c , estimatedTOF );
            
            if ( currentFp( particle ) > bestFp( particle ) )
                
                bestFp( particle ) = currentFp( particle );
                bestP( : , particle ) = p( : , particle ); % melhores posições de cada partícula até o momento
                
            end

        end
        
        if ( max( currentFp( particle ) ) > gBestFP )
            
            indexGBest = find( currentFp == max( currentFp ) );
            indexGBest = indexGBest( 1 );
            gBestP = p( : , indexGBest );
            gBestFP = currentFp( indexGBest ); % melhor valor global até o momento
            
        end
        
        for particle = 1 : numberOfParticles,
            
            v( : , particle ) = v( : , particle ) + c1 * rand * ( bestP( : , particle ) - p( : , particle ) ) + c2 * rand * ( gBestP - p( : , particle ) );
            
        end        
        
        p = p + v;
        
        if ( constrainPositions ) % impõe restrição física para que as partículas estejam dentro do recinto
            
            for particle = 1 : numberOfParticles,
                
                for dimension = 1 : 3 ,
                    
                    if ( p( dimension , particle ) < 0 )
                        
                        p( dimension , particle ) = 0;
                        
                    end
                    
                    if ( p( dimension , particle ) > roomDimensions( dimension ) )
                        
                        p( dimension , particle ) = roomDimensions( dimension );
                        
                    end
                    
                    
                end
                
            end
            
        end
        
        
        
        
        
    end