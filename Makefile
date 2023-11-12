.PHONY: out
out: hash move

hash:
	$(eval HASHED_NAME := $(shell shasum ReadMe.md | awk '{print $$1}'))
	pandoc ReadMe.md -o "$(HASHED_NAME).pdf"

.PHONY: move
move:
	$(eval DATE := $(shell date --iso-8601=date))
	mv "$(HASHED_NAME).pdf" "Oscar Barlow CV $(DATE).pdf"	
