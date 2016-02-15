var util = require('util');
var dsUtil = require('./_utils.js');
var Reward = require('./reward.js');

/** Create a new alert instance
 *
 * @constructor
 * @param {object} data Alert data
 */
var Alert = function(data) {
  this.id = data.id;
  this.activation = new Date(1000 * data.Activation.sec);
  this.expiry = new Date(1000 * data.Expiry.sec);
  this.desctiption = data.MissionInfo.descText;
  this.location = data.MissionInfo.location;
  this.missionType = data.MissionInfo.missionType;
  this.faction = data.MissionInfo.faction;
  this.minLevel = data.MissionInfo.minEnemyLevel;
  this.maxLevel = data.MissionInfo.maxEnemyLevel;
  this.nightmare = data.MissionInfo.nightmare;
  this.archwing = data.MissionInfo.archwingRequired;

  this.reward = new Reward({
    items: data.MissionInfo.missionReward.items,
    countedItems: data.MissionInfo.missionReward.countedItems,
    credits: data.MissionInfo.missionReward.credits
  });
}

/**
 * Return a string representation of this alert object
 *
 * @return {string} The new string object
 */
Alert.prototype.toString = function() {
  var alertString = util.format('%s\n' +
                                '%s (%s)\n' +
                                '%s\n' +
                                'level %d - %d\n' +
                                'Expires in %s'+
                                '\n--------------------',
                                this.location, this.missionType, this.faction,
                                this.reward.toString(), this.minLevel,
                                this.maxLevel, this.getETAString());

  return alertString;
}

/**
 * Return a string containing the alert's ETA
 *
 * @return {string} The new string object
 */
Alert.prototype.getETAString = function() {
  return dsUtil.timeDeltaToString(this.expiry.getTime() - Date.now());
}

/**
 * Returns an array of strings each representing a reward type
 * Empty for credit only alerts
 *
 * @return {array} The reward type array
 */
Alert.prototype.getRewardTypes = function() {
  return this.reward.getTypes();
}

/** Returns true if the alert has expired, false otherwise
 *
 * @return {boolean} Expired-ness of the alert
 */
Alert.prototype.isExpired = function() {
  return this.expiry.getTime() < Date.now();
}

module.exports = Alert;
