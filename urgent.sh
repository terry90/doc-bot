#!/bin/bash

function broadcast() {
    ls /dev/ | grep -E '^ttys.{3}$' | while read -r line ; do
					  echo $1 > "/dev/$line"
				      done
}

count=0
while [  $count -lt 30 ]; do
    broadcast ""
    let count=count+1
done
broadcast "WOOOO ! Wake up ! Slack notif bitch"
