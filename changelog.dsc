MagbungkalChangelogs:
    type: world
    debug: false
    events:
        after discord message received channel:1210587415643947028 for:magbungkal:
        - define description <context.new_message.text>
        - define author <context.new_message.author.name>
        - define footer_icon <context.new_message.author.avatar_url>
        - define version <server.flag[update_version]>
        - definemap embed_map:
            title: Patch Notes v<util.time_now.month>.<[version]>
            color: <&color[#7C4751]>
            description: "<[description]>"
            footer: Magbungkal.net - Development Team (<[author]>)
            footer_icon: <[footer_icon]>
        - define embed <discord_embed.with_map[<[embed_map]>]>
        - ~discordmessage id:magbungkal channel:1182349787576684664 "<discord_role[magbungkal,1126475444837949500,1143936995291316234].mention> - <util.time_now.format_discord>" embed:<[embed]>
        - flag server update_version:++