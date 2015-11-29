from datetime import datetime
import threading, time, shelve, argparse, os.path, dbm, requests, sqlite3, telegram

from pyDeathsnacks import pyDeathsnacks

class Genesis:

    TOKEN_PATH = 'token.txt'
    DB_NAME = 'your db here'

    INSTRUCTIONS = (
                'I am allowed to answer to any of these commands:\n\n'
                '/start - Start tracking alerts and invasions (all but credits or resource alerts).\n'
                '/stop - Stop tracking alerts and invasions.\n'
                '/alerts - Get all active alerts.\n'
                '/invasions - Get all active invasions and ETA.\n'
                '/craft weapon - Shows weapon manufacturing info. \n'
                '/darvo - Get current daily deals.\n'
                '/simaris - Show current Simaris target and completion.\n'
                '/baro - Shows baro deals or ETA.\n'
                '/startbd - Allows receiving Cephalon\'s broadcasts.\n'
                '/stopbd - Stops Cephalon\'s broadcasts.\n'
                '/help - Show this info.\n'
                '/donate - Link to contribute to Cephalon development (thanks!).\n'
                '/changelog - Version changes log.\n'
                '/about - Info about tenno creators and contributors.\n\n'
                'And maybe some commands more, I\'m not sure, my calibrator is still broken!'
            )
    
    def __init__(self):
        
        read_token()
        self.wrapper = telegram.Bot(token = self.token)

        db = sqlite3.connect(DB_NAME)
        cursor = db.cursor()

        query = ('CREATE TABLE IF NOT EXISTS users '
                 '(chat_id INTEGER PRIMARY KEY, platform INTEGER,'
                 'alert_track INTEGER, invasion_track INTEGER,'
                 'broadcast INTEGER, photo INTEGER,'
                 'helmet_track INTEGER, clantech_track INTEGER,'
                 'nightmare_track INTEGER, aura_track INTEGER,'
                 'resource_track INTEGER, nitain_track INTEGER)')

        cursor.execute(query)
        db.commit()
        db.close()


    def read_token(self):
        """ Read the bot token from the file specified in TOKEN_PATH"""

        with open(TOKEN_PATH) as f:
            self.token = f.readline()


    def start(self, chatid):
        """ Register new users """

        db = sqlite3.connect(DB_NAME)
        cursor = db.cursor()

        #checks if user exists already
        query = "SELECT name FROM users WHERE chat_id = ?"
        cursor.execute(query, (chatid,))
        row = cursor.fetchone()

        if row == None:
            #create a record if doesn't exist

            create = ('INSERT INTO user VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)')
            cursor.execute(create, (chatid, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
            db.commit()
            db.close()

            wrapper.sendMessage(chat_id = chatid, text = "Welcome operator!\n" + INSTRUCTIONS)


    def alert_track(self,chatid,chatname):
        """ Connects to database and change alert tracking value from 0 to 1 or 1 to 0 (tracking/not tracking) """

        db = sqlite3.connect(DB_NAME)
        cursor = db.cursor()

        query = "SELECT alert_track FROM users WHERE chat_id = ?"
        cursor.execute(query, (chatid,))
        row = cursor.fetchone()

        if row != None:
            #if fetching was succesful it checks chat_id value
            update = "UPDATE users SET alert_track = ? WHERE chat_id = ?"

            if row[0] == 0:
                #starts
                cursor.execute(update, (1, chatid))
                wrapper.sendMessage(chat_id = chatid, text = "Starting tracking alerts, here we go!\n")
            else:
                #stops
                cursor.execute(update, (0, chatid))
                wrapper.sendMessage(chat_id = chatid, text = "Stopping the tracking, use /startalerts if you want to start tracking again, operator\n")

            db.commit()
        db.close()
            

    def invasion_track(self,chatid):
        """ Connects to database and change invasion tracking value from 0 to 1 or 1 to 0 (tracking/not tracking) """

        db = sqlite3.connect(DB_NAME)
        cursor = db.cursor()

        query = "SELECT invasion_track FROM users WHERE chat_id = ?"
        cursor.execute(query, (chatid,))
        row = cursor.fetchone()

        if row != None:
            #if fetching was succesful it checks chat_id value
            update = "UPDATE users SET invasion_track = ? WHERE chat_id = ?"
            
            if row[0] == 0:
                #starts
                cursor.execute(update, (1, chatid))
                wrapper.sendMessage(chat_id = chatid, text = "Starting tracking invasions, here we go!\n")
            else:
                #stops
                cursor.execute(update, (0, chatid))
                wrapper.sendMessage(chat_id = chatid, text = "Stopping the tracking, use /invasion if you want to start tracking again, operator\n")

            db.commit()
        db.close()

    def broadcast(self,field,message):
        """ Broadcast a message checking if a row value is 1 (if users are tracking) """

        db = sqlite3.connect(DB_NAME)
        cursor = db.cursor()

        query = "SELECT chat_id FROM users WHERE ? = 1"
        cursor.execute(query, (field,))
        rows = cursor.fetchall()

        for row in rows:
            send_message(row[0], message)

        db.close()

    def remove_chat(self, chatid):
        db = sqlite3.connect(DB_NAME)
        cursor = db.cursor()

        cursor.execute('DELETE FROM users WHERE chat_id = ?', (chatid,))

        db.commit()
        db.close()


    def run(self):


    def bot(self, message):
        """ Answers received messages

        Parameters
        ----------
        message : str
            Textual content of received message
        """

        text = message['text']
        chat_id = message['chat']['id']

        if '/help' in text:
            self.send(chat_id, WarBot.USAGE)

        elif '/alerts' in text:
            if 'all' in text:
                self.send(chat_id, self.get_alert_string(True))
            else:
                self.send(chat_id, self.get_alert_string(False))

        elif '/invasions' in text:
            if 'all' in text:
                self.send(chat_id, self.get_invasion_string(True))
            else:
                self.send(chat_id, self.get_invasion_string(False))
        
        elif '/darvo' in text:
            self.send(chat_id, self.get_deals_string())

        elif '/news' in text:
            self.send(chat_id, self.get_news_string(), markdown=True,
                      link_preview=False)

        elif '/notify' in text:
            if 'on' in text:
                self.set_notifications(chat_id, True)
            elif 'off' in text:
                self.set_notifications(chat_id, False)

        if (message.left_chat_partecipant is not None and
                message.left_chat_participant.id == wrapper.id):
            self.remove_chat(chat_id)


    if __name__ == '__main__':

        os.chdir(os.path.dirname(__file__))
        bot = Genesis()
        bot.run()
