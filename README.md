# m8mouse RGB and DPI controller

This is a small CLI tool to replicate the *M8 Mouse* windows 
application to control *Zi You Lang* devices which go by many
different brands/labels (Red Wolf, Ziyulang).

The M8 Mouse software used to control this is not downloadable 
from official vendor/whitelabel sources, but instead passed around
on online drives, so it made sense to distill the main functionality
out into something more open source.

This was tested on a Zi You Lang *T60 model* on Linux, but could
be extended to Windows/MAC as the hidapi library is cross platform.

## Device Identification

The main mcu on the T60 model is a Sunplus Innovation Technology
SPCP19X chip, which of course doesn't have lots of datasheets out
there, so most of this work came from tracing what M8 Mouse does.

The VID/PID of the chip is not enough to identify it is the right device
so instead we rely on checking the handshake and memory buffer to confirm

        //1bcf:Sunplus Innovation Technology Inc.
        //08a0:Gaming mouse [Philips SPK9304]



## Compiling and Running

### Dependencies

This tool depends primarily on **hidapi** (with the libusb backend).  Make sure the library and headers are installed before building.

On Debian/Ubuntu systems:
```
sudo apt install libhidapi-libusb0 libhidapi-dev cmake build-essential pkg-config
```
On Fedora:
```
sudo dnf install hidapi-devel cmake gcc-c++ make pkgconf-pkg-config
```
On Arch Linux:
```
sudo pacman -Syu hidapi cmake base-devel pkgconf
```
### Build & Install

There's an install script in the repo.
```
./install.sh
```
### Manual Build Instructions

If you want to build manually run:
```
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local
cmake --build . -- -j$(nproc)
cmake --install .
```
### Using the Tool

After installing, make sure your udev rules are reloaded and the mouse is re-plugged (or reboot):
```
sudo udevadm control --reload-rules
sudo udevadm trigger
```
# Basic usage examples:

## Show help
```
m8mouse -h
```
## List supported modes and settings
```
m8mouse -l
```
## Query current device state
```
m8mouse
```
## Update device state (example: DPI=1, LED=2, speed=4)
```
m8mouse -dpi 1 -led 2 -speed 4
```
## Known Issues

- Device communication is slow due to ~14ms required between each set/get command.

## License

#### MIT — see LICENSE file for details.

## Credits

#### Logging framework used for debugging: https://github.com/rxi/log.c/
