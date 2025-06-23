spamrules:
    type: world
    debug: false
    events:
        after discord message received channel:1321697952862834758 for:magbungkal:
        - define description <context.new_message.text>
        - definemap embed_map:
            title: Thank you for reading our rules!
            description: <[description]>
            footer: Magbungkal.net
            footer_icon: https://media.discordapp.net/attachments/1142368712461135963/1321706135132311626/Magbungkal_new_logo_PNG_Transparent.png?ex=676e3642&is=676ce4c2&hm=2b730a117fb122bfa2af3811fe2d461c8dd88bc80ba15b016a6eeb166952ab7a&=&format=webp&quality=lossless&width=671&height=671
        - define embed <discord_embed.with_map[<[embed_map]>]>
        - ~discordmessage id:magbungkal channel:1131506911330705458 <[embed].with[color].as[#7C4751]>