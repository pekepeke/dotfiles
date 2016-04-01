## composer.json に package 追加

```
composer require phpunit/phpunit:3.7.*       # requireに追加
composer require phpunit/phpunit:3.7.* --dev # require-devに追加
```

## remove

```
composer remove jenssegers/mongodb
composer remove jenssegers/mongodb --update-with-dependencies
```

## self-upgrade
```
composer self-upgrade
```
