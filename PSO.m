clc
clear all

numberOfParticles = 100;
roomDimensions = [ 5.2 7.5 2.6 ];

% Inicializa��o
particles = [ rand( 1 , numberOfParticles ) * roomDimensions( 1 );
              rand( 1 , numberOfParticles ) * roomDimensions( 2 );
              rand( 1 , numberOfParticles ) * roomDimensions( 3 )];
