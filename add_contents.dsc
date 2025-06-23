add_contents:
    type: world
    debug: false
    events:
        after discord message received channel:1197743297431605379 for:magbungkal:
        - define description <context.new_message.text>
        - define author <context.new_message.author.name>
        - define footer_icon <context.new_message.author.avatar_url>
        - define role <discord_role[magbungkal,1126475444837949500,1182533680342777947]>


        - definemap button_map:
            1:
              style: link
              id: <[description]>
              label: Click to go to stream

        - define button_list <list>
        - foreach <[button_map]>:
           - define my_button <discord_button.with_map[<[value]>]>
           - define button_list:->:<[my_button]>
        - ~discordmessage id:magbungkal channel:1182342605921587261 rows:<list_single[<[button_list]>]> "<[role].mention> **<[author].to_uppercase>** is currently streaming Magbungkal.net - **__[Watch the stream here!](<[description]>)__**<n><n>"
