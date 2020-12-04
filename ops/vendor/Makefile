TERRAFORM_VERSION ?= 0.14.0
OS_TYPE ?= linux
CPU_ARCH ?= amd64
AWS_EKS_VERSION ?= 1.18.9/2020-11-02
HELM_VERSION ?= 3.4.1

all: terraform kubectl helm

terraform:
	$(MAKE) terraform_$(TERRAFORM_VERSION)_$(OS_TYPE)_$(CPU_ARCH).zip
	unzip terraform_$(TERRAFORM_VERSION)_$(OS_TYPE)_$(CPU_ARCH).zip

terraform_$(TERRAFORM_VERSION)_$(OS_TYPE)_$(CPU_ARCH).zip:
	curl -o "terraform_$(TERRAFORM_VERSION)_$(OS_TYPE)_$(CPU_ARCH).zip" \
		https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_$(OS_TYPE)_$(CPU_ARCH).zip

kubectl:
	curl -o kubectl \
		https://amazon-eks.s3-us-west-2.amazonaws.com/$(AWS_EKS_VERSION)/bin/$(OS_TYPE)/$(CPU_ARCH)/kubectl
	chmod +x kubectl

helm:
	$(MAKE) helm-v$(HELM_VERSION)-$(OS_TYPE)-$(CPU_ARCH).tar.gz
	@tar -xzf helm-v$(HELM_VERSION)-$(OS_TYPE)-$(CPU_ARCH).tar.gz
	@mv $(OS_TYPE)-$(CPU_ARCH)/helm .
	@rm -rf $(OS_TYPE)-$(CPU_ARCH)

helm-v$(HELM_VERSION)-$(OS_TYPE)-$(CPU_ARCH).tar.gz:
	curl -LO https://get.helm.sh/helm-v$(HELM_VERSION)-$(OS_TYPE)-$(CPU_ARCH).tar.gz

clean:
	rm -f terraform*
	rm -f kubectl
	rm -f helm*

