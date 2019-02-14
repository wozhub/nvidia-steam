# Steam with NVIDIA GPU

Steam running inside a GPU linked docker.

I forked [fim/docker-steam-nvidia](https://github.com/fim/docker-steam-nvidia) repository but copied some key code from [qury/docker-nvidia-steam](https://github.com/qury/docker-nvidia-steam).

This is my first (maybe second) docker project, so things might be a little messy, sorry about the sharp edges.
I'll try to polish it up soon.

## Requirements

* Docker
* NVIDIA GPU
* PulseAudio

## Build

`./build.sh`

## Run

`./run.sh`

## TODO

[ ] Merge `run.sh` with fim's executable (`steam`)
[ ] Is there a better way to handle local Steam profile?
[ ] Clean up! I'm sure there is useless code both in `Dockerfile` and `run.sh`
[ ] Install a proper shortcut (at least for Gnome!)
