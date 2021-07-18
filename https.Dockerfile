## BUILD CONTAINER ##
FROM node:latest AS build
LABEL stage=builder

WORKDIR /app

COPY . ./
RUN npm install
RUN npm run build

## NGINX RUN CONTAINER ##
FROM nginx:stable-alpine

RUN	\
        # Install Python 2
        apk add --no-cache python2 \
	python2-dev \
	&& python -m ensurepip \
	&& rm -r /usr/lib/python*/ensurepip \
	&& pip install --upgrade pip setuptools

RUN	\
        # Install packages required by agent
        apk add --no-cache procps \
        util-linux \
	libstdc++ \
	libffi-dev \
	openssl-dev \
        \
        # install packages required for agent build
        && apk add --no-cache --virtual .amplify\
        build-base \
        git \
        linux-headers

RUN	cd / \
        # clone latest agent from repository and build it
        && git clone https://github.com/nginxinc/nginx-amplify-agent \
        && cd nginx-amplify-agent/ \
        && pip install --no-cache-dir -r packages/nginx-amplify-agent/requirements.txt \
	&& pip install --no-cache-dir --upgrade ujson==2.0.3 \
        && python2.7 setup.py install \
        \
        # make sure agent log exists
        && mkdir -p /var/log/amplify-agent \
        && touch /var/log/amplify-agent/agent.log \
        && touch /var/log/nginx/access.log \
        && touch /var/log/nginx/error.log \
        \
        # create agent config file
        && cp /etc/amplify-agent/agent.conf.default /etc/amplify-agent/agent.conf \
        \
        # Cleanup
        && cd .. \
        && rm -Rf nginx-amplify-agent/ \
        && find /usr/lib/python2.7 -name \*\.pyo -exec rm {} \; \
        && find /usr/lib/python2.7 -name \*\.pyc -exec rm {} \; \
        && apk del .amplify

## COPY ALL CONFIGS
COPY ./entrypoint.sh /entrypoint.sh
COPY conf/nginx/nginx_http.conf /etc/nginx/nginx.conf
COPY conf/nginx/server.conf /etc/nginx/conf.d/default.conf
COPY conf/nginx/stub_status.conf /etc/nginx/conf.d/stub_status.conf

## COPY APPLICATION FROM NODE BUILD CONTAINER
COPY --from=build /app/public /app

EXPOSE 80

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]

