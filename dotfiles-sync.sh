#!/usr/bin/env bash
rm tags

git add . 
git commit -m 'Cron update'
git push 
