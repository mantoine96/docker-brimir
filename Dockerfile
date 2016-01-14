FROM ruby:latest
MAINTAINER Matthieu ANTOINE <matthieu@matthieu-antoine.me>

RUN mkdir -p /opt/brimir
RUN cd /opt
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates
RUN echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger jessie main' > /etc/apt/sources.list.d/passenger.list
RUN git clone https://github.com/ivaldi/brimir /opt/brimir
WORKDIR /opt/brimir
RUN apt-get update && apt-get -y install apache2.2-common nodejs postgresql postgresql-client pwgen libapache2-mod-passenger
RUN a2enmod passenger && apache2ctl restart
RUN bundle install --without sqlite mysql development test --deployment
#RUN /etc/init.d/postgresql start
#Generate database
ADD generate-database.sh /opt/brimir/generate-database.sh
RUN /bin/bash generate-database.sh /opt/brimir
EXPOSE 3000
RUN /etc/init.d/postgresql start
RUN sed -i "s/<%= ENV\[\"SECRET_KEY_BASE\"\] %>/`bin/rake secret`/g" /opt/brimir/config/secrets.yml
RUN /etc/init.d/postgresql start && sleep 10 && bin/rake db:schema:load RAILS_ENV=production
RUN bin/rake assets:precompile RAILS_ENV=production
ADD loadUser.rb /opt/brimir/loadUser.rb
RUN /etc/init.d/postgresql start && bin/rails console production < loadUser.rb
RUN update-rc.d postgresql enable
RUN /etc/init.d/postgresql start
CMD /etc/init.d/postgresql start && passenger start -a 0.0.0.0 -p 3000 -e production
