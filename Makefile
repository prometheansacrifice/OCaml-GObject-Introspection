.PHONY : coverage
coverage :
	BISECT_ENABLE=YES jbuilder runtest
	bisect-ppx-report -html _coverage/ `find . -name 'bisect*.out'`

.PHONY : documentation
documentation :
	jbuilder build @doc
	find _build/default/_doc/_html/gobject-introspection/ -type f |xargs sed -i 's/\.\.\/odoc\.css/odoc\.css/g'
	mv _build/default/_doc/_html/odoc.css _build/default/_doc/_html/gobject-introspection/
	rm -rf docs/*
	cp -rf _build/default/_doc/_html/gobject-introspection/* docs/
	# cp odoc.css docs/
	jbuilder clean
