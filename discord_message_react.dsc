discord_message_react:
    type: world
    debug: false
    events:
        after discord message received:
        - define message <context.new_message>
        - define user <[message].author>
        - define text <[message].text>
        # magbungkal emoji
        - define emoji 1265691405586796614
        # warning emoji
        - define warning-yellow.emoji 1268067220412694560
        - define exclamation.emoji 1268067207007440917
        - stop if:<[user].is_bot>
        - if <[text].contains[magbungkal]>:
            - ~discordreact id:magbungkal message:<[message]> add reaction:<[emoji]>
        - if <[text].contains[steamcommunity]>:
            - ~discordreact id:magbungkal message:<[message]> add reaction:<[warning-yellow.emoji]>
            - ~discordreact id:magbungkal message:<[message]> add reaction:<[exclamation.emoji]>
            - wait 3s
            - adjust <[message]> delete