## WORK IN PROGRESS!

# hassio-os
Hass.io OS based on buildroot

# building
Running sudo `./enter.sh` will get you into the build docker container.   
`cd /buildroot/buildroot-2017.11.1`  
`make`  

From outside the docker container, while it is still running you can use `sudo ./getimage.sh` to get the output image, 
and `sudo ./getconfig` to backup the config changes to buildroot you made.
