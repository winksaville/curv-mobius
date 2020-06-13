# Use a BROWSER if it exists otherwise use google-chrome-stable
export png_viewer=$(if $(BROWSER),$(BROWSER),google-chrome-stable)

_vsize=$(if $(vsize),$(vsize),1)
size=-O vsize=$(_vsize)

_name=$(if $(name),$(name),mobius)
filename=$(_name)

export screenshot_filename=$(filename).png

AT=@

.PHONY: help
help:
	$(AT)echo "make target"
	$(AT)echo " targets:"
	$(AT)echo "   obj      output $(filename).obj"
	$(AT)echo "   slice    prusa-silcer $(filename).obj"
	$(AT)echo "   ss       take a screenshot"
	$(AT)echo "   view     view screenshot"

obj: $(filename).obj

$(filename).obj: $(filename).curv
	eval curv -o $(filename).obj $(size) -O jit $(filename).curv

.PHONY: slice
slice: $(filename).obj
	prusa-slicer $(filename).obj

.PHONY: ss
ss:
	$(AT)echo "select desired window, you have 2 seconds:"
	$(AT)gnome-screenshot -w -d 2 -f "$${screenshot_filename}"
	$(AT)echo "done, screenshot written to $${screenshot_filename}"

.PHONY: view
view:
	$(AT)$${png_viewer} $${screenshot_filename}

.PHONY: clean
clean:
	$(AT)rm -f $(filename).obj

.PHONY: distclean clean
distclean:
	$(AT)rm -f $(filename).png $(filename).3mf ,*
