import requests 

from alert import Alert
from invasion import Invasion
from deal import Deal
from news import News
from baro import Baro
from library import Library

class pyDeathsnacks:

    INVASION_URL = 'https://deathsnacks.com/wf/data/invasion.json'
    ALERT_URL = 'https://deathsnacks.com/wf/data/last15alerts_localized.json'
    DEAL_URL = 'https://deathsnacks.com/wf/data/daily_deals.json'
    NEWS_URL = 'https://deathsnacks.com/wf/data/news_raw.txt'
    LIBRARY_URL = 'https://deathsnacks.com/wf/data/library_target.json'
    BARO_URL = 'https://deathsnacks.com/wf/data/voidtraders.json'


    @staticmethod
    def get_alerts():
        alert_data = download_json(ALERT_URL)

        return [Alert(d) for d in alert_data]

    @staticmethod
    def get_invasions():
        invasion_data = download_json(INVASION_URL) 

        return [Invasion(d) for d in alert_data]

    @staticmethod
    def get_deals():
        deal_data = download_json(DEAL_URL)

        return [Deal(d) for d in deal_data]

    @staticmethod
    def get_news():
        news_data = download_text(NEWS_URL)

        news_data.pop()
        return [News(d) for d in news_data]

    @staticmethod
    def get_baro():
        baro_data = download_json(BARO_URL)

        return [Baro(d) for d in baro_data]

    @staticmethod
    def get_library():
        library_data = download_json(LIBRARY_URL)

        return Library(library_data)

    @staticmethod
    def download_json(url):
        r = None

        try:
            r = requests.get(url)
        except requests.exceptions.RequestException:
            raise RuntimeError('Error while connecting to ' + url)

        # Raise an exception in case of a bad response
        if not r.status_code == requests.codes.ok:
            raise RuntimeError('Bad response from ' + url)

        # Response.json() might raise ValueError
        try:
            json_data = r.json()
        except ValueError as e:
            raise RuntimeError('Bad JSON from ' + url) from e

        # Raise an exception in case of an empty response
        if not json_data:
            raise RuntimeError('Empty response from ' + url)

        return json_data

    @staticmethod
    def download_text(url):
        r = None

        try:
            r = requests.get(url)
        except requests.exceptions.RequestException:
            raise RuntimeError('Error while connecting to ' + url)

        # Raise an exception in case of a bad response
        if not r.status_code == requests.codes.ok:
            raise RuntimeError('Bad response from ' + url)

        data = r.text.split('\n')

        # Raise an exception in case of an empty response
        if not data:
            raise RuntimeError('Empty response from ' + url)

        return data
