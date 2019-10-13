all:
	git add . && git commit -a -m 'update' && git push origin master
	rm -rf ./../official/docs
	rm -rf ./../official/en/docs
	cp -R zh ./../official/docs
	cp -R en ./../official/en/docs
	cd ./../official && make
	cd ./../docs
	