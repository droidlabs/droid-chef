# nodejs [![Build Status](https://secure.travis-ci.org/hectcastro/chef-nodejs.png?branch=master)](http://travis-ci.org/hectcastro/chef-nodejs)

## Description

Installs and configures Node.js and npm.  Much of the work in this cookbook reflects
work done by [Librato](https://github.com/librato/nodejs-cookbook).

## Requirements

### Platforms

* Ubuntu 11.10 (Oneiric)
* Ubuntu 12.04 (Precise)

### Cookbooks

* build-essential

## Attributes

* `node["nodejs"]["version"]` - Version of Node.js to install.
* `node["nodejs"]["dir"]` - Directory to install into.
* `node["nodejs"]["url"]` - URL to the Node.js archive.

## Recipes

* `recipe[nodejs]` will install Node.js and npm.

## Usage

Currently only supports installation from source.
