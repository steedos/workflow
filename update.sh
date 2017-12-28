git pull
git submodule update --init --recursive

rm -rf packages/steedos-cms

cd packages/steedos-emailjs
git checkout master
git pull

cd ../../
cd packages/steedos-portal
git checkout master
git pull

cd ../../