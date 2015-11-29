from datetime import datetime

import utils


class News:
    """This class represents a news item and is initialized with
    data in text format

    """

    def __init__(self, data):
        info = data.split('|')

        self.id         = info[0]
        self.link       = info[1]
        self.time       = datetime.fromtimestamp(int(info[2]))
        self.text       = info[3]

    def __str__(self):
        """Returns a string with the description of the news item

        """

        return '\[{} ago]: [{}]({})'.format(self.get_elapsed_time(),
                                              self.text, self.link)

    def get_elapsed_time(self):
        """Returns a string containing the time that has passed since
        the news item was published

        """

        return utils.timedelta_to_string(datetime.now() - self.time)
        
