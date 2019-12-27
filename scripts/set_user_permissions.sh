#!/bin/bash

sudo groupadd docker

sudo usermod -aG docker gmcvitti

sudo chown root:docker /var/run/docker.sock

