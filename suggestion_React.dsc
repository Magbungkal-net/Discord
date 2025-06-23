suggestionreact:
    type: world
    debug: false
    events:
        after discord message received:
        - define message <context.new_message>
        - define user <[message].author>
        - define text <[message].text>
        - define emoji 1210597270932951111
        - stop if:<[user].is_bot>
        - if <[text].contains[!suggest]>:
            - ~discordreact id:magbungkal message:<[message]> add reaction:<[emoji]>
            
            