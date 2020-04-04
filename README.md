# ShapeOS-Xnest-i3wm
X window system in docker container

## Get

```
git clone git@github.com:d00t-b-res/ShapeOS-Xnest-i3wm.git
```

## Build

```
docker build -t shapeos-xnest-i3wm .
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
