
let s:db_host = 'localhost'
let s:db_port = '3306'
let s:db_user = 'root'
let s:db_password = ''
let s:db_name = ''

let b:dbext_type = 'MYSQL'
let b:dbext_host = s:db_host
let b:dbext_user = s:db_user
let b:dbext_port = s:db_port
let b:dbext_extra = ''
let b:dbext_password = s:db_password
let b:dbext_dbname = s:db_name

if &filetype =~ 'sql$'
  let b:quickrun_config = {
  \ 'cmdopt': printf("-u %s -h %s -P %s %s",
  \     s:db_user, s:db_host, s:db_port, s:db_name)
  \   .(empty(s:db_password) ? "-p".s:db_password : ''),
  \ }
endif
