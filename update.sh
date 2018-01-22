git checkout fssh
git pull
git submodule update --init --recursive

cd packages/steedos-cms
git checkout fssh
git pull

cd ../../
cd packages/steedos-emailjs
git checkout fssh
git pull

cd ../../
cd packages/steedos-portal
git checkout master
git pull

cd ../../