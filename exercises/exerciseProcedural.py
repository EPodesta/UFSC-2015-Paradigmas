import urllib
import json

f = raw_input("Type the currency you wanto to convert(Use only currency code): ")
f = f.upper()
t = raw_input("Type to which currency you want to convert(Use only currency code): ")
t = t.upper()
url = "https://currency-api.appspot.com/api/%s/%s.json" %(f, t)

url = urllib.urlopen(url)

result = url.read()


result = json.loads(result)

url.close()
if v == None:
	print ("1 %s equals to %f %s: ")%(f, result["rate"], t)