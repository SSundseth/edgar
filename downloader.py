import requests
import os
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def download_file(file_url):
    download_folder = "data/"

    base_url = "https://www.sec.gov/Archives/"

    resp = requests.get(f"{base_url}{file_url}", verify=False)

    file_name = file_url.split("/")[-1]

    save_path = download_folder + file_name
    
    os.makedirs(os.path.dirname(save_path), exist_ok=True)
    with open(save_path, "w", encoding="utf-8") as f:
        f.write(resp.text)




with open("13fAll.txt") as f:
    size = len(f)
    for cnt, line in enumerate(f):
        print(f"{cnt}/{size} Downloading file: {line}")
        download_file(line.strip())
