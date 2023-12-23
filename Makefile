il/co/psagot/trade1/login.json: il/co/psagot/trade1/credentials.json
	cat $< | curl "https://trade1.psagot.co.il:9005/v2/json/login" --data @/dev/stdin -o $@

il/co/psagot/trade1/session.http: il/co/psagot/trade1/login.json
	cat $< | jq ".Login.SessionKey" -r | xargs printf "session: %s\n" > $@

il/co/psagot/trade1/account.json: il/co/psagot/trade1/session.http
	curl https://trade1.psagot.co.il:9005/v2/json/account/view \
	       	--get \
		--data account=150-52582\
	       	--header @$< \
		-o $@

il/co/psagot/trade1/holdings.json: il/co/psagot/trade1/account.json
	cat $< | jq ".View.Account.AccountPosition.Balance" > $@

il/co/psagot/trade1/currencies.json: il/co/psagot/trade1/account.json
	cat $< | jq ".View.Account.OnlineCashByCurrency" > $@

il/co/psagot/trade1/status.json: il/co/psagot/trade1/account.json
	cat $< | jq ".View.Account | del(.AccountPosition,.OnlineCashByCurrency)" > $@

il/co/psagot/trade1/transactions.json: il/co/psagot/trade1/session.http
	curl https://trade1.psagot.co.il:9005/v2/json/account/transactions \
	       	--get \
		--data fromDate=01012020 \
		-f \
		--data toDate=$(shell date +"%d%m%Y") \
	       	--data account=150-52582 \
		--header @$< \
		| jq ".Transactions.Transaction" \
		> $@

com/portfolio-insight/radar.xlsx:
	curl -s https://www.portfolio-insight.com/dividend-radar | pup "a[data-gatrack] attr{href}" | xargs curl -o $@ --create-dirs

com/portfolio-insight/radar.csv: com/portfolio-insight/radar.xlsx
	in2csv $< --sheet All --skip-lines 2 | sed 's/ %//' > $@

%.csv: %.json
	json2csv < $< > $@

%.csv:
	curl "http://localhost:3000/$@" -o $@ -f --create-dirs

%.sqlinsert: %.csv
	psql -c 'truncate "$(subst /,_,$*)"' || true
	cat $< |\
	       	 csvsql --tables $(subst /,_,$*) \
		 --date-format "%d/%m/%Y" \
	      	 --insert \
	       	 --db postgresql:// \
	       	 --create-if-not-exists

schema.sql:
	pg_dump --schema-only --no-owner | sed -e '/^--/d' > $@

clean:
	rm -rf com il/co/psagot/trade1/login.json
