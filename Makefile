il/co/psagot/trade1/login.json: il/co/psagot/trade1/credentials.json
	cat $< | curl "https://trade1.psagot.co.il:9005/v2/json/login"  -k -f --data @/dev/stdin -o $@

il/co/psagot/trade1/session.http: il/co/psagot/trade1/login.json
	cat $< | jq ".Login.SessionKey" -r | xargs printf "session: %s\n" > $@

il/co/psagot/trade1/account.json: il/co/psagot/trade1/session.http
	curl https://trade1.psagot.co.il:9005/v2/json/account/view \
		-k \
		-f \
	       	--get \
		--data account=150-52582\
	       	--header @$< \
		-o $@

il/co/psagot/trade1/holdings.json: il/co/psagot/trade1/account.json
	cat $< \
	       	| jq ".View.Account.AccountPosition.Balance"\
		| sed 's/\(BaseRateChangePercentage": \)"0"/\1"0.0"/'\
		| sed 's/\(ProfitLoss": \)"0"/\1"0.0"/'\
		> $@

com/nasdaq/dividends:
	curl 'https://api.nasdaq.com/api/quote/ABR/dividends?assetclass=stocks' \
		-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:121.0) Gecko/20100101 Firefox/121.0'\
		-H 'Accept: application/json, text/plain, */*'\
	       	-H 'Accept-Language: en-US,en;q=0.5'\
	       	-H 'Accept-Encoding: gzip, deflate, br'

il/co/psagot/trade1/currencies.json: il/co/psagot/trade1/account.json
	cat $< | jq ".View.Account.OnlineCashByCurrency" > $@

il/co/psagot/trade1/status.json: il/co/psagot/trade1/account.json
	cat $< | jq ".View.Account | del(.AccountPosition,.OnlineCashByCurrency)" > $@

il/co/psagot/trade1/transactions.json: il/co/psagot/trade1/session.http
	curl https://trade1.psagot.co.il:9005/v2/json/account/transactions \
	       	--get \
		--data fromDate=01012020 \
		-k \
		-f \
		--data toDate=$(shell date +"%d%m%Y") \
	       	--data account=150-52582 \
		--header @$< \
		| jq ".Transactions.Transaction" \
		> $@

com/portfolio-insight/radar.xlsx:
	curl -f https://www.portfolio-insight.com/dividend-radar | pup "a[data-gatrack] attr{href}" | xargs curl -f -o $@ --create-dirs

com/portfolio-insight/radar.csv: com/portfolio-insight/radar.xlsx
	in2csv $< --sheet All --skip-lines 2 | sed 's/ %//' > $@

%.csv: %.json
	json2csv < $< > $@

%.csv:
	curl "http://localhost:3000/$@" -f -o $@ -f --create-dirs

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
