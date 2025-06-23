spamspamspam:
    type: world
    debug: false
    events:
        after discord message received channel:1263518523074941032 for:magbungkal:
        - define description <context.new_message.text>
        - definemap embed_map:
            color: orange
            description: <[description]>
            # footer: <[author]> @ play.magbungkal.net
            # footer_icon: <[footer_icon]>
        - define embed <discord_embed.with_map[<[embed_map]>]>
        - ~discordmessage id:magbungkal channel:1182320011759603826 <[embed].with[color].as[#7C4751]>