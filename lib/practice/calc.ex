defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  #function takes in an operator/num and returns a tagged token
  def toToken(value) do
    case value do 
      "+" -> {:op, "+"}
      "-" -> {:op, "-"}
      "/" -> {:op, "/"}
      "*" -> {:op, "*"}
      x -> {:num, parse_float(x)}
    end
  end

  #function takes in a split postfix expression, accumulator stack for operand and returns an evaluated result
  def postFixToEval(arr, operandStack) do
    cond do 
      #if arr not done processing,
      #update operandStack with head of postfix arr
      #recurse on the tail of postfix arr
      length(arr) != 0 ->
        newOperandStack = processPostFixToken(hd(arr), operandStack)
        postFixToEval(tl(arr), newOperandStack)
      #if arr is processed, pop the result in stack
      length(arr) == 0 ->
        hd(operandStack)
    end
  end

  #function takes in a tagged token returns an updated operand stack 
  def processPostFixToken(token, operandStack) do
    case elem(token, 0) do
      #if token is a num, push to stack
      :num -> [elem(token, 1)] ++ operandStack
      #if token is an operator, pop stack twice, perform evaluation, then push result to stack
      :op ->
        case elem(token, 1) do
          "+" ->
            result = hd(tl(operandStack)) + hd(operandStack)
            [result] ++ tl(tl(operandStack))
          "-" ->
            result = hd(tl(operandStack)) - hd(operandStack)
            [result] ++ tl(tl(operandStack))
          "/" ->
            result = hd(tl(operandStack)) / hd(operandStack)
            [result] ++ tl(tl(operandStack))
          "*" ->
            result = hd(tl(operandStack)) * hd(operandStack)
            [result] ++ tl(tl(operandStack))
        end
    end
  end

  #function takes in a split inflix expression, accumulator for postfix arr, accumulator for operator stack, and returns a postfix expression array
  def toPostFixNum(arr, outputList, stackOp) do
    cond do
      #if arr not done processing
      length(arr) != 0 ->
        #if head of arr is an operator, update outputList and stackOp
        #recurse on tail of arr
        #else if head of arr is a num, append to outputList and recurse on tail of arr
        if(elem(hd(arr), 0) == :op) do
          {newOutputList, newStackOp} = handleOp(hd(arr), outputList, stackOp)
          toPostFixNum(tl(arr), newOutputList, newStackOp)
        else
          toPostFixNum(tl(arr), outputList ++ [hd(arr)], stackOp)
        end
      #if arr is done processing and stack is not empty
      #append stack to end of outputList
      length(arr) == 0 && length(stackOp) != 0 ->
        outputList ++ stackOp
      #if arr is done processing and stack is empty, return outputList
      length(arr) == 0 && length(stackOp) == 0 ->
        outputList
    end
  end
  
  #function takes in a token and returns an updated outputList and stackOp
  def handleOp(token, outputList, stackOp) do
    #perform popAndAppend if head of stackOp has same or higher priority than token
    # else, push token to stack
    case elem(token, 1) do
      "+" -> 
      if length(stackOp) != 0 do
        popAndAppend(token, outputList, stackOp)
      else
        stackOp = [token] ++ stackOp
        {outputList, stackOp}
      end
      "-" ->
      if length(stackOp) != 0 do
        popAndAppend(token, outputList, stackOp)
      else
        stackOp = [token] ++ stackOp
        {outputList, stackOp}
      end
      "*" ->
      if length(stackOp) != 0 && elem(hd(stackOp), 1) == "/" do
        popAndAppend(token, outputList, stackOp)
      else
        stackOp = [token] ++ stackOp
        {outputList, stackOp}
      end
      "/" ->
      if length(stackOp) != 0 && elem(hd(stackOp), 1) == "*" do
        popAndAppend(token, outputList, stackOp)       
      else
        stackOp = [token] ++ stackOp
        {outputList, stackOp}
      end
      _ -> {outputList, stackOp}
    end
  end

  #pop stack and append head to outputList. Push token to stack
  def popAndAppend(token, outputList, stackOp) do
    newStack = tl(stackOp)
    newOutputList = outputList ++ [hd(stackOp)]
    newStack = [token] ++ newStack
    {newOutputList, newStack} 
  end

  #checks if any token contains an operator and length > 1 with the exception of negative numbers
  def isInvalid(arr) do
    Enum.any?(arr, fn(token) -> String.contains?(token, ["*", "+", "/", "-"]) && String.length(token) > 1 && !String.match?(token, ~r/^[-]\d$/) end)
  end

  def calc(expr) do
    # Split expression into list
    # Tag tokens
    # convert to postfix expression
    # evaluate
    arr = String.split(expr)
    if isInvalid(arr) do
      raise ArgumentError
    else
      arr
      |> Enum.map(fn(x) -> toToken(x) end)
      |> toPostFixNum([], [])
      |> postFixToEval([])
    end
  end
end
