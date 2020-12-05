
ingress.add:
	helm repo add "stable" "https://charts.helm.sh/stable" --force-update
	helm repo add nginx-stable https://helm.nginx.com/stable
	helm repo update
	##ffs wont work with basic auth
#	helm install  in-con nginx-stable/nginx-ingress --set controller.service.loadBalancerSourceRanges={"82.39.97.42/32"}  --set controller.replicaCount=3 
	helm upgrade --install in-con stable/nginx-ingress --set controller.service.httpPort.enable=false --set controller.service.loadBalancerSourceRanges={"\
		173.245.48.0/20,\
		103.21.244.0/22,\
		103.22.200.0/22,\
		103.31.4.0/22,\
		141.101.64.0/18,\
		108.162.192.0/18,\
		190.93.240.0/20,\
		188.114.96.0/20,\
		197.234.240.0/22,\
		198.41.128.0/17,\
		162.158.0.0/15,\
		104.16.0.0/12,\
		172.64.0.0/13,\
		131.0.72.0/22\
		"}  --set controller.replicaCount=3

gocd.install:# gocd.pre
	helm repo add gocd https://gocd.github.io/helm-chart
	helm repo update
	kubectl create ns gocd
	helm upgrade --install  gocd gocd/gocd  --set server.ingress.hosts={"ci.wipro.tech"} --namespace gocd 
#	kubectl create secret generic basic-auth --from-file=auth --namespace gocd
	kubectl annotate ingress gocd-server kubernetes.io/ingress.class="nginx" --namespace gocd
#	kubectl annotate ingress gocd-server nginx.ingress.kubernetes.io/auth-secret="basic-auth" --namespace gocd
#	kubectl annotate ingress gocd-server nginx.ingress.kubernetes.io/auth-type="basic" --namespace gocd
	kubectl annotate ingress gocd-server nginx.ingress.kubernetes.io/force-ssl-redirect=true --namespace gocd

#gocd.pre:
#	htpasswd -c auth buildit
#	kubectl create secret generic basic-auth --from-file=auth

docs.install:
	helm upgrade -install bookstack stable/bookstack --set ingress.enabled=true --set ingress.hosts={"docs.wipro.tech"}

chat.install:
	helm upgrade --install chat stable/rocketchat --set mongodb.mongodbPassword=$(echo -n $(openssl rand -base64 32)),mongodb.mongodbRootPassword=$(echo -n $(openssl rand -base64 32)) --set host=chat.wipro.tech --set ingress.enabled=true

gocd.uninstall:
	helm uninstall  gocd --namespace gocd
	kubectl delete namespace gocd

ingress.remove:
	helm uninstall in-con
