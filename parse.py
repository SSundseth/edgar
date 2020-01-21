import xml.etree.ElementTree as ET
from os import listdir
from os.path import isfile, join

def parse_file(file):
    cik = file.split("/")[-1].split("-")[0]

    isAddition = False

    # Find the informationTable section of the file
    with open(file) as f:
        line = f.readline()

        if "amendmentType" in line.lower() and "RESTATEMENT" not in line.lower():
            isAddition = True

        informationTableXml = ""

        while line:
            if "informationTable" in line:
                informationTableXml += line

                keepGoing = True
                while line and keepGoing:
                    line = f.readline()
                    if "informationTable" in line:
                        informationTableXml += line
                        keepGoing = False
                    else:
                        informationTableXml += line

            line = f.readline()

    if "informationTable" not in informationTableXml.strip().split('\n')[-1]:
        informationTableXml = informationTableXml.split('\n')[0]

    # Now we have the information xml in a string
    root = ET.fromstring(informationTableXml)

    name_of_issuer = ""
    title_of_class = ""
    cusip = ""
    value = ""
    shrs_or_prn_amt = ""
    shrs_or_prn_amt_type = ""
    put_call = ""
    investment_discretion = ""
    other_manager = ""
    voting_authority_sole = ""
    voting_authority_shared = ""
    voting_authority_none = ""

    write_line = ""

    for infoTable in root:
        for child in infoTable:
            if "nameOfIssuer" in child.tag:
                name_of_issuer = child.text
            elif "titleOfClass" in child.tag:
                title_of_class = child.text
            elif "cusip" in child.tag:
                cusip = child.text
            elif "value" in child.tag:
                value = child.text
            elif "investmentDiscretion" in child.tag:
                investment_discretion = child.text
            elif "otherManager" in child.tag:
                other_manager = child.text
            elif "putCall" in child.tag:
                put_call = child.text
            elif "shrsOrPrnAmt" in child.tag:
                for shrs in child:
                    if "sshPrnamt" in shrs.tag and "Type" not in shrs.tag:
                        shrs_or_prn_amt = shrs.text
                    elif "sshPrnamtType" in shrs.tag:
                        shrs_or_prn_amt_type = shrs.text
            elif "votingAuthority" in child.tag:
                for vote_auth in child:
                    if "Sole" in vote_auth.tag:
                        voting_authority_sole = vote_auth.text
                    elif "Shared" in vote_auth.tag:
                        voting_authority_shared = vote_auth.text
                    elif "None" in vote_auth.tag:
                        voting_authority_none = vote_auth.text

        if "put" != put_call.lower():
            write_line += cik+","+ \
                    name_of_issuer.replace(',',' ').replace('\n', ' ')+","+ \
                    title_of_class.replace(',', ' ').replace('\n', ' ')+","+ \
                    cusip.replace(',',' ').replace('\n', ' ')+","+ \
                    value.replace(',',' ').replace('\n', ' ')+","+ \
                    shrs_or_prn_amt.replace(',',' ').replace('\n', ' ')+","+ \
                    shrs_or_prn_amt_type.replace(',',' ').replace('\n', ' ')+","+ \
                    put_call.replace(',',' ').replace('\n', ' ')+","+ \
                    investment_discretion.replace(',',' ').replace('\n', ' ')+","+ \
                    other_manager.replace(',', ' ').replace('\n', ' ')+","+ \
                    voting_authority_sole.replace(',',' ').replace('\n', ' ')+","+ \
                    voting_authority_shared.replace(',',' ').replace('\n', ' ')+","+ \
                    voting_authority_none.replace(',',' ').replace('\n', ' ')+"\n"

    if isAddition:
        with open("dataAddition.csv", "a") as write_file:
            write_file.write(write_line)
    else:
        with open("data.csv", "a") as write_file:
            write_file.write(write_line)


all_files = [f for f in listdir("data/") if isfile(join("data/", f))]
size = len(all_files)
for cnt, f in enumerate(all_files):
    print(f"{cnt}/{size} Parsing {f}")
    parse_file("data/"+f)
