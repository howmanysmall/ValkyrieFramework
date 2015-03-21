#!/bin/bash

pkill nginx
lapis server collb_dev >& server.log &
lapis server local_dev >& local.log  &

disown
disown
