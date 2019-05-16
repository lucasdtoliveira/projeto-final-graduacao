clc
clear all


%load results_2017_8_3_17_6_35.mat
load results_2017_8_9_15_45_16.mat



%localizationErrorCmVector = [ 0 : .1 : 350 ];

microphoneNumber = 50;
positionMic = microphonePositions(:,microphoneNumber);
%movie(M,n,fps) M é o vetor com os frames, n o número de vezes que será
%reproduzido e fps the number of frames per second

for varianceGaussianNoiseIndex = 1 : numel( varianceGaussianNoiseVector ),

    for numberOfTOFLargeErrorsIndex = 1 : numel( numberOfTOFLargeErrorsVector ),
        pause

       for indexIterations = 1:numberOfIterations,
                
           x = progression(1, :, indexIterations, varianceGaussianNoiseIndex, numberOfTOFLargeErrorsIndex, microphoneNumber);
           y = progression(2, :, indexIterations, varianceGaussianNoiseIndex, numberOfTOFLargeErrorsIndex, microphoneNumber);
           z = progression(3, :, indexIterations, varianceGaussianNoiseIndex, numberOfTOFLargeErrorsIndex, microphoneNumber);
          
          %progression = zeros(3, numberOfParticles, numberOfIterations, numel( varianceGaussianNoiseVector ), numel( numberOfTOFLargeErrorsVector ), numberOfMicrophonePositions)   %%     
         % scatter3(x,y,z,'filled')
          scatter(x,y,'filled')
          axis([0 6 0 8])
          hold on
         
          %scatter3(gBestP(1),gBestP(2),gBestP(3),'filled', 'MarkerEdgeColor','g','MarkerFaceColor','y')
          scatter(gBestP(1, microphoneNumber,numberOfTOFLargeErrorsIndex,varianceGaussianNoiseIndex),gBestP(2, microphoneNumber,numberOfTOFLargeErrorsIndex,varianceGaussianNoiseIndex),'filled', 'MarkerEdgeColor','b' , 'MarkerFaceColor','y')
          scatter(positionMic(1, 1), positionMic(2, 1) , 'filled',  'MarkerEdgeColor','b', 'MarkerFaceColor','r') 
          title( [ '\sigma_{\nu}^2 = ' num2str( varianceGaussianNoiseVector( varianceGaussianNoiseIndex ) ) ' - Number of Large TOF Errors: ' num2str( numberOfTOFLargeErrorsVector( numberOfTOFLargeErrorsIndex ) )] )
         
          F(indexIterations, numberOfTOFLargeErrorsIndex, varianceGaussianNoiseIndex) = getframe(gcf);
      
          pause(0.1)
            
          hold off
       end
      
         
    end
end

