default: local

ci: create-pdf rename publish

create-pdf:
	pdflatex CV.tex

local: create-pdf set-date rename

.PHONY: publish
publish:
	gh release create "$(DATE)" -t "Oscar Barlow CV $(DATE)" -n "Oscar Barlow's CV for $(DATE). A PDF is available to download from the link below." "$(GITHUB_WORKSPACE)/Oscar Barlow CV $(DATE).pdf"

rename:
	mv "CV.pdf" "Oscar Barlow CV $(DATE).pdf"	

.PHONY: set-date
set-date:
	$(eval DATE := $(shell date --iso-8601=date))