pipe := BEGIN { m = "^\#pipe$$" }
pipe += $$1 ~ m && $$2 { $$1 = ""; p = $$0; printf "" | p; next }
pipe += !p { if (show) print }
pipe += $$0 ~ m { close(p); p = 0 }
pipe += p { print | p }

mkfile := \#!/bin/bash\ncat | install -m 0644 --backup=t -D /dev/fd/0 "$$1"
mkfile:; echo -e '$($@)' | install /dev/fd/0 $@

ifeq ($(and $(filter $(MAKECMDGOALS),unroll),T),T)
export PATH := .:$(PATH)
.unroll: $(self)-roll.yml mkfile; awk '$(pipe)' $<; touch -r $< $(roll)
unroll: .unroll;
endif

roll.first := \# -*- Mode: YAML; indent-tabs-mode: nil; fill-column: 96; -*-
roll.pipe  := \#pipe
roll.last  := \#pipe touch .unroll

roll.file  = echo "$(roll.pipe) mkfile $1";
roll.file += cat $1;

roll.cmd  = (echo "$(roll.first)";
roll.cmd += $(foreach _,$(roll),$(call roll.file,$_))
roll.cmd += echo "$(roll.last)")
roll.cmd += | install --backup=t /dev/fd/0 $@

ifeq ($(and $(filter $(MAKECMDGOALS),roll),T),T)
$(self)-roll.yml: $(roll); $(roll.cmd)
roll: $(self)-roll.yml;
endif
