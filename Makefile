run:
	rm -rf ./docs
	env HUGO_ENV=production hugo -d ./docs
	echo "www.den3tsou.com" > ./docs/CNAME
