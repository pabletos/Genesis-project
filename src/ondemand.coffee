# Description:
#   Display mission info at the user's request
#
# Dependencies:
#   None
#
# Configuration:
#   MONGODB_URL - MongoDB url
#
# Commands:
#   hubot alerts - Display alerts
#   hubot invasions - Display invasions
#   hubot darvo - Display daily deals
#   hubot news - Display news
#   hubot baro - Display current Baro status/inventory
#
# Author:
#   nspacestd

Users = require('./lib/users.js')
ds = require('./lib/deathsnacks.js')

mongoURL = process.env.MONGODB_URL

module.exports = (robot) ->
  userDB = new Users(mongoURL)

  robot.respond /alerts/, (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        robot.logger.error err
      else
        ds.getAlerts ds.PLATFORM[platform], (err, data) ->
          if err
            robot.logger.error err
          else
            message =
              if data then (alert.toString() for alert in data).join('\n')
              else 'There are no alerts at the moment'
            res.send message

  robot.respond /invasions/, (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        robot.logger.error err
      else
        ds.getInvasions ds.PLATFORM[platform], (err, data) ->
          if err
            robot.logger.error err
          else
            message =
              if data then (invasion.toString() for invasion in data).join('\n')
              else 'There are no invasions at the moment'
            res.send message

  robot.respond /darvo/, (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        robot.logger.error err
      else
        ds.getDeals ds.PLATFORM[platform], (err, data) ->
          if err
            robot.logger.error err
          else
            message =
              if data then(deal.toString() for deal in data).join('\n\n')
              else 'There is no daily deal at the moment'
            res.send message

  robot.respond /news/, (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        robot.logger.error err
      else
        ds.getNews ds.PLATFORM[platform], (err, data) ->
          if err
            robot.logger.error err
          else
            if data
              if robot.adapterName is 'telegram'
                # Send with Markdown
                message = (news.toString(true, true) for news in data).join('\n\n')
                robot.emit 'telegram:invoke', 'sendMessage',
                  chat_id: res.message.room
                  text: message
                  parse_mode: 'Markdown'
                  disable_web_page_preview: true
                , (err, response) ->
                  if err
                    robot.logger.error err

              # No Telegram
              else
                message = (news.toString(true, false) for news in data).join('\n\n')
                res.send message
            # No news
            else
              res.send 'There are no news at the moment'

  robot.respond /baro/, (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        robot.logger.error err
      else
        ds.getBaro ds.PLATFORM[platform], (err, data) ->
          if err
            robot.logger.error err
          else
            res.send data.toString()

