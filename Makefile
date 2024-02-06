default: local

ci: create-pdf rename publish

.PHONY: clean
clean:
	rm CV.aux CV.log CV.out indent.log && rm *.pdf

create-pdf:
	pdflatex CV.tex

.PHONY: deps
deps:
	sudo apt-get update && sudo apt-get install -y pandoc texlive-latex-recommended texlive-latex-extra texlive-extra-utils

local: create-pdf set-date rename

.PHONY: publish
publish:
	gh release create "$(DATE)" -t "Oscar Barlow CV $(DATE)" -n "Oscar Barlow's CV for $(DATE). A PDF is available to download from the link below." "$(GITHUB_WORKSPACE)/Oscar Barlow CV $(DATE).pdf"

rename:
	mv "CV.pdf" "Oscar Barlow CV $(DATE).pdf"	

.PHONY: set-date
set-date:
	$(eval DATE := $(shell date --iso-8601=date))