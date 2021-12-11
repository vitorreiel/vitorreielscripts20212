#!/bin/bash
BEGIN {}
($2 ~ /^1[1-2]/) && ($6 ~ /Accepted/) { print }
