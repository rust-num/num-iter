#!/bin/bash

set -e

CRATE=num-iter
MSRV=1.31

get_rust_version() {
  local array=($(rustc --version));
  echo "${array[1]}";
  return 0;
}
RUST_VERSION=$(get_rust_version)

check_version() {
  IFS=. read -ra rust <<< "$RUST_VERSION"
  IFS=. read -ra want <<< "$1"
  [[ "${rust[0]}" -gt "${want[0]}" ||
   ( "${rust[0]}" -eq "${want[0]}" &&
     "${rust[1]}" -ge "${want[1]}" )
  ]]
}

echo "Testing $CRATE on rustc $RUST_VERSION"
if ! check_version $MSRV ; then
  echo "The minimum for $CRATE is rustc $MSRV"
  exit 1
fi

FEATURES=()
echo "Testing supported features: ${FEATURES[*]}"

cargo generate-lockfile

# num-traits 0.2.19 started using dep: features, which requires 1.60 and is
# otherwise ignored down to 1.51, but we need a manual downgrade before that.
check_version 1.51 || cargo update -p num-traits --precise 0.2.18

set -x

# test the default
cargo build
cargo test

# test `no_std`
cargo build --no-default-features
cargo test --no-default-features

# test each isolated feature, with and without std
for feature in ${FEATURES[*]}; do
  cargo build --no-default-features --features="std $feature"
  cargo test --no-default-features --features="std $feature"

  cargo build --no-default-features --features="$feature"
  cargo test --no-default-features --features="$feature"
done

# test all supported features, with and without std
cargo build --features="std ${FEATURES[*]}"
cargo test --features="std ${FEATURES[*]}"

cargo build --features="${FEATURES[*]}"
cargo test --features="${FEATURES[*]}"
