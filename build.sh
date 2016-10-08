#!/bin/bash
meteor build --server https://cn.steedos.com/workflow --directory /srv/workflow
cd /srv/workflow/bundle/programs/server
rm -rf node_modules
npm install --registry=https://registry.npm.taobao.org

cd /srv/workflow/
pm2 restart workflow.0
