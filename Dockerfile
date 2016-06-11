FROM node:6

COPY . /app
WORKDIR /app
RUN ["npm", "install", "-g", "coffee-script"]
RUN ["npm", "install"]

VOLUME /app/formatted
VOLUME /app/raw

CMD make
