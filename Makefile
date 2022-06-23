%:
	mkdir -p $(@D)
	curl http://localhost:3000/$* -o $@ -f

