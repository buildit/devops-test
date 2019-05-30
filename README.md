# Devops-test (FEATURE branch)

This page outlines the steps taken to implement a CI pipeline for the BuildIT Devops test - see [BuildIt DevOps Test](README_BUILDIT.md).
Any changes made to the _feature_ branch of this repository will trigger the pipeline resulting in deployment of the sample
web app to a HA environment on Digital Ocean.

### Pre-requsites
The following steps will assume that you have the following already setup
 * GitHub account
 * Digital Ocean account
 * Codeship account
 * Personal SSH key

## (1) Fork repository
This repository was created from a fork of the BuildIt DevOps Test repo at [https://github.com/buildit/devops-test](https://github.com/buildit/devops-test)

A local working copy of this repo can be created using the following command once forked to your GitHub account.
```
git clone https://github.com/dazoido/devops-test.git
```

## (2) Create a Droplet on Digital Ocean
Create a droplet capable of running the Node web app. Use the steps below:

1. Login to your Digital Ocean account
1. Create a Droplet using a standard Ubuntu distribution (Note: You can use their pre-baked 'Node on Ubuntu' image under the __Marketplace__ tab but for the purpose of being verbose we will use a standard image and install node on the droplet too)
1. Add your public SSH key to the droplet
1. Give you droplet and more friendly, identifiable name e.g. ws1-devops
1. You can skip over most of the other options (for the purpose of creating this demo/test)


## (3) Create 'deploy' user
Create a deploy user for managing deployments to droplet

1. SSH to droplet as root user - `ssh root@DROPLET_IP`
1. Add 'deploy' user - `useradd -s /bin/bash -m -d /home/deploy deploy`
1. Set password for 'deploy' user - `passwd deploy`
1. Give 'deploy user' sudo/root level access - `usermod -aG sudo deploy`
1. Create authorized_key file for ssh access to 'deploy' user -
    ```
    cd /home/deploy
    mkdir .ssh
    chown deploy:deploy .ssh
    chmod 700 .ssh
    cd .ssh
    touch authorized_keys
    chown deploy:deploy authorized_keys
    chmod 600 authorized_keys
    ```
    Note: alternatively you can use `ssh-copy-id` command from your local machine to setup the necessary ssh directory, files and add your     key.
1. Add your public SSH key to `/home/deploy/.ssh/authorized_keys`


## (4) Create SSH keys for deploy and connect to GitHub
Generate SSH keys for 'deploy' user and use these to connect the droplet to GitHub

1. SSH into your droplet as the 'deploy' user - `ssh deploy@DROPLET_IP`
    ```
    ssh-keygen -t rsa -C "deploy"
    ```
    When prompted save the key with an empty passphrase.
    This will save the generated private/public pair to `/home/deploy/.ssh/id_rsa`.
1. Add the following ssh-agent startup script to `/home/deploy/.bashrc`. You will need to reboot the server for the `ssh-agent` to be started and the deploy key automatically added.
    ```
    if [ ! -S ~/.ssh/ssh_auth_sock ]; then
      eval `ssh-agent`
      ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
    fi
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
    ssh-add -l > /dev/null || ssh-add
    ```
1. Copy the contents of `id_rsa.pub` to your Github repo - Settings > Deploy Keys. (Do not allow write permissions).


## (5) Install Node and NPM on your Droplet
1. To install Node and NPM, SSH into to your newly created droplet and run the following commands:
    ```
    curl -sL https://deb.nodesource.com/setup_10.x -o node_10_setup.sh
    chmod 760 node_10_setup.sh
    sudo bash node_10_setup.sh
    sudo apt install nodejs
    ```
1.Verify successful installation using the following commands:
    ```
    node -v
    npm -v
    ```

## (6) Install Node app on Droplet
Clone the repo to a folder on the droplet.
1. Create folder where repo/app will reside
    ```
    cd /var
    mkdir www
    sudo chown deploy:deploy -R www
    cd www
    ```
1. Clone repo `git clone git@github.com:dazoido/devops-test.git`
1. Install app dependencies and start app
    ```
    cd devops-test
    npm install
    npm start
    ```

## (7) Setup Codeship to manage CI
1. Create project and connect to repository
1. Set deployment script - Project > Project Settings > Deploy
    ```
    # deploy to ws1-devops
    ssh deploy@DROPLET_IP 'cd /var/www/devops-test && git checkout feature && git pull && npm install && pm2 restart all'
    ```
1. Set build triggers - Project > Project Settings > Build Triggers
    * Select Behaviour - _Run builds for these branches only_ enter 'feature' for only the feature branch to trigger build
    * Select Build Trigger - _Build on commit, merge, and tags_
1. Copy SSH key in - Project > Project Settings > General to `/home/deploy/.ssh/authorized_keys`

## (8) Create second Droplet for HA environment
1. Either repeat steps 2-6 __OR__ more convienently take a _snapshot_ of the first droplet and use this to create the second droplet.
1. SSH into the second droplet to start `ssh-agent` and the deploy key
1. Start the app/server `cd /var/www/devops-test && npm start`
1. Update the deploy script on Codeship to deploy to the second droplet 
    ```
    # deploy to ws1-devops
    ssh deploy@DROPLET_IP 'cd /var/www/devops-test && git checkout feature && git pull && npm install && pm2 restart all'

    # deploy to ws2-devops
    ssh deploy@DROPLET_IP 'cd /var/www/devops-test && git checkout feature && git pull && npm install && pm2 restart all'
    ```
## (9) Setup Loadbalancer on DigitalOcean
1. Spin up a loadbalancer on Digital Ocean and add the droplets to its balancing group
1. Configure the settings as follows <img width="1218" alt="DigitalOcean_LB_settings" src="https://user-images.githubusercontent.com/22031811/58669926-44a9e100-8335-11e9-822a-29163d084e02.png">

