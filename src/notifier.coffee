# Description:
#   Sends alert/invasion/news notifications to subscribed users
#
# Dependencies:
#   None
#
# Configuration:
#   MONGODB_URL - MongoDB url
#
# Commands:
#   None
#
# Author:
#   nspacestd

util = require 'util'
Users = require './lib/users.js'
platforms = require './lib/platforms.json'
md = require 'node-md-config'
Worldstate = require('warframe-worldstate-parser').Parser

mongoURL = process.env.MONGODB_URL
NOTIFICATION_INTERVAL =  process.env.WORLDSTATE_CACHE_LENGTH || 300000

worldStates = 
  PC: null
  PS4: null
  X1:  null
worldStates[worldstate] = new Worldstate worldstate for worldstate of worldStates

module.exports = (robot) ->
  userDB = new Users(mongoURL)
  setInterval check, NOTIFICATION_INTERVAL, robot, userDB
  setTimeout check, 10000, robot, userDB

check = (robot, userDB) ->
  ###
  # Check for new alerts/invasions/news
  #
  # @param object robot
  # @param object userDB
  ###
  for platform in platforms
    checkNews(robot, userDB, platform)
    checkSortie(robot, userDB, platform)
    checkFissures(robot, userDB, platform)
    checkBaro(robot, userDB, platform)
    checkDarvo(robot, userDB, platform)
    checkEnemies(robot, userDB, platform)
    checkAlerts(robot, userDB, platform)
    checkInvasions(robot, userDB, platform)
    checkConclaveDailies(robot, userDB, platform)
    checkConclaveWeeklies(robot, userDB, platform)
    checkSyndicateArbiters(robot, userDB, platform)
    checkSyndicateSuda(robot, userDB, platform)
    checkSyndicateLoka(robot, userDB, platform)
    checkSyndicatePerrin(robot, userDB, platform)
    checkSyndicateRedVeil(robot, userDB, platform)
    checkSyndicateMeridian(robot, userDB, platform)
  return

checkAlerts = (robot, userDB, platform) ->
  ###
  # Check for new alerts and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking alerts (' + platform + ')...'
  worldStates[platform].getAlerts (err, alerts) ->  
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedAlertIds = robot.brain.get('notifiedAlertIds' + platform) or []
      robot.brain.set 'notifiedAlertIds' + platform, (a.id for a in alerts)

      for a in alerts when a.id not in notifiedAlertIds
        types = a.getRewardTypes()
        # Credit only alerts are not notified
        if types.length
          query = $and: [
            {platform: platform}
            {items:
              $in: types
            }
            {items: 'alerts'}
          ]
          broadcast a.toString(), query, robot, userDB
      return

checkInvasions = (robot, userDB, platform) ->
  ###
  # Check for new invasions and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking invasions (' + platform + ')...'
  worldStates[platform].getInvasions (err, invasions) ->  
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedInvasionIds = robot.brain.get('notifiedInvasionIds' + platform) or []
      robot.brain.set 'notifiedInvasionIds' + platform, (i.id for i in invasions)

      for i in invasions when i.id not in notifiedInvasionIds
        types = i.getRewardTypes()
        # Credit only invasions are not notified
        if types.length
          query = $and: [
            {platform: platform}
            {items:
              $in: types
            }
            {items: 'invasions'}
          ]
          broadcast i.toString(), query, robot, userDB
      return

checkNews = (robot, userDB, platform) ->
  ###
  # Check for unread news and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking news (' + platform + ')...'
  worldStates[platform].getNews (err, news) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedNewsIds = robot.brain.get('notifiedNewsIds' + platform) or []
      robot.brain.set 'notifiedNewsIds' + platform, (n.id for n in news)

      for n in news when n.id not in notifiedNewsIds
        broadcast n.toString(),
          items: 'news'
          platform: platform
        , robot, userDB
      return
    
    
checkSortie = (robot, userDB, platform) ->
  ###
  # Check for unread sorties and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking sorties (' + platform + ')...'
  worldStates[platform].getSortie (err, sortie) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedSortieId = robot.brain.get('notifiedSortieId' + platform) or ''
      robot.brain.set 'notifiedSortieId' + platform, sortie.id
      if (sortie != null && sortie.id != notifiedSortieId)
        broadcast sortie.toString(),
          items: 'sorties'
          platform: platform
        , robot, userDB
      return
checkFissures = (robot, userDB, platform) ->
  ###
  # Check for unread fissures and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking fissures (' + platform + ')...'
  worldStates[platform].getFissures (err, fissures) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedFissureIds = robot.brain.get('notifiedFissureIds' + platform) or []
      robot.brain.set 'notifiedFissureIds' + platform, (f.id for f in fissures)

      for f in fissures when f.id not in notifiedFissureIds
        broadcast md.codeMulti+f.toString()+md.blockEnd,
          items: 'fissures'
          platform: platform
        , robot, userDB
      return
checkEnemies = (robot, userDB, platform) ->
  ###
  # Check for unread persistent enemies and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking enemies (' + platform + ')...'
  worldStates[platform].getAllPersistentEnemies (err, enemies) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedEnemyIds = robot.brain.get('notifiedEnemyIds' + platform) or []
      robot.brain.set 'notifiedEnemyIds' + platform, (e.id for e in enemies)

      for e in enemies when e.id not in notifiedEnemyIds
        broadcast  md.codeMulti+e.toString()+md.blockEnd,
          items: 'enemies'
          platform: platform
        , robot, userDB
      return

checkBaro = (robot, userDB, platform) ->
  ###
  # Check for unread Baro Ki'Teer notifications and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking Baro (' + platform + ')...'  
  worldStates[platform].getVoidTrader (err, baro) ->
    if err
      robot.logger.error err
    else
      if baro?
        # IDs are saved in robot.brain
        notifiedBaroId = robot.brain.get('notifiedBaroId' + platform) or ''
        robot.brain.set 'notifiedBaroId' + platform, baro.id

        if (baro != null && baro.id != notifiedBaroId)
          broadcast baro.toString(),
            items: 'baro'
            platform: platform
          , robot, userDB
        return

checkDarvo = (robot, userDB, platform) ->
  ###
  # Check for unread Darvo Daily Deals notifications and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking Darvo (' + platform + ')...'
  worldStates[platform].getDeals (err, deals) ->
    if err
      return robot.logger.error err
    else
      if deals?
        # IDs are saved in robot.brain
        notifiedDarvoIds = robot.brain.get('notifiedDarvoIds' + platform) or []
        robot.brain.set 'notifiedDarvoIds' + platform, (d.id for d in deals)

        for d in deals when d.id not in notifiedDarvoIds
          broadcast md.codeMulti+d.toString()+md.blockEnd,
            items: 'darvo'
            platform: platform
          , robot, userDB
        return


checkConclaveDailies = (robot, userDB, platform) ->
  ###
  # Check for unread conclave daily challenges and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking conclave daily challenges (' + platform + ')...'
  worldStates[platform].getConclaveDailies (err, challenges) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedDailyConclaveIds = robot.brain.get('notifiedDailyConclaveIds' + platform) or []
      robot.brain.set 'notifiedDailyConclaveIds' + platform, (c.id for c in challenges)

      for c in challenges when c.id not in notifiedDailyConclaveIds
        broadcast  md.codeMulti+c.toString(true)+md.blockEnd,
          items: 'conclave.dailies'
          platform: platform
        , robot, userDB
      return
    
checkConclaveWeeklies = (robot, userDB, platform) ->
  ###
  # Check for unread conclave weekly challenges and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking conclave daily challenges (' + platform + ')...'
  worldStates[platform].getConclaveWeeklies (err, challenges) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedWeeklyConclaveIds = robot.brain.get('notifiedWeeklyConclaveIds' + platform) or []
      robot.brain.set 'notifiedWeeklyConclaveIds' + platform, (c.id for c in challenges)

      for c in challenges when c.id not in notifiedWeeklyConclaveIds
        broadcast  md.codeMulti+c.toString(true)+md.blockEnd,
          items: 'conclave.weeklies'
          platform: platform
        , robot, userDB
      return
    
checkSyndicateArbiters = (robot, userDB, platform) ->
  ###
  # Check for unread conclave weekly challenges and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking Arbiters of Hexis Missions (' + platform + ')...'
  worldStates[platform].getArbitersOfHexisMissions (err, mission) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedArbitersId = robot.brain.get('notifiedArbitersId' + platform) or ''
      robot.brain.set 'notifiedArbitersId' + platform, mission.id
      if(mission != null && mission.id != notifiedArbitersId)
        broadcast  md.codeMulti+mission.toString()+md.blockEnd,
          items: 'syndicate.arbiters'
          platform: platform
        , robot, userDB
      return
checkSyndicateSuda = (robot, userDB, platform) ->
  ###
  # Check for unread Cephalon Suda missions and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking Cephalon Suda Missions (' + platform + ')...'
  worldStates[platform].getCephalonSudaMissions (err, mission) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedSudaId = robot.brain.get('notifiedSudaId' + platform) or ''
      robot.brain.set 'notifiedSudaId' + platform, mission.id
      if(mission != null && mission.id != notifiedSudaId)
        broadcast  md.codeMulti+mission.toString()+md.blockEnd,
          items: 'syndicate.suda'
          platform: platform
        , robot, userDB
      return
    
checkSyndicateLoka = (robot, userDB, platform) ->
  ###
  # Check for unread New Loka missions and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking New Loka Missions (' + platform + ')...'
  worldStates[platform].getNewLokaMissions (err, mission) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedLokaId = robot.brain.get('notifiedLokaId' + platform) or ''
      robot.brain.set 'notifiedLokaId' + platform, mission.id

      if(mission != null && mission.id != notifiedLokaId)
        broadcast  md.codeMulti+mission.toString()+md.blockEnd,
          items: 'syndicate.loka'
          platform: platform
        , robot, userDB
      return
checkSyndicatePerrin = (robot, userDB, platform) ->
  ###
  # Check for unread Perrin Sequence missions and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking Perrin Sequence Missions (' + platform + ')...'
  worldStates[platform].getPerrinSequenceMissions (err, mission) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedPerrinId = robot.brain.get('notifiedPerrinId' + platform) or ''
      robot.brain.set 'notifiedPerrinId' + platform, mission.id

      if(mission != null && mission.id != notifiedPerrinId)
        broadcast  md.codeMulti+mission.toString()+md.blockEnd,
          items: 'syndicate.perrin'
          platform: platform
        , robot, userDB
      return
checkSyndicateRedVeil = (robot, userDB, platform) ->
  ###
  # Check for unread Red Veil Missions and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking Red Veil Missions (' + platform + ')...'
  worldStates[platform].getRedVeilMissions (err, mission) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedRedVeilId = robot.brain.get('notifiedRedVeilId' + platform) or ''
      robot.brain.set 'notifiedRedVeilId' + platform, mission.id

      if(mission != null && mission.id != notifiedRedVeilId)
        broadcast  md.codeMulti+mission.toString()+md.blockEnd,
          items: 'syndicate.veil'
          platform: platform
        , robot, userDB
      return
checkSyndicateMeridian = (robot, userDB, platform) ->
  ###
  # Check for unread Steel Meridian missions and notify them to subscribed users from userDB
  #
  # @param object robot
  # @param object userDB
  # @param string platform
  ###
  robot.logger.debug 'Checking Steel Meridian Missions (' + platform + ')...'
  worldStates[platform].getSteelMeridianMissions (err, mission) ->
    if err
      return robot.logger.error err
    else
      # IDs are saved in robot.brain
      notifiedMeridianId = robot.brain.get('notifiedMeridianId' + platform) or ''
      robot.brain.set 'notifiedMeridianId' + platform, mission.id

      if(mission != null && mission.id != notifiedMeridianId)
        broadcast  md.codeMulti+mission.toString()+md.blockEnd,
          items: 'syndicate.meridian'
          platform: platform
        , robot, userDB
      return
    
    
broadcast = (message, query, robot, userDB) ->
  ###
  # Broadcast a message to all subscribed users that match a query
  #
  # @param string message
  # @param object query
  # @param object robot
  # @param object userDB
  ###
  robot.logger.debug 'Broadcasting to: %s', util.inspect(query, {depth: null})
  userDB.broadcast query, (err, chatID) ->
    if err
      return robot.logger.error err
    else
      robot.messageRoom chatID, message