.PHONY: pdf
pdf:
	pandoc ReadMe.md -o "Oscar Barlow CV `date --iso-8601=date`.pdf"

	
