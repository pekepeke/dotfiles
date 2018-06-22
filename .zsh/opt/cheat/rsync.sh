rsync -av ~/img/ public/img/
rsync -av --delete ~/img/ public/img/
rsync -av --dry-run ~/img/ public/img/

# リモートからローカルに同期
rsync -av -e 'ssh -i ~/.ssh/wawawa-key.pem' ec2-user@172.22.1.1:/home/ec2-user/remote /home/ec2-user/local
# ローカルからリモートへ同期(-eオプションはリモートサーバの記載の直前に書く必要がある)
rsync -av  /home/ec2-user/local -e 'ssh -i ~/.ssh/wawawa-key.pem' ec2-user@172.22.1.1:/home/ec2-user/remote

