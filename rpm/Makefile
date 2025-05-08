RPMS := $(wildcard */.)

.PHONY: name-versions update-all $(RPMS)

name-versions: $(RPMS)
	for rpm in $(RPMS); do $(MAKE) -C $$rpm name-version; done

update-all: $(RPMS)
	for rpm in $(RPMS); do $(MAKE) -C $$rpm update; done

