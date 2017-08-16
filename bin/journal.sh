#!/bin/bash

# Cron script for 30-min activity journal
#——————————————-

play -n synth 0.1 sin 880 | echo -e "\a"
export DISPLAY=:0
gvim -c "VimwikiMakeDiaryNote" + -c "CreateHourlyTopics"
