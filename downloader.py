from urllib.parse import urlencode

import requests
import os
from lxml import etree


def download_file(file_url):
    download_folder = "C:/Users/stefan.sundseth/edgar/data/"

    base_url = "https://www.sec.gov/Archives/"

    resp = requests.get(f"{base_url}{file_url}", verify=False)

    file_name = file_url.split("/")[-1]

    save_path = download_folder + file_name
    
    os.makedirs(os.path.dirname(save_path), exist_ok=True)
    with open(save_path, "w", encoding="utf-8") as f:
        f.write(resp.text)




with open("13fAll.txt") as f:
    lines = [line.rstrip('\n') for line in f]

for line in lines:
    print(f"Downloading file: {line}")
    download_file(line)
