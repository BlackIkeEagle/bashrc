bashrc
======

install local
-------------

1. clone this repository

2. link your .bashrc to the repositories bashrc file

	``` sh
	$ ln -s ~/location/of/the/clone/bashrc ~/.bashrc
	```

install global
--------------

1. clone this repository

2. link your /etc/bash.bashrc or /etc/bash.bashrc.local to the repositories bashrc file

	``` sh
	$ ln -s /location/of/the/clone/bashrc /etc/bash.bashrc
	```
or

	``` sh
	$ ln -s /location/of/the/clone/bashrc /etc/bash.bashrc.local
	```

configuration
-------------

1. global configuration

	``` sh
	$ vim /etc/bashrc.config
	```

2. local configuration

	NOTE: the local configuration takes precedence over the global configuration.
	``` sh
	$ vim ~/.bashrc.config
	```

3. configuration flags

	``` bash
    PSCOL=${REG}${COLYLW}  # default ps (prompt) color
    USRCOL=${BLD}${COLYLW} # the color used for the user
    HSTCOL=${BLD}${COLWHT} # the color used for the hostname
	```
