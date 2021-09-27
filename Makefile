CURR_DIR		:=	$(shell pwd)
NEW_TAG			=	$(shell date +"%Y%m%d%H%M")
LATEST_IMGID	= 	$(shell docker images htc-report-safe-builder -q)

.PHONY: all add_cred init install-pippkg update-pippkg install-pyenv install-env pull pull-img build-image build-dev-img run run-server stop clean

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

pull-img:
	docker pull httpd

build-img:
	docker build -t daradish-server . --no-cache

build-dev-img:
	docker build -f Dockerfile.python -t daradish-builder . --no-cache

run:
	python app.py

run-server:
	docker run -d --rm --name daradish-server -p 8080:80 -v $(CURR_DIR)/daradish:/usr/local/apache2/htdocs/ httpd:latest

stop:
	docker stop daradish-server

clean:
	docker rm daradish-server
