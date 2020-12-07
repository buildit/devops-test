# Buildit devops-test
## Includes supporting infra - EKS/GOCD pipelines

## Usage
Commit to this repository - the ci system will trigger -> test -> build -> deploy

## Auth
To login to any services (inc. ci service). Just enter you wipro company email address when prompted, followed up by your login code.
## Application endpoint
- http://buildit.wipro.tech

## CI
![Alt text](ci.png?raw=true "ci pipeline")
- https://ci.wipro.tech

## Install app
```sh
make -C helm install
```

## Building infrastructure

```sh
make -C ops plan
make -C ops  apply
```

## TODO
 - Safe (custom) TLS certs for ci endpoint
 - Note due to time restictions to get this done before end of day there are some steps (documented) that should be run out of band of scripting. For example route53 records.
 - Add secrets manaagement to ci system.
 - Unpack pipeline docker bootstrap mess into own image

