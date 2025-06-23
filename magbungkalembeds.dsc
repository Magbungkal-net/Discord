discord_message_ip:
    type: world
    debug: false
    events:
        after discord message received:
        - define message <context.new_message>
        - define user <[message].author>
        - define text <[message].text>
        - define emoji 1146697542046859294
        - stop if:<[user].is_bot>
        - definemap embed_map:
             color: orange
             description: **Magbungkal**<n> __**play.magbungkal.net**__
        - define embed <discord_embed.with_map[<[embed_map]>]>
        - if <[text].contains[!ip]>:
            - discordmessage id:magbungkal embed:<discord_embed[title=hi;description=this is an embed!]>