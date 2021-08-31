# Contributing to `FowlerNollVo`

This project is small and simple. We expect most contributions to relate to:
* Bug fixes
* Performance
* Documentation
* Style
* Implementations

Changes to the hash function are considered out of scope, since this repository is simply an implementation of the existing function.

## Bug Fixes

If you find that the FNV-1 hash is improperly implemented please create an issue and let us know.
If you find that a certain method causes memory leaks, please report so showing your profiling results.
If you experience a crash of any kind, please create an issue and include your code.

## Performance

Changes that produce demonstrably lower memory utilization or execution time are more than welcome.
Make sure you include unit tests with your pull requests that demonstrate that performance change.

## Documentation

There may be spelling errors, strangely worded sentences, or simply missing details and examples.
If you were confused reading something, please create an issue and we will happily update our docs.

## Style

The initial package was not written with a style guide in mind.
If you find some code hard to read, please create an issue and we will resolve it quickly.
If more than a handful of people speak up, we can consider adopting a style guide.

## Implementations

Additional hash sizes may be considered if the implementation passes the same suite of consistency and collision rate tests as the original four.
The main thing preventing this right now is the lack of a 128-bit integer type in the Swift standard library.
