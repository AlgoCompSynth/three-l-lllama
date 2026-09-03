# Setting up Alpine Linux container hosting on your Raspberry Pi

You will need at least a Pi 4 and at least 4 GB of RAM. Even with
that much capacity, what you can do with AI models will be limited.
These directions are tested on a GNOME Linux desktop. They should
work for other desktops, but I don't have any Macintosh or Windows
machines to test on.

## Flashing Alpine to a USB drive or microSD card

1. Flash the USB drive or microSD card with Alpine Linux using the
Raspberry Pi Imager. Make sure you get the 64-bit version.

2. Open the File Manager and mount the `PIBOOT` partition.

3. Go to <https://github.com/macmpi/alpine-linux-headless-bootstrap>.
Download the latest release of `headless.apkovl.tar.gz` to `PIBOOT`.
***Do not unpack the tarball - Alpine uses it packed!!*** After the
download, unmount `PIBOOT` and remove the USB drive / microSD card
from your computer.

## Install Alpine on your Raspberry Pi

1. You will need a ***wired*** internet connection for this step.
There are ways to get the WiFi working but it's a hassle if it
doesn't work. Wired always works. Put the drive or card in the Pi,
power it on and boot it. After a bit you will have an SSH server
listening.

2. Find out your Pi's IP address - I get it from my router admin
web service. Do `ssh root@<ip-address>`. There's no password - yet.

3. At the `alpine-headless:~#` prompt, enter `setup-alpine`. This
will take you through a series of steps. Notes:

    a. Set up the network interfaces however you want them.
    b. Network time protocol: use the default `busybox`.
    c. APK mirror: first enter `c` to enable the community repo.
        Then enter `f` to pick the fastest mirror.
    d. User: You will need to enter a non-root user for container
        hosting and other uses.
    e. Use the default `openssh` for SSH server.
    f. Disk & Install: Up to this point everything has been saved to 
        a RAM disk. You will need to save it to the USB drive / microSD
        card, overwriting the installation files that are there.

        First, enter `y` to try the boot media. It will take some time,
        then show you a list of disks. For example, on my install on a
        USB drive, it shows

        ```
        Available disks are:
          sda   (256.7 GB General  USB Flash Drive )

        Which disk(s) would you like to use? (or '?' for help or 'none') [none]
        ```

        You need to type in the name of the disk and press `Enter`. In my case,
        it's `sda`.

        ```
        The following disk is selected:
          sda   (256.7 GB General  USB Flash Drive )

        How would you like to use it? ('sys', 'data', 'crypt', 'lvm' or '?' for help) [?]
        ```

        Enter `sys`.

        ```

        ```
        WARNING: The following disk(s) will be erased:
          sda   (256.7 GB General  USB Flash Drive )

        WARNING: Erase the above disk(s) and continue? (y/n) [n]
        ```

        Enter `y`.

        After all of that, you are done!

        ```
        Installation is complete. Please reboot.
        alpine-headless:~#
        ```

## Set up the command line

1. `ssh` into the machine.
2. Become `root`. You will need the `root` password you set during
the install.

```
carlos:~$ su -
Password:
carlos:~#
```

3. Add some administrative packages.
```
carlos:~# apk add bash git shadow sudo
```

4. Change your login shell to `bash`.
```
carlos:~# chsh <your-user-name>
Changing the login shell for <your-user-name>
Enter the new value, or press ENTER for the default
        Login Shell [/bin/sh]: /bin/bash
carlos:~#
```

5. Allow the `wheel` group to use `sudo`:
```
carlos:# visudo
```

Find these lines:

```
## Uncomment to allow members of group wheel to execute any command
# %wheel ALL=(ALL:ALL) ALL
```

and uncomment the second one.

6. Log out.

## Setting up hosting

1. `ssh` back into the Pi.

2. Clone this repository:

```
carlos:~$ mkdir Projects
carlos:~$ cd Projects/
carlos:~/Projects$ git clone https://github.com/AlgoCompSynth/three-l-lllama.git
Cloning into 'three-l-lllama'...
remote: Enumerating objects: 261, done.
remote: Counting objects: 100% (51/51), done.
remote: Compressing objects: 100% (35/35), done.
remote: Total 261 (delta 28), reused 34 (delta 16), pack-reused 210 (from 1)
Receiving objects: 100% (261/261), 59.44 KiB | 1.32 MiB/s, done.
Resolving deltas: 100% (153/153), done.
carlos:~/Projects$
```

3. Run the setup script:

```
carlos:~/Projects$ cd three-l-lllama/Alpine-Linux-Hosting
carlos:~/Projects/three-l-lllama/Alpine-Linux-Hosting$ ./set-up-hosting.sh
....Setting versions
....Setting up home directory
[sudo] password for <your-user-name>:
....Setting neovim configuration files
....Setting starship configuration file
grep: /home/znmeb/.bashrc: No such file or directory
....Appending starship init to /home/znmeb/.bashrc
....Appending aliases to /home/znmeb/.bashrc
....Finished

carlos:~/Projects/three-l-lllama/Alpine-Linux-Hosting$
```
4. Log out.
