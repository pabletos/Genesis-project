# Description:
#   Display utility info at the user's request
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot armor - Display instructions for calculating armor
#   hubot armor <current armor> - Display current damage resistance and amount of corrosive procs required to strip it
#   hubot armor <base armor> <base level> <current level> - Display the current armor, damage resistance, and necessary corrosive procs to strip armor.
#   hubot chart - Display link to Warframe progression chart
#   hubot cycle - Display the current day/night cycle for Earth and tell you how much time is left.
#   hubot damage - Display link to Damage 2.0 infographic
#   hubot efficiency chart - Display link to Duration/Efficienct chart
#   hubot pc/price check/pricecheck <item or mod> - Display nexus-stats.com data for a particular crafted item (Ex.: Vauban prime).
#   hubot shield - Display instructions for calculating shields
#   hubot shield <base shields> <base level> <current level> - Display the current shields.
#   hubot trial <in-game-name> - display link to search for stats for user
#   hubot where (is) <item> - Display list of locations for requested item
#
# Author:
#   nspacestd
#   aliasfalse
util = require 'util'
moment = require 'moment'
md = require 'node-md-config'
PriceCheck = require 'warframe-nexus-query'
LocCheck = require 'warframe-location-query'

dsUtil = require './lib/_utils.js'

module.exports = (robot) ->
  priceCheckr = new PriceCheck()
  locationCheckr = new LocCheck()
  
  getCurrentEarthCycle = ->
    hour = Math.floor(moment().valueOf() / 3600000) % 24
    cycle = 'Night'
    opposite = 'Day'
    if hour >= 0 and hour < 4 or hour >= 8 and hour < 12 or hour >= 16 and hour < 20
      cycle = 'Day'
      opposite = 'Night'
    hourleft = 3 - (hour % 4)
    minutes = 59 - moment().minutes()
    seconds = 59 - moment().seconds()
    timePieces = []
    if hourleft > 0
      timePieces.push hourleft + 'h'
    if minutes > 0
      timePieces.push minutes + 'm'
    if seconds > 0
      timePieces.push seconds + 's'
    format = '%sOperator, Earth is currently in %stime. Time remaining until %s: %s.%s'
    return util.format format, md.codeMulti, cycle, opposite, timePieces.join(' '), md.blockEnd
  
  robot.respond /armor(?:\s+([\d+\.?\d*\s]+))?/i, id:'hubot-warframe.armor', (res) ->
    pattern3Params = new RegExp(/(\d+\.?\d*)(?:\s+(\d+\.?\d*)\s+(\d+\.?\d*))?$/)
    pattern1Param = new RegExp(/(\d+\.?\d*)$/)
    robot.logger.debug util.format('matched armor command. matching string: %s', res.match[1])
    params = res.match[1]
    
    if pattern3Params.test(params)
      armor = params.match(pattern3Params)[1]
      baseLevel = params.match(pattern3Params)[2]
      currentLevel = params.match(pattern3Params)[3]
      
      if(typeof baseLevel == 'undefined')
        robot.logger.debug 'Entered 1-param armor'
        armorString = util.format('%s%s%s %s %s',
                                md.codeMulti, dsUtil.damageReduction(armor), 
                                md.lineEnd, dsUtil.armorStrip(armor), md.blockEnd)
      else
        robot.logger.debug 'Entered 3-param armor'
        armorString = util.format('%s%s%s', 
                                md.codeMulti, dsUtil.armorFull(armor, baseLevel, currentLevel), 
                                md.blockEnd)

            
    else
      robot.logger.debug 'Entered 0-param armor'
      armorInstruct3 = 'armor (Base Armor) (Base Level) (Current Level) calculate armor and stats.'
      armorInstruct1 = 'armor (Current Armor) Calculate damage resistance.'
      armorString = util.format('%sPossible uses include:%s%s%s%s%s', 
                                md.codeMulti, md.lineEnd, 
                                armorInstruct3, md.lineEnd, 
                                armorInstruct1, md.blockEnd)
    res.send armorString
    
  robot.respond /chart/i, id:'hubot-warframe.chart', (res) ->
    res.send string = "#{md.linkBegin}Chart"+
          "#{md.linkMid}http://chart.morningstar.ninja/"+
          "#{md.linkEnd}"
  robot.respond /cycle/i, id:'hubot-warframe.cycle', (res) ->
    res.send getCurrentEarthCycle()
  robot.respond /damage/i, id:'hubot-warframe.damage', (res) ->  
    damageURL = 'http://morningstar.ninja/chart/Damage_2.0_Resistance_Flowchart.png'
    res.send "#{md.linkBegin}Damage 2.0#{md.linkMid}#{damageURL}#{md.linkEnd}"
  robot.respond /efficiency\s?chart/, id:'hubot-warframe.efficiencychart', (res) ->
    efficienctChartURL = 'http://morningstar.ninja/chart/efficiency.png'
    res.send "#{md.linkBegin}Duration/Efficiency Balance Chart#{md.linkMid}#{efficienctChartURL}#{md.linkEnd}"
  robot.respond /p(?:rice)?\s?c(?:heck)?(?:\s+([\w+\s]+))?/i, id:'hubot-warframe.pricecheck', (res) ->
    query = res.match[1]
    if query?
      priceCheckr.priceCheckQueryString query, (err, componentString) ->
        if err
            return robot.logger.error err
        res.send componentString
    else
      res.send "#{md.codeMulti}Usage: whereis <prime part/blueprint>#{md.blockEnd}"
  robot.respond /shield(?:\s+([\d+\.?\d*\s]+))?/, id:'hubot-warframe.shields', (res) ->
    pattern3Params = new RegExp(/^(\d+\.?\d*)(?:\s+(\d+\.?\d*)\s+(\d+\.?\d*))?$/)
    robot.logger.debug util.format('matched shield command. matching string: %s', res.match[1])
    params = res.match[1]
    
    if pattern3Params.test(params)
      shields = params.match(pattern3Params)[1]
      baseLevel = params.match(pattern3Params)[2]
      currentLevel = params.match(pattern3Params)[3]
      
      robot.logger.debug 'Entered 3-param shield'
      shieldString = dsUtil.shieldString dsUtil.shieldCalc(shields, baseLevel, currentLevel), currentLevel    
    else
      robot.logger.debug 'Entered 0-param shield'
      shieldInstruct3 = 'shield (Base Shelds) (Base Level) (Current Level) calculate shields and stats.'
      shieldString = "#{md.codeMulti}Possible uses include:#{md.lineEnd}#{shieldInstruct3}#{md.blockEnd}"
    res.send shieldString
  robot.respond /trial(?:\s+([\w+\s]+))?(?:\s+([\w+\s]+))?/i, id:'hubot-warframe.trials', (res) ->
    params = res.match[1]
  
    lorRegExp = /(?:(?:lor)|(?:law of retribution))\s*?(?:([\w+\s]+))?/i
    jordasRegExp = /(?:j(?:ordas)?(?:\s?v(?:erdict)?)?)(?:\s+([\w+\s]+))?/i
    
    baseURL = 'http://wf.christx.tw/'
    searchAppend = 'search.php?id='
    jordasSearchAppend = 'JordasSearch.php?id='
    jordasAppend = 'JordasRecords.php?type=all'
    
    messageToSend = 'Sorry, Operator, no functionality exists for that yet.'
    
    if(typeof params == 'undefined')
      messageToSend = baseURL
    else if lorRegExp.test params
      name = params.match(lorRegExp)[1]
      if(typeof name != 'undefined')
        messageToSend = baseURL + searchAppend + encodeURIComponent name.replace(/\s/,'')
      else
        messageToSend = baseURL
    else if jordasRegExp.test params
      name = params.match(jordasRegExp)[1]
      if(typeof name != 'undefined')
        messageToSend = baseURL + jordasSearchAppend + encodeURIComponent name.replace(/\s/,'')
      else
        messageToSend = baseURL + jordasAppend
    else if(typeof params != 'undefined')
      messageToSend = baseURL + searchAppend + encodeURIComponent params.replace(/\s/,'')
    res.send messageToSend
  robot.respond /where(?:\s?is)?(?:\s+([\w+\s]+))?/i, id:'hubot-warframe.where', (res) ->
    query = res.match[1]
    if query?
      locationCheckr.getLocationsForComponent query, (err, componentStringList) ->
        if err
            return robot.logger.error err
        res.send md.codeMulti+componentString+md.blockEnd for componentString in componentStringList
    else
      res.send "#{md.codeMulti}Usage: whereis <prime part/blueprint>#{md.blockEnd}"
      
  robot.respond /mod(.+)/i, id:'hubot-warframe.mod', (res) ->
    type = res.match[1]
    if not type
      res.reply "#{md.codeMulti}Please specify a search term#{md.blockEnd}"
    else
      #default case
      query = type.match(/(.+)/)[1]
      robot.logger.debug("Searched for query: #{query}")
      dsUtil.modSearch(query)
        .then((message) =>
          if typeof message != 'undefined'
            res.send message
          else
            res.reply "#{md.codeMulti}Please specify a search term#{md.blockEnd}"
        )
        .catch(console.error)
    
    
  robot.respond /wiki(.+)/i, id:'hubot-warframe.wiki', (res) ->
    type = res.match[1]
    if not type
      res.reply "#{md.codeMulti}Please specify a search term#{md.blockEnd}"
    else
      #default case
      query = type.match(/(.+)/)[1]
      robot.logger.debug("Searched for query: #{query}")
      dsUtil.wikiSearch(query)
        .then((message) =>
          if typeof message != 'undefined'
            res.send message
          else
            res.reply "#{md.codeMulti}Please specify a search term#{md.blockEnd}"
        )
        .catch(console.error)