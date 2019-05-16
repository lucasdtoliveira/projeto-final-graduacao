function [ bestGAdec ] = ga_L( populationSize , generationNumber , eliteRate , mutationRate , roomDimensions , Delta , loudspeakersPositions , c , estimatedTOF )

population = round( rand( populationSize, 24 ) );
population_2 = zeros( populationSize, 24 );
evolutionTracking = zeros( populationSize, 24 , generationNumber );
currentFp = zeros( generationNumber , populationSize );
numberOfEliteElements = populationSize * eliteRate; 
numberOfLoudspeakers = size( loudspeakersPositions , 1 );
% Fazer loop até a condição de parada (quantidade de gerações)

for generationCount = 1:generationNumber,  

   %evolutionTracking( : , : , generationNumber ) = population;
    
   for elementCount = 1:populationSize,
            % calculando a função objetivo para todos os elementos da
            % geração e guardando os valores
           currentFp( elementCount , generationCount ) = evaluateFglobalGA( population( elementCount , : ) , Delta , numberOfLoudspeakers , loudspeakersPositions , c , estimatedTOF , roomDimensions );
  
   end 
   ind = find( max(currentFp) );
   bestGA = population( ind(1) , : );
   %separando os melhores individuos para copia-los na proxima geração
   aux = sort( currentFp( : , generationCount ) , 'descend' );
   
   for elementCount = 1:numberOfEliteElements
       
       index = find( currentFp( : , generationCount ) == aux( elementCount ) );
       population_2( elementCount , : ) = population( index(1) , : );
       
   end    

   numberOfCrossovers = round(( populationSize - numberOfEliteElements )) / 2;
   
   
   % fazendo crossover para preencher o restante de population_2
   index2 = numberOfEliteElements+1;
   for crossoverCount = 1:numberOfCrossovers
      
      chosenOnes =  ceil( rand( 1 , 2 ) * populationSize );
      crossoverPoint = ceil( rand ) * 24;
      population_2( index2:(index2+1) , : ) = crossover( population( chosenOnes( 1 ) , : ) , population( chosenOnes( 2 ) , : ) , crossoverPoint );
      index2 = index2 + 2;
      
   end
   
   % mutação
   for mutationCount = (numberOfEliteElements+1):populationSize
   
       mutation( population_2( mutationCount , : ) , mutationRate );
        
   end
   
   population = population_2;  
   
   bestGAdec = convertToDecimal( bestGA , roomDimensions );
   
end


