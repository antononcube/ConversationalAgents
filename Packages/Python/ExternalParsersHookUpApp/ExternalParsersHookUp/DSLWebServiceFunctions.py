import json
import urllib.request


def DSLWebServiceInterpretationURL(command, url="http://accendodata.net:5040/translate/"):
    command_safe = urllib.parse.quote(command)

    url_safe = url + "'" + command_safe + "'"

    return url_safe


def DSLWebServiceInterpretation(command, url="http://accendodata.net:5040/translate/"):
    url_safe = DSLWebServiceInterpretationURL(command, url)

    data = urllib.request.urlopen(url_safe).read()
    res = json.loads(data)
    return res
