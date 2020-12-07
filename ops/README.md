
make plan
make apply
make activate CLUSTER_SUFFIX=<take from eks cluster name>
make -C layers ingress.add
#update cflare
kubectl edit -n kube-system configmap/aws-auth # add system:master to instance role
make -C layers gocd.install
# wait a few mins for gocd to initialise
# add pipeline config to gocd -> edit the cluster suffix in the file first
