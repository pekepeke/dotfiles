json_escape () {
  printf '%s' $1 | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}
json_escape () {
  printf '%s' $1 | php -r 'echo json_encode(file_get_contents("php://stdin"));'
}

