#!/bin/bash
BEGIN {}
($5 ~ /sshd/) && (($10 ~ /root/) || ($11 ~ /root/) ) { print }
