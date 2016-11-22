# Description:
#   Miscellaneous commands
#
# Dependencies:
#   None
#
# Configuration:
#   MONGODB_URL - MongoDB url
#
# Commands:
#   hubot start - Add user to database and start tracking
#   hubot stop - Turn off notifications
#
# Author:
#   nspacestd
#   aliasfalse

Users = require('./lib/users.js')

mongoURL = process.env.MONGODB_URL

module.exports = (robot) ->
  userDB = new Users(mongoURL)

  robot.respond /start/, id:'hubot-warframe.start' , (res) ->
    userDB.add res.message.room, (err, result) ->
      if err
        robot.logger.error err
      else
        if result
          res.send 'Tracking started'
        else
          res.send 'Already tracking'

  robot.respond /stop/, id:'hubot-warframe.stop', (res) ->
    userDB.stopTrack res.message.room, (err) ->
      if err
        robot.logger.error err
      else
        res.send 'Tracking stopped'

  if robot.adapterName is 'discord'
    robot.leave (res) ->
      if res.message.user.id is robot.adapter.client.user.id
        userDB.remove res.message.room, (err) ->
          robot.logger.error err if err
    robot.enter (res) ->
      if res.message.user.id is robot.adapter.client.user.id
        res.send 'Hello, Operator! Please type /start to begin tracking.'
  
  if robot.adapterName is 'telegram'
    # Remove chat from the database when the bot is kicked, Telegram only
    robot.leave (res) ->
      if res.message.user.id is robot.adapter.bot_id
        userDB.remove res.message.room, (err) ->
          robot.logger.error err if err

    robot.enter (res) ->
      if res.message.user.id is robot.adapter.bot_id
        res.send 'Hello, Operator! Please type /start to begin tracking.'
