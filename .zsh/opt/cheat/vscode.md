## keybindings
- https://code.visualstudio.com/docs/customization/keybindings

## lang
### php
#### xdebug

```
{ "configurations": [
	{
		"serverSourceRoot": "/var/www/html",
		"localSourceRoot": "${workspaceRoot}",
	},
	{
		"name": "XDebug on docker",
		"type": "php",
		"request": "launch",
		"port": 9001,
		"pathMappings": {
			// {docker上のdocument root}:{ローカルのdocument root}
			"/var/www/html":"/Path/to/your/local/root"
		}
	}
]}
```
