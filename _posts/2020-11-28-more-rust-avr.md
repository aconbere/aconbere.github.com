---
layout: post
title: "Daily Log 2020-11-28: More Rust AVR"
date: 2020-11-28 08:33 -0800
---

## Trying out avr-hal

From the rust avr gitter channel;

* https://github.com/Rahix/avr-hal
* https://github.com/Rahix/avr-hal/tree/master/chips/attiny85-hal

### Workspaces and Git Imported Crates

This mostly worked but avr-hal isn't hosted on crates.io and is imported via git. This would be fine but I wasn't familiar with how workspaces and git imported crates worked.

hal-avr defines a Cago.toml entry that looks like this

> [workspace]
> members = [
>     "avr-hal-generic",
>     ...
>     "chips/attiny85-hal",
>     ...
>     "boards/trinket",
> ]

This defines a series of "workspaces" in cargo terminology. A workspace is a package in a package and allows you to split up a project into a series of interdependent crates. In typical use of Crates.io these all just show up as separate crates.

When you define a dependency in your own Cargo.toml like

> [dependencies.attiny85-hal]
> git = "https://github.com/Rahix/avr-hal"
> rev = "a22f954"

It tells Cargo to find the "attiny85-hal" crate *somewhere* in the linked repository including any workspaces. So in this case since we want to use this with our ATtiny85 board we are importing specifically the *attiny85-hal* crate from the avr project.

### Compiling

I ran into some issues getting my very simple test compiling (just a loop in main). The avr-hal project provides an `entry` macro that sets up your main function to be properly loaded for running by the chip. In this case while I could `use attiny85_hal`, no macro entry was found. This ended up having to do with "features". This isn't a feature of cargo that I'm familiar with and it took me a bit of fumbling to get it working. Eventually I added this to my Cargo.toml.

> [features]
> default = ["rt"]
> rt = ["attiny85-hal/rt"]

rt is a Cargo feature that includes a runtime. It appears to be derived from the [scd2rust crate](https://docs.rs/svd2rust/0.17.0/svd2rust/) which provides automated code generation based on SVD specs.
