function [ tof ] = evaluateTOF( m , loudspeakersPositions , c )

numberOfLoudspeakers = size( loudspeakersPositions , 1 );
tof = zeros( numberOfLoudspeakers , 1 );

for speaker = 1 : numberOfLoudspeakers,
    
    tof( speaker ) = norm( loudspeakersPositions( speaker , : ) - m' ) / c;
    
end

