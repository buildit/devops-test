[![Github CI](https://github.com/elliottmurray/devops-test/workflows/CI/badge.svg)](https://github.com/elliottmurray/devops-test/actions)


# Setup
I have assumed docker is installed. I ran it with node 12 locally. I managed this with dotenv/nvm but would probably use .node_version ongoing.


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


