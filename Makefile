%:
	mkdir -p $(@D)
	curl http://danielbraun.xyz/$* -o $@ -f

