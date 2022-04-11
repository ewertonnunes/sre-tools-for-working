# sre-tools-for-working

```
# Build Image from your currently path.
docker build -t sre-tools .
docker build -t ewertonrdr/sre-tools .
```
```
# Run Image with name and env-file (put your configuratios profile here.)
docker run --name sre-tools-eflorencio --env-file ./user-config.env -dit ewertonrdr/sre-tools:latest
```

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
TODO: Install and create a user structure.
gimme-aws-creds
mongodb shell
psql
```



