CUPS + Canon LBP6020
====================

CUPS + Canon LBP6020 printer driver inside phusion/baseimage (Ubuntu 16.04)

This image provides a (reasonably) simple and stable way to run the
notoriously unreliable Canon CAPT driver.

This is still a work in progress, as the manual steps below prove.  The
server is set up with little security, assuming that it is running on a
trusted lan, e.g. a typical home network.

Prior to building the image download the current CAPT driver from:

http://www.canon-europe.com/Support/Consumer_Products/products/printers/Laser/i-SENSYS_LBP6020B.aspx?type=download&softwaredetailid=tcm:13-1057853&os=Linux&language=EN

If the version has changed from 2.70
(Linux_CAPT_PrinterDriver_V270_uk_EN.tar.gz) it will be necessary to
edit the Dockerfile and update the archive filename and package
filenames.

Then:

Build the image:

```bash
sudo docker build -t lbp6020 . 2>&1 | tee build.log
```

Assuming the printer connects as /dev/usb/lp1, run the container with:

```bash
sudo docker run -d --privileged=true -e CUPS_USER_ADMIN=admin -e CUPS_USER_PASSWORD=secr3t -p 6631:631/tcp -v /dev/bus/usb:/dev/bus/usb lbp6020
```

If the printer appears as something else, you'll need to edit
start_cups.sh and set the device name appropriately.

Print with:

```bash
lp -d lbp6020 -h localhost:6631 file.name
```

While it should be possible to set up a local CUPS server to print to
the container, I haven't got that working yet.  Any suggestions will be
appreciated.

Many thanks to @ticosax for making the original image available.
