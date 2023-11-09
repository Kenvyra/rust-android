#!/bin/bash
podman run --rm -it --name rust --privileged --ulimit=host --ipc=host --cgroups=disabled --security-opt label=disable rust:latest bash
