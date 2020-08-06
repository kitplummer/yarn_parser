# YarnParser

## Installation

[Available in Hex](https://hex.pm/packages/yarn_parser), the package can be installed
by adding `yarn_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:yarn_parser, "~> 0.3.0"}
  ]
end
```

## Usage

```elixir
iex> input = 
  """
  # Some comment
  # yarn lockfile v1
  key1, key2:
    val1 true
    subkey1:
      val2 123
  """

iex> {:ok, parsed} = YarnParser.parse(input)
parsed
{:ok,
  %{
    "comments" => ["# Some comment", "# yarn lockfile v1],
    "key1" => %{
      "val1" => true,
      "subkey1" => %{
        "val2" => 123
      }
    },
    "key2" => %{
      "val1" => true,
      "subkey1" => %{
        "val2" => 123
      }
    }
  }
}

iex> YarnParser.get_version(parsed)
1
```

## TODO
- [ ] Parse with merge conflicts
- [ ] Improve error messages

