# Buildit devops-test
## Includes supporting infra - EKS/GOCD pipelines

## Note to buildit team!
 - This project was submitted to the agent `WITH` credentials for accessing the ci system

## Usage
Commit to this repository - the ci system will trigger -> test -> build -> deploy

## Application endpoint
- http://buildit.wipro.tech

## CI
- https://ci.wipro.tech

## Install app
```sh
make install
```

## Building infrastructure
```sh
cd ops
make plan
make apply
```

## TODO
 - Safe (custom) TLS certs for ci endpoint
 - Note due to time restictions to get this done before end of day there are some steps (documented) that should be run out of band of scripting. For example route53 records.
 - Add secrets manaagement to ci system.

