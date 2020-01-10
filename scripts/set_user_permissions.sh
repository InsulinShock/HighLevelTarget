#!/bin/bash

# sudo groupadd docker

sudo usermod -a -G docker gmcvitti

sudo chown root:docker /var/run/docker.sock

