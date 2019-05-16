function [ estimatedTOF ] = corruptingTOF( tof , noiseGaussianVariance , fs , numberOfLoudspeakers , numberOfTOFLargeErrors , minLargeTOFError , maxLargeTOFError )

    estimatedTOF = tof + sqrt( noiseGaussianVariance ) * randn( size( tof ) );

    estimatedTOF = round( estimatedTOF * fs ) / fs;

    indices = randperm( numberOfLoudspeakers );
    indices = indices( 1 : numberOfTOFLargeErrors );

    for corruption = 1 : numberOfTOFLargeErrors,

        estimatedTOF( indices( corruption ) ) = estimatedTOF( indices( corruption ) ) + rand * ( maxLargeTOFError - minLargeTOFError ) + minLargeTOFError;

    end
