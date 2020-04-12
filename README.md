![Docker Image CI](https://github.com/d00t-b-res/ShapeOS-Xnest-i3wm/workflows/Docker%20Image%20CI/badge.svg)
# ShapeOS on Xnest with i3wm
X window system in docker container

Based on [Alpine Linux 3.11](https://alpinelinux.org/)

Window manager [i3wm-gaps](https://github.com/Airblader/i3)

Internet browser [Chromium](https://www.chromium.org/)

Terminal emulator [RXVT](http://rxvt.sourceforge.net/)

zsh theme [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)

## Get

```
git clone git@github.com:d00t-b-res/ShapeOS-Xnest-i3wm.git
```

## Build

```
docker build -t shapeos-xnest-i3wm .
```
or Docker hub:

```
docker pull bres/shapeos-xnest-i3wm:latest
```

## Configure

Allow connections for your X11 server
use:
```
xhost + 
```

## Run
```
docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix --privileged --ipc host shapeos-xnest-i3wm
```

## Run with persistent sotrage
```
docker run -it -e GEOMETRY=1280x720  -v /var/lib/shapeos-xnest-i3wm2:/persistent -v /tmp/.X11-unix:/tmp/.X11-unix --privileged --ipc host shapeos-xnest-i3wm
```
## Eenvironments

| Env        | Value           | Description  |
| ------------- |:-------------:| -----:|
| SCREEN     | 1280x720 | window size |
| FULLSCREEN     | true | fullscreen |

## Screenshots 
![screen1](img/screen1.png)

![screen2](img/screen2.png)

![screen3](img/screen3.png)
