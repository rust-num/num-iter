extern crate autocfg;

use autocfg::AutoCfg;
use std::env;

fn main() {
    // If the "i128" feature is explicity requested, don't bother probing for it.
    // It will still cause a build error if that was set improperly.
    if env::var_os("CARGO_FEATURE_I128").is_some() || autocfg::new().probe_type("i128") {
        autocfg::emit("has_i128");
    }

    // The RangeBounds trait was stabilized in 1.28, so from that version onwards we
    // implement that trait.
    AutoCfg::new().unwrap().emit_rustc_version(1, 28);

    autocfg::rerun_path("build.rs");
}
