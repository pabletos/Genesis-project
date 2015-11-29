from datetime import datetime


class Baro:
    """This class represents a Baro item and is initialized with
    data in JSON format

    """

    def __init__(self, data):
        self.config            = data['Config']
        self.start             = datetime.fromtimestamp(data['Activation']['sec'])
        self.end               = datetime.fromtimestamp(data['Expiry']['sec'])
        self.location          = data['Node']
        self.manifest          = data['Manifest']

    def __str__(self):
        """Returns a string with all the information about Baro offer

        """
        baroItemString = ""
        if datetime.now() < self.start:
            return "None"

        else:

            for item in self.manifest:
                baroItemString += ('== '+ str(item["ItemType"]) +' ==\n'
                                    '- price: '+ str(item["PrimePrice"]) +' ducats + '+ str(item["RegularPrice"]) +'cr -\n\n' )

            return baroItemString

    def get_eta_string(self):
        """Returns a string containing the Baro's ETA

        """
        seconds = int((self.end - datetime.now()).total_seconds())
        return '{} days, {} hrs, {} mins'.format((seconds // 86400), ((seconds % 86400) // 3600),
                                        (seconds % 3600) // 60)

    def get_start_string(self):
        """Returns a string containing the Baro's start

        """
        seconds = int((self.start - datetime.now()).total_seconds())
        return '{} days, {} hrs, {} mins'.format((seconds // 86400), ((seconds % 86400) // 3600),
                                        (seconds % 3600) // 60)