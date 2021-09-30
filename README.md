# J5pux Optpy

## How do I install these formulae?

`brew install j5pux/optpy/<formula>`

Or `brew tap j5pux/optpy` and then `brew install <formula>`.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## Create and Test 
```bash
cd /usr/local/Homebrew/Library/Taps/j5pux
gh new homebrew-optpy public "Homebrew tap for python install opt"
url="https://github.com/j5pux/optpy/archive/refs/tags/v0.1.0.tar.gz"
brew create --tap=j5pux/optpy "${url/ref\/tags\//}" 
brew edit j5pux/optpy/optpy
brew audit --quiet --new optpy
brew install --quiet j5pux/optpy/optpy
brew test --quiet optpy
```
### Print variables 
```bash
brew audit --new variables

````
