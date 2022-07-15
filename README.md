
# Homebrew tap (3rd-party repository)

A private formula repository for [Homebrew](https://docs.brew.sh/).

## Usage

```bash
brew tap junipersquare/homebrew git@github.com:junipersquare/homebrew-repo.git  
brew install junipersquare/homebrew/<formula>
```

Example: 
```
brew install junipersquare/homebrew/pre-commit
```

Once a formula is updated:

```
brew update    ## refresh formulas
brew upgrade junipersquare/homebrew/<formula>
```

## Adding a formula with a duplicate name
> If your tap contains a formula that is also present in homebrew/core, that’s fine, but you would need to specify 
> its fully qualified name in the form <user>/<repo>/<formula> to install your version.
> Whenever a brew install foo command is issued, brew selects which formula to use by searching in the following order:
> - core formulae
> - other taps
> If you need a formula to be installed from a particular tap, you can use fully qualified names to refer to them.

```bash
brew install vim                     # installs from homebrew/core
brew install username/repo/vim       # installs from your custom repository
```
