clc
clear all

%load results_2016_10_13_10_58_9.mat
load results_2017_8_1_19_17_47.mat



localizationErrorCmVector = [ 0 : .1 : 100 ];

for varianceGaussianNoiseIndex = 1 : numel( varianceGaussianNoiseVector ),

    for numberOfTOFLargeErrorsIndex = 1 : numel( numberOfTOFLargeErrorsVector ),
        
      currentLocalizationErrorsPSO = squeeze( localizationErrorsPSO( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , : ) );
      currentLocalizationErrorsT = squeeze( localizationErrorsT( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , : ) );
      currentLocalizationErrorsD = squeeze( localizationErrorsD( varianceGaussianNoiseIndex , numberOfTOFLargeErrorsIndex , : ) );
      
      eCDFPSO = evaluateCDF( currentLocalizationErrorsPSO , localizationErrorCmVector );
      eCDFT   = evaluateCDF( currentLocalizationErrorsT   , localizationErrorCmVector );
      eCDFD   = evaluateCDF( currentLocalizationErrorsD   , localizationErrorCmVector );
      
      set( figure , 'Color' , 'w' )
      plot( localizationErrorCmVector , eCDFPSO , 'b' );
      hold on
      plot( localizationErrorCmVector , eCDFT , 'r' );
      plot( localizationErrorCmVector , eCDFD , 'g' );
      legend( 'PSO' , 'T' , 'D' )
      xlabel( 'Localization Error (cm)' )
      ylabel( 'CDF' )
      grid on
      axis tight
      title( [ '\sigma_{\nu}^2 = ' num2str( varianceGaussianNoiseVector( varianceGaussianNoiseIndex ) ) ' - Number of Large TOF Errors: ' num2str( numberOfTOFLargeErrorsVector( numberOfTOFLargeErrorsIndex ) )] )
        
    end
end

