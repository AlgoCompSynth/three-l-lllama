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
This will create the empty container and its home directory. If the script detects an
existing container, it will exit without doing anything! Otherwise, it will create a
base image and a container.

If the script detects an NVIDIA GPU, the container will be called `three-l-lllama-CUDA`
and its home directory will be `~/three-l-lllama-CUDA-Home`. If it does not find a GPU
these will be `three-l-lllama-CPU` and `~/three-l-lllama-CPU-Home`. The home directory
will be created if it does not exist.

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

Finally, populate the container:

```
./3-populate-container.sh
```

This will install the NVIDIA container toolkit in the container if the compute mode
is CUDA. Then it will compile `llama.cpp`. This takes quite some time; it is optimzing
for your CPU via `--march=native`. However, `ccache` is enabled, so if you decide to
re-compile with a newer version, modules from previous compiles that have not changed
will not be recompiled.

After `llama.cpp`, the script recompiles `terra`. This runs fairly quickly, although 
the test suite after the compile takes a few minutes. All the tests should pass; if
any fail, please open an issue at
<https://github.com/AlgoCompSynth/three-l-lllama/issues/new>!

The last operation installs the Homebrew command line. This is what a typical run
looks like:

```
* Populate Container *

Setting host-specific environment variables:
ARCH: x86_64
INFO[0000] Found 3 CDI devices
COMPUTE_MODE: CUDA
IMAGE_NAME: three-l-lllama-base:latest
CONTAINER_NAME: three-l-lllama-CUDA
CONTAINER_HOME: /home/znmeb/three-l-lllama-CUDA-Home
....Installing CUDA toolkit
....CUDA toolkit is installed
..Installing llama.cpp
COMPUTE_MODE: CUDA
....Cloning llama.cpp b10453
....Configuring llama.cpp
....Compiling llama.cpp
....Installing llama.cpp
....llama.cpp installed
..Installing Terra
....Cloning terra 1.2.2
....Configuring terra
....Compiling terra
....Installing terra
....terra installed
....Testing terra
....terra tests complete
vtablerec.t
weirdheader.t
zeroargs.t
zeroreturn.t
zeroreturn2.t
=================

564 tests passed. 0 tests failed.
69.47user 7.19system 1:16.91elapsed 99%CPU (0avgtext+0avgdata 1033128maxresident)k
0inputs+2152outputs (0major+3006496minor)pagefaults 0swaps
..Installing Homebrew command line
....Setting up home directory
....Adding Homebrew to the command line
....Activating Homebrew PATH
....Installing brew packages
....Cleaning up
....Installing pi-llama plugin
....Setting configuration files
....Appending starship init to /home/znmeb/three-l-lllama-CUDA-Home/.bashrc
....Finished

REPOSITORY                     TAG               IMAGE ID      CREATED         SIZE
localhost/three-l-lllama-base  latest            a33476d542d3  15 minutes ago  6.14 GB
docker.io/library/debian       trixie-backports  b964a672fbff  13 days ago     124 MB
* Finished Populate Container
```

## Getting started on a Raspberry Pi 5

Prerequisites: a Raspberry Pi ***5*** with at least 8 GiB of RAM and a
solid-state disk or USB 3 disk drive. microSD card storage, Pi 5s with
less than 8 GiB of RAM or Raspberry Pis older than a Pi 5 / CM5 / Pi 500
are not supported!
