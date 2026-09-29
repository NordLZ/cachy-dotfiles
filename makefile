.PHONY: all delete

all:
	stow -v -R --no-folding --target=$$HOME */

delete:
	stow -v -D --no-folding --target=$$HOME */
