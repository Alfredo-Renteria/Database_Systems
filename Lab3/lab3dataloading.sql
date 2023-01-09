/*
* Alfredo Renteria
* Filename: lab3dataloading.sql
* Script File to Populate the Lab3 DB
*/

-- Populate the tables
COPY Houses FROM stdin USING DELIMITERS '|';
111|1156 High Street,Santa Cruz,CA, 95060|10|2018-06-23
222|324 Ghost Ave,Vegas,NV,55864|5|2020-04-16
333|920 Pacific Ave,Santa Cruz,CA,95069|6|2016-03-18
444|41st Ave,Capitola,CA,95662|7|2017-11-30
555|416 116th Ave NE, Bellevue, WA 98004|8|2018-09-26
\.

COPY Persons FROM stdin USING DELIMITERS '|';
1|John Wick|111
2|Steve Vai|222
3|Harrison Ford|111
4|Brad Pitt|444
5|Sam Mata|555
6|Maria Santos Tavares Melo Jose|555
7|Huan Halvorson|222 
8|Scarlet Mandela|333
9|Effertz Hara|444
10|Labadie Son|555
11|Preeti King|555
13|Mason Sporer|555
16|Alicia Biden|444
17|Kassulke Feil|333
18|Sonia Roy|111
20|Alex Robinson|222
\.

COPY Brokers FROM stdin USING DELIMITERS '|';
1|A|Lighthouse Realty|2
11|C|Weathervane Group Realty|1
20|B|Catbird Estates|3
18|B|Champions Real Estate Advisors|4
17|D|Weathervane Group Realty|1
2|C|Weathervane Group|1
\.

COPY Offers FROM stdin USING DELIMITERS '|';
111|13|2019-07-27|854559.55|TRUE
111|13|2019-07-25|854559.55|FALSE
222|13|2019-07-26|12450000.55|TRUE
111|2|2019-07-27|855559.80|TRUE
222|16|2020-06-20|12750000.55|TRUE
222|16|2020-06-19|12650000.55|TRUE
333|6|2017-05-28|400000.76|TRUE
444|6|2018-05-28|400000.76|FALSE
\.


COPY ForSaleHouses FROM stdin USING DELIMITERS '|';
111|2019-06-24|1|850000.34|FALSE
111|2018-05-23|1|840000.34|FALSE
222|2020-05-08|17|15750000.99|FALSE
222|2020-03-15|18|15850000.99|FALSE
333|2017-05-20|17|410000|FALSE
333|2016-02-10|18|440000|FALSE
444|2017-09-01|20|200000.33|FALSE
444|2018-11-21|1|250000.33|TRUE
444|2016-08-16|20|250000.33|FALSE
555|2018-05-26|20|4600000.45|FALSE
555|2019-02-25|1|4600000.45|FALSE
222|2020-04-26|18|15850000.45|FALSE
111|2020-10-01|1|850000.12|TRUE
\.

COPY SoldHouses FROM stdin USING DELIMITERS '|';
111|2018-05-23|2020-06-03|5|893000.34
222|2020-05-08|2020-05-16|1|15850000.99
333|2016-02-10|2016-03-13|8|440000
444|2017-09-01|2017-11-30|9|200000.33
444|2016-08-16|2016-09-24|4|250000.33
555|2018-05-26|2018-09-26|7|4700000.45
222|2020-03-15|2020-04-16|1|15750000.99
111|2019-06-24|2020-03-03|5|863000.34
333|2017-05-20|2020-03-13|8|440000
\.

COPY SoldHouseChanges FROM stdin USING DELIMITERS '|';
555|2019-02-25|7|4780000.45
222|2020-04-26|1|15850000.99
333|2017-05-20|8|490000.21
111|2019-06-24|7|813000.34
\.