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

Well, sir, there is now!

## A toolbox for local inference

`three-l-llama` is a `llama.cpp`-based toolbox container inspired by
<https://github.com/ggml-org/llama.cpp/blob/master/docs/backend/CUDA-FEDORA.md>.
I've ported it to Raspberry Pi OS for the Raspberry Pi 5, and added
code so it can detect whether it's running on an `aarch64` or `x86_64`
Linux host, and, if `x86_64`, whether there's a NVIDIA GPU or not.

## Getting started on a Raspberry Pi 5

Prerequisites: a Raspberry Pi ***5*** with at least 8 GiB of RAM and a
solid-state disk or USB 3 disk drive. microSD card storage, Pi 5s with
less than 8 GiB of RAM or Raspberry Pis older than a Pi 5 / CM5 / Pi 500
are not supported!

## Getting started on Bluefin Dakota
