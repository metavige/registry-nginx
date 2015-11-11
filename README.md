
## 啟動 nginx

```
docker run -d -p 80:80 --link registry:docker-registry --name registry-nginx metavige/registry-nginx
```

## 設定帳號密碼

- 進入 registry-nginx container

```
$ docker exec -it registry-nginx sh
/ # htpasswd -c .htpasswd newuser
New password:
Re-type new password:
Adding password for user newuser
/ #
``` 

