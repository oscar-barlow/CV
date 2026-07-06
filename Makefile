CVS := leadership-cv advisory-cv consultant-cv
PDFS := $(CVS:%=%.pdf)
LEADERSHIP_RELEASE_PDF := Oscar.Barlow.Leadership.CV.$(DATE).pdf
ADVISORY_RELEASE_PDF := Oscar.Barlow.Advisory.CV.$(DATE).pdf
CONSULTANT_RELEASE_PDF := Oscar.Barlow.Consultant.CV.$(DATE).pdf
LEADERSHIP_MAX_PAGES := 2
ADVISORY_MAX_PAGES := 1
CONSULTANT_MAX_PAGES := 1

default: local

ci: spellcheck check-length rename publish

.PHONY: clean
clean:
	rm -f $(CVS:%=%.aux) $(CVS:%=%.log) $(CVS:%=%.out)
	rm -f $(PDFS)
	rm -f Oscar.Barlow.Leadership.CV.*.pdf Oscar.Barlow.Advisory.CV.*.pdf Oscar.Barlow.Consultant.CV.*.pdf

.PHONY: check-length
check-length: create-pdf
	@for cv in $(CVS); do \
		case "$$cv" in \
			leadership-cv) max="$(LEADERSHIP_MAX_PAGES)" ;; \
			advisory-cv) max="$(ADVISORY_MAX_PAGES)" ;; \
			consultant-cv) max="$(CONSULTANT_MAX_PAGES)" ;; \
			*) echo "Unknown CV: $$cv" >&2; exit 1 ;; \
		esac; \
		pages=$$(pdfinfo "$$cv.pdf" | awk '/Pages/ {print $$2}'); \
		echo "$$cv.pdf $$pages (max $$max)"; \
		if [ "$$pages" -gt "$$max" ]; then \
			echo "$$cv.pdf is too long." >&2; \
			exit 1; \
		fi; \
	done

.PHONY: create-pdf
create-pdf: $(PDFS)

%.pdf: %.tex cv.sty
	pdflatex $<

.PHONY: deps
deps:
	sudo apt-get update && sudo apt-get install -y pandoc texlive-latex-recommended texlive-latex-extra texlive-extra-utils texlive-fonts-extra aspell poppler-utils

local: create-pdf check-length set-date rename

.PHONY: publish
publish:
	gh release create "$(DATE)" -t "Oscar Barlow CVs $(DATE)" -n "Oscar Barlow's CVs for $(DATE). PDFs are available to download from the links below." "$(GITHUB_WORKSPACE)/$(LEADERSHIP_RELEASE_PDF)" "$(GITHUB_WORKSPACE)/$(ADVISORY_RELEASE_PDF)" "$(GITHUB_WORKSPACE)/$(CONSULTANT_RELEASE_PDF)"

.PHONY: rename
rename:
	@for cv in $(CVS); do \
		case "$$cv" in \
			leadership-cv) output="$(LEADERSHIP_RELEASE_PDF)" ;; \
			advisory-cv) output="$(ADVISORY_RELEASE_PDF)" ;; \
			consultant-cv) output="$(CONSULTANT_RELEASE_PDF)" ;; \
			*) echo "Unknown CV: $$cv" >&2; exit 1 ;; \
		esac; \
		mv "$$cv.pdf" "$$output"; \
	done

.PHONY: set-date
set-date:
	$(eval DATE := $(shell date --iso-8601=date))

.PHONY: spellcheck
spellcheck:
	@for cv in $(CVS); do \
		errors=$$(aspell list --mode=tex --lang=en_GB-ise --personal=./.aspell.en.pws < "$$cv.tex"); \
		if [ -n "$$errors" ]; then \
			echo "$$cv.tex spelling errors:"; \
			echo "$$errors"; \
			exit 1; \
		fi; \
	done
