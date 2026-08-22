# Critical Code Review: `three-l-lllama`

Reviewed: all host scripts, `Containerfile`, `distrobox.ini`, and `installers/*`.
Non-obvious behaviors were verified against upstream: Distrobox `1.8.2.5`
(`distrobox-assemble` ini handling, `distrobox-enter` PATH/workdir logic),
the Debian trixie package index, and the `apt.llvm.org` `llvm.sh` script.
Findings are ordered by severity.

---

## 🔴 High severity

### 1. README onboarding points at a script that doesn't exist
`README.md:68` tells users to run `./1-re-create-distrobox.sh`; the file is
`1-create-distrobox.sh`. A new user following the README fails at step 1 with
"No such file or directory". Fix the name (and check for other stale references).

### 2. `terralang.sh` silently swallows the entire test suite
`installers/terralang.sh:35-36`:
```bash
/usr/bin/time terra run \
  >> $LOGFILE 2>&1 || true
```
`|| true` discards the exit status, so `3-populate-container.sh` reports
success even if Terra tests fail. This directly contradicts the README
("**All tests should pass**; if any fail, please file an issue") — currently
a failure is only visible if a human reads the last 10 lines of the log.
Drop the `|| true` (or at least capture and print the status and `exit`
non-zero on failure).

### 3. `coding-agents.sh` depends on `~/.local/bin` being in the host's PATH — nothing guarantees it
`installers/coding-agents.sh:26-32` extracts node/npm into `$HOME/.local` and
immediately calls `npm --version`. Verified in `distrobox-enter` (1.8.2.5):
the container inherits the **host's** `PATH` (plus standard FHS paths). The
container's home is a *fresh* directory, so `bash -l` reads no user profile;
the `~/.local/bin` append in `aliases.sh` only takes effect in *later*
interactive shells. On a stock Debian/Ubuntu host (default bash `PATH` has
no `~/.local/bin`), `npm` is not found and the populate script dies mid-way
with a confusing "command not found". Add
`export PATH="$HOME/.local/bin:$PATH"` right after the node extraction
(same latent issue for the `pi` binary it installs).

### 4. Re-running `3-populate-container.sh` silently executes stale scripts
`3-populate-container.sh:9`: `cp -rp installers $CONTAINER_HOME`. GNU
`cp -r` semantics: when `$CONTAINER_HOME/installers` already exists (any
second run), the copy lands in `$CONTAINER_HOME/installers/installers/`, and
the `pushd` + `distrobox enter -- ./...` that follow run the **old** copied
scripts, not what's in the repo. So "pull new installer fixes → re-run
populate" does not actually apply the fixes. Related non-idempotencies in
the same flow:

- `installers/homebrew-command-line.sh:17` appends the brew `shellenv` line
  to `.bashrc` **unconditionally** — every re-run adds another duplicate
  (the starship block *does* have a guard at lines 41-42; this one should too).
- `installers/homebrew-command-line.sh:39` `cp -rp nvim $HOME/.config`
  nests to `.config/nvim/nvim/` on re-run (inert garbage, but it accumulates).

Fix: `rm -rf "$CONTAINER_HOME/installers" && cp -rp installers "$CONTAINER_HOME"`,
and guard the `.bashrc` appends.

### 5. README makes two false performance claims
`README.md:107`: "optimizes for your CPU via `--march=native`. However,
`ccache` is enabled…"

- `grep -rn march` over the whole repo: only the README. No build passes
  `-march=native` (llama.cpp's CMake does not add it either).
- `ccache` is *installed* (`trixie-packages.sh:26`) but never wired in —
  no `CMAKE_C_COMPILER_LAUNCHER`, no `CC="ccache gcc"`.

Both claims shape user expectations (incremental rebuilds will be full
rebuilds; no per-CPU tuning). Either implement them or fix the docs.

---

## 🟠 Medium severity

### 6. All top-level scripts assume CWD = repo root
- `1-create-distrobox.sh` relies on `distrobox assemble`'s default input
  file `./distrobox.ini` (verified in `distrobox-assemble`). Run it from
  anywhere else and assemble will try to `curl ./distrobox.ini` and fail opaquely.
- `3-populate-container.sh:9` uses relative `installers/`.
- Both source `./set-host-envars`.

Add `cd "$(dirname "$0")"` (or equivalent script-dir resolution) at the top
of each entry script.

### 7. Silent GPU → CPU degradation
On a CUDA host the container gets `--device=nvidia.com/gpu=all` and the CUDA
toolkit, but `llama-cpp.sh:7-8` re-detects via in-container `nvidia-smi`
(`nvidia-smi-test.sh`). If CDI isn't actually delivering the device
(misconfigured toolkit, driver mismatch), `nvidia-smi` fails, and the script
**silently builds CPU-only llama.cpp** in a container the user believes is
GPU-enabled. Re-detection is a good idea; the fallback should `echo` a loud
warning (or fail) when the *host* said CUDA but the container can't see a GPU.

### 8. GPU detection requires CDI specs that a fresh toolkit install doesn't have
`set-host-envars:21` requires `nvidia-ctk cdi list | grep gpu`. A stock
NVIDIA Container Toolkit install has **no** CDI spec until the user runs
`nvidia-ctk cdi generate`. Until then a GPU user silently gets the CPU
container with no explanation. The README's "you need the NVIDIA Container
Toolkit on the host" understates this — document the CDI generation step
(or auto-generate it in the script).

### 9. Implicit dependency on Distrobox 1.x behavior (breaks on 2.0)
`distrobox.ini` uses `home=$CONTAINER_HOME` and `image=$IMAGE_NAME`. This
only works because bash-era `distrobox assemble` writes ini values to a temp
file and **sources it as shell code** (`run_distrobox` → `. "${tmpfile}"`),
so the variables expand. The upstream Go rewrite (distrobox 2.0, current
`main`) parses manifests without any env expansion — these become *literal*
values (`image=$IMAGE_NAME`, home directory named `$CONTAINER_HOME`) and
fail in a confusing way. Options: pin "requires Distrobox 1.x" in the
README, or generate the ini at runtime with values already expanded
(e.g., `envsubst` or printf into the ini).

### 10. Hardcoded CUDA path coupled across two files
`installers/llama-cpp.sh:25` hardcodes `CUDACXX=/usr/local/cuda-13.3/bin/nvcc`;
`installers/trixie-cuda.sh:19` pins `cuda-toolkit-13-3`. Bumping the toolkit
in one file silently breaks the other. Use the stable symlink
`/usr/local/cuda/bin/nvcc` (or factor the version into `set-versions.sh`).

### 11. Destructive `rm -rf` on user-visible source trees
`llama-cpp.sh:14-15` and `terralang.sh:9-10` delete `~/Projects/llama.cpp`
and `~/Projects/terra`. The README explicitly hands these directories to the
user "for use by developers" — a re-populate after local experiments destroys
their work with no warning. Clone into a private build dir
(e.g., `$HOME/.build/`) or at minimum confirm the directory is a git repo
before nuking.

### 12. Supply-chain hygiene
- Homebrew: `curl -fsSL .../install/HEAD/install.sh | bash` — unpinned *and*
  on the HEAD branch (a future upstream change can break or alter behavior).
  Pin a release tag/commit.
- CMake tarball (GitHub), node tarball (nodejs.org), `llvm.sh`
  (apt.llvm.org), CUDA keyring `.deb`: no checksum verification anywhere.
  For scripts that `sudo apt-get install` system-wide, add sha256 checks
  (at least for the binaries executed directly: `llvm.sh`, cmake, node,
  brew installer).

### 13. `test-rtx-3090.sh` (untracked)
- Not in git — commit it or mark it local-only.
- With `set -e`, if the interactive `pi` session exits non-zero, the script
  aborts **before** `pkill "llama serve"` → an orphaned server holding
  ~24 GB of VRAM. Use `trap 'pkill -f "llama serve"' EXIT`.
- `sleep 15` is a guess; check the server's health endpoint (curl) in a loop
  before launching `pi`, and handle the model-load failure case.
- `pkill "llama serve"` matches only the parent cmdline; consider `pkill -f`
  on a unique flag or a PID file.
- `source set-host-envars` here is dead weight: inside the container
  `nvidia-ctk` doesn't exist, and none of the exported vars are used by
  this script.

---

## 🟡 Low / nits

- `coding-agents.sh:23` — `exit -255`: bash wraps exit status mod 256, so
  this exits **1**, not 255. Misleading; use `exit 1` (or a real 0-255 code).
- `coding-agents.sh:32` — `echo "npm --version $(npm --version)"` prints
  `npm --version 11.x`; clearly meant to just run `npm --version`.
- `installers/aliases.sh:1` — `[[ ! "$PATH" =~ "$HOME/.local/bin" ]]` treats
  `$HOME` as an **ERE**: a `.` in a username becomes a wildcard (harmless
  here), and any regex metacharacter would misbehave. Use a `case` pattern
  or literal match.
- `installers/trixie-packages.sh:27-28` — installs both
  `libopenblas64-openmp-dev` and `libopenblas-openmp-dev`; both exist in
  trixie (verified), but one is redundant for ggml's OpenBLAS linkage.
  Pick one.
- `1-create-distrobox.sh:18-22` — manually writing
  `~/.local/bin/$CONTAINER_NAME` duplicates what distrobox already generates
  by default at container creation. Harmless, but redundant.
- README sample output is stale: shows `Cloning llama.cpp b10453` while
  `set-versions.sh` pins `0.2.0`; says the Homebrew-based CLI "including the
  Pi coding agent" while pi is actually npm-installed (`coding-agents.sh`).
  Also "install the NVIDIA container toolkit into the container" — it's the
  CUDA *toolkit* (`cuda-toolkit-13-3`), not the container toolkit (that's
  host-side).
- `Containerfile` — no `apt-get clean` / `rm -rf /var/lib/apt/lists` after
  installs, so the apt cache is baked into the 6.14 GB image;
  `> bootstrap.log 2>&1` with `-qqy` captures nothing useful and leaves a
  junk file in the image.
- `installers/llama-cpp.sh:19` — `-DGGML_VULKAN=1` works (CMake truthy) but
  `-DGGML_VULKAN=ON` is conventional.
- `set-host-envars:20` — `which` is non-POSIX (fine in practice);
  `command -v` is the idiomatic choice. Also `nvidia-ctk cdi list` stderr is
  not redirected, so a missing-CDI case prints toolkit noise into the log.
- `distrobox.ini` — CPU and CUDA sections share the same
  `home=$CONTAINER_HOME`; if a host's GPU status changes over time, both
  containers can exist and share one home dir. Consider per-mode homes or
  document it.
- `3-populate-container.sh:14-18` — stray blank line inside the CUDA `if`
  (cosmetic).
- `installers/trixie-packages.sh:38` — `./llvm.sh 22 all`: the `all`
  argument is meaningful (install all LLVM 22 components), but a one-line
  comment would save the next reader's confusion.

---

## What's solid

- Clean three-step host workflow with a clear separation: build image →
  set password → populate; the CPU/CUDA branching via two ini sections is a
  good use of `distrobox assemble --name`.
- Version pinning centralized in `set-versions.sh` (see #10 for the CUDA
  exception).
- `start_now=true` + systemd init gives a real PAM/sudo environment, which
  the password step relies on — consistent.
- The in-container GPU re-check (#7) is the right instinct; it just needs a
  loud fallback.
- Every apt package name in `trixie-packages.sh` verified against the trixie
  index — all valid.
- The `pushd $CONTAINER_HOME/installers` trick works because
  `distrobox enter` maps the host `PWD` into the container verbatim when it's
  under the container home (verified in `distrobox-enter`) — but it's worth
  a comment, since it's the kind of thing that breaks silently if the host
  home is symlinked.

---

## Suggested priority

Fix #1 (one-line doc fix), #2 (one-line), #3 (one-line), #4 (idempotency),
then #7/#8 (GPU UX) and #9 (distrobox pinning) before the next release.
#12 (supply-chain hygiene) is the biggest longer-term risk.
