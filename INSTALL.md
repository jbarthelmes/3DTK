# Installation

## Ubuntu 16.04 

The easiest way to make sure that you install the right dependencies for unpackaged software like _3DTK_ on Debian based distributions is to build a meta package using the equivs tool. For _3DTK_ we ship the control information of such a meta package in the svn repository so that you can use the equivs tool to build and install a meta package which will then in turn make sure that you have all the required dependencies on your system. The advantage compared to installing all dependencies manually is that removing the meta package `3dtk-build-deps` you created will also automatically remove all the dependencies that were installed with it and are:
```
$ echo deb http://archive.ubuntu.com/ubuntu trusty main universe | sudo tee -a /etc/apt/sources.list > /dev/null
$ sudo apt-get update
$ sudo apt-get install --no-install-recommends equivs subversion
$ svn checkout svn://svn.code.sf.net/p/slam6d/code/trunk slam6d-code
$ cd slam6d-code
$ equivs-build doc/equivs/control
$ sudo dpkg -i 3dtk-build-deps_1.0_all.deb
$ sudo apt-get -f install --no-install-recommends
$ make
$ bin/slam6D dat
$ bin/show dat
```

## Debian Jessie

Read and follow the instructions for Ubuntu 16.04 with the following adaptions:
```
$ equivs-build doc/equivs/control.debian.jessie
```
Before compiling ($make) disable (switch to OFF) the options:
`WITH_GLFW`, `WITH_QT` 

## macOS 10.13 High Sierra

The easiest way to install all required dependencies is to use Homebrew. You can install Homebrew as follows:
```
$/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
for more information about Homebrew have a look at [Homebrew](http://brew.sh/index_de.html).
After this the commands to install the dependencies are:
```
$ brew update
$ brew tap brewsci/science
$ brew update
$ brew install cmake boost libzip opencv3 ann eigen freeglut suite-sparse glui
```

To compile _3DTK_ follow the instructions at the [README](README.md) file.

## Fedora 25
```
$ dnf install make gcc gcc-c++ libzip-devel ann-devel boost-devel opencv-devel mesa-libGL-devel freeglut-devel libXmu-devel libXi-devel suitesparse-devel
```