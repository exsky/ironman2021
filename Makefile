CURR_DIR		:=	$(shell pwd)
NEW_TAG			=	$(shell date +"%Y%m%d%H%M")

.PHONY: all add_cred init install-pippkg update-pippkg install-pyenv install-env pull run run-server stop clean pull-img build-img build-dev-img push-image

all:

add_cred:
	[ ! -f ~/.aws/credentials ] && mkdir -p ~/.aws && touch ~/.aws/credentials || echo "Check aws credential file exists"
	cat .aws_credentials >> ~/.aws/credentials

init:
	pyenv install

install-pippkg:
	pip install -r requirements.txt

update-pippkg:
	pipenv sync
	pipenv run pip freeze > requirements.txt

install-pyenv:
	#git clone git://github.com/yyuu/pyenv.git ~/.pyenv
	echo 'export PYENV_ROOT="$$HOME/.pyenv"' >> ~/.bash_profile
	echo 'export PATH="$$PYENV_ROOT/bin:$$PATH"' >> ~/.bash_profile
	echo 'eval "$$(pyenv init -)"' >> ~/.bash_profile
	source ~/.bash_profile

install-env:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	apt-get update
	apt-get install -y unzip
	unzip awscliv2.zip
	./aws/install --update

pull:
	git pull

run:
	python app.py

run-server:
	docker run -d --rm --name daradish-server -p 8080:80 -v $(CURR_DIR)/daradish:/usr/local/apache2/htdocs/ httpd:latest

stop:
	docker stop daradish-server

clean:
	docker rm daradish-server

pull-img:
	docker pull httpd

build-img:
	docker build -t news-grabber . --no-cache

build-dev-img:
	docker build -f Dockerfile.python -t daradish-builder . --no-cache

push-image:
	aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 999999999999.dkr.ecr.ap-northeast-1.amazonaws.com
	docker tag news-grabber:latest 999999999999.dkr.ecr.ap-northeast-1.amazonaws.com/news-grabber:latest
	docker tag news-grabber:latest 999999999999.dkr.ecr.ap-northeast-1.amazonaws.com/news-grabber:${NEW_TAG}
	docker push 999999999999.dkr.ecr.ap-northeast-1.amazonaws.com/news-grabber:latest
	docker push 999999999999.dkr.ecr.ap-northeast-1.amazonaws.com/news-grabber:${NEW_TAG}
