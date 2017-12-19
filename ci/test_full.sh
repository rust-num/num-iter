#!/bin/bash

set -ex

echo Testing num-iter on rustc ${TRAVIS_RUST_VERSION}

# num-iter should build and test everywhere.
cargo build --verbose
cargo test --verbose

# We have no features to test...
