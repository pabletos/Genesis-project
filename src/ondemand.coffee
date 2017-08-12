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
#   hubot baro - Display current Baro status/inventory
#   hubot bonus - Display current global bonus if there is one
#   hubot conclave - Display usage for conclave command
#   hubot conclave all - Display all conclave challenges
#   hubot conclave daily - Display active daily conclave challenges
#   hubot conclave weekly - Display active weekly conclave challenges
#   hubot darvo - Display daily deals
#   hubot enemies - Display list of active persistent enemies where they were last found
#   hubot event - Display information about current event
#   hubot fissures - Display currently active fissures
#   hubot flash deals - Display Current Market flash deals
#   hubot invasions - Display invasions
#   hubot news - Display news
#   hubot primeaccess - Display current Prime Access news
#   hubot update - Display current update
#   hubot simaris - Display current Synthesis target
#   hubot sortie - Display current sortie missions
#   hubot syndicate <syndicate> - Display syndicate mission nodes
#
# Author:
#   nspacestd
#   aliasfalse

util = require('util')
md = require('node-md-config')

Users = require('./lib/users.js')
dsUtil = require('./lib/_utils.js')
Worldstate = require('warframe-worldstate-parser').Parser

mongoURL = process.env.MONGODB_URL

module.exports = (robot) ->
  userDB = new Users(mongoURL)
  
  worldStates = 
    PC: null
    PS4: null
    X1:  null
  worldStates[worldstate] = new Worldstate(worldstate) for worldstate of worldStates
  
  robot.respond /alerts/i, id:'hubot-warframe.alerts', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        robot.logger.error err
      else
        worldStates[platform].getAlertsString (err, alertsString) ->
          if err
            robot.logger.error err
          res.send alertsString
        
    
  robot.respond /baro/i, id:'hubot-warframe.baro', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        robot.logger.error err
      else
         worldStates[platform].getVoidTraderString (err, voidTraderString) ->
          if err
            robot.logger.error err
          res.send voidTraderString
          
  robot.respond /bonus/i, id:'hubot-warframe.bonus', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        return robot.logger.error err
      worldStates[platform].getGlobalModifersString (err, bonusString) ->
        if err
            return robot.logger.error err
        res.send bonusString
  robot.respond /conclave(?:\s+([\w+\s]+))?/i, id:'hubot-warframe.conclave', (res) ->
    robot.logger.debug util.format('matched conclave command. matching string: %s', res.match[1])
    params = res.match[1]
    challengeFormat = '%s%s%s'
    noChallengeString = util.format('%sNo Challenges%s',  md.codeMulti, md.blockEnd)
    allRegExp = new RegExp(/^(all)$/)
    dailyRegExp = new RegExp(/^(daily)$/)
    weeklyRegExp = new RegExp(/^(weekly)$/)
    
    if allRegExp.test(params)
      robot.logger.debug 'Entered all challenge'
      userDB.getPlatform res.message.room, (err, platform) ->
        if err
          return robot.logger.error err
        worldStates[platform].getConclaveAllString (err, conclaveAllString) ->
          if err
            return robot.logger.error err
          res.send conclaveAllString
    else if dailyRegExp.test(params)
      robot.logger.debug 'Entered daily challenge'
      userDB.getPlatform res.message.room, (err, platform) ->
        if err
          return robot.logger.error err
        worldStates[platform].getConclaveDailiesString (err, conclaveDailiesString) ->
          if err
            return robot.logger.error err
          res.send conclaveDailiesString
    else if weeklyRegExp.test(params)
      robot.logger.debug 'Entered weekly challenge'
      userDB.getPlatform res.message.room, (err, platform) ->
        if err
          return robot.logger.error err
        worldStates[platform].getConclaveWeekliesString (err, conclaveWeekliesString) ->
          if err
            return robot.logger.error err
          res.send conclaveWeekliesString
    else
      robot.logger.debug 'Entered null challenge'
      conclaveInstructAll = 'conclave all - print all conclave challenges.'
      conclaveInstructWeekly = 'conclave weekly - print weekly conclave challenges.'
      conclaveInstructDaily = 'conclave daily - print conclave daily challenges.'
      res.send util.format('%sPossible uses include:%s%s%s%s%s%s', 
                                    md.codeMulti, md.lineEnd, 
                                    conclaveInstructAll, md.lineEnd, 
                                    conclaveInstructWeekly, md.lineEnd, 
                                    conclaveInstructDaily, md.blockEnd)
  robot.respond /darvo/i, id:'hubot-warframe.darvo', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        robot.logger.error err
      else
        worldStates[platform].getDealsString (err, dealsString) ->
          if err
            robot.logger.error err
          res.send dealsString

  robot.respond /enemies/i, id:'hubot-warframe.enemies', (res) ->
    robot.logger.debug 'Entered persistent enemies command'
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        return robot.logger.error err
      worldStates[platform].getAllPersistentEnemiesString (err, enemiesString) ->
        if err
          return robot.logger.error err
        res.send enemiesString
  
  robot.respond /event/i, id:'hubot-warframe.event', (res) ->
    robot.logger.debug 'Entered events command'
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        return robot.logger.error err
      worldStates[platform].getEventsString (err, eventsString) ->
        if err
          return robot.logger.error err
        res.send eventsString  
  
  robot.respond /fissures/i, id:'hubot-warframe.fissures', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        return robot.logger.error err
      worldStates[platform].getFissureString (err, fissuresString) ->
        if err
          return robot.logger.error err
        res.send fissuresString 
  
  robot.respond /flash(?:\s?deals?)/i, id:'hubot-warframe.flashdeals', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        return robot.logger.error err
      worldStates[platform].getFlashDealsString (err, flashDealsString) ->
        if err
          return robot.logger.error err
        res.send flashDealsString
  
  robot.respond /invasions/i, id:'hubot-warframe.invasions', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        robot.logger.error err
      else
        worldStates[platform].getInvasionsString (err, invasionsString) ->
          if err
            robot.logger.error err
          res.send invasionsString
  robot.respond /news/i, id:'hubot-warframe.news', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        return robot.logger.error err
      worldStates[platform].getNewsString (err, newsString) ->
        if err
            return robot.logger.error err
        res.send newsString
      
  robot.respond /prime\s?access/i, id:'hubot-warframe.primeaccess', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        return robot.logger.error err
      worldStates[platform].getPrimeAccessString (err, primeAccessString) ->
        if err
            return robot.logger.error err
        res.send primeAccessString
  
  robot.respond /update/i, id:'hubot-warframe.updates', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        return robot.logger.error err
      worldStates[platform].getUpdatesString (err, updatesString) ->
        if err
            return robot.logger.error err
        res.send updatesString
  robot.respond /simaris/i, id:'hubot-warframe.simaris', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        return robot.logger.error err
      worldStates[platform].getSimarisString (err, simarisString) ->
        if err
            return robot.logger.error err
        res.send simarisString 
  robot.respond /sortie/i, id:'hubot-warframe.sortie', (res) ->
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        return robot.logger.error err
      worldStates[platform].getSortieString (err, sortieString) ->
        if err
            return robot.logger.error err
        res.send sortieString
        
  robot.respond /syndicate(?:\s+([\w+\s]+))?/i, id:'hubot-warframe.syndicate', (res) ->
    syndicateReg = res.match[1]
    arbitersReg = /arbiters(\sof)?(\shexis)?/
    sudaReg = /(cephalon\s)?suda/
    lokaReg = /(new\s)?loka/
    perrinReg = /perrin(\ssequence)?/
    steelMeridianReg = /(steel\s)?meridian/
    redVeilReg = /(red\s)?veil/
    allReg = /all/
    
    userDB.getPlatform res.message.room, (err, platform) ->
      if err
        return robot.logger.error err
      syndicateString = ''
      if syndicateReg?
        if arbitersReg.test syndicateReg
          worldStates[platform].getArbitersOfHexisString (err, arbiterString) ->
            if err
                return robot.logger.error err
            robot.logger.debug "Entering arbiters syndicate"
            res.send arbiterString
        else if sudaReg.test syndicateReg
          worldStates[platform].getCephalonSudaString (err, sudaString) ->
            if err
                return robot.logger.error err
            robot.logger.debug "Entering cephalon suda syndicate"
            res.send sudaString
        else if lokaReg.test syndicateReg
          worldStates[platform].getNewLokaString (err, lokaString) ->
            if err
                return robot.logger.error err
            robot.logger.debug "Entering new loka syndicate"
            res.send lokaString
        else if perrinReg.test syndicateReg
          worldStates[platform].getPerrinSequenceString (err, perrinString) ->
            if err
                return robot.logger.error err
            robot.logger.debug "Entering perrin sequence syndicate"
            res.send perrinString
        else if steelMeridianReg.test syndicateReg
          worldStates[platform].getSteelMeridianString (err, steelMeridianString) ->
            if err
                return robot.logger.error err
            robot.logger.debug "Entering steel Meridian syndicate"
            res.send steelMeridianString
        else if redVeilReg.test syndicateReg
          worldStates[platform].getRedVeilString (err, redVeilString) ->
            if err
                return robot.logger.error err
            robot.logger.debug "Entering red veil syndicate"
            res.send redVeilString
        else if allReg.test syndicateReg
          worldStates[platform].getAllSyndicatesAsString (err, allSyndString) ->
            if err
                return robot.logger.error err
            robot.logger.debug "Entering all syndicate"
            res.send allSyndString
        else
         res.send util.format("#{md.codeMulti}Operator, that is not a currently valid syndicate, stay alert.#{md.blockEnd}")
      else
        syndicates = ["arbiters of hexis", "cephalon suda", "new loka", "perrin sequence", "steel meridian", "red veil"]
        syndicateString = "#{md.codeMulti}Available syndicates:#{md.lineEnd}"
        syndicates.forEach (syndicate) ->
            syndicateString += "  \u2022 #{syndicate}#{md.lineEnd}" 
        res.send syndicateString += md.blockEnd