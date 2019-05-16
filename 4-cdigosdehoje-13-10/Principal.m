clc
clear all

numberOfLoudspeakers = 10;
roomDimensions = [ 5.2 7.5 2.6 ];
c = 345;
numberOfIterations = 100;
numberOfParticles = 10;
Delta = 5 * 10 ^ ( -3 );
constrainPositions = 1;

numberOfMicrophonePositions = 2000;

loudspeakersPositions = getloudspeakersPositions( numberOfLoudspeakers );

microphonePositions = [ roomDimensions( 1 ) * rand( 1 , numberOfMicrophonePositions ) ;
                        roomDimensions( 2 ) * rand( 1 , numberOfMicrophonePositions ) ; 
                        roomDimensions( 3 ) * rand( 1 , numberOfMicrophonePositions ) ];
                    
fs = 48000;
varianceGaussianNoiseVector = [ 10 ^ ( -6 ) ]; 
numberOfTOFLargeErrorsVector = [ 0 1 ];

minLargeTOFError = 2 * 10 ^ ( -3 ); % in s
maxLargeTOFError = 18 * 10 ^ ( -3 ); % in s

c1 = 2;
c2 = 2;

localizationErrorsPSO = zeros( numel( varianceGaussianNoiseVector ) , numel( numberOfTOFLargeErrorsVector ) , numberOfMicrophonePositions );
localizationErrorsT = zeros( numel( varianceGaussianNoiseVector ) , numel( numberOfTOFLargeErrorsVector ) , numberOfMicrophonePositions );
localizationErrorsD = zeros( numel( varianceGaussianNoiseVector ) , numel( numberOfTOFLargeErrorsVector ) , numberOfMicrophonePositions );

for microphoneNumber = 1 : numberOfMicrophonePositions,
    
    if ( mod( microphoneNumber, 100 ) == 0 )
        disp( microphoneNumber ) 
    end
    
    for varianceGaussianNoiseIndex = 1 : numel( varianceGaussianNoiseVector ),
        
        for numberOfTOFLargeErrorsIndex = 1 : numel( numberOfTOFLargeErrorsVector ),

            noiseGaussianVariance = varianceGaussianNoiseVector( varianceGaussianNoiseIndex );
            numberOfTOFLargeErrors = numberOfTOFLargeErrorsVector( numberOfTOFLargeErrorsIndex );
            
            m = microphonePositions( : , microphoneNumber );

            tof = evaluateTOF( m , loudspeakersPositions , c );

            estimatedTOF = corruptingTOF( tof , noiseGaussianVariance , fs , numberOfLoudspeakers , numberOfTOFLargeErrors , minLargeTOFError , maxLargeTOFError );

            estimatedTDOF = estimatedTOF( 2 : end ) - estimatedTOF( 1 );

            % método T
            H{ 1 } = [ ones( numberOfLoudspeakers , 1 ) -2 * loudspeakersPositions ];
            g{ 1 } = - transp( sum( transp( loudspeakersPositions .^ 2 ) ) ) + c ^ 2 * estimatedTOF .^ 2;
            % método D
            H{ 2 } = [ -2 * c * estimatedTDOF -2 * ( loudspeakersPositions( 2 : end , : ) - repmat( loudspeakersPositions( 1 , : ) , numberOfLoudspeakers - 1 , 1  ) ) ];
            g{ 2 } = - transp( sum( transp( ( loudspeakersPositions( 2 : end , : ) - repmat( loudspeakersPositions( 1 , : ) , numberOfLoudspeakers - 1 , 1  ) ) ) .^ 2 ) )  + c ^ 2 * estimatedTDOF .^ 2;

            theta{ 1 } = inv( transp( H{ 1 } ) * H{ 1 } ) * transp( H{ 1 } ) * g{ 1 };
            theta{ 2 } = inv( transp( H{ 2 } ) * H{ 2 } ) * transp( H{ 2 } ) * g{ 2 };

            theta{ 2 }( 2 : 4 ) = theta{ 2 }( 2 : 4 )  + loudspeakersPositions( 1 , : )';

            localizationErrorsT( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , microphoneNumber ) = norm( m - theta{ 1 }( 2 : 4 ) ) * 100;
            localizationErrorsD( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , microphoneNumber ) = norm( m - theta{ 2 }( 2 : 4 ) ) * 100;
            
            gBestP = particleSwarmAlgorithm( numberOfIterations , numberOfParticles , roomDimensions , Delta , loudspeakersPositions , c , estimatedTOF , c1 , c2 , constrainPositions );
            
            localizationErrorsPSO( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , microphoneNumber ) = norm( m - gBestP ) * 100;
            
        end
    end
end

v = clock;
fileName = [ 'results_' num2str( v( 1 ) ) '_' num2str( v( 2 ) ) '_' num2str( v( 3 ) ) '_' num2str( v( 4 ) ) '_' num2str( v( 5 ) ) '_' num2str( round( v( 6 ) ) ) ];

save( fileName )

