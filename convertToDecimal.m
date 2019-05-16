function [ decimalVector ] = convertToDecimal( candidateMbinary , roomDimensions )

decimalVector( 1 ) = bi2de( candidateMbinary( 1:8 ), 'left-msb' ) * ( roomDimensions(1)/255 );
decimalVector( 2 ) = bi2de( candidateMbinary( 9:16 ), 'left-msb' ) * ( roomDimensions(2)/255 );
decimalVector( 3 ) = bi2de( candidateMbinary( 17:24 ), 'left-msb' ) * ( roomDimensions(3)/255 );


%roomDimensions = [ 5.2 7.5 2.6 ];