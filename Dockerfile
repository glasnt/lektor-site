FROM python:3.8-slim AS build

ENV APP_HOME /app
WORKDIR $APP_HOME

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

RUN lektor build --output-path _build

FROM nginx:alpine 
ENV PORT 8080

COPY ./nginx.conf /etc/nginx/conf.d/configfile.template
#??
RUN sh -c "envsubst '\$PORT'  < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf"
COPY --from=build /app/_build/ /var/www/

CMD nginx -g 'daemon off;'
