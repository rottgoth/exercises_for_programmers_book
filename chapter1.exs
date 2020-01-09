defmodule TipCalculator do
  def run(io \\ IO) do
    amount = get_input(io, "Bill amount:", "bill amount")
    tip_rate = get_input(io, "Tip rate:", "tip rate")

    {tip, total} = calculate(amount, tip_rate)
    io.puts "Tip: #{:erlang.float_to_binary(tip, [decimals: 2])}"
    io.puts "Total: #{:erlang.float_to_binary(total, [decimals: 2])}"
  end

  def calculate(amount, tip_rate) do
    tip_percent = tip_rate / 100
    tip = Float.round(amount * tip_percent, 2)
    total = Float.round(amount + tip, 2)
    {tip, total}
  end

  defp get_input(io, input, attr) do
    try do
      input
      |> io.gets
      |> String.trim
      |> Float.parse
      |> elem(0)
      |> validate_input
    rescue
      ArgumentError ->
        io.puts "Expected result: Please enter a valid number for the #{attr}."
        get_input(io, input, attr)
    end
  end

  defp validate_input(number) when number > 0, do: number
  defp validate_input(_), do: raise ArgumentError
end

ExUnit.start()

defmodule FakeIO do
  def gets("Bill amount:"), do: "10"
  def gets("Tip rate:"), do: "15"
  def gets(value), do: raise ArgumentError, message: "invalid argument #{value}"
  def puts("Tip: 1.50"), do: true
  def puts("Total: 11.50"), do: true
  def puts(value), do: raise ArgumentError, message: "invalid argument #{value}"
end

defmodule TipCalculatorTest do
  use ExUnit.Case
  # doctest TipCalculator

  test "run" do
    assert TipCalculator.run(FakeIO) == true
  end

  # calculate
  test "when amount is 10 and tip 15, total is 11.50" do
    assert TipCalculator.calculate(10, 15) == {1.50, 11.50}
  end

  test "when amount is 11.25 and tip 15, total is 11.50" do
    assert TipCalculator.calculate(11.25, 15) == {1.69, 12.94}
  end

  test "when amount is 0 and tip 15, total is 0" do
    assert TipCalculator.calculate(0, 15) == {0, 0}
  end

  test "when amount is 10 and tip 0, total is 10" do
    assert TipCalculator.calculate(10, 0) == {0, 10}
  end
end

TipCalculator.run