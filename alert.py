from datetime import datetime

import utils

class Alert:
    """This class represents an alert and is initialized with
    data in JSON format

    """

    def __init__(self, data):
        self.id             = data['id']
        self.expiry         = datetime.fromtimestamp(data['Expiry']['sec'])
        self.description    = data['MissionInfo']['descText']
        self.location       = data['MissionInfo']['location']
        self.missionType    = data['MissionInfo']['missionType']
        self.faction        = data['MissionInfo']['faction']
        self.reward         = data['MissionInfo']['missionReward']
        self.minLevel       = data['MissionInfo']['minEnemyLevel']
        self.maxLevel       = data['MissionInfo']['maxEnemyLevel']
        self.nightmare      = data['MissionInfo']['nightmare']

    def __str__(self):
        """Returns a string with all the information about this alert

        """
        rewardString = ''

        for item in self.reward['items']:
            rewardString += '{} + '.format(item)

        for item in self.reward['countedItems']:
            rewardString += '{} {} + '.format(item['ItemCount'],
                                              item['ItemType'])

        rewardString += str(self.reward['credits']) + 'cr'

        alertString = ('{0}\n'
                       '{1} ({2})\n'
                       '{3}\n'
                       'level {4} - {5}\n'
                       'Expires in {6}')

        return alertString.format(self.location, self.missionType,
                                  self.faction, rewardString,
                                  self.minLevel, self.maxLevel,
                                  self.get_eta_string())

    def get_eta_string(self):
        """Returns a string containing the alert's ETA

        """
        return utils.timedelta_to_string(self.expiry - datetime.now())

    def get_rewards(self):
        """Returns a list containing the alert's rewards

        """
        return [i for i in self.reward['items']] + \
            [i['ItemType'] for i in self.reward['countedItems']]
