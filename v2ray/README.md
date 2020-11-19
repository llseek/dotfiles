1. Set DNS A Record for spinlock.xyz on godaddy.com

2. Issue https certificate

```
$ sudo su
# apt install socat
# curl https://get.acme.sh | sh
# ~/.acme.sh/acme.sh --issue -d spinlock.xyz --standalone -k ec-256
# ~/.acme.sh/acme.sh --installcert -d spinlock.xyz --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc
# ~/.acme.sh/acme.sh --upgrade --auto-upgrade
# crontab -l
19 0 * * * "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" > /dev/null
```

3. Launch nginx

```
$ sudo apt install nginx
$ cp dotfiles/nginx/default /etc/nginx/sites-available/default
$ sudo systemctl restart nginx
$ sudo netstat -tunlp | grep nginx
tcp        0      0 0.0.0.0:443             0.0.0.0:*               LISTEN      10569/nginx: master
```

4. Launch v2ray

```
$ wget https://github.com/dreamrover/v2ray-deb/releases/download/4.27.5/v2ray-4.27.5-amd64.deb
$ sudo dpkg -i v2ray-4.27.5-amd64.deb
$ sudo cp dotfiles/v2ray/server.json /etc/v2ray/server.json
$ sudo systemct restart v2ray
$ sudo netstat -tunlp | grep nginx
tcp        0      0 127.0.0.1:10000         0.0.0.0:*               LISTEN      10631/v2ray
```
