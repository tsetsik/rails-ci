FROM ruby:2.5
MAINTAINER Tsvetomir Demerdzhiev

# Initial setup
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs unzip xinetd telnetd wget apt-transport-https

# Install Chrome
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update -yqqq && \
  apt-get install -y google-chrome-stable > /dev/null 2>&1 && \
  sed -i 's/"$@"/--no-sandbox "$@"/g' /opt/google/chrome/google-chrome; \
  rm -rf /var/lib/apt/lists/*

# Install chromedriver
RUN \
  wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/2.35/chromedriver_linux64.zip && \
  unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/ && \
  rm /tmp/chromedriver.zip && \
  chmod ugo+rx /usr/bin/chromedriver

# Install yarn
RUN \
  wget -q -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
  apt-get update -yq && \
  apt-get install -y yarn; \
  rm -rf /var/lib/apt/lists/*

EXPOSE 80