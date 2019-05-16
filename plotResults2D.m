clc
clear all

%load results_2016_10_13_10_58_9.mat
%load results_2017_8_1_18_45_55.mat


load results_2017_8_9_15_45_16.mat


estimatedPositionT2D = zeros(2, numberOfMicrophonePositions);
estimatedPositionD2D = zeros(2, numberOfMicrophonePositions);

localizationErrorsT2D = zeros(numel( varianceGaussianNoiseVector ),numel( numberOfTOFLargeErrorsVector ), numberOfMicrophonePositions);
localizationErrorsD2D = zeros(numel( varianceGaussianNoiseVector ),numel( numberOfTOFLargeErrorsVector ), numberOfMicrophonePositions);
localizationErrorsPSO2D = zeros(numel( varianceGaussianNoiseVector ),numel( numberOfTOFLargeErrorsVector ), numberOfMicrophonePositions);

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
            
            localizationErrorsT2D( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , microphoneNumber ) = norm( m(1:2) - theta{ 1 }( 2 : 3 ) ) * 100;
            localizationErrorsD2D( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , microphoneNumber ) = norm( m(1:2) - theta{ 2 }( 2 : 3 ) ) * 100;
            
            localizationErrorsPSO2D( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , microphoneNumber ) = norm( m(1:2) - gBestP(1:2,microphoneNumber,numberOfTOFLargeErrorsIndex,varianceGaussianNoiseIndex) ) * 100;
            
        end
    end
end






localizationErrorCmVector = [ 0 : .1 : 350 ];

for varianceGaussianNoiseIndex = 1 : numel( varianceGaussianNoiseVector ),

    set( figure , 'Color' , 'w' )
    for numberOfTOFLargeErrorsIndex = 1 : numel( numberOfTOFLargeErrorsVector ),
        
      currentLocalizationErrorsPSO = squeeze( localizationErrorsPSO( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , : ) );
      currentLocalizationErrorsT = squeeze( localizationErrorsT( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , : ) );
      currentLocalizationErrorsD = squeeze( localizationErrorsD( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , : ) );        
        
      currentLocalizationErrorsPSO2D = squeeze( localizationErrorsPSO2D( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , : ) );
      currentLocalizationErrorsT2D = squeeze( localizationErrorsT2D( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , : ) );
      currentLocalizationErrorsD2D = squeeze( localizationErrorsD2D( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , : ) );
      
      
      eCDFPSO = evaluateCDF( currentLocalizationErrorsPSO , localizationErrorCmVector );
      eCDFT   = evaluateCDF( currentLocalizationErrorsT   , localizationErrorCmVector );
      eCDFD   = evaluateCDF( currentLocalizationErrorsD   , localizationErrorCmVector );
      
      eCDFPSO2D = evaluateCDF( currentLocalizationErrorsPSO2D , localizationErrorCmVector );
      eCDFT2D   = evaluateCDF( currentLocalizationErrorsT2D   , localizationErrorCmVector );
      eCDFD2D   = evaluateCDF( currentLocalizationErrorsD2D   , localizationErrorCmVector );
      
      
      %set( figure , 'Color' , 'w' )
      subplot(numel( numberOfTOFLargeErrorsVector ),1,numberOfTOFLargeErrorsIndex)
      plot( localizationErrorCmVector , eCDFPSO2D , 'b' );
      hold on
      plot( localizationErrorCmVector , eCDFPSO , 'c' );
    %  plot( localizationErrorCmVector , eCDFT2D , 'r' );
    %  plot( localizationErrorCmVector , eCDFD2D , 'g' );
      legend( 'PSO2D' , 'PSO')
      xlabel( 'Localization Error (cm)' )
      ylabel( 'CDF' )
      grid on
      axis tight
      title( [ '\sigma_{\nu}^2 = ' num2str( varianceGaussianNoiseVector( varianceGaussianNoiseIndex ) ) ' - Number of Large TOF Errors: ' num2str( numberOfTOFLargeErrorsVector( numberOfTOFLargeErrorsIndex ) )] )
        
    end
end
