![Genesis Avatar](resources/images/cephalontransparent.png)

#Hubot-Warframe
A [Hubot](https://hubot.github.com/) module for tracking Warframe alerts, invasions and more.

[![Build Status](https://travis-ci.org/pabletos/Hubot-Warframe.svg)](https://travis-ci.org/pabletos/Hubot-Warframe)

[![Try hubot-warframe on Discord!](https://img.shields.io/badge/Discord-Genesis-7289DA.svg)](https://discord.me/cephalon-sanctuary)  

[![Try hubot-warframe on Telegram!](https://img.shields.io/badge/Telegram-Beta%20War%20Bot-279DD8.svg)](https://telegram.me/betawarbot)

## Installation via NPM

1. Install the __Hubot-Warframe__ module as a Hubot dependency by running:

    ```
    npm install --save hubot-warframe
    ```

2. Add this to your `external-scripts.json` file:

    ```json
    [
        "hubot-warframe"
    ]
    ```

3. Run your bot and see below for available config / commands

## Configuration

hubot-warframe requires a MongoDB server. It uses the **MONGODB_URL** environment variable for determining where to connect to

Environment Variable | Description | Example
--- | --- | ---
MONGODB_URL | connection url for mongodb (REQUIRED) | `mongodb://<host>:<port>/<database>`
HUBOT_WARFRAME_LANG_PATH | Define the path to the languages.json in order to allow a custom string set to be defined. This will default to the included `languages.json` included with the module. (OPTIONAL) | `./languages.json`

## Commands

Command | Listener ID | Description
--- | ------- | ---
`hubot alerts` | `hubot-warframe.alerts` | Displays active alerts
`hubot baro` | `hubot-warframe.baro` | Displays current Baro Ki'Teer status/inventory
`hubot start` | `hubot-warframe.start` | Adds user to DB and starts tracking
`hubot armor`  | `hubot-warframe.armor` | Display instructions for calculating armor
`hubot armor <current armor>` | `hubot-warframe.armor`  | Display current damage resistance and amount of corrosive procs required to strip it
`hubot armor <base armor> <base level> <current level>` | `hubot-warframe.armor` |  Display the current armor, damage resistance, and necessary corrosive procs to strip armor.
`hubot bonus` | `hubot-warframe.bonus` | Display the current Bonus Weekend modifier if there is one
`hubot chart` | `hubot-warframe.chart` | Display mission progression chart
`hubot conclave` | `hubot-warframe.conclave` | Display usage for conclave command
`hubot conclave all` | `hubot-warframe.conclave` | Display all conclave challenges
`hubot conclave daily` | `hubot-warframe.conclave` | Display active daily conclave challenges
`hubot conclave weekly` | `hubot-warframe.conclave` | Display active weekly conclave challenges
`hubot cycle` | `hubot-warframe.cycle` | Display the current day/night cycle for Earth and tell you how much time is left.
`hubot damage` | `hubot-warframe.damage` | Display link to Damage 2.0 infographic
`hubot darvo` | `hubot-warframe.darvo` | Displays current Darvo Daily Deal
`hubot end` | `hubot-warframe.end` | Hide custom keyboard (telegram only)
`hubot enemies` | `hubot-warframe.enemies` | Display list of active persistent enemies where they were last found
`hubot fissures` | `hubot-warframe.fissures` | List of fissures
`hubot flash deals`|`hubot-warframe.flashdeals`| Display list of currently active flash deals
`hubot frame profile <warframe>` | `hubot-warframe.profile` | Display link to warframe profile video
`hubot invasions` | `hubot-warframe.invasions` | Displays current Invasions
`hubot news` | `hubot-warframe.news` | Displays news
`hubot platform <platform>` | `hubot-warframe.platform` | Changes the platform
`hubot platform` | `hubot-warframe.platform/` | Displays menu
`hubot pc/price check/pricecheck <item or mod>` | `hubot-warframe.pricecheck` | Display nexus-stats.com data for a particular item.
`hubot primeaccess` | `hubot-warframe.primeaccess` | Display current Prime Access news
`hubot settings` | `hubot-warframe.settings` | Display settings menu
`hubot simaris` | `hubot-warframe.simaris` | Get Synthesis target tracking
`hubot shield`  | `hubot-warframe.shield` | Display instructions for calculating armor
`hubot shield <base shield> <base level> <current level>` | `hubot-warframe.shield` |  Display the current shields given the data.
`hubot sortie` | `hubot-warframe.sortie` | Display current sortie missions
`hubot stop` | `hubot-warframe.stop` | Turn off notifications
`hubot track <reward or event>` | `hubot-warframe.track` | Start tracking reward or event
`hubot track` | `hubot-warframe.track` | Tracking menu
`hubot tutorial <topic>` | `hubot-warframe.tutorial` | Display link to topic's tutorial video
`hubot untrack <reward or event>` | `hubot-warframe.untrack` | Stop tracking reward or event
`hubot update` | `hubot-warframe.update` | Display current update
`hubot where (is) <item>` | `hubot-warframe.where` | Display list of locations for requested item


## Sample Interaction

```
user1>> /start

hubot>> Tracking started

user1>> /settings

hubot>> 
Your platform is PC
Alerts are OFF
Invasions are OFF
News are OFF

Tracked rewards:
Alternative helmets
ClanTech resources
Nightmare Mods
Auras
Resources
Nitain Extract
Void Keys
Weapon skins
Weapons
Other rewards

user1>> /end

hubot>> Done

```
