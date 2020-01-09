# Create a program that prompts for an input string and displays output
# that shows the input string and the number of characters the string
# contains.
# Example Output 
  # What is the input string? Homer
  # Homer has 5 characters.

defmodule CountingCharacters do
  def run(io \\ IO) do
    io.gets("What is the input string?")
    |> String.trim
    |> print_count(io)
  end

  defp print_count("", io), do: io.puts("No characters.")
  defp print_count(input, io) do
    io.puts("#{input} has #{String.length(input)} characters.")
  end
end

ExUnit.start()

defmodule FakeIO do
  def start_link(input) do
    Agent.start_link(fn -> input end, name: __MODULE__)
  end

  def gets(_prompt) do
    Agent.get(__MODULE__, & &1)
  end

  def puts(message), do: message
end

defmodule CountingCharactersTest do
  use ExUnit.Case

  describe "#run" do
    test 'when single case' do
      FakeIO.start_link("Homer\n")
      assert CountingCharacters.run(FakeIO) == "Homer has 5 characters."
    end

    test 'when no input received' do
      FakeIO.start_link("\n")
      assert CountingCharacters.run(FakeIO) == "No characters."
    end
  end
end