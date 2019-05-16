function [ resultado ] = mutation( candidate , mutationRate )

resultado = candidate;

for i = 1:size( candidate )
    
    a = rand;
    if ( a < mutationRate )
        
        resultado( i ) = not( candidate( i ) );
        
    end
 
end