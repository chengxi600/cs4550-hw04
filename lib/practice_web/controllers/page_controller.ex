defmodule PracticeWeb.PageController do
  use PracticeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def double(conn, %{"x" => x}) do
    try do
      if String.match?(x, ~r/[^\d\s]/) do
        raise MatchError
      end
      {x, _} = Integer.parse(x)
      y = Practice.double(x)
      render conn, "double.html", x: x, y: y
    rescue
      MatchError ->
      y = "Please put a valid number"
      render conn, "double.html", x: x, y: y
    end
  end

  def calc(conn, %{"expr" => expr}) do
    try do
      if String.match?(expr, ~r/[^\d+-\/*\s]/) do
        raise MatchError
      end
      y = Practice.calc(expr)
      render conn, "calc.html", expr: expr, y: y
    rescue
      ArgumentError ->
      y = "Please put a valid expression. Put spaces between each operator and operand."
      render conn, "calc.html", expr: expr, y: y

      MatchError ->
      y = "Please put valid numbers or operators."
      render conn, "calc.html", expr: expr, y: y
    end
  end

  def factor(conn, %{"x" => x}) do
    try do
      if String.match?(x, ~r/[^\d\s]/) do
        raise MatchError
      end
      {x, _} = Integer.parse(x)
      y = Enum.join(Practice.factor(x), ", ")
      render conn, "factor.html", x: x, y: y
    rescue
      MatchError ->
      y = "Please put a valid positive integer"
      render conn, "factor.html", x: x, y: y
    end
  end

  def palindrome(conn, %{"str" => str}) do
    y = Practice.palindrome(str)
    render conn, "palindrome.html", str: str, y: y
  end

  # TODO: Add an action for palindrome.
  # TODO: Add a template for palindrome over in lib/*_web/templates/page/??.html.eex
end
