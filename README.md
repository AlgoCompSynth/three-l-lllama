# three-l-lllama

 The one-l lama,<br>
 He's a priest.<br>
 The two-l llama,<br>
 He's a beast.<br>
 And I will bet<br>
 A silk pajama<br>
 There isn't any<br>
 Three-l lllama.*<br>
<br>
-- Ogden Nash<br>
<br>
 *The author's attention has been called to a type of conflagration known as a three-alarmer. Pooh.

 * * *

Well, sir, there is a three-l lllama now!

## Introduction

`three-l-llama` is a pet [`Distrobox`](https://distrobox.it/) container
designed for developers exploring large language models (LLMs) and the
[`LLVM`](https://llvm.org/) compiler infrastructure. Although the
primary target is a Linux PC with an NVIDIA GPU, `three-l-lllama`
provides scripts for installing the software on a Raspberry Pi 5.

[`llama.cpp`](https://llama.app/) provides the infrastructure for running
LLMs locally. `three-l-llama` uses `llama.cpp` because it's easily
compiled from source, provides many performance monitoring and tuning
tools, and can use multiple high-performance computing modes - GPUs,
SIMD instructions in the CPU, [Vulkan](https://www.vulkan.org/), and
[OpenBLAS](https://www.openmathlib.org/OpenBLAS/).

[`Terra`](https://terralang.org) provides the tools for exploring and using
`LLVM`. `Terra` is a low-level language tightly integrated with Lua. As a
result it's optimized for creating domain-specific languages optimized by
`LLVM`, including `CUDA` GPUs.

Both `llama.cpp` and `Terra` are compiled from GitHub source repositories
and the source projects are on the installed filesystem for use by the
developer and coding agents. `LLVM` is installed as `apt` packages from
<https://apt.llvm.org/>; the current stable version is 22. `CMake` is
installed from tarballs at <https://cmake.org/download/#latest>; the
current stable version is 4.4.2.

Finally, `three-l-lllama` provides a command line based on
[Homebrew](https://brew.sh/), including the
[`Pi` coding agent](https://pi.dev/), the [Starship](https://starship.rs/)
shell prompt generator, the [Neovim](https://neovim.io/) editor, and, of
course, Lua.

## Getting started on a Linux host

You will need Distrobox and Podman installed. Recent version of Fedora,
Ubuntu, Debian, Arch and their derivatives all have usable versions, so it's
just a matter of installing them in the package manager.

I don't have any AMD CPUs or GPUs so I can't help you with specific tuning issues.
For NVIDIA, you should have a GTX 1600 / RTX 2000 series card or newer. You need
the NVIDIA Container Toolkit on the host but you do not need CUDA - that runs in
the container!

```
git clone https://github.com/AlgoCompSynth/three-l-lllama.git
cd three-l-lllama
./1-re-create-distrobox.sh
```

This with create the empty container and its home directory. If the script detects
an NVIDIA GPU, the container will be called `three-l-lllama-CUDA` and its home directory
will be `~/three-l-lllama-CUDA-Home`. If it does not find a GPU these will be
`three-l-lllama-CPU` and `~/three-l-lllama-CPU-Home`.

Next, you will need to set an administrator password in the container so you can use `sudo`.

```
❯ ./2-set-admin-password.sh
* Set Administrator Password *

Setting host-specific environment variables:
ARCH: x86_64
INFO[0000] Found 3 CDI devices
COMPUTE_MODE: CUDA
IMAGE_NAME: three-l-lllama-base:latest
CONTAINER_NAME: three-l-lllama-CUDA
CONTAINER_HOME: /home/znmeb/three-l-lllama-CUDA-Home
..You need to set a '*****' password to use 'sudo' in the container
New password:
Retype new password:
passwd: password updated successfully
* Finished Set Administrator Password *
```

## Getting started on a Raspberry Pi 5

Prerequisites: a Raspberry Pi ***5*** with at least 8 GiB of RAM and a
solid-state disk or USB 3 disk drive. microSD card storage, Pi 5s with
less than 8 GiB of RAM or Raspberry Pis older than a Pi 5 / CM5 / Pi 500
are not supported!
