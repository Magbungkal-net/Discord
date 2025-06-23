DiscordAutoMod:
    type: world
    debug: false
    events:
        after discord message received:
        - define message <context.new_message>
        - define user <[message].author>
        - define text <[message].text>
        - define data <script[discordautomoddata].parsed_key[words]>
        - define words <[data].parsed>
        - if <[text].contains_any_case_sensitive_text[<[data]>]>:
          - stop if:<[user].roles[1142516104518967397]>
          - stop if:<[user].is_bot>
          - define dont_use_message <script[discordautomoddata].parsed_key[messages].get[dont-use]>
          - define dont_use.embed <discord_embed.with_map[<[dont_use_message]>]>
          - discordmessage id:magbungkal reply:<[message]> <[dont_use.embed]>
          # timeout the user
          - discordtimeout id:magbungkal user:<[user]> group:1126475444837949500 "reason:Was using bad words" duration:30s
          # send to discord logs
          - define player-punish.message <script[discordautomoddata].parsed_key[messages].get[player-punish]>
          - define player-punish.embed <discord_embed.with_map[<[player-punish.message]>]>
          - discordmessage id:magbungkal channel:1263705307733823533 <[player-punish.embed]>
          # send to user
          - define player-punish-user.message <script[discordautomoddata].parsed_key[messages].get[player-punish-user]>
          - define player-punish-user.embed <discord_embed.with_map[<[player-punish-user.message]>]>
          - discordmessage id:magbungkal user:<[user]> <[player-punish-user.embed]>
DiscordAutoModData:
    type: data
    messages:
      dont-use:
        title: Hey do not use that word here!
        color: maroon
      player-punish:
        title: Mute Notice
        thumbnail: <[user].avatar_url>
        description: **<[user].name>** has been muted for 1 minute by Bot because message contained inappropriate language. listed here: https://logs.magbungkal.net/ekixubusol.md
        color: gray
      player-punish-user:
        title: Mute Notice
        thumbnail: <[user].avatar_url>
        description: Hey <[user].mention>, <n><n>You have been muted for 10 minutes by the Bot of Magbungkal.net because your message contained inappropriate language.<n><n>**Message:** <[text]><n>
      role-staff: 1131569003068936252
      magbungkal-discord: 1142516104518967397
    words:
    - putangina
    - tanginamo
    - fuck
    - nigger
    - shit
    - arsehead
    - asshole
    - bastard
    - bitch
    - bollocks
    - brotherfucker
    - bugger
    - bullshit
    - christ on bike
    - christ on a cracker
    - cock
    - cocksucker
    - cunt
    - dammit
    - damn
    - damnit
    - dick
    - dick-head
    - dickhead
    - dumbass
    - dumb ass
    - dipshit
    - focc
    - foccing
    - father-fucker
    - fatherfucker
    - frigger
    - fuck
    - fucker
    - fucking
    - god dammit
    - god damn
    - goddammit
    - gyatt
    - gae
    - goodshit
    - goodfuckingshit
    - holyshit
    - holy shit
    - horseshit
    - in shit
    - inshit
    - jizz
    - jack-ass
    - kike
    - milf
    - mother fucker
    - mother-fucker
    - motherfucker
    - nigger
    - nigga
    - niger
    - nigra
    - pigfucker
    - piss
    - prick
    - pussy
    - shit
    - shit ass
    - sibling fucker
    - sisterfuck
    - sisterfucker
    - slut
    - son of a whore
    - son a bitch
    - sex
    - seggs
    - twat
    - vulshit
    - vitch
    - wanker
    - antanga
    - bobo
    - boboka
    - boboamp
    - bano
    - bonak
    - butaw
    - cantotan
    - d3d3
    - ekup
    - engot
    - futangina
    - futanginamo
    - fakyou
    - fakyu
    - gago
    - gagoka
    - gagoamp
    - hutangina
    - inang yan
    - ina mo
    - inangyan
    - jakol
    - jabol
    - jabolero
    - jakolero
    - kipay
    - k@ntot
    - kantot
    - kantutan
    - kantotan
    - kingina
    - kinginang yan
    - laspag
    - laspagin
    - mangkanor
    - naglo-lo na
    - nyeta
    - onanay
    - puke
    - pota
    - punyeta
    - punyemas
    - pakyu
    - putangina
    - puta
    - pakeningshit
    - p0ta
    - pot@
    - pepe
    - posangina
    - pukingina
    - pukinangina
    - shet
    - tite
    - tangna
    - tangina
    - tangnang
    - tanginang
    - tang1na
    - tang1nang
    - T@nga
    - tarantado
    - tongina
    - ukininam
    - vakla
    - walwal
    - xoxo
    - yawa
    - zex
    - zeggs
