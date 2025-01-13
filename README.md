# swift-differentiation-testing
This repository serves as a test suite of crashes and other broken behaviour related to the [Differentiable Swift](https://github.com/differentiable-swift#meet-differentiable-swift) language feature. It aims to provide a low bar for Differentiable Swift users to provide reproducers to crashes or incorrect behaviour. 
Tests that reproduce currently broken behaviour are added as expecting to fail and once fixed in future toolchain releases will be marked as fixed and used to run as a test suite. 
The tests are currently divided into 4 different categories: 
- Compiletime crash tests, checks for unexpected while compiling code.
- Runtime crash tests, checks for unexpected crashes while running code.
- Runtime validation tests, checks for incorrect results while running code.
- Runtime performance tests, checks for changes in performance as implementations evolve.

The ultimate goal of this repository is for the library portion to no longer exist since all implementations are either upstreamed to [Swift](https://github.com/swiftlang/swift) or the provided workarounds are no longer needed since there's more direct language support making them obsolete. 
We would ultimately like this repository to become a collection of Examples and documentation on the language feature so that people can more easily get started using Differentiable Swift! 

## Overview
Currently this repository provides the following:
- [Compiletime crash test](CompiletimeCrashTests) suite
- [Runtime crash test](RuntimeCrashTests) suite
- [Runtime validation test](RuntimeValidationTests) suite
- [Runtime performance test](RuntimePerformanceTests) suite with [results being tracked over time](https://differentiable-swift.github.io/swift-differentiation-testing/RuntimePerformanceTests/results/)

## Differentiable Swift
The goal of the Differentiable Swift language feature is to provide first-class, language-integrated support for differentiable programming, making Swift the first general-purpose, statically typed programming language to have automatic differentiation built in. Originally developed as part of the [Swift for TensorFlow](https://github.com/tensorflow/swift) project, teams at [PassiveLogic](https://passivelogic.com) and elsewhere are currently working on it. Differentiable Swift is purely a language feature and isn't tied to any specific machine learning framework or platform.
To find out more, have a look at our library [differentiable-swift]() or our other [repositories](https://github.com/differentiable-swift).

## Contributing
If you run into something that's broken please file an issue! If you have code that reproduces broken behaviour add it to the issue so that we can more easily debug or help with the problem you're running into. 

## License
This library is released under the Apache 2.0 license. See [LICENSE](https://github.com/differentiable-swift/swift-differentiation/blob/main/LICENSE) for details.
