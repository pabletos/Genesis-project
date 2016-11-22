var util = require('util');
var md = require('node-md-config');
const Wikia = require('node-wikia');
const warframe = new Wikia('warframe');

/**
 * Converts the difference between two Date object to a String.
 * Convenience function
 *
 * @param {integer} millis  Difference in milliseconds between the two dates
 *
 * @return {string}
 */
module.exports.timeDeltaToString = function (millis) {
  var seconds = millis / 1000;
  var timePieces = [];

  if (seconds >= 86400) { // Seconds in a day
    timePieces.push(util.format('%dd', Math.floor(seconds / 86400)));
    seconds = Math.floor(seconds) % 86400;
  }
  if (seconds >= 3600) { // Seconds in an hour
    timePieces.push(util.format('%dh', Math.floor(seconds / 3600)));
    seconds = Math.floor(seconds) % 3600;
  }
  if(seconds > 60){
    timePieces.push(util.format('%dm', Math.floor(seconds/60)));
    seconds = Math.floor(seconds) % 60;
  }
  if(seconds > 0)
  {
    timePieces.push(util.format('%ds', Math.floor(seconds)));
  }
  return timePieces.join(' ');
};

module.exports.damageReduction = function (currentArmor) {
  var damageRes = (parseFloat(currentArmor) / (parseFloat(currentArmor) + 300) * 100).toFixed(2);
  return util.format("%d% damage reduction", damageRes);
};

module.exports.armorFull = function (baseArmor, baseLevel, currentLevel) {
  var armor = (parseFloat(baseArmor) * (1 + (Math.pow((parseFloat(currentLevel) - parseFloat(baseLevel)),1.75) / 200))).toFixed(2);
  var armorString = util.format("At level %s your enemy would have %d Armor %s %s", 
                     parseFloat(currentLevel).toFixed(0), armor, md.lineEnd, 
                     this.damageReduction(armor))

  return util.format('%s %s %s', armorString, md.lineEnd, this.armorStrip(armor))
};

module.exports.armorStrip = function (armor) {
  var armorStripValue = 8*Math.log10(parseInt(armor)).toFixed(2);
  
  return util.format("You will need %d corrosive procs to strip your enemy of armor.", Math.ceil(armorStripValue));
};

module.exports.shieldCalc = function(baseShields, baseLevel, currentLevel) {    
    return (parseFloat(baseShields) + (Math.pow(parseFloat(currentLevel)-parseFloat(baseLevel), 2) * 0.0075 * parseFloat(baseShields))).toFixed(2);
};

module.exports.shieldString = function(shields, level) {
  return util.format("%sAt level %s, your enemy would have %d Shields.%s", md.codeMulti, parseFloat(level).toFixed(0), shields, md.blockEnd)
}

module.exports.stringsPath = process.env.HUBOT_WARFRAME_LANG_PATH || '../../resources/dataFiles/languages.json';

module.exports.modSearch = function (query) { 
  return new Promise(function(resolve, reject){
    const Wikia = require('node-wikia');
        const warframe = new Wikia('warframe');
        warframe.getSearchList({
            query: query,
            limit: 1
          })
          .then((json) => {
            const id = json.items[0].id;
            warframe.getArticleDetails({
                ids: [id]
              })
              .then((json) => {
                 let thumbUrl = json.items[`${id}`].thumbnail;
                 thumbUrl = thumbUrl.replace(/\/revision\/.*/, '');
                 warframe.getArticlesList({
                     category: "Mods",
                     limit: 1000
                 })
                 .then((list) => {
                     var sent = false;
                     const items = list.items;
                     for(var i in items){
                         if(items[i].id === id){
                             sent = true;
                             resolve(thumbUrl);
                         }
                     }
                     if(!sent){
                         resolve(`${md.codeMulti}No result for search, Operator. Attempt another search query.${md.blockEnd}`);
                     }
                 })
                 .catch((error) => {
                   console.warn(error);
                   resolve(`${md.codeMulti}No result for search, Operator. Attempt another search query.${md.blockEnd}`);
                 });
              })
              .catch((error) => {
                 console.warn(error);
                 resolve(`${md.codeMulti}No result for search, Operator. Attempt another search query.${md.blockEnd}`);
              });
          })
          .catch((error) => {
             console.warn(error);
             resolve(`${md.codeMulti}No result for search, Operator. Attempt another search query.${md.blockEnd}`);
           });
    });
}

module.exports.wikiSearch = function (query) { 
  return new Promise(function(resolve, reject){
    const Wikia = require('node-wikia');
    const warframe = new Wikia('warframe');
    warframe.getSearchList({
        query: query,
        limit: 1
      })
      .then((json) => {
        if(json.items[0]){
          resolve(`${md.linkBegin}${json.items[0].title}${md.linkMid}${json.items[0].url}${md.linkEnd}`);
        } else {
          resolve(`${md.codeMulti}No result for search, Operator. Attempt another search query.${md.blockEnd}`);
        }
      })
      .catch((error) => console.warn(error));
    });
}