#!/bin/bash
echo "Update yum packages"
yum update -y

# Install yum packages
echo "Installing ruby"
yum install ruby -y
echo "Installing wget"
yum install wget -y

# Install Dart
echo "Installing dart"
wget -q https://storage.googleapis.com/dart-archive/channels/stable/release/2.18.1/sdk/dartsdk-linux-x64-release.zip
unzip -q dartsdk-linux-x64-release.zip
sudo mv dart-sdk/ /usr/lib/dart/
sudo chmod -R 755 /usr/lib/dart/
echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> /etc/profile.d/script.sh

# Install CodeDeploy agent
echo "Installing CodeDeploy agent"
cd /home/ec2-user
wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
chmod +x ./install
./install auto
rm install

# Set runmode
echo "Setting runmode"
echo ${runmode} > /home/ec2-user/runmode
chown ec2-user:ec2-user /home/ec2-user/runmode

echo "Setup done"
