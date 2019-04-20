#!/bin/bash
echo "*** Waiting for Clud-Init to finish ***"
cloud-init status --wait
echo "*** Kubernetes Pulling Images:"
kubeadm config images pull
echo "*** Kubernetes Initializing:"
kubeadm init \
--apiserver-advertise-address "0.0.0.0" \
| tee /tmp/kubeadm.log
echo "*** Installing Weave:"
export K8S_VERSION="$(kubectl version | base64 | tr -d '\n')"
export WEAVE_URL="https://cloud.weave.works/k8s/net?k8s-version=$K8S_VERSION"
kubectl apply -f "$WEAVE_URL"
echo "*** Waiting for Kubernetes to get ready:"
STATE="NotReady"
while test "$STATE" != "Ready" ; do 
STATE=$(kubectl get node | tail -1 | awk '{print $2}')
echo -n "." ; sleep 1
done
echo ""
if grep "kubeadm join" /tmp/kubeadm.log >/dev/null
then echo '{"join":"'$(kubeadm token create --ttl 0 --print-join-command)'"}' >/etc/join.json
fi
