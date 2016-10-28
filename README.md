# Undercloud Control Plane 

## Description 

An HTTP based API , written in Ruby and Sinatra, for managing the undercloud provisioning interactions. Provides functions for easy interaction via jenkins or curl. 
Handles the boot / installation control of systems being built for the undercloud

## Requires

### OS

Ubuntu 16.04

### Packages

* ruby (tested on 16.04 system ruby)
* ruby-sequel
* ruby-sinatra
* ruby-sqlite3
* sqlite3
* unicorn

## Building

For convenience, a build script `build.sh` is in the root of the repository. This uses FPM and should be called a directory up from the repo root.

## Installing

Installation is handled via puppet, seek the `dc_staging::master::api` class 


