#!/bin/bash
meteor build --server https://cn.steedos.com/workflow --directory /srv/workflow
cd /srv/workflow/bundle/programs/server
rm -rf node_modules
rm -f npm-shrinkwrap.json
npm install --registry https://registry.npm.taobao.org -d

cd /srv/workflow/
pm2 restart workflow.0
