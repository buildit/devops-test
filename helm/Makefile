TAG ?= v1

install:
	helm upgrade --install buildit buildit/ --set image.tag=$(TAG)

uninstall:
	helm uninstall buildit
