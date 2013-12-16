This folder must be readable + writable by the process that runs the webserver (for apache, this is probably "apache.apache" or "nobody.nobody").

This command should be sufficient, though not very secure:
```
chmod a+rw rw/
```
