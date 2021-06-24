## BUILD CONTAINER ##
FROM node:latest AS build
LABEL stage=builder

WORKDIR /app

COPY . ./
RUN npm install
RUN npm run build

## RUN CONTAINER ##
FROM nginx:alpine AS run

COPY --from=build /app/public /app
COPY ./data/nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443