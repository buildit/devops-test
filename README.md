![CI](https://github.com/elliottmurray/devops-test/workflows/CI/badge.svg)
![Deploy to GKE](https://github.com/elliottmurray/devops-test/workflows/Deploy%20to%20GKE/badge.svg)

# Setup
I have assumed docker is installed. I ran it with node 12 locally. I managed this with dotenv/nvm but would probably use .node_version ongoing. I have used github actions and you will need to set up some secrets/config so will have to re-fork this repo to get a deployment working. The secrets you will need to setup:

GKE_PROJECT
GKE_SA_KEY # a service account key (need instructions for this)


## Running this web application
 This is a NodeJS application:	This is a NodeJS application:

- `npm test` runs the application tests	- `npm test` runs the application tests
- `npm start` starts the http server


## Run in docker
Run the following to build and run locally:

```bash
docker build -t buildit .
docker run -p 3000:3000 -it buildit
```


## GKE setup
Assumed you have an account. Create a project called em-buildit and enable Kubernetes api's. Then run

```bash
gcloud config set project em-buildit
gcloud config set compute/zone europe-north1-a
gcloud container clusters create buildit-cluster

```




