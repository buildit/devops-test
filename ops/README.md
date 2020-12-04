
make plan
make apply
make activate CLUSTER_SUFFIX=<take from eks cluster name>
cd layers; make ingress.add
# update r53 with lb
kubectl edit -n kube-system configmap/aws-auth # add system:master to instance role
make gocd.install
# wait a few mins for gocd to initialise
# add pipeline config to gocd -> edit the cluster suffix in the file first
