![Genesis Avatar](resources/images/cephalontransparent.png)

#Hubot-Warframe
A [Hubot](https://hubot.github.com/) module for tracking Warframe alerts, invasions and more.

[![Build Status](https://travis-ci.org/pabletos/Hubot-Warframe.svg)](https://travis-ci.org/pabletos/Hubot-Warframe)

[![Try hubot-warframe on Discord!](https://discordapp.com/api/servers/146691885363232769/widget.png?style=banner)](https://discord.me/cephalon-genesis)  

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
`hubot start` | `/start/` | Adds user to DB and starts tracking
`hubot alerts` | `/alerts/` | Displays active alerts
`hubot baro` | `/baro/` | Displays current Baro Ki'Teer status/inventory
`hubot darvo` | `/darvo/` | Displays current Darvo Daily Deal
`hubot end` | `/end/` | Hide custom keyboard (telegram only)
`hubot invasions` | `/invasions/` | Displays current Invasions
`hubot news` | `/news/` | Displays news
`hubot platform <platform>` | `/platform\s*(\w+)?/` | Changes the platform
`hubot platform` | `/platform\s*(\w+)?/` | Displays menu
`hubot settings` | `/settings/` | Display settings menu
`hubot stop` | `/stop/` | Turn off notifications
`hubot track <reward or event>` | `/track\s*(\w+)?/` | Start tracking reward or event
`hubot track` | `/track\s*(\w+)?/` | Tracking menu
`hubot untrack <reward or event>` | `/untrack\s+(\w+)/` | Stop tracking reward or event
`hubot simaris` | `/simaris/` | Get Synthesis target tracking
`hubot update` | `/update/` | Display current update
`hubot primeaccess` | `/primeaccess/` | Display current Prime Access news
`hubot damage` | `/damage/` | Display link to Damage 2.0 infographic
`hubot armor`  | `/armor(?:\s+([\d\s]+))?/` | Display instructions for calculating armor
`hubot armor <current armor>` | `/armor(?:\s+([\d\s]+))?/`  | Display current damage resistance and amount of corrosive procs required to strip it
`hubot armor <base armor> <base level> <current level>` | `/armor(?:\s+([\d\s]+))?/` |  Display the current armor, damage resistance, and necessary corrosive procs to strip armor.
`hubot shield`  | `/shield(?:\s+([\d\s]+))?/` | Display instructions for calculating armor
`hubot shield <base shield> <base level> <current level>` | `/shield(?:\s+([\d\s]+))?/` |  Display the current shields.
`hubot conclave` | `/conclave(?:\s+([\w+\s]+))?/` | Display usage for conclave command
`hubot conclave all` | `/conclave(?:\s+([\w+\s]+))?/` | Display all conclave challenges
`hubot conclave daily` | `/conclave(?:\s+([\w+\s]+))?/` | Display active daily conclave challenges
`hubot conclave weekly` | `/conclave(?:\s+([\w+\s]+))?/` | Display active weekly conclave challenges
`hubot enemies` | `/enemies/` | Display list of active persistent enemies where they were last found
`hubot sortie` | `/sortie/` | Display current sortie missions
`hubot chart` | `/chart/` | Display mission progression chart
`hubot tutorial <topic>` | `/tutorial\s?(.+)/` | Display link to topic's tutorial video
`hubot profile <warframe>` | `/profile\s?(.+)/` | Display link to warframe profile video

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
