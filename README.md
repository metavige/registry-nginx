
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
* 透過 `sudo sh -c "openssl s_client -showcerts -connect registry.co:443 </dev/null 2>/dev/null| openssl x509 -outform PEM > /etc/docker/certs.d/registry.co/ca.crt"` 指令，把 SSL 網站的 CERT 匯出變成本地端的檔案
* 透過 `docker login registry.co`  登入 registry
 
## 在 docker-machine 內加上以上設定，自動化

如果是使用 docker-machine 建立的環境，上面做的動作需要進入到機器內去做。  
但是做完之後，下次重開機得在重做一次，因為 docker-machine 建立出來的 virtualbox 環境，每次在重新啟動的時候，除了 /var/lib/boot2docker 目錄下的檔案，其他環境設定都會重新產生  
所以，需要有其他方法來做到以上動作～  

* 用 `docker-machine ssh` 指令進入 machine
* 進入到 `/var/lib/boot2docker` 目錄下，建立一個 boot2local.sh 檔案 (sudo)
* 把上面的動作放進這個 sh 檔案裡面

Sample:    

```
#!/bin/sh

echo "192.168.0.10 registry.co" >> /etc/hosts
mkdir -p /etc/docker/certs.d/registry.co
sh -c "openssl s_client -showcerts -connect registry.co:443 </dev/null 2>/dev/null| openssl x509 -outform PEM > /etc/docker/certs.d/registry.co/ca.crt"
```

