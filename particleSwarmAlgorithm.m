function [ gBestP, positionProgressionPSO ] = particleSwarmAlgorithm( numberOfIterations , numberOfParticles , roomDimensions , Delta , loudspeakersPositions , c , estimatedTOF , c1 , c2 , constrainPositions )

    numberOfLoudspeakers = size( loudspeakersPositions , 1 );
    
    % Inicializa��o das part�culas
    p = [ rand( 1 , numberOfParticles ) * roomDimensions( 1 );
          rand( 1 , numberOfParticles ) * roomDimensions( 2 );
          rand( 1 , numberOfParticles ) * roomDimensions( 3 )];
    v = zeros( 3 , numberOfParticles );
    bestP = p; % melhores posi��es de cada part�cula at� o momento
    
    positionProgressionPSO = zeros(3, numberOfParticles, numberOfIterations);
    
    currentFp = zeros( numberOfParticles , 1 );      
    bestFp = zeros( numberOfParticles , 1 );
    i=1;
    for particle = 1 : numberOfParticles,

        currentFp( particle ) = evaluateFglobal( p( : , particle )' , Delta , numberOfLoudspeakers , loudspeakersPositions , c , estimatedTOF );

    end
    bestFp = currentFp;
    
    indexGBest = find( currentFp == max( currentFp ) );
    indexGBest = indexGBest( 1 );
    gBestP = p( : , indexGBest );
    gBestFP = currentFp( indexGBest ); % melhor valor global at� o momento

    for iterationNumber = 1 : numberOfIterations,
         if ( mod( iterationNumber, 200 ) == 0 )
            disp( iterationNumber ) 
         end
    
        % Avalia��o da fun��o objetivo
        for particle = 1 : numberOfParticles,

            currentFp( particle ) = evaluateFglobal( p( : , particle )' , Delta , numberOfLoudspeakers , loudspeakersPositions , c , estimatedTOF );
            
            if ( currentFp( particle ) > bestFp( particle ) )
                
                bestFp( particle ) = currentFp( particle );
                bestP( : , particle ) = p( : , particle ); % melhores posi��es de cada part�cula at� o momento
                
            end
            
        end
        
        if ( max( currentFp( particle ) ) > gBestFP )
            
            indexGBest = find( currentFp == max( currentFp ) );
            indexGBest = indexGBest( 1 );
            gBestP = p( : , indexGBest );
            gBestFP = currentFp( indexGBest ); % melhor valor global at� o momento
            
        end
        
        for particle = 1 : numberOfParticles,
            
            v( : , particle ) = v( : , particle ) + c1 * rand * ( bestP( : , particle ) - p( : , particle ) ) + c2 * rand * ( gBestP - p( : , particle ) );
            
        end        
        positionProgressionPSO(:,:,iterationNumber) = p(:,:);% todas as linhas (as coordenadas) , todos os agentes, na itera��o i
     %   positionProgressionPSO(:,:,numberOfIterations)
    %  iterationNumber
     %  pause 
        p = p + v;
        
        if ( constrainPositions ) % imp�e restri��o f�sica para que as part�culas estejam dentro do recinto
            
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