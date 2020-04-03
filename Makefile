# for local testing
build: 
	docker build -t lektor-site .

serve: build
	docker run --rm -p 8080:8080 lektor-site

compile: 
	pip-compile requirements.in

static: 
	lektor build --output-path _build
	python -m http.server 1337 --directory _build/

clean: 
	rm _build/ -rf 

.DEFAULT_GOAL := serve

# for deployment
deploy:
	gcloud builds submit --tag gcr.io/glasnt-lektor-site/lektor-site
	gcloud run deploy lektor-site --image gcr.io/glasnt-lektor-site/lektor-site
