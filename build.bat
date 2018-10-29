meteor build --server https://cn.steedos.com/workflow --directory C:/Code/Build/apps-build/
cd C:/Code/Build/apps-build/bundle/programs/server
rm -rf node_modules
npm install --registry https://registry.npm.taobao.org -d

cd C:/Code/Build/apps-build/
pm2 restart pm2.json