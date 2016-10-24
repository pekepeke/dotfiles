ntp
====

### 時刻セット

```
date --set='2016/10/01 01:00:00'
```

### 時刻合わせ

```
ntpdate ntp.nict.jp
ntpdate -B ntp.nict.jp # slew モードで同期(徐々に時刻を合わせる方式)
ntpdate -b ntp.nict.jp # step モードで同期(=すぐに合わせる)
ntpdate -d ntp.nict.jp # debug用時刻の修正は行わない
ntpdate -q ntp.nict.jp # NTPサーバーに問い合わせのみ行う
```

### /etc/ntp.conf

```
server -4 ntp.nict.jp
server -4 ntp1.jst.mfeed.ad.jp
server -4 ntp2.jst.mfeed.ad.jp
server -4 ntp3.jst.mfeed.ad.jp
```

