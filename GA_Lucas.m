%My attempt

clear
clc

% Inicializa��o
% Gerar uma popula��o aleat�ria bin�ria - s�o 24 bits no total (vetor linha)

populationSize = 20;
generationNumber = 100;
eliteRate = 0.1;
numberOfEliteElements = populationSize * eliteRate; 

population = round( rand( populationSize, 24 ) );
population_2 = zeros( populationSize, 24 );
evolutionTracking = zeros( populationSize, 24 , generationNumber );
currentFp = zeros( generationNumber , populationSize );
mutationRate = 0.01;


%copiado de Principal.m



% Fazer loop at� a condi��o de parada (quantidade de gera��es)

for generationCount = 1:generationNumber,  

   evolutionTracking( : , : , generationNumber ) = population;
    
   for elementCount = 1:populationSize,
            % calculando a fun��o objetivo para todos os elementos da
            % gera��o e guardando os valores
           currentFp( elementCount , generationCount ) = evaluateFglobalGA( population( elementCount , : ) , Delta , numberOfLoudspeakers , loudspeakersPositions , c , estimatedTOF );
  
   end 
   
   %separando os melhores individuos para copia-los na proxima gera��o
   aux = sort( currentFp( : , generationCount ) , 'descend' );
   
   for elementCount = 1:numberOfEliteElements
       index = find( currentFp( : , generationCount ) == aux( elementCount ) );
       population_2( elementCount , : ) = population( index , : );
       
   end    

   numberOfCrossovers = ( populationSize - numberOfEliteElements ) / 2;
   
   
   % fazendo crossover para preencher o restante de population_2
   index2 = numberOfEliteElements+1;
   for crossoverCount = 1:numberOfCrossover
      
      chosenOnes =  round( rand( 1 , 2 ) * populationSize );
      crossoverPoint = round( rand ) * 24;
      population_2( index2:(index2+1) , : ) = crossover( population( chosenOnes( 1 ) , : ) , population( chosenOnes( 2 ) , : ) , crossoverPoint );
      index2 = index2 + 2;
      
   end
   
   % muta��o
   for mutationCount = (numberOfEliteElements+1):populationSize
   
       mutate( population_2( mutationCount , : ) , mutationRate );
        
   end
   
   population = population_2;
   
   
end

