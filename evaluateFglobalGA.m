function [ F ] = evaluateFglobalGA( candidateMbinary , Delta , numberOfLoudspeakers , loudspeakersPositions , c , estimatedTOF , roomDimensions )

%x = candidateM;
F = 0;
%disp('evalGA')
%candidateM = zeros(1,3);
candidateM = convertToDecimal( candidateMbinary , roomDimensions );


for r = 1 : numberOfLoudspeakers - 1,
    for s = r + 1 : numberOfLoudspeakers,
        
        expectedTDOF = norm( candidateM - loudspeakersPositions( s , : ) ) / c - norm( candidateM - loudspeakersPositions( r , : ) ) / c;
        estimatedTDOFsr = estimatedTOF( s ) - estimatedTOF( r );
        DeltaTau = expectedTDOF - estimatedTDOFsr;
        F = F + evaluatef( DeltaTau , Delta );
        
    end
end
