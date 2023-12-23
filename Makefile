com/portfolio-insight/radar.xlsx:
	curl -s https://www.portfolio-insight.com/dividend-radar | pup "a[data-gatrack] attr{href}" | xargs curl -o $@ --create-dirs

com/portfolio-insight/radar.csv: com/portfolio-insight/radar.xlsx
	in2csv $< --sheet All --skip-lines 2 | sed 's/ %//' > $@

%.csv:
	curl "http://localhost:3000/$@" -o $@ -f --create-dirs

%.sqlinsert: %.csv
	psql -c 'truncate "$(subst /,_,$*)"' || true
	cat $< |\
	       	 csvsql --tables $(subst /,_,$*) \
	      	 --insert \
	       	 --db postgresql:// \
	       	 --create-if-not-exists
