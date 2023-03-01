#!/bin/bash

sudo docker run --rm -it -v $(pwd):/app:Z arm/asm:latest /bin/bash
