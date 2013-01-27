#!/usr/bin/env sh

msg='Update stats.'

cd raw && git cpush $msg && cd ..
cd formatted && git cpush $msg && cd ..
git add raw formatted && git cpush $msg
