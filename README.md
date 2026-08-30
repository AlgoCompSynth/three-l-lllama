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

Well, sir, there is a three-l lllama now! _Lua, LLVM and LLMs!_

## Introduction

`three-l-llama` is a pet [`Distrobox`](https://distrobox.it/) container
designed for developers exploring large language models (LLMs) and the
[`LLVM`](https://llvm.org/) compiler infrastructure. The first release
features [Unsloth Studio](https://unsloth.ai/docs/new/studio), the
[Claude](https://code.claude.com/docs/en/cli-reference),
[Codex](https://learn.chatgpt.com/docs/codex/cli),
[OpenCode](https://opencode.ai/docs/cli/) and
[Pi](https://pi.dev/) command line coding agents, and
[`Terra`](https://terralang.org).

Unsloth Studio and the coding agents provide the infrastructure for
running LLMs locally and using them for coding assistance. `three-l-llama`
uses Unsloth Studio because it provides model tuning tools in addition to
simply downloading and running models.

`LLVM` is installed as `apt` packages from <https://apt.llvm.org/>;
the current stable version is 22. `Terra`, compiled from source, provides
tools for exploring and using `LLVM`.

`Terra` is a low-level language tightly integrated with Lua. `Terra` is
designed for creating domain-specific languages using `LLVM`, including
languages using `CUDA` GPUs. Lua 5.5, the
[Fennel](https://fennel-lang.org/) Lisp-like Lua front end, and the
[LuaRocks](https://luarocks.org/) package manager are also included.

Finally, `three-l-lllama` provides a command line based on
[Homebrew](https://brew.sh/), including the [Starship](https://starship.rs/)
shell prompt generator, two ["nerd fonts"](https://www.nerdfonts.com/),
and the [Neovim](https://neovim.io/) editor.

## Getting started on a Linux host

You will need Distrobox and Podman installed. Recent version of Fedora,
Ubuntu, Debian, Arch and their derivatives all have usable versions, so it's
just a matter of installing them in the package manager.

I don't have any AMD CPUs or GPUs so I can't help you with specific tuning issues.
For NVIDIA, you should have a GTX 1600 / RTX 2000 series card or newer. You need
the NVIDIA Container Toolkit on the host but you do not need `CUDA` - that runs in
the container!

```
git clone https://github.com/AlgoCompSynth/three-l-lllama.git
cd three-l-lllama
./1-create-distrobox.sh
```
This will create the container and its home directory. If the script detects an
existing container, it will exit without doing anything! Otherwise, it will create a
base image and a container.

If the script detects an NVIDIA GPU, the container will be called `three-l-lllama-CUDA`
and its home directory will be `~/three-l-lllama-CUDA-Home`. If it does not find a GPU
these will be `three-l-lllama-CPU` and `~/three-l-lllama-CPU-Home`. The home directory
will be created if it does not exist.

This is what a typical run looks like:

```
❯ ./1-create-distrobox.sh
* Create Distrobox *

Setting host-specific environment variables:
ARCH: x86_64
INFO[0000] Found 3 CDI devices
COMPUTE_MODE: CUDA
NVIDIA_FLAGS: --nvidia
IMAGE_NAME: three-l-lllama-base:latest
CONTAINER_NAME: three-l-lllama-CUDA
CONTAINER_HOME: /home/znmeb/three-l-lllama-CUDA-Home
..Building base image
STEP 1/6: FROM quay.io/toolbx-images/debian-toolbox:13
Trying to pull quay.io/toolbx-images/debian-toolbox:13...
Getting image source signatures
Checking if image destination supports signatures
Copying blob c6fef83b4ca1 done   |
Copying blob 16b15a516118 done   |
Copying config 15d3651584 done   |
Writing manifest to image destination
Storing signatures
STEP 2/6: LABEL maintainer="M. Edward (Ed) Borasky <znmeb@algocompsynth.com>"
STEP 3/6: ENV DEBIAN_FRONTEND=noninteractive
STEP 4/6: WORKDIR /root
STEP 5/6: COPY installers/base-packages.sh installers/set-installer-envars /root/
STEP 6/6: RUN apt-get update -qq   && apt-get install -qqy     sudo     wget     > bootstrap.log 2>&1   && ./base-packages.sh
....Setting versions
....Prepending /usr/lib/llvm-22/bin to PATH
....Update
....Upgrade
....Installing base packages
....Base packages installed
....Installing LLVM 22
....LLVM installed
....Importing signing key
....Adding Mozilla repository
....Prioritizing Mozilla packages
....Installing Firefox developer edition
....Updating search databases
....Finished

COMMIT three-l-lllama-base:latest
Getting image source signatures
Copying blob 1277cc4236bd done   |
Copying config 8243c900ec done   |
Writing manifest to image destination
--> 8243c900ec6b
Successfully tagged localhost/three-l-lllama-base:latest
8243c900ec6b62fae547cc40b37a83c5a3db9d3504f93e2b4a4fc51da3c907d8
..Creating three-l-lllama-CUDA
Creating 'three-l-lllama-CUDA' using image three-l-lllama-base:latest    [ OK ]
Distrobox 'three-l-lllama-CUDA' successfully created.
To enter, run:

distrobox enter three-l-lllama-CUDA

..Creating command line entry script /home/znmeb/.local/bin/three-l-lllama-CUDA
COMPUTE_MODE: CUDA
Starting container...                            [ OK ]
Installing basic packages...                     [ OK ]
Setting up devpts mounts...                      [ OK ]
Setting up read-only mounts...                   [ OK ]
Setting up read-write mounts...                  [ OK ]
Setting up host's sockets integration...         [ OK ]
Setting up host's nvidia integration...          [ OK ]
Integrating host's themes, icons, fonts...       [ OK ]
Setting up distrobox profile...                  [ OK ]
Setting up sudo...                               [ OK ]
Setting up user's group list...                  [ OK ]
Setting up existing user - shell...              [ OK ]
Setting up existing user - groups...             [ OK ]
Setting up user home...                          [ OK ]
Ensuring user's access...                        [ OK ]
Setting up skel...                               [ OK ]
Setting up init system...                        [ OK ]
Firing up init system...                         [ OK ]

Container Setup Complete!
....Installing CUDA toolkit
....CUDA toolkit is installed

..Installing command line base
....Setting versions
....Prepending /usr/lib/llvm-22/bin to PATH
....Setting up home directory
....Installing Homebrew
....Adding Homebrew init to the command line
....Activating Homebrew PATH
....Installing brew packages
....Cleaning up
....Setting neovim configuration files
....Setting starship configuration file
....Appending starship init to /home/znmeb/three-l-lllama-CUDA-Home/.bashrc
....Appending aliases to /home/znmeb/three-l-lllama-CUDA-Home/.bashrc
....Finished

..Installing Terra from source
....Setting versions
....Prepending /usr/lib/llvm-22/bin to PATH
....Activating Homebrew PATH
....Installing brew packages
....Cleaning up
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
71.56user 7.66system 1:23.34elapsed 95%CPU (0avgtext+0avgdata 1032316maxresident)k
122312inputs+2536outputs (25major+3276533minor)pagefaults 0swaps
....Finished

..Installing AI tools
....Setting versions
....Prepending /usr/lib/llvm-22/bin to PATH
....Activating Homebrew PATH
....Installing brew packages
Trusted tap: anomalyco/tap
....Cleaning up
....Installing Unsloth Desktop
....Installing unsloth bash completions
bash completion installed in /home/znmeb/three-l-lllama-CUDA-Home/.bash_completions/unsloth.sh
Completion will take effect once you restart the terminal
....Exporting Unsloth Studio to host app list
Application /home/znmeb/three-l-lllama-CUDA-Home/.local/share/applications/unsloth-studio.desktop successfully exported.
OK!
/home/znmeb/three-l-lllama-CUDA-Home/.local/share/applications/unsloth-studio.desktop will appear in your applications list in a few seconds.
....Finished

* Finished Create Distrobox *


deinonychus in three-l-lllama on  unsloth-3090-testing [!] took 9m53s
```
