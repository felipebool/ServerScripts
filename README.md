# server-scripts

Just a few scripts I made to automate system administration tasks. They are all developed in a Debian 7 Environment.

## vhost.sh
This script setup a complete Apache virtual host environment. It creates DocumentRoot directory,
Apache virtual host configuration file, change permissions and ownership. The process of creating
a new virtual host became as easy as:

### Usage
```sh
$ sudo ./vhost.sh server_name user-owner
```
where:
* server_name: domain name, without www, e.g. awesomeness.com
* user-owner: user who will be used, e.g. www-data

## strongpass.sh
Little tool I've made to generate safe passwords!

### Usage
```sh
$ ./strongpass.sh password_lenth
```

## wordpress.sh
This is a tool I'm constantly improving, it downloads the latests wordpress installation (Pt-Br version),
creates the database, deals with directory permission, creates a wordpress config file populated with
the information previously generated and other things. There's a TODO list in the comments inside the
script with a few extra features I'm working on. This tool turns the 5-minutes wordpress installation
into 5-seconds wordpress instalation.

### Usage
```sh
$ ./wordpress <wp_installation_path> <wp_project_name>
```
