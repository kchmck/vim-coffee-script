REF = HEAD
HASH = $(shell git show-ref --hash --abbrev $(REF))

ARCHIVE = vim-coffee-script-$(HASH).zip
ARCHIVE_DIRS = after ftdetect ftplugin indent syntax

# Nothing to do by default
all:

$(ARCHIVE):
	git archive $(REF) $(ARCHIVE_DIRS) -o $@

archive: $(ARCHIVE)

clean:
	-rm -f $(ARCHIVE)

# For easy copypasta into vim.org
hash:
	@echo $(HASH)

coffeeAll:
	@grep -E 'syn (match|region)' syntax/coffee.vim |\
	 grep -v 'contained' |\
	 awk '{print $$3}' |\
	 uniq |\
	 grep -vE 'Error|coffeeAssignString|coffeeHeregexComment|coffeeInterp'

.PHONY: archive clean hash coffeeAll
