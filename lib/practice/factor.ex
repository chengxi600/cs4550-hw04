defmodule Practice.Factor do
    def factor(x) do
        x
        |> getFactors([], 2)
    end

    def getFactors(num, arr, divisor) do
        rem = rem(num, divisor)
        if num == divisor do
            arr ++ [divisor]
        else
            cond do
                rem == 0 ->
                    getFactors(trunc(num/divisor), arr ++ [divisor], divisor)
                rem != 0 ->
                    getFactors(num, arr, divisor + 1)
            end
        end
    end    
end