run:
	rm -rf ./docs
	env HUGO_ENV=production hugo -d ./docs
