import requests
import pandas as pd
from bs4 import BeautifulSoup
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def string_to_int(string):
    multipliers = {'K':1000, 'M':1000000, 'B':1000000000}
    if string[-1].isdigit(): # check if no suffix
        return int(string)
    mult = multipliers[string[-1]] # look up suffix to get multiplier
     # convert number to float, multiply by multiplier, then make int
    return int(float(string[:-1]) * mult)

with open("stockList") as tickerList:
    tickers = [line.rstrip('\n').split(',') for line in tickerList]


for line in tickers:
    ticker = line[0]
    cusip = line[1]
    print("Ticker: "+ticker)
    print("Cusip: "+cusip)

    url=f"https://www.sharesoutstandinghistory.com/{ticker.lower()}"
    print(url)
    response = requests.get(url, verify=False)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'lxml')
        table = soup.findAll("td", {"class":"tstyle"})
        if len(table) > 0:
            lastval = table[-1].text
            total = string_to_int(lastval)
            print(total)

            write_line = f"{cusip},{total},{ticker}\n"
            with open("tickerTotals.csv", "a") as write_file:
                    write_file.write(write_line)


