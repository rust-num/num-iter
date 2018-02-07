#!/bin/bash

set -ex

echo Testing num-iter on rustc ${TRAVIS_RUST_VERSION}

# num-iter should build and test everywhere.
cargo build --verbose
cargo test --verbose

# test `no_std`
cargo build --verbose --no-default-features
cargo test --verbose --no-default-features
