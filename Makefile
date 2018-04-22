.PHONY: test

deps:
	pip install -r requirements.txt; \
	pip install -r test_requirements.txt

lint:
	flake8 hello_world test
test:
	PYTHONPATH=. py.test
test_cov:
	PYTHONPATH=. py.test --verbose -s --cov=.
test_xunit:
	PYTHONPATH=. py.test --verbose -s --cov=. --junit-xml=test_results.xml

docker_build:
	docker build -t hello-world-printer .
docker_run: docker_build
			docker run \
			--name hello-world-printer-dev \
			-p 5000:5000 \
			-d hello-world-printer
test_smoke:
	 	curl --fail 127.0.0.1:5000

USERNAME=luk8982
TAG=$(USERNAME)/hello-world-printer

docker_push: docker_build
	@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
	docker tag hello-world-printer $(TAG); \
	docker push $(TAG); \
	docker logout;

