SERVICE_NAME = $(shell basename githot)

OS = $(shell uname -s | tr A-Z a-z)
ARCH = $(shell uname -m | tr A-Z a-z)

ZIP_DATE = $(shell date +"%Y%m%d.%H%M%S")

SERVICE_VERSION = $(shell cat VERSION)
ZIP_NAME = $(SERVICE_NAME)-$(SERVICE_VERSION)

all: release

build:
	cp VERSION ./runtime

zip: build
	cd ./runtime && tar -zcvf ../dist/$(ZIP_NAME).$(ZIP_DATE).tgz --exclude .gitignore --exclude .DS_Store .

release: build
	cd ./runtime && tar -zcvf ../dist/$(ZIP_NAME).$(OS).$(ARCH).tgz --exclude .gitignore --exclude .DS_Store .
