FROM mysql:5.6
COPY my.conf /etc/my.conf
RUN sed -ie 's/^sql_/# sql_/' /usr/my.cnf \
	&& echo "sql_mode=" >> /usr/my.cnf
