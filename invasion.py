class Invasion:
    """This class represents an invasion, and is initialized with
    data in JSON format

    """

    def __init__(self, data):

        self.id         = data['Id']
        self.node       = data['Node']
        self.planet     = data['Region']
        self.faction1   = data['InvaderInfo']['Faction']
        self.type1      = data['InvaderInfo']['MissionType']
        self.reward1    = data['InvaderInfo']['Reward']
        self.level1_min = data['InvaderInfo']['MinLevel']
        self.level1_max = data['InvaderInfo']['MaxLevel']
        self.faction2   = data['DefenderInfo']['Faction']
        self.type2      = data['DefenderInfo']['MissionType']
        self.reward2    = data['DefenderInfo']['Reward']
        self.level2_min = data['DefenderInfo']['MinLevel']
        self.level2_max = data['DefenderInfo']['MaxLevel']
        self.completion = data['Percentage']
        self.ETA        = data['Eta']
        self.desc       = data['Description']

    def __str__(self):
        """Returns a string with all the information about
        this invasion

        """
        if self.faction1 == 'Infestation':
            invasionString = ('{0} ({1})\n'
                              '{2} ({7})\n'
                              '{8}\n'
                              '{9:.2f}% - {10}')

        else:
            invasionString = ('{0} ({1}) - {2}\n'
                              '{3} ({4}, {5}) vs.\n'
                              '{6} ({7}, {8})\n'
                              '{9:.2f}% - {10}')

        return invasionString.format(self.node, self.planet, self.desc,
                                     self.faction1, self.type1,
                                     self.reward1, self.faction2,
                                     self.type2, self.reward2,
                                     self.completion, self.ETA)

    def get_rewards(self):
        """Returns a list containing the invasion's rewards excluding credits

        """
        return [i for i in [self.reward1, self.reward2] if 'cr' not in i]
