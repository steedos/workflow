npm install --global --production windows-build-tools
npm install -g node-gyp

meteor build --server https://cn.steedos.com/workflow --directory ../apps-build/
cd ../apps-build/bundle/programs/server
rm -rf node_modules
npm install

cd ../../
node main.js
#pm2 restart workflow.0
