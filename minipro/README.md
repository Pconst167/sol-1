# minipro
## Latest "stable" version 0.7.3

An open source program for controlling XGecu's series of chip programmers.

This program exists because XGecu does not provide a program for use on
Linux or other flavors of Unix.  We who keep this project going prefer a
simple, free, and open-source program that presents a command-line
interface that allows for a GUI front-end if desired.


## Features
* Native support for Linux, BSD, macOS, and other flavors of Unix.
* Compatibility with TL866CS, TL866A, TL866II+, T48, and T56 from XGecu
  (http://www.xgecu.com/en/)
* More than 13000 target devices (including AVRs, PICs, various BIOSes
  and EEPROMs)
* ZIF40 socket and ISP support
* Vendor-specific MCU configuration bits
* Chip ID verification
* Logic IC testing
* Bitbang support
* Overcurrent protection
* System testing

## Synopsis

```nohighlight
$ minipro -p ATMEGA48 -w atmega48.bin
$ minipro -p ATMEGA48 -r atmega48.bin
```

## Prerequisites

You'll need some sort of Linux or MacOS machine.  Other Unices may work,
though that is untested.  You will need version 1.0.16 or greater of
libusb.  Earlier versions may work, but are untested.


## Installation on Linux

### Install build dependencies 

#### Debian/Ubuntu
```nohighlight
sudo apt-get install build-essential pkg-config git libusb-1.0-0-dev zlib1g-dev

```

#### CentOS 7
```nohighlight
sudo yum install gcc make pkgconfig git libusbx-devel
```

#### openSUSE
```nohighlight
sudo zypper install gcc make git-core srecord rpmdevtools libusb-1_0-devel
```

### Checkout source code and compile 
```nohighlight
git clone https://gitlab.com/DavidGriffith/minipro.git
cd minipro
make
sudo make install
```

If you have a T56, you'll need to download and install algorithms from
Xgeku's official software package.
```nohighlight
sudo make install-algorithm
```

### Udev configuration (recommended)
If you want to access the programmer as a regular user, you'll have to
configure udev to recognize the programmer and set appropriate access
permissions.

```nohighlight
sudo cp udev/*.rules /etc/udev/rules.d/
sudo udevadm trigger
```
You'll also have to add your regular user to the `plugdev` system
group:
```nohighlight
sudo usermod -a -G plugdev YOUR-USER
```
Note that this change will only become effective after your next
login.

### Bash completion (optional)

Bash users may want to optionally install the provided completion file:
```nohighlight
sudo cp bash_completion.d/minipro /etc/bash_completion.d/
```

### Making a .deb package

Building a Debian package directly from this repository is easy.  Make
sure you have the build dependencies installed as described above.  Be
sure it all builds, then do this:

```nohighlight
sudo apt-get install fakeroot debhelper dpkg-dev
fakeroot dpkg-buildpackage -b -us -uc
```

You should then have a .deb package for you to install with `dpkg -i`. 
Note that the .deb package will already provide the udev and 
bash-completion configurations for you.

### Making a Debian source package for a PPA

The following commands require `git-buildpackage`:

```nohighlight
git archive --format=tar HEAD | tar x && git commit -am "packaging: Makefile substitution"
gbp dch --commit --since=HEAD --upstream-branch=master --dch-opt="-lppa" --dch-opt="-D$(lsb_release -c -s)" debian
gbp buildpackage --git-upstream-tree=SLOPPY --git-export-dir=../build-area -S
```

You can then `dput` the `*.changes` file in `../build-area` to your PPA.

### Making a .rpm package

You can build RPM packages for Fedora, CentOS and openSUSE with the supplied
`rpm/minipro-*.spec` files.

First make sure you have a RPM build environment set up. You need to have
the rpmdevtools package installed and a `rpmbuild` directory tree within
your homedir. Use the `rpmdev-setuptree` command to create the rpmbuild
directory tree if it does not exist yet.

Then use these commands to download the source tarballs from Gitlab and
build the package for Fedora and CentOS:

```nohighlight
spectool -g -R rpm/minipro-fedora.spec
rpmbuild -ba rpm/minipro-fedora.spec
```

Or for openSUSE:

```nohighlight
rpmdev-spectool -f -g -R rpm/minipro-opensuse.spec
rpmbuild -ba rpm/minipro-opensuse.spec
```

The final RPMs can be found below `~/rpmbuild/RPMS/`

## Installation on Guix

```nohighlight
guix install minipro
```

### Udev configuration (Guix System)

If you want to access the programmer without root privileges you must install the necessary udev rules. This can be done by extending `udev-service-type` in your `operating-system` configuration with this package.


```nohighlight
(udev-rules-service 'minipro minipro #:groups '("plugdev")
```

Additionally your user must be member of the `plugdev` group. At that point, minipro should be installed and ready to use.

## Installation on macOS

The easiest way to install on macOS is by using [homebrew](https://brew.sh/) to install the most recent release:

```nohighlight
brew install minipro
```

At that point, minipro should be installed and ready to use.

If you'd rather compile from source (if, for instance, you need newer code than is in the most recent release), you'll need to do the following to prepare your environment and compile the code.

### Install dependencies
Install `pkg-config` and `libusb` using brew or MacPorts:
```
brew install pkg-config
brew install libusb
brew link libusb
```
or:
```
port install pkgconfig
port install libusb
```
### Checkout source code and compile
```nohighlight
git clone git@gitlab.com:DavidGriffith/minipro.git
cd minipro
make
sudo make install
```

### Download and install bitstream algorithms for the T56

Unlike the other programmers from Xgecu, the T56 does not store its FPGA
bitstreams in the hardware.  Instead it must be loaded by the
controlling software.  Those bitstreams (Xgecu calls them algorithms)
are found in the official Xgecu software releases.  They cannot be
included here for copyright reasons.  Instead the build process can
download them for you and convert them into a single file for use by
`minipro`.
```nohighlight
make algorithm
sudo make install-algorithm
```


### Checksum notes

When you download an archive/tarball from Gitlab, there is no guarantee
that the file given to you will hash to the same value time and time
again.  For Gitlab to allow for this would require it to store a very
large amount of data.  If you run a packaging system that depends on
hashes like that, consider following the example of the FreeBSD ports
system.  What they do is use the SHA-1 commit hash of the version to be
installed.  Check out how FreeBSD does it for Minipro here:
https://github.com/freebsd/freebsd-ports/tree/main/sysutils/minipro

### Attributions

Code and data for testing ICs have been borrowed from
https://github.com/Johnlon/integrated-circuit-tester and
https://github.com/akshaybaweja/Smart-IC-Tester and used in accordance
with the MIT License (https://opensource.org/license/MIT)
