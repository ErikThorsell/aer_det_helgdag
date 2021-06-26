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

EXPOSE 80 443
