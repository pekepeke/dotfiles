boot2docker ssh
user: docker
pass: tcuser

boot2docker ssh -L 8000:localhost:8000
boot2docker ssh -L [local]:localhost:[remote]

docker build -t test/sshd .
docker ps -a
docker commit -m "commit" [id] test/sshd
## sshd 起動
docker run -d -p 22 test/sshd

