PATH := $(PWD)/$(VENV)/bin:$(PWD)/vendor:$(shell printenv PATH)

KUBECONFIG ?= $(PWD)/.kubeconfig_wipro
PWD = $(shell pwd)
SHELL := env PATH='$(PATH)' /bin/bash
CLUSTER_SUFFIX ?= d0xOnFS1
AWS_PROFILE = default

export KUBECONFIG
export PATH

vendor/%:
	cd vendor && make all

init: vendor/terraform
	@echo ">> initializing terraform"
	terraform init

plan: init
	@echo ">> planning terraform"
	terraform plan

apply:
	@echo ">> applying terraform"
	terraform apply

destroy:
	@echo ">> DESTROYING terraform"
	terraform destroy


activate: kubeconfig
	@exec $(SHELL)

kubeconfig:
	aws eks update-kubeconfig --name "wipro-eks-$(CLUSTER_SUFFIX)" \
		--kubeconfig $(KUBECONFIG)
	kubectl config set-context --current --namespace=default --kubeconfig  $(KUBECONFIG)

pods:
	kubectl --kubeconfig .kubeconfig get pods

clean:
	cd vendor && make clean
	rm -rf .terraform
