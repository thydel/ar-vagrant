top:; @date

SHELL := bash

Makefile:;

################

-include self.mk
self ?= $(notdir $(shell pwd))

roll :=
# find . \( -name '*.yml' -o -name '*.j2' -o -name '*.md' \) | grep -v LICENSE | sort | sed -e 's/^/roll += /'

roll += ./defaults/main.yml
roll += ./setup/defaults/main.yml
roll += ./setup/tasks/main.yml
roll += ./setup/templates/meta/main.yml.j2
roll += ./setup/templates/README.md.j2
roll += ./tasks/main.yml

roll += $(self)-setup.yml
roll += $(self)-play.yml

ifeq ($(and $(filter $(MAKECMDGOALS),roll unroll),T),T)
include roll.mk
endif

################

skl.d := ../ar-skl

skl.gpp := README.gpp.md
skl.gpp += meta/main.gpp.yml

skl := LICENSE.md
skl += roll.mk
skl += $(skl.gpp)

$(self)-play.yml: $(self)-% : $(skl.d)/skl-%; install $< $@

$(skl): % : $(skl.d)/%; install $< $@
skl: $(skl) $(self)-play.yml

################

notilde:; find -type f -name '*~' | xargs -r rm

################

ifeq ($(and $(filter $(MAKECMDGOALS),copy),T),T)
. := $(or $(to),$(error must define "to" with target "copy"))
endif

DRY :=
DRY := -n

copy.exclude :=

copy.exclude += .git/
copy.exclude += .gitignore
copy.exclude += .hg/
copy.exclude += .hgignore
copy.exclude += .hide/
copy.exclude += .unroll
copy.exclude += mkfile
copy.exclude += $(self)-roll.yml

copy  =
copy += rsync -avC $(DRY) $(copy.exclude:%=--exclude %) . $(to)

copy:; $($@)

################

f2rm :=
f2rm += handlers/main.yml
f2rm += vars/main.yml

d2rm :=
d2rm += files
d2rm += handlers
d2rm += templates
d2rm += vars

clean:; rm $(f2rm); rmdir $(d2rm)

################

run    := DRY :=
vartar := run

$(vartar):; @: $(eval $($@))
