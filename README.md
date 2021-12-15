_This project is mostly for learning purposes._

# Identicon

Generate an avatar which represents a hash of unique information.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `identicon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:identicon, "~> 0.1.0"}
  ]
end
```

## Usage

The command below will generate the identicon for the `test` input string in the current folder, as a 250x250 PNG image.

```
$ iex -S mix
iex(1)> Identicon.generate_image("test")
:ok
```


## Notes

### EGD - Erlang Graphical Drawer

`:egd` is no longer available in Elixir OTP, so to get around this

mix.exs:

```
{:egd, github: "erlang/egd"}
```

To install dependencies:

```
mix deps.clean --all
mix deps.get
mix deps.compile
```

### Generate docs

mix.exs:

```
{:ex_doc, "~> 0.12"}
```

```
mix docs
```


