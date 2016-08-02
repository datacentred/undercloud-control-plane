# Undercloud Control Plane 

## Description 

An HTTP based API , written in Ruby and Sinatra, for managing the undercloud provisioning interactions. Provides functions for easy interaction via jenkins or curl. 
Handles the boot / installation control of systems being built for the undercloud

## Requires

Ruby & Rubygems
Sqlite (or Postgres) 

## Installation

Installation should be handled via puppet, but a Gemfile is provided for a simple *bundle install* in the directory

### TODO:

 * Move more static config into the YAML config structure 
 * Probably should add some tests ;)

