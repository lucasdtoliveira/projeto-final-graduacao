function [ F ] = evaluateFglobal( candidateM , Delta , numberOfLoudspeakers , loudspeakersPositions , c , estimatedTOF )

F = 0;
for r = 1 : numberOfLoudspeakers - 1,
    for s = r + 1 : numberOfLoudspeakers,
        
        expectedTDOF = norm( candidateM - loudspeakersPositions( s , : ) ) / c - norm( candidateM - loudspeakersPositions( r , : ) ) / c;
        estimatedTDOFsr = estimatedTOF( s ) - estimatedTOF( r );
        DeltaTau = expectedTDOF - estimatedTDOFsr;
        F = F + evaluatef( DeltaTau , Delta );
        
    end
end
