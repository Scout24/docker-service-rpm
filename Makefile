# override to customize
NAME = schlomo
IMAGE = $(NAME):latest
VERSION = 0
RELEASE = 0
RUNARGS = -p 80:80
REQUIRES = docker-engine

WORK_DIR := $(PWD)/work-$(shell mktemp -u XXXXXXXXXXXXXXXXXX)

.PHONY: info rpm schlomo example clean

info:
	@echo make rpm will build an RPM. Use NAME= VERSION= RELEASE= RUNARGS= REQUIRES= to customize
	@echo make example will build the example schlomo Docker app that you can use to play aroung.

rpm:
	mkdir -p $(WORK_DIR)/BUILD
	docker save $(IMAGE) >$(WORK_DIR)/image
	sed <service.sh >$(WORK_DIR)/service.sh -e "s/REPLACE_IMAGE/$(IMAGE)/g" -e "s/REPLACE_NAME/$(NAME)/g" -e 's/REPLACE_RUNARGS/$(RUNARGS)/g'
	cp service.spec $(WORK_DIR)/$(NAME).spec
	rpmbuild -bb -D "image $(IMAGE)" -D "name $(NAME)" -D "version $(VERSION)" -D "release $(RELEASE)" -D "requires $(REQUIRES)" -D "_topdir $(WORK_DIR)" -D "_sourcedir %_topdir" -D "_rpmdir %_topdir" -D "_target_os linux" $(WORK_DIR)/schlomo.spec
	mv $(WORK_DIR)/noarch/$(NAME)*rpm .
	rm -Rf $(WORK_DIR)
	@echo
	@echo Created RPM: $$(du -h $(NAME)*rpm)

schlomo:
	docker build --tag schlomo:latest schlomo

example: schlomo rpm

clean:
	-docker rm -f schlomo
	-docker rmi -f schlomo
	-rm -f *rpm work-*
