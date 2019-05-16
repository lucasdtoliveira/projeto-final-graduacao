function [ eCDF ] = evaluateCDF( errorsVector , xVector )

eCDF = zeros( size( xVector ) );

for point = 1 : numel( xVector ),
    
    x = xVector( point );
    eCDF( point ) = numel( find( errorsVector <= x ) ) / numel( errorsVector );
    
end