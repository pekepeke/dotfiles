
## codegen-cli

```bash
docker run --rm -v $(pwd):/local swaggerapi/swagger-codegen-cli generate -i swagger.yml -l [lang] -o /local/out/swift

docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate -i /local/swagger.yml -g [lang] -o /local/out/
```
