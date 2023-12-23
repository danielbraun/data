

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;



COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';



CREATE FUNCTION public.com_stockcharts_chart_url(text) RETURNS text
    LANGUAGE sql STRICT
    AS $_$
 select format('https://stockcharts.com/h-sc/ui?s=%s&p=D&yr=3&mn=0&dy=0&id=p86063460767', $1)
 $_$;


SET default_tablespace = '';

SET default_table_access_method = heap;


CREATE TABLE public.annual_tax_report (
    id integer NOT NULL,
    il_co_psagot_867 bytea,
    il_co_mizrahi_tz_long bytea,
    il_gov_btl_ishur_tashlumim_shnati bytea,
    year integer,
    il_gov_edu_106 bytea,
    il_gov_btl_takbulei_miluim bytea,
    il_gov_taxes_shuma bytea,
    il_gov_taxes_1301 bytea
);



ALTER TABLE public.annual_tax_report ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.annual_tax_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE public.music_bands (
    id integer NOT NULL,
    name text
);



CREATE SEQUENCE public.bands_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.bands_id_seq OWNED BY public.music_bands.id;



CREATE TABLE public."com_portfolio-insight_radar" (
    "Symbol" character varying NOT NULL,
    "Company" character varying NOT NULL,
    "FV" boolean,
    "Sector" character varying NOT NULL,
    "No Years" numeric NOT NULL,
    "Price" numeric NOT NULL,
    "Div Yield" numeric NOT NULL,
    "5Y Avg Yield" numeric NOT NULL,
    "Current Div" numeric NOT NULL,
    "Payouts/ Year" numeric NOT NULL,
    "Annualized" numeric NOT NULL,
    "Previous Div" numeric,
    "Ex-Date" date,
    "Pay-Date" date,
    "Low" numeric NOT NULL,
    "High" numeric NOT NULL,
    "DGR 1Y" numeric NOT NULL,
    "DGR 3Y" numeric,
    "DGR 5Y" numeric,
    "DGR 10Y" numeric,
    "TTR 1Y" numeric NOT NULL,
    "TTR 3Y" numeric NOT NULL,
    "Fair Value" character varying NOT NULL,
    "FV_2" numeric NOT NULL,
    y character varying NOT NULL,
    "Streak Basis" character varying NOT NULL,
    "Chowder Number" numeric,
    "EPS 1Y" numeric NOT NULL,
    "Revenue 1Y" numeric NOT NULL,
    "NPM" numeric NOT NULL,
    "CF/Share" numeric NOT NULL,
    "ROE" numeric,
    "Current R" numeric NOT NULL,
    "Debt/Capital" numeric NOT NULL,
    "ROTC" numeric,
    "P/E" numeric NOT NULL,
    "P/BV" numeric NOT NULL,
    "PEG" numeric NOT NULL,
    "New Member" boolean,
    "Industry" character varying NOT NULL
);



CREATE TABLE public.com_tradingview_symbols (
    "Perf.Y" numeric,
    "RSI" numeric,
    base_currency_logoid character varying,
    change numeric,
    close numeric,
    currency_logoid character varying,
    dividend_ex_date_upcoming date,
    dividend_yield_recent numeric,
    dps_common_stock_prim_issue_yoy_growth_fy numeric,
    logoid character varying,
    market_cap_calc numeric,
    name character varying NOT NULL,
    price_52_week_high numeric,
    price_52_week_low numeric,
    sector character varying,
    subtype character varying,
    total_shares_diluted numeric,
    total_shares_outstanding numeric,
    type character varying,
    price_earnings_ttm numeric,
    continuous_dividend_growth numeric,
    continuous_dividend_payout numeric,
    dividend_payout_ratio_ttm numeric,
    exchange text
);



CREATE VIEW public.com_tradingview_symbols_extra AS
 SELECT com_tradingview_symbols.name,
    (((com_tradingview_symbols.close - com_tradingview_symbols.price_52_week_low) / (com_tradingview_symbols.price_52_week_high - com_tradingview_symbols.price_52_week_low)) * (100)::numeric) AS "1y_range"
   FROM public.com_tradingview_symbols;



CREATE TABLE public.daily (
    id integer NOT NULL,
    date date DEFAULT now(),
    tfilin boolean DEFAULT true,
    book_isbn text,
    book_chapter text
);



CREATE TABLE public.il_co_migdal (
    id integer NOT NULL,
    "UserPolicies_api_pensionAggregateddata" jsonb
);



CREATE TABLE public."il_co_mizrahi-tefahot" (
    id integer NOT NULL,
    "/Online/api/SkyOSH/get428Index" jsonb
);



CREATE TABLE public."il_co_yl-invest" (
    id integer NOT NULL,
    "api_Balance" jsonb
);



CREATE VIEW public.finance_balance_sheet AS
 SELECT 'migadal pension'::text AS name,
    (((il_co_migdal."UserPolicies_api_pensionAggregateddata" -> 'Data'::text) -> 'AggregatedPensionData'::text) ->> 'RedemptionValues'::text) AS ils
   FROM public.il_co_migdal
UNION
 SELECT 'קרן השתלמות ילין לפידות'::text AS name,
    ("il_co_yl-invest"."api_Balance" ->> 'total'::text) AS ils
   FROM public."il_co_yl-invest"
UNION
 SELECT 'עוש בנק המזרחי'::text AS name,
    ((("il_co_mizrahi-tefahot"."/Online/api/SkyOSH/get428Index" -> 'body'::text) -> 'fields'::text) ->> 'Yitra'::text) AS ils
   FROM public."il_co_mizrahi-tefahot";



CREATE TABLE public.finance_shortlist (
    id integer NOT NULL,
    name text
);



ALTER TABLE public.finance_shortlist ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.finance_shortlist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE VIEW public.finance_stocks_full AS
 SELECT com_tradingview_symbols.name,
    com_tradingview_symbols."Perf.Y",
    com_tradingview_symbols."RSI",
    com_tradingview_symbols.base_currency_logoid,
    com_tradingview_symbols.change,
    com_tradingview_symbols.close,
    com_tradingview_symbols.currency_logoid,
    com_tradingview_symbols.dividend_ex_date_upcoming,
    com_tradingview_symbols.dividend_yield_recent,
    com_tradingview_symbols.dps_common_stock_prim_issue_yoy_growth_fy,
    com_tradingview_symbols.logoid,
    com_tradingview_symbols.market_cap_calc,
    com_tradingview_symbols.price_52_week_high,
    com_tradingview_symbols.price_52_week_low,
    com_tradingview_symbols.sector,
    com_tradingview_symbols.subtype,
    com_tradingview_symbols.total_shares_diluted,
    com_tradingview_symbols.total_shares_outstanding,
    com_tradingview_symbols.type,
    com_tradingview_symbols.price_earnings_ttm,
    com_tradingview_symbols.continuous_dividend_growth,
    com_tradingview_symbols.continuous_dividend_payout,
    com_tradingview_symbols.dividend_payout_ratio_ttm,
    com_tradingview_symbols.exchange,
    com_tradingview_symbols_extra."1y_range",
    r."Chowder Number",
    r."DGR 10Y",
    r."Symbol",
    r."5Y Avg Yield",
    r."Industry",
    r."EPS 1Y",
    r."PEG",
    r."Sector",
    r."DGR 1Y",
    r."TTR 1Y",
    r."Fair Value",
    r."Current R",
    r."Streak Basis",
    r."P/BV",
    r."Price",
    r."Pay-Date",
    r."No Years",
    r."Previous Div",
    r."Annualized",
    r."High",
    r."Company",
    r."ROTC",
    r."Debt/Capital",
    r."Ex-Date",
    r."Payouts/ Year",
    r."Revenue 1Y",
    r."CF/Share",
    r."TTR 3Y",
    r."Current Div",
    r."Low",
    NULL::numeric AS "FV %",
    r."DGR 5Y",
    r."Div Yield",
    r."ROE",
    r."NPM",
    r."P/E",
    r."DGR 3Y",
    public.com_stockcharts_chart_url((com_tradingview_symbols.name)::text) AS chart
   FROM ((public.com_tradingview_symbols
     JOIN public.com_tradingview_symbols_extra USING (name))
     LEFT JOIN public."com_portfolio-insight_radar" r ON ((((com_tradingview_symbols.name)::text = (r."Symbol")::text) AND (com_tradingview_symbols.exchange <> 'TASE'::text))));



CREATE VIEW public.finance_stocks_dividend AS
 SELECT finance_stocks_full.name AS a,
    finance_stocks_full."1y_range" AS perf_1y_range,
    finance_stocks_full.change AS perf_change,
    finance_stocks_full."RSI" AS perf_rsi,
    finance_stocks_full.dividend_ex_date_upcoming AS zdividend_exdate,
    finance_stocks_full.dividend_yield_recent AS zdividend_yield,
    finance_stocks_full.dps_common_stock_prim_issue_yoy_growth_fy AS zdividend_growth,
    finance_stocks_full."No Years",
    NULL::text AS exchange,
    NULL::numeric AS dividend_payout_ratio_ttm,
    finance_stocks_full.continuous_dividend_growth AS zdividend_streak_growth,
    finance_stocks_full.continuous_dividend_payout AS zdividend_streak_pay,
    NULL::numeric AS market_cap_calc,
    finance_stocks_full.chart
   FROM public.finance_stocks_full
  WHERE (((finance_stocks_full.dividend_yield_recent > (0)::numeric) AND (finance_stocks_full.continuous_dividend_growth > (3)::numeric)) OR (finance_stocks_full."No Years" > (0)::numeric))
  ORDER BY finance_stocks_full.dividend_yield_recent DESC;



CREATE TABLE public.gym (
    date date DEFAULT now() NOT NULL,
    squat numeric,
    deadlift numeric,
    press_bench numeric,
    press_overhead numeric,
    body_weight numeric
);



CREATE TABLE public.il_co_isracard_transactions (
    adendum boolean,
    "bcKey" boolean,
    "cardIndex" boolean,
    city character varying,
    "currencyId" character varying,
    "currentPaymentCurrency" character varying,
    "dealSum" numeric,
    "dealSumOutbound" numeric,
    "dealSumType" boolean,
    "dealsInbound" boolean,
    "displayProperties" boolean,
    "fullPaymentDate" character varying,
    "fullPurchaseDate" character varying,
    "fullPurchaseDateOutbound" character varying,
    "fullSupplierNameHeb" character varying,
    "fullSupplierNameOutbound" character varying,
    "horaatKeva" character varying,
    "isButton" boolean,
    "isCaptcha" boolean,
    "isError" boolean,
    "isHoraatKeva" boolean,
    "isShowDealsOutbound" character varying,
    "isShowLinkForSupplierDetails" boolean,
    message boolean,
    "moreInfo" character varying,
    "paymentDate" character varying,
    "paymentSum" numeric,
    "paymentSumOutbound" numeric,
    "paymentSumSign" boolean,
    "purchaseDate" character varying,
    "purchaseDateOutbound" character varying,
    "returnCode" boolean,
    "returnMessage" boolean,
    "siteName" boolean,
    solek character varying,
    "specificDate" boolean,
    stage boolean,
    "supplierId" numeric,
    "supplierName" character varying,
    "supplierNameOutbound" character varying,
    "tablePageNum" boolean,
    "voucherNumber" numeric,
    "voucherNumberRatz" numeric,
    "voucherNumberRatzOutbound" numeric
);



ALTER TABLE public.il_co_migdal ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.il_co_migdal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



ALTER TABLE public."il_co_mizrahi-tefahot" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."il_co_mizrahi-tefahot_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE public.il_co_psagot_trade1_currencies (
    "Code" character varying NOT NULL,
    "Value" numeric NOT NULL
);



CREATE TABLE public.il_co_psagot_trade1_holdings (
    "EquityNumber" numeric NOT NULL,
    "BaseRate" numeric NOT NULL,
    "LastRate" numeric NOT NULL,
    "BaseRateChangePercentage" boolean NOT NULL,
    "MorningNV" numeric NOT NULL,
    "MorningVL" numeric NOT NULL,
    "OnlineNV" numeric NOT NULL,
    "OnlineVL" numeric NOT NULL,
    "OnlineNisVL" numeric NOT NULL,
    "AvailableNV" numeric NOT NULL,
    "ProfitLoss" numeric NOT NULL,
    "AveragePrice" numeric NOT NULL,
    "MorningAveragePrice" numeric NOT NULL,
    "IsAdjustedAvgPrice" boolean NOT NULL,
    "LienNv" boolean NOT NULL,
    "LoanNv" boolean NOT NULL,
    "SubAccount" boolean NOT NULL,
    "SubAccountName" character varying NOT NULL,
    "AveragePriceProfitLoss" numeric NOT NULL,
    "AveragePriceProfitLossNis" numeric NOT NULL,
    "AveragePriceProfitLossPercentage" numeric NOT NULL,
    "OnlinePercentage" numeric NOT NULL,
    "CurrencyCode" character varying NOT NULL,
    "DelayInMin" boolean NOT NULL,
    "Product" boolean,
    "Group" boolean,
    "ExpiryDate" timestamp without time zone,
    "ValueDate" timestamp without time zone,
    "Key" boolean,
    "Source" character varying NOT NULL
);



CREATE TABLE public.il_co_psagot_trade1_tickers (
    "EquityNumber" numeric NOT NULL,
    ticker text
);



CREATE VIEW public.il_co_psagot_holdings_short AS
 SELECT il_co_psagot_trade1_tickers.ticker,
    il_co_psagot_trade1_holdings."AvailableNV" AS amount,
    il_co_psagot_trade1_holdings."AveragePrice" AS cost
   FROM (public.il_co_psagot_trade1_holdings
     JOIN public.il_co_psagot_trade1_tickers USING ("EquityNumber"))
UNION
 SELECT concat(il_co_psagot_trade1_currencies."Code", 'ILS') AS ticker,
    il_co_psagot_trade1_currencies."Value" AS amount,
    NULL::numeric AS cost
   FROM public.il_co_psagot_trade1_currencies;



CREATE VIEW public.il_co_psagot_portfolio AS
 SELECT h.ticker,
    s."RSI",
    (h.cost * h.amount) AS cost,
    (s.close * h.amount) AS value,
    round((((s.close / h.cost) * (100)::numeric) - (100)::numeric), 2) AS capital_gains,
    (s."Annualized" * h.amount) AS cash_flow,
    ((s.close - h.cost) * h.amount) AS profit,
    s.dividend_yield_recent,
    s2.close AS usdils
   FROM ((public.il_co_psagot_holdings_short h
     LEFT JOIN public.finance_stocks_full s ON ((h.ticker = (s.name)::text)))
     LEFT JOIN public.finance_stocks_full s2 ON (((s2.name)::text = 'USDILS'::text)));



CREATE TABLE public.il_co_psagot_trade1_status (
    "OnlineBuyingPower" numeric NOT NULL,
    "CreditIsUse" boolean NOT NULL,
    "DerivativesCredit" boolean NOT NULL,
    "EquitiesCredit" boolean NOT NULL,
    "CashCredit" boolean NOT NULL,
    "ExistingCollateral" numeric NOT NULL,
    "IncomeToReceive" numeric NOT NULL,
    "MorningCash" numeric NOT NULL,
    "MorningValue" numeric NOT NULL,
    "OnlineCash" numeric NOT NULL,
    "OnlineValue" numeric NOT NULL,
    "RequestedCollateral" boolean NOT NULL,
    "RequestedEquitiesCollateral" boolean NOT NULL,
    "RequestedDerivativesCollateral" boolean NOT NULL,
    "ExternalForeignMargin" boolean NOT NULL,
    "PortfolioMorningValue" boolean NOT NULL,
    "PortfolioOnlineValue" boolean NOT NULL,
    "AddCashLongDerivatives" boolean NOT NULL,
    "AddCashShortDerivatives" boolean NOT NULL,
    "AggregatedCreditLine" boolean NOT NULL,
    "MaxCashOverdraught" boolean NOT NULL,
    "OverdraughtAsPercentOfHoldingsValue" boolean NOT NULL,
    "ExtraLONGAddition" boolean NOT NULL,
    "ExtraShortAddition" boolean NOT NULL,
    "CurrencyCode" character varying NOT NULL,
    "AveragePriceNisProfitLoss" numeric NOT NULL,
    "AveragePriceNisProfitLossPercentage" numeric NOT NULL,
    "IsAveragePriceNisProfitLossAdjusted" boolean NOT NULL
);



CREATE TABLE public.il_co_psagot_trade1_transactions (
    "ActionDate" date NOT NULL,
    "EquityNumber" numeric NOT NULL,
    "ValidityDate" date NOT NULL,
    "NV" numeric NOT NULL,
    "Price" numeric NOT NULL,
    "ForeignCurrencyRate" numeric NOT NULL,
    "ForeignTaxVL" numeric NOT NULL,
    "TaxVL" boolean NOT NULL,
    "TaxPrecentage" numeric NOT NULL,
    "VL" numeric NOT NULL,
    "NisVL" numeric NOT NULL,
    "Name" character varying NOT NULL,
    "CurrencyCode" character varying NOT NULL,
    "Action" character varying NOT NULL,
    "Commission" numeric NOT NULL
);



ALTER TABLE public."il_co_yl-invest" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."il_co_yl-invest_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE public.il_gov_justice_nesach_tabu (
    id integer NOT NULL,
    block integer,
    plot integer,
    nesach bytea,
    date date
);



ALTER TABLE public.il_gov_justice_nesach_tabu ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.il_gov_justice_nesach_tabu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE public.il_gov_taxes_1301 (
    id integer NOT NULL,
    year integer,
    "ג_250" numeric,
    "ג_150" numeric,
    "ז_238" numeric,
    "ג_001" numeric,
    "ה_141" numeric,
    "ח_054" numeric,
    "ח_256" numeric,
    "ט_290" numeric,
    "יב_030" numeric,
    "טו_294" numeric,
    "טו_040_ztotal" numeric,
    "1324_462" numeric,
    "1324_431" numeric,
    "1322_13" numeric,
    "1322_33" numeric,
    "ה_078" numeric,
    "יא_166" numeric,
    "טו_043" numeric,
    "ז_186" numeric,
    "י_195" numeric,
    "ג_158" numeric,
    "יב_244" numeric,
    "יב_248" numeric,
    "יד_045" numeric,
    "טו_042" numeric,
    "טו_040_psagot_capgains" numeric,
    "טו_040_psagot_div" numeric,
    "טו_040_btl_miluim" numeric,
    "טו_040_psagot_reit" numeric,
    "טו_040_ts" numeric,
    "1322_56" numeric,
    by text
);



ALTER TABLE public.il_gov_taxes_1301 ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.il_gov_taxes_1301_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE public.il_org_oref_alarms (
    data character varying NOT NULL,
    date date NOT NULL,
    "time" interval NOT NULL,
    "alertDate" timestamp without time zone,
    category numeric NOT NULL,
    category_desc character varying NOT NULL,
    matrix_id numeric NOT NULL,
    rid numeric NOT NULL
);



CREATE TABLE public.music_band_songs (
    id integer NOT NULL,
    band integer,
    song integer
);



CREATE SEQUENCE public.music_band_songs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.music_band_songs_id_seq OWNED BY public.music_band_songs.id;



CREATE TABLE public.music_songs (
    id integer NOT NULL,
    title text,
    key_original text,
    key_deborah text,
    spotify_id text,
    deborah_youtube_id text,
    notes text,
    artist text
);



CREATE TABLE public.music_songs_charts (
    id integer NOT NULL,
    file bytea,
    song integer
);



ALTER TABLE public.music_songs_charts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.music_songs_charts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE public.music_songs_new (
    id integer NOT NULL,
    name text,
    parts_guitar text,
    parts_keyboard text,
    parts_percussion text,
    parts_vocals text,
    lyrics text,
    notes text,
    youtube text,
    key text,
    bpm numeric,
    youtube_live text
);



CREATE TABLE public.people (
    id integer NOT NULL,
    name text,
    twitter text,
    youtube text,
    instagram text,
    rss text
);



ALTER TABLE public.people ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE VIEW public.pg_queries AS
 SELECT pg_stat_activity.pid,
    age(clock_timestamp(), pg_stat_activity.query_start) AS age,
    pg_stat_activity.usename,
    pg_stat_activity.query
   FROM pg_stat_activity
  WHERE ((pg_stat_activity.query <> '<IDLE>'::text) AND (pg_stat_activity.query !~~* '%pg_stat_activity%'::text))
  ORDER BY pg_stat_activity.query_start DESC;



CREATE TABLE public.shopping (
    id integer NOT NULL,
    supplier text,
    pantry_oil_olive text,
    pantry_coffee_black text,
    pantry_cereals text,
    pantry_breadcrumbs text,
    pantry_cookies text,
    pantry_wine text,
    pantry_beers text,
    pantry_pitzhuchim text,
    fridge_vegetable_onion text,
    fridge_vegetable_tomato text,
    fridge_vegetable_cucumber text,
    bathroom_soap text,
    bathroom_tiadent text,
    bathroom_toothpaste text,
    bathroom_toothbrush text,
    bathroom_alcogel text,
    freezer_meat text,
    fridge_milk text,
    fridge_cheese text,
    fridge_fruit_watermelon text,
    bathroom_toilet_paper text,
    pantry_protein_powder text,
    closet_underwear text,
    closet_jeans text,
    office_chair text,
    bathroom_laundry_detergent text
);



ALTER TABLE public.shopping ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.shopping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE public.song_parts (
    id integer NOT NULL,
    song integer,
    name text,
    bars numeric NOT NULL,
    "position" integer,
    lyrics text,
    chords text
);



ALTER TABLE public.song_parts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.song_parts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE VIEW public.song_parts_timeline AS
 SELECT format('%s (%s)'::text, song.title, COALESCE(song.key_deborah, song.key_original)) AS "row",
    COALESCE(part.name, ''::text) AS bar,
    COALESCE(part.bars, (1)::numeric) AS length,
    part.lyrics AS tooltip
   FROM (public.song_parts part
     RIGHT JOIN public.music_songs song ON ((part.song = song.id)))
  ORDER BY part.song, part."position", part.id;



ALTER TABLE public.music_songs_new ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.songs2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



ALTER TABLE public.music_songs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.songs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE SEQUENCE public.untitled_table_18_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.untitled_table_18_id_seq OWNED BY public.daily.id;



CREATE TABLE public.vehicles (
    id integer NOT NULL,
    tire_front_psi integer,
    tire_rear_psi integer,
    license_plate text,
    insurance_pdf bytea,
    license_pdf bytea,
    insurance_expiration text,
    license_expiration text,
    manual text,
    seat text
);



CREATE SEQUENCE public.vehicles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.vehicles_id_seq OWNED BY public.vehicles.id;



ALTER TABLE ONLY public.daily ALTER COLUMN id SET DEFAULT nextval('public.untitled_table_18_id_seq'::regclass);



ALTER TABLE ONLY public.music_band_songs ALTER COLUMN id SET DEFAULT nextval('public.music_band_songs_id_seq'::regclass);



ALTER TABLE ONLY public.music_bands ALTER COLUMN id SET DEFAULT nextval('public.bands_id_seq'::regclass);



ALTER TABLE ONLY public.vehicles ALTER COLUMN id SET DEFAULT nextval('public.vehicles_id_seq'::regclass);



ALTER TABLE ONLY public.annual_tax_report
    ADD CONSTRAINT annual_tax_report_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public."com_portfolio-insight_radar"
    ADD CONSTRAINT "com_portfolio-insight_radar_pkey" PRIMARY KEY ("Symbol");



ALTER TABLE ONLY public.daily
    ADD CONSTRAINT daily_date_key UNIQUE (date);



ALTER TABLE ONLY public.com_tradingview_symbols
    ADD CONSTRAINT exchange_name_unique UNIQUE (exchange, name);



ALTER TABLE ONLY public.finance_shortlist
    ADD CONSTRAINT finance_shortlist_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.gym
    ADD CONSTRAINT gym_pkey PRIMARY KEY (date);



ALTER TABLE ONLY public.il_co_migdal
    ADD CONSTRAINT il_co_migdal_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public."il_co_mizrahi-tefahot"
    ADD CONSTRAINT "il_co_mizrahi-tefahot_pkey" PRIMARY KEY (id);



ALTER TABLE ONLY public.il_co_psagot_trade1_tickers
    ADD CONSTRAINT il_co_psagot_trade1_tickers_pkey PRIMARY KEY ("EquityNumber");



ALTER TABLE ONLY public."il_co_yl-invest"
    ADD CONSTRAINT "il_co_yl-invest_pkey" PRIMARY KEY (id);



ALTER TABLE ONLY public.il_gov_justice_nesach_tabu
    ADD CONSTRAINT il_gov_justice_nesach_tabu_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.il_gov_taxes_1301
    ADD CONSTRAINT il_gov_taxes_1301_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.il_org_oref_alarms
    ADD CONSTRAINT il_org_oref_alarms_pkey PRIMARY KEY (rid);



ALTER TABLE ONLY public.music_band_songs
    ADD CONSTRAINT music_band_songs_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.music_bands
    ADD CONSTRAINT music_bands_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.music_songs_charts
    ADD CONSTRAINT music_songs_charts_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.shopping
    ADD CONSTRAINT shopping_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.song_parts
    ADD CONSTRAINT song_parts_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.music_songs_new
    ADD CONSTRAINT songs2_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.music_songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.daily
    ADD CONSTRAINT untitled_table_18_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.music_band_songs
    ADD CONSTRAINT music_band_songs_band_fkey FOREIGN KEY (band) REFERENCES public.music_bands(id);



ALTER TABLE ONLY public.music_band_songs
    ADD CONSTRAINT music_band_songs_song_fkey FOREIGN KEY (song) REFERENCES public.music_songs_new(id);



ALTER TABLE ONLY public.music_songs_charts
    ADD CONSTRAINT music_songs_charts_song_fkey FOREIGN KEY (song) REFERENCES public.music_songs_new(id);



ALTER TABLE ONLY public.song_parts
    ADD CONSTRAINT song_parts_song_fkey FOREIGN KEY (song) REFERENCES public.music_songs(id);



