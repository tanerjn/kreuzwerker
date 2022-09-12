#!/usr/bash
echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc
echo 'export LANG=en_US.UTF-8' >> ~/.bashrc
source ~/.bashrc

sudo yum update -y

sudo amazon-linux-extras install docker -y

wget https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz 

tar xfz linux-amd64-1.1.0.tar.gz 

sudo cp linux-amd64-1.1.0/ccat /usr/local/bin/

sudo chmod +x /usr/local/bin/ccat

ccat /dev/sda

sudo service docker start

sudo systemctl enable docker

sudo docker info

echo "\nDISK\n"
sudo parted /dev/sda unit s print free

# build the docker image
sudo docker build -t test-kreuzwerker .

# login to your docker hub account
cat ~/dockerpass.txt | sudo docker login --username tanermetin --password-stdin 

# use the docker tag command to give the image a new name
sudo docker tag test-kreuzwerker tanermetin/test-kreuzwerker

# push the image to your docker hub repository
sudo docker push tanermetin/test-kreuzwerker

# start the container to test the image 
sudo docker run --publish 8000:8000 test-kreuzwerker 
