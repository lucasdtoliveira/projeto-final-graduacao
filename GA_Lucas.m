%My attempt

clear
clc

% Inicialização
% Gerar uma população aleatória binária - são 24 bits no total (vetor linha)

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



% Fazer loop até a condição de parada (quantidade de gerações)

for generationCount = 1:generationNumber,  

   evolutionTracking( : , : , generationNumber ) = population;
    
   for elementCount = 1:populationSize,
            % calculando a função objetivo para todos os elementos da
            % geração e guardando os valores
           currentFp( elementCount , generationCount ) = evaluateFglobalGA( population( elementCount , : ) , Delta , numberOfLoudspeakers , loudspeakersPositions , c , estimatedTOF );
  
   end 
   
   %separando os melhores individuos para copia-los na proxima geração
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
   
   % mutação
   for mutationCount = (numberOfEliteElements+1):populationSize
   
       mutate( population_2( mutationCount , : ) , mutationRate );
        
   end
   
   population = population_2;
   
   
end

