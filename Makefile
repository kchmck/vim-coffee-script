REF = HEAD
HASH = $(shell git rev-list -n 1 --abbrev-commit $(REF))

ARCHIVE = vim-coffee-script-$(HASH).zip
ARCHIVE_DIRS = after ftdetect ftplugin indent syntax

# Don't do anything by default.
all:

# Make vim.org zipball.
archive:
	git archive $(REF) -o $(ARCHIVE) -- $(ARCHIVE_DIRS)

# Remove zipball.
clean:
	-rm -f $(ARCHIVE)

# Print the abbreviated hash of REF for easy copypasta into vim.org.
hash:
	@echo $(HASH)

# Build the list of syntaxes for @coffeeAll.
coffeeAll:
	@grep -E 'syn (match|region)' syntax/coffee.vim |\
	 grep -v 'contained' |\
	 awk '{print $$3}' |\
	 uniq

.PHONY: all archive clean hash coffeeAll
