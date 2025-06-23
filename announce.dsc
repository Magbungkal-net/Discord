MagbungkalAnnouncement:
    type: world
    debug: false
    events:
        after discord message received channel:1380917352480116866 for:magbungkal:
        - define description <context.new_message.text>
        - define author <context.new_message.author.name>
        - define footer_icon <context.new_message.author.avatar_url>
        - define version <server.flag[update_version]>
        - definemap embed_map:
            title: ANNOUNCEMENT
            thumbnail: https://media.discordapp.net/attachments/1142368712461135963/1321706135132311626/Magbungkal_new_logo_PNG_Transparent.png?ex=683fd4c2&is=683e8342&hm=c5cc754c2588272bf9ade9d98b3b43836504243f38295298e18472bc0cdc2e5e&=&format=webp&quality=lossless&width=960&height=960
            color: <&color[#7C4751]>
            description: "<[description]>"
            footer: Regards, <[author]>
            footer_icon: <[footer_icon]>
        - define embed <discord_embed.with_map[<[embed_map]>]>
        - ~discordmessage id:magbungkal channel:1126812180814241822 "<discord_role[magbungkal,1126475444837949500,1182513726914580483].mention> - <util.time_now.format_discord>" embed:<[embed]>
        - flag server update_version:++