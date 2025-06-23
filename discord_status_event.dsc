discord_status_event:
    type: world
    debug: false
    events:
        after discord message received channel:1210587395758759996 for:magbungkal:
        - define description <context.new_message.text>
        - define author <context.new_message.author.name>
        - define footer_icon <context.new_message.author.avatar_url>
        - define version <server.flag[update_version]>
        - define timestamp <util.time_now.format_discord[R]>
        - narrate <util.time_now.format_discord[R]>
        - definemap embed_map:
            author_name: Supporter Rewards
            author_icon_url: https://i.imgur.com/vhI4Qyz.png
            color: orange
            description: "> <[description]>"
            #footer: by <[author]>
            #footer_icon: <[footer_icon]>
        - define embed <discord_embed.with_map[<[embed_map]>]>
        - ~discordmessage id:magbungkal channel:1182318611088552026 <[embed]>
        - flag server update_version:++