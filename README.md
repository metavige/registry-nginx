
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

目前 registry-nginx 的 htpasswd 檔案放在 `/.htpasswd`  
所以，如果為了方便維護，也可以透過 -v 的方式，將檔案放在外部    

## Docker 使用 private repository

假設 registry-nginx 所在 IP 是 192.168.0.10，我們可以用 Host 的 Mapping 
方便使用  
如果我們使用 registry.co 當做 registry host  

另外，目前 docker client version 測試是 1.9.0  

* 先在 /etc/hosts 加上 192.168.0.10 registry.co 的 Mapping
* 建立 /etc/docker/certs.d/registry.co 目錄 
* 透過 `openssl s_client -showcerts -connect registry.co:443 | openssl x509 -outform PEM > /etc/docker/certs.d/registry.co/ca.crt`  指令，把 SSL 網站的 CERT 匯出變成本地端的檔案  
* 透過 `docker login registry.co`  登入 registry
 




