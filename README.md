
## Reference

參考 [Authenticating proxy with nginx](https://docs.docker.com/registry/nginx/)

## 啟動 registry

```
docker run -d -p 5000:5000 --name registry registry:2
```

## 啟動 nginx

```
docker run -d -p 443:443 --link registry:registry metavige/registry-nginx
```

## 設定帳號密碼

- 進入 registry-nginx container

```
$ docker exec -it registry-nginx sh
/ # htpasswd -c /.htpasswd newuser
New password:
Re-type new password:
Adding password for user newuser
/ #
``` 

## 後記

現在只有在 ubuntu 的環境測試過，可以很正常的運行  
目前在 docker-machine 建立起來的環境試驗還不能使用   


