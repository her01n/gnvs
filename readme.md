## gnvs

This is a script to generate **goaccess** statistics pages
for each **nginx** virtual server.

## Install

### Requirements

*ngingx* and *goaccess* are necessary.
Requires *ruby* to run.
*apache2-utils* for *htpasswd* command to secure statistics page.

    $ sudo apt install ruby nginx goaccess apache2-utils

### Configure logs

By default, *nginx* does log access for all virtual servers in one file,
without a way to determine which server handled the traffic.
We fix this by logging each virtual server to a separate file.
For each virtual server add an *access_log* directive:

File /etc/nginx/sites-enabled/domain1.conf:

```
server {
  server_name domain1.ltd;
  access_log /var/log/nginx/domain1.ltd.access.log;
  ...
}
```

### Configure statistics page

The script generates a static web page at /var/www/goaccess.

Generate a password for you admin user:

     $ sudo touch /etc/nginx/passwd
     $ sudo htpasswd /etc/nginx/passwd admin

File /etc/nginx/sites-enabled/example.com:

```
server {
  server_name example.com;
  ...
  location /goaccess/ {
    root /var/www;
    auth_basic "Web Administrator";
    auth_basic_user_file /etc/nginx/passwd;
  }
  # Optional, to fix the fonts issue on debian
  location /fonts/ {
    root /var/www/goaccess;
  }
  ...
}
```

And restart nginx to take effect.

    $ sudo systemctl restart nginx

### Install the script

Install the script using *make*.

    $ sudo make install

The page should now work, and it should be updated every ten minutes automatically.

### Font

In debian, the pages are missing the font.
To workaround download *fontawesome-webfont.woff2*,
and put into *fonts* directory in your domain root.
For example:

    $ wget https://gitlab.com/adium/MagicMirror/-/raw/master/font/fontawesome-webfont.woff2
    $ sudo mkdir -p /var/www/goaccess/fonts
    $ sudo cp fontawesome-webfont.woff2 /var/www/goaccess/fonts

## TODO

- make the list page look more like the goaccess page
- show some statistics on the main page, best would be a table like in site page
- handle log rotating
- do not install to /etc, find another way to shedule update

