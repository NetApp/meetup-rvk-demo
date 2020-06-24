all: nginx cert-manager demo linkerd litmus chaos weavescope


nginx: 
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/aws/deploy.yaml 

cert-manager:
	kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager.yaml	
	sleep 5
	kubectl apply -f cluster-issuer.yaml

demo:
	kubectl apply -f application-full-stack.yaml

linkerd:
	linkerd install | kubectl apply -f -

litmus:
	kubectl apply -f https://litmuschaos.github.io/pages/litmus-operator-v1.5.0.yaml

chaos:
	kubectl apply -f https://hub.litmuschaos.io/api/chaos/1.5.0?file=charts/generic/experiments.yaml 

weavescope:
	kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"

