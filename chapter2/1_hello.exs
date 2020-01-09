defmodule HelloWorld do
  def greeting(io \\ IO) do
    get_name(io)
    |> get_greeting
    |> io.puts
  end

  defp get_name(io) do
    io.gets("What is your name? ") |> String.trim
  end

  defp get_greeting(name), do: "Hello, #{name}, nice to meet you!"
end

HelloWorld.greeting