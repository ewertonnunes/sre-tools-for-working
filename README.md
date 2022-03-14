# sre-tools-for-working
I'm building a Docker image with important tools for SRE.
# Build Image 
docker build -t sre-tools .
# Run Image with name and env-file (put your configuratios profile here.)
docker run --name sre-tools-eflorencio --env-file ./user-config.env -dit sre-tools:latest

Any suggestions are welcome.

```html
git - ok
kubectl - ok
kubectx - ok
kubens - ok
helm3 - ok
python3 - ok
golang - pending
ansible - ok
terraform (tfenv) - TODO: atualizar versão do terraform
awscli - (Verificar versão)
google cloud sdk - ok
--------------
gimme-aws-creds
mongodb shell
psql
```



