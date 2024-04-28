# your server name goes here
server=https://2fdf3c4b-13be-4ea6-a507-03fc108f394e.eu-central-1.linodelke.net:443
# the name of the secret containing the service account token goes here
name=prod-deployer-token

ca=$(kubectl get secret/$name -n prod -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret/$name -n prod -o jsonpath='{.data.token}' | base64 --decode)
namespace=$(kubectl get secret/$name  -n prod -o jsonpath='{.data.namespace}' | base64 --decode)

echo "
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: default
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${token}
" > sa.kubeconfig