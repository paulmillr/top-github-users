FROM node:6

COPY . /app
WORKDIR /app
RUN ["npm", "install"]

VOLUME /app/formatted
VOLUME /app/raw

CMD make
