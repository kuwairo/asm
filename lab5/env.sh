#!/bin/bash

sudo docker run --rm -it -v $(pwd):/app:Z asm:latest /bin/bash
