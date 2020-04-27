import requests
import xml.etree.ElementTree as ET


ndcID_set = set()
with open("DE1_0_2008_to_2010_Prescription_Drug_Events_Sample_5.csv", "r") as f:
	for line in f:
		ndcID = line.split(',')[3]
		ndcID_set.add(ndcID)
print("Number of unique NDC ID: " + str(len(ndcID_set)))
		
# ndc_to_rx = dict()
n_rx_found = 0
with open("ndc_to_rx.csv", "w+") as f:
	for ndcID in ndcID_set:
		url = "https://rxnav.nlm.nih.gov/REST/rxcui?idtype=NDC&id={}".format(ndcID)
		response = requests.get(url)
		root = ET.fromstring(response.text)
		rxnormID = 'NA'
		if len(root[0]) >= 3:
			rxnormID = root[0][2].text
		else:
			if ndcID[0] == '0':
				ndcID_10_ls = [ndcID[1:5]+'-'+ndcID[5:9]+'-'+ndcID[9:], ndcID[1:6]+'-'+ndcID[6:9]+'-'+ndcID[9:], ndcID[1:6]+'-'+ndcID[6:10]+'-'+ndcID[10]]
				for ndcID_10 in ndcID_10_ls:
					url = "https://rxnav.nlm.nih.gov/REST/rxcui?idtype=NDC&id={}".format(ndcID_10)
					response = requests.get(url)
					root = ET.fromstring(response.text)
					if len(root[0]) >= 3:
						rxnormID = root[0][2].text
						break
		# ndc_to_rx[ndcID] = rxnormID
		f.write("{},{}\n".format(ndcID, rxnormID))
		if rxnormID != 'NA':
			n_rx_found += 1
		print(ndcID + ', ' + rxnormID)
print("Number of Rx ID found: " + str(n_rx_found))

# with open("ndc_to_rx.csv", "w+") as f:
# 	for ndcID, rxnormID in ndc_to_rx.items():
# 		f.write("{},{}\n".format(ndcID, rxnormID))