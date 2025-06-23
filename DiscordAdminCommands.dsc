DiscordAdminCommandsData:
    type: data
    messages:
        no-username:
            color: orange
            title: Enter a username!
        no-permission:
            color: maroon
            title: ❌ You are not authorized to use this command
        success-message:
            color: lime
            title: ✔️ Successfully given to <[player]>
        not-recognize:
            color: maroon
            title: ❌ You are not authorized to use this command
    admin-role: 1131569003068936252

DiscordAdminCommands:
    type: world
    debug: false
    events:
        after discord message received:
        - define message <context.new_message>
        - define channel <context.channel>
        - define group <context.group>
        - define user <[message].author>
        - define text <[message].text>
        - define avatar <[user].avatar_url>
        - define exp <util.random.int[100].to[500]>
        - flag <[user]> level_xp:+:<[exp]>
        - stop if:<[user].is_bot>
        - stop if:<discord_user[1151705545619816468]>

        # command for giving coins
        - define admin-role <script[discordadmincommandsdata].data_key[admin-role]>
        - define coins asddad

        - if <[text].starts_with[!magbungkalcoins]> && <[user].roles[<[group]>].parse[id].contains[<[admin-role]>]>:
            - if <[text].split.size> <= 1:
                - define no-username <script[discordadmincommandsdata].parsed_key[messages].get[no-username]>
                - define embed <discord_embed.with_map[<[no-username]>]>
                - discordmessage id:magbungkal reply:<[message]> <[embed]>
                - stop
            - define player <server.match_offline_player[<[text].split.get[2]>].if_null[null]>
            - if <[player]> == null:
                - define not-recognize <script[discordadmincommandsdata].parsed_key[messages].get[not-recognize]>
                - define embed <discord_embed.with_map[<[no-username]>]>
                - discordmessage id:magbungkal reply:<[message]> <[embed]>
                - stop

        - if <[text].starts_with[!magbungkalcoins]> && !<[user].roles[<[group]>].parse[id].contains[<[admin-role]>]>:
            - if <[text].split.size> <= 1:
                - define no-permission <script[discordadmincommandsdata].parsed_key[messages].get[no-permission]>
                - define embed <discord_embed.with_map[<[no-permission]>]>
                - discordmessage id:magbungkal reply:<[message]> <[embed]>
                - stop