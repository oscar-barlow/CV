.PHONY: default
default: local

.PHONY: ci
ci: create-pdf rename publish

create-pdf:
	pandoc ReadMe.md -o "$(HASHED_NAME).pdf"

.PHONY: local
local: set-hashed-name create-pdf set-date rename

.PHONY: rename
rename:
	mv "$(HASHED_NAME).pdf" "Oscar Barlow CV $(DATE).pdf"	

.PHONY: set-date
set-date:
	$(eval DATE := $(shell date --iso-8601=date))

.PHONY: set-hashed-name
set-hashed-name:
	$(eval HASHED_NAME := $(shell shasum ReadMe.md | awk '{print $$1}'))
