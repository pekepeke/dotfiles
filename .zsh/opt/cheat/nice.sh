## 優先度を低く(最低19)
nice -n 10 hoge.sh
## 優先度を高く(最大-20)
nice -n -10 hoge.sh
## PID=4654 の nice を変更
renice -10 -p 4654
