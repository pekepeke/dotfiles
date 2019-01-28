docker exec -it container /bin/bash -c "cd / ; cmd $(echo "$*" | sed -e 's!\\!\\\\!g')"
