# FROM openjdk:8-jdk
FROM node:14

ENV test_suite="XXXX"
ENV test_environment="XXXX"
ENV protractor_config="protractor-docker.config.js"
ENV chrome_version=78.0.3904.108
ENV HTTP_PROXY="http://host.docker.internal:1087"
ENV HTTPS_PROXY="http://host.docker.internal:1087"

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
	&& apt-get install -y nodejs \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Google Chrome
# RUN export http_proxy=http://192.168.123.109:1087
# RUN export https_proxy=http://127.0.0.1:1087
RUN wget -q -O --no-check-certificate - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update -qqy \
	&& apt-get -qqy install google-chrome-stable \
	&& rm /etc/apt/sources.list.d/google-chrome.list \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
	&& sed -i 's/"$HERE\/chrome"/"$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome

# Set the working directory as Project
WORKDIR /

# Copy all the file to the working directory
COPY . /

# Delete the node modules folder
RUN rm -rf node_modules

# Install project dependencies
RUN npm install
RUN npm run before-test && npm run test

# Download the chrome binaries
# RUN ./node_modules/.bin/webdriver-manager update --versions.chrome ${chrome_version}

# #Start protractor test cases 
# RUN ./node_modules/protractor/bin/protractor  ${protractor_config}} --suite ${test_suite} --params.env ${test_environment}