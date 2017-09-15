git checkout qhd
git pull
git submodule update --init --recursive

cd packages/steedos-cms
git checkout master
git pull

cd ../../
cd packages/steedos-emailjs
git checkout master
git pull

cd ../../
cd packages/steedos-portal
git checkout master
git pull

cd ../../