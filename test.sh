#!/usr/bin/env bash

brew audit --quiet --new optpy-test
#brew audit --quiet --new variables
#brew install --quiet j5pux/optpy/optpy
#brew install --quiet j5pux/optpy/variables
brew install --quiet j5pux/optpy/optpy-test
#brew test --quiet optpy
brew test --quiet optpy-test
#brew test --quiet variables
