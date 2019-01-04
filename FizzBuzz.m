% FizzBuzz in Matlab

startingPoint = -100;
endPoint = 100;

FizzBuzzer(startingPoint, endPoint)

%%%%%%%%%%%%
% Function definitions
%%%%%%%%%%%%

function FizzBuzzer(strtPoint, endPoint)
% Cycles through a range defined by two integers,
% prints FIZZ for multiples of three, BUZZ for multiples of five,
% and FIZZBUZZ for multiples of both. Returns nothing useful

    for n = strtPoint:endPoint
        if n == 0
            disp(n)
        elseif (mod(n, 3) == 0 && mod(n, 5) == 0)
            disp('FIZZBUZZ')
        elseif mod(n, 3) == 0
            disp('FIZZ')
        elseif mod(n, 5) == 0
            disp('BUZZ')
        else
            disp(n)
        end       
    end
end







