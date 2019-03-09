# Scenic Escher

An implementation of Escher's Square Limit using Scenic and Elixir.

This work is based on the [Functional Geometry
paper](https://eprints.soton.ac.uk/257577/1/funcgeo2.pdf) by Peter Henderson. Here's the abstract:

```
An algebra of pictures is described that is sufficiently powerful to denote
the structure of a well-known Escher woodcut, Square Limit. A decomposition of the
picture that is reasonably faithful to Escher's original design is given. This illustrates
how a suitably chosen algebraic specification can be both a clear description and a
practical implementation method. It also allows us to address some of the criteria
that make a good algebraic description.
```

## How to run

Pull the repo

```
git clone https://github.com/Arkham/scenic_escher
```

Install and compile all the dependencies

```
mix deps.get && mix deps.compile
```

Then run the program

```
iex -S mix scenic.run
```

You should see something like this

![](https://github.com/Arkham/scenic_escher/blob/master/images/square_limit.png)


## Credits

Huge props to https://github.com/einarwh/escher-workshop
