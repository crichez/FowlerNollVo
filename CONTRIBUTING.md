# Contributing to `FowlerNollVo`

This project is open for contributions! There are four main ways to contribute:

## Issues

Issues are a great way to call out bugs, performance issues, platform compatibility issues
you run into if you don't want to to get into the project code base.

There is no required issue format. If you're not sure where to begin, use one of the 
built-in issue templates for this project. If none of those quite fit your needs,
start from scratch. We'll make sure to ask follow-up questions if we are missing
any information.

When submitting issues, it's important to remember that this project is an *inplementation*
of FNV-1. This means changes to the hash function itself are out of scope.

## Running the Test Suite

If you have access to a platform that isn't already listed as supported in the README,
we would love it if you ran the package test suite and reported your results in an issue.
This is a cross-platform project, and more platforms are always better!

If you find that a specific use case is not tested for, you can use the Test Request
template to describe what you would like to add.

## Pull Requests

If you change or add to the project, please submit a pull request describing your changes.
Once again, there is no required format! Currently [Christopher Richez](github.com/crichez)
approves new contributors to keep the automated test workflows from running on
untrusted code and wasting resources. 
Make sure you commit all your changes to a branch with a very specific name so it's easier to track.
You can reference some of the [closed pull requests](github.com/crichez/swift-fowler-noll-vo/pulls) 
for good examples.

## New Implementations

Currently, the package only provides digests up to 64 bits long due to the lack of a 
multiplication operator on longer unisgned integer types. This is not a technical
limitation so much as a convenience limitation. If you write stable, reliable code for longer digests, 
please pull request and don't forget to include unit tests in your commit.

This project does not need to be pure-swift, it only needs to have a Swift API that is
stable accross all platforms and architectures. Architecture & platform-specific code is 
acceptable as long as it isn't exposed to platforms that don't support it.
