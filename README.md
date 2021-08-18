## How to run

### run `setup.sh`

What does it do?

1. creates kubernetes cluster on local docker using kind
2. installs consul using helm
3. port forward consul on localhost:8500
4. builds java service image
5. loads image in kind cluster
6. creates kv for the application in consul
7. runs containerised spring boot app in local k8s cluster

Checking that it works -

1. port forward spring boot app port 8080
2. `curl localhost:8080/message` you should get `Hello World` - this message is coming from consul - you can modify this message on consul UI (port forward 8500 for consul server pod and try changing the message and redeploy the spring boot app)
