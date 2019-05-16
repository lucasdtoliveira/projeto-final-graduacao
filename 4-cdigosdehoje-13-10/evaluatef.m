function [ y ] = evaluatef( x , Delta )

if ( abs( x ) > Delta )
    y = 0;
else
    y = - x ^ 2 / Delta ^ 2 + 1;
end