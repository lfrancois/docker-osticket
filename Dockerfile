FROM ubuntu
MAINTAINER Ludovic Francois <ludo@msolution.io>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update
RUN apt-get -y install apache2 php5 libapache2-mod-php5 php5-imap
RUN apt-get -y install git
RUN apt-get -y install mysql-server
RUN apt-get -y install php5-imap php5-gd php5-mysql

RUN cd /root/ && git clone https://github.com/osTicket/osTicket-1.8 
RUN cd /root/osTicket-1.8/ && php setup/cli/manage.php deploy --setup /var/www/html/osticket

RUN php5enmod imap
RUN /etc/init.d/apache2 restart

RUN cd /var/www/html/osticket/ && cp include/ost-sampleconfig.php include/ost-config.php && chmod 0666 include/ost-config.php

RUN /etc/init.d/mysql restart
#RUN chmod 0664 /var/www/html/osticket/include/ost-config.php
#RUN rm -rf /var/www/html/osticket/setup/            

RUN echo http://obelix.zoxx.net/osticket/index.php
RUN echo http://obelix.zoxx.net/osticket/scp/settings.php

RUN echo "America/Los_Angeles" | tee /etc/timezone
RUN echo dpkg-reconfigure --frontend noninteractive tzdata

RUN echo 'date.timezone = "America/Los_Angeles"' | tee -a /etc/php5/apache2/php.ini
RUN echo 'cgi.fix_pathinfo=1' | tee -a /etc/php5/apache2/php.ini

RUN apt-get -y install postfix mailutils libsasl2-2 ca-certificates libsasl2-modules
RUN postconf -e "mydestination = support.msolution.io, localhost.localdomain, localhost"
RUN postconf -e "inet_interfaces = all"
RUN postconf -e "myhostname = support.msolution.io"


EXPOSE 80
ADD run.sh /run.sh
ADD clean.sh /clean.sh
RUN chmod 755 /*.sh
CMD ["/run.sh"]
