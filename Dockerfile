# Build with:
# 	docker build -t cswl/xampp .

FROM ubuntu:18.04

ENV TERM=xterm

# Install curl and net-stats for XAMPP 
RUN apt-get update && \
 apt install -yq curl net-tools psmisc

# Download the installer (7.2.12)
RUN XAMPP_DL_LINK=' \
	https://downloadsapachefriends.global.ssl.fastly.net/7.2.12/xampp-linux-x64-7.2.12-0-installer.run?from_af=true \
	' \ 
	&& curl -L -o xampp-linux-installer.run $XAMPP_DL_LINK

# Run the installer in Unattended mode
# Currently there is a bug which doesnt show progress
RUN chmod 755 xampp-linux-installer.run
RUN ./xampp-linux-installer.run --mode unattended --unattendedmodeui  minimal 

# Delete the installer file after install
RUN rm ./xampp-linux-installer.run

# Enable XAMPP web interface(remove security checks)
RUN /opt/lampp/bin/perl -pi -e s'/Require local/Require all granted/g' /opt/lampp/etc/extra/httpd-xampp.conf

# Enable includes of several configuration files
RUN mkdir /opt/lampp/apache2/conf.d && \
echo "IncludeOptional /opt/lampp/apache2/conf.d/*.conf" >> /opt/lampp/etc/httpd.conf

# Create a /www folder and a symbolic link to it in /opt/lampp/htdocs. 
# It'll be accessible via http://localhost:[port]/www/
# This is convenient because it doesn't interfere with xampp, phpmyadmin or other tools in /opt/lampp/htdocs
RUN mkdir /www
RUN ln -s /www /opt/lampp/htdocs/

# Link to /usr/bin for easier starting
RUN ln -sf /opt/lampp/lampp /usr/bin/lampp

# Add xampp binaires to .bashrc
RUN echo "export PATH=\$PATH:/opt/lampp/bin/" >> /root/.bashrc
RUN echo "export TERM=xterm" >> /root/.bashrc

EXPOSE 80 443 3306

ADD init.sh /usr/local/bin/init.sh
RUN chmod 777 /usr/local/bin/init.sh

# Start the init script
ENTRYPOINT ["/usr/local/bin/init.sh"]


