CURR_DIR		:=	$(shell pwd)
NEW_TAG			=	$(shell date +"%Y%m%d%H%M")
LATEST_IMGID	= 	$(shell docker images htc-report-safe-builder -q)

.PHONY: all init install-pippkg update-pippkg install-env pull pull-img build-dev-img run run-server stop clean

all:

init:
	pyenv install 3.9.6

install-pippkg:
	pyenv local 3.9.6
	pip install -r requirements.txt

update-pippkg:
	pipenv sync
	pipenv run pip freeze > requirements.txt

install-env:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	apt-get update
	apt-get install -y unzip
	unzip awscliv2.zip
	./aws/install --update

pull:
	git pull

pull-img:
	docker pull httpd

build-dev-img:
	docker build -t daradish-builder . --no-cache

run:
	pyenv local 3.9.6
	python app.py

run-server:
	docker run -d --rm --name daradish-server -p 8080:80 -v $(CURR_DIR)/daradish:/usr/local/apache2/htdocs/ httpd:latest

stop:
	docker stop daradish-server

clean:
	docker rm daradish-server
