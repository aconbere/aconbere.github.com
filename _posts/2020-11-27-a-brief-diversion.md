---
layout: post
title: "A Brief Diversion: Rust AVR"
date: 2020-11-27 19:14 -0800
---

So I didn't realize it, but rust has had AVR support since July 2020. So to take a break from the regularly scheduled hardware design to see how rust feels working on the ATTiny85. I didn't end up getting this working. While I was able to get a build running [here](https://github.com/aconbere/avr-rust-attiny85-test), I'm still unclear how to access specific registers of the ATtiny85 like PORTB or DRRB, and I'm not convinced that if I did program my chip with this program that it would run.

It did however make a reasonable sized binary only about twice as large as the similarly simple C++ program.

> AVR Memory Usage
> ----------------
> Device: attiny85
> 
> Program:      92 bytes (1.1% Full)
> (.text + .data + .bootloader)
> 
> Data:          0 bytes (0.0% Full)
> (.data + .bss + .noinit)


Also it took forever. A release build of this simplist of examples took nearly 20s. I hope I can figure out more and I'll report back here if I figure anything out.

## Getting Started

Still need a bunch of avr packages

> sudo apt-get install binutils gcc-avr avr-libc avrdude

You need the avr toolchain

> https://www.microchip.com/mplab/avr-support/avr-and-arm-toolchains-c-compilers
> PATH=$PATH:$HOME/Downloads/avr8-gnu-toolchain-3.6.2.1759-linux.any.x86_64/avr8-gnu-toolchain-linux_x86_64/bin/

### Installing AVR support

> $ rustup toolchain install nightly
> $ rustup component add rust-src --toolchain nightly

### Turning on nightly support

> rustup override set nightly

### Building

> cargo build -Z build-std=core --target target.json --release


### Setting up a target

The Rust nightly compiler includes a built-in target for ATmega328 but not ATtiny85. To get support for ATtiny85 you need to build a target json configuration.

> rustc --print target-spec-json -Z unstable-options --target avr-unknown-gnu-atmega328 > my-custom-avr-unknown-gnu-atmega328.json

