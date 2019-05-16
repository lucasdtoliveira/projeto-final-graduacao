clc
clear all

numberOfLoudspeakers = 10;
roomDimensions = [ 5.2 7.5 2.6 ];
c = 345;
numberOfIterations = 50;
numberOfParticles = 20;
Delta = 5 * 10 ^ ( -3 );
constrainPositions = 1;

bounds = [0 roomDimensions(1); 0 roomDimensions(2); 0 roomDimensions(3)];
evalOps = [];

numberOfMicrophonePositions = 1;

loudspeakersPositions = getloudspeakersPositions( numberOfLoudspeakers );

microphonePositions = [ roomDimensions( 1 ) * rand( 1 , numberOfMicrophonePositions ) ;
                        roomDimensions( 2 ) * rand( 1 , numberOfMicrophonePositions ) ; 
                        roomDimensions( 3 ) * rand( 1 , numberOfMicrophonePositions ) ];
 
                    
fs = 48000;
varianceGaussianNoiseVector = [ 10 ^ ( -6 ) 2 * 10 ^ ( -6 ) 3 * 10 ^ ( -6 ) 4 * 10 ^ ( -6 ) 5 * 10 ^ ( -6 ) ]; 
numberOfTOFLargeErrorsVector = [ 0 1 2 3 ];

minLargeTOFError = 2 * 10 ^ ( -3 ); % in s
maxLargeTOFError = 18 * 10 ^ ( -3 ); % in s

c1 = 1.1;
c2 = 1.3;

estimatedPositionT = zeros(3, numberOfMicrophonePositions);
estimatedPositionD = zeros(3, numberOfMicrophonePositions);

localizationErrorsGA = zeros( numel( varianceGaussianNoiseVector ) , numel( numberOfTOFLargeErrorsVector ) , numberOfMicrophonePositions );
localizationErrorsPSO = zeros( numel( varianceGaussianNoiseVector ) , numel( numberOfTOFLargeErrorsVector ) , numberOfMicrophonePositions );
localizationErrorsT = zeros( numel( varianceGaussianNoiseVector ) , numel( numberOfTOFLargeErrorsVector ) , numberOfMicrophonePositions );
localizationErrorsD = zeros( numel( varianceGaussianNoiseVector ) , numel( numberOfTOFLargeErrorsVector ) , numberOfMicrophonePositions );

progression = zeros(3, numberOfParticles, numberOfIterations, numel( varianceGaussianNoiseVector ), numel( numberOfTOFLargeErrorsVector ), numberOfMicrophonePositions);

gBestP = zeros(3, numberOfMicrophonePositions, numel( numberOfTOFLargeErrorsVector ), numel( varianceGaussianNoiseVector ));

x = zeros(3, numberOfMicrophonePositions, numel( numberOfTOFLargeErrorsVector ), numel( varianceGaussianNoiseVector ));
endPop = zeros(3, numberOfMicrophonePositions, numel( numberOfTOFLargeErrorsVector ), numel( varianceGaussianNoiseVector ));
bestSols = zeros(3, numberOfMicrophonePositions, numel( numberOfTOFLargeErrorsVector ), numel( varianceGaussianNoiseVector ));
trace = zeros(3, numberOfMicrophonePositions, numel( numberOfTOFLargeErrorsVector ), numel( varianceGaussianNoiseVector ));

for microphoneNumber = 1 : numberOfMicrophonePositions,
    
    if ( mod( microphoneNumber, 50 ) == 0 )
        disp('Mic number')
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

            estimatedPositionT(:, microphoneNumber) = theta{ 1 }( 2 : 4 );
            estimatedPositionD(:, microphoneNumber) = theta{ 2 }( 2 : 4 );
            
            localizationErrorsT( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , microphoneNumber ) = norm( m - theta{ 1 }( 2 : 4 ) ) * 100;
            localizationErrorsD( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , microphoneNumber ) = norm( m - theta{ 2 }( 2 : 4 ) ) * 100;
            
            [gBestP(:, microphoneNumber,numberOfTOFLargeErrorsIndex,varianceGaussianNoiseIndex), progression(:, :, :, numberOfTOFLargeErrorsIndex, varianceGaussianNoiseIndex, microphoneNumber)] = particleSwarmAlgorithm( numberOfIterations , numberOfParticles , roomDimensions , Delta , loudspeakersPositions , c , estimatedTOF , c1 , c2 , constrainPositions );
            
            disp('comecou GA')
            
            initPop=initialize(20 , bounds , 'evaluateFglobalGA' , evalOps, [1e-6 1]);
            
            [ x(:, microphoneNumber,numberOfTOFLargeErrorsIndex,varianceGaussianNoiseIndex) , endPop(:, microphoneNumber,numberOfTOFLargeErrorsIndex,varianceGaussianNoiseIndex) , bestSols(:, microphoneNumber,numberOfTOFLargeErrorsIndex,varianceGaussianNoiseIndex) , trace(:, microphoneNumber,numberOfTOFLargeErrorsIndex,varianceGaussianNoiseIndex) ] = ...
                ga( bounds , 'evaluateFglobalGA' , [] , initPop , [1e-6 1 1] , 'maxGenTerm' , 50 , 'normGeomSelect' , [0.08]  ,['simpleXover'] , [2] , 'nonUnifMutation' , [2 1 3] );
             
            disp('terminou GA')
            localizationErrorsGA( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , microphoneNumber ) = norm( m - x(:,microphoneNumber,numberOfTOFLargeErrorsIndex,varianceGaussianNoiseIndex) ) * 100;
            
            localizationErrorsPSO( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , microphoneNumber ) = norm( m - gBestP(:,microphoneNumber,numberOfTOFLargeErrorsIndex,varianceGaussianNoiseIndex) ) * 100;
            
        end
    end
end

%v = clock;
%fileName = [ 'results_' num2str( v( 1 ) ) '_' num2str( v( 2 ) ) '_' num2str( v( 3 ) ) '_' num2str( v( 4 ) ) '_' num2str( v( 5 ) ) '_' num2str( round( v( 6 ) ) ) ];

%save( fileName )