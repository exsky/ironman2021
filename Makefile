CURR_DIR		:=	$(shell pwd)
NEW_TAG			=	$(shell date +"%Y%m%d%H%M")
LATEST_IMGID	= 	$(shell docker images htc-report-safe-builder -q)

.PHONY: all init pull pull-img build-dev-img run run-server stop clean

all:

init:
	pyenv local 3.9.7
	pipenv shell

pull:
	git pull

pull-img:
	docker pull httpd

build-dev-img:
	docker build -t daradish-builder . --no-cache

run:
	python app.py

run-server:
	docker run -d --rm --name daradish-server -p 8080:80 -v $(CURR_DIR)/daradish:/usr/local/apache2/htdocs/ httpd:latest

stop:
	docker stop daradish-server

clean:
	docker rm daradish-server
