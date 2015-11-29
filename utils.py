from datetime import datetime

def timedelta_to_string(td):
    """Returns a custom string representation of a timedelta object

    Parameters
    ----------
    td : timedelta
        timedelta object to be represented as a string
    """

    seconds = int(td.total_seconds())
    time_string = ''

    if seconds >= 86400:        # Seconds in a day
        time_string = "{0}d"
    elif seconds >= 3600:
        time_string = "{1}h {2}m"
    else:
        time_string = "{2}m"

    return time_string.format(seconds // 86400, seconds // 3600, (seconds % 3600) // 60)
