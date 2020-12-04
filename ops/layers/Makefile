
ingress.add:
	helm repo add "stable" "https://charts.helm.sh/stable" --force-update
	helm repo add nginx-stable https://helm.nginx.com/stable
	helm repo update
	##ffs wont work with basic auth
#	helm install  in-con nginx-stable/nginx-ingress --set controller.service.loadBalancerSourceRanges={"82.39.97.42/32"}  --set controller.replicaCount=3 
	helm install in-con stable/nginx-ingress --set controller.service.httpPort.enable=false --set controller.service.loadBalancerSourceRanges={"82.39.97.42/32"}  --set controller.replicaCount=3

gocd.install: gocd.pre
	helm repo add gocd https://gocd.github.io/helm-chart
	helm repo update
	kubectl create ns gocd
	helm upgrade --install  gocd gocd/gocd  --set server.ingress.hosts={"ci.wipro.tech"} --namespace gocd 
	kubectl create secret generic basic-auth --from-file=auth --namespace gocd
	kubectl annotate ingress gocd-server kubernetes.io/ingress.class="nginx" --namespace gocd
	kubectl annotate ingress gocd-server nginx.ingress.kubernetes.io/auth-secret="basic-auth" --namespace gocd
	kubectl annotate ingress gocd-server nginx.ingress.kubernetes.io/auth-type="basic" --namespace gocd
	kubectl annotate ingress gocd-server nginx.ingress.kubernetes.io/force-ssl-redirect=true --namespace gocd

gocd.pre:
	htpasswd -c auth buildit
	kubectl create secret generic basic-auth --from-file=auth

gocd.uninstall:
	helm uninstall  gocd --namespace gocd
	kubectl delete namespace gocd

ingress.remove:
	helm uninstall in-con
