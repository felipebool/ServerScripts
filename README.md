# server-scripts

Just a few scripts made to automate system administration tasks. They are all developed in a Debian 7 Environment.

## vhost.sh
This script setup a complete Apache virtual host environment. It creates DocumentRoot directory, Apache virtual host configuration file, change permissions and ownership. The process of creating a new virtual host became as easy as:
```sh
$ sudo ./vhost.sh server_name user-owner
```
where:
* server_name: domain name, without www, e.g. awesomeness.com
* user-owner: user who will be used, e.g. www-data
