fn main() {
    let autocfg = autocfg::new();

    // The RangeBounds trait was stabilized in 1.28, so from that version onwards we
    // implement that trait.
    autocfg.emit_rustc_version(1, 28);

    autocfg::rerun_path("build.rs");
}
