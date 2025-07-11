# register the ticket command
discord_ticket_command_reg:
    type: task
    debug: false
    script:
    - define group <script[discord_ticket_config].data_key[group-id]>
    - define msg_command <script[discord_ticket_config].data_key[msg-command]>
    - define command_desc <script[discord_ticket_config].data_key[msg-command-desc]>
    - ~discordcommand id:magbungkal create group:<[group]> name:<[msg_command]> description:<[command_desc]>


discord_ticket_events_handler:
    type: world
    debug: false
    events:
        #
        # handles the generation of the support msg
        #
        on discord slash command:
        - define interaction <context.interaction>
        - define command <script[discord_ticket_config].data_key[msg-command]>
        - define command_name <context.command.name>
        - if <[command]> == <[command_name]>:
            # check if user has allowed roles
            - define user <[interaction].user>
            - define group <script[discord_ticket_config].data_key[group-id]>
            - define msg_command_roles <script[discord_ticket_config].data_key[msg-command-roles]>
            - if !<[msg_command_roles].contains_any[<[user].roles[<[group]>].parse[id]>]>:
                - ~discordinteraction reply interaction:<[interaction]> "You're not allowed to use this command"
                - stop
            - ~discordinteraction defer interaction:<[interaction]>

            # main msg for ticket
            - define msg_data <script[discord_ticket_config].parsed_key[messages].get[main]>
            - define msg_embed <discord_embed.with_map[<[msg_data]>].with[color].as[#7C4751]>

            # generate buttons
            - define buttons <script[discord_ticket_config].parsed_key[buttons]>
            - define rows <map>
            - foreach <[buttons]> as:button:
                - define index <[loop_index]>
                - define button <discord_button.with_map[<[button]>]>
                - define rows <[rows].include[<[index]>=<[button]>]>
            - define rows <map[1=<[rows]>]>

            - announce to_console <[rows].to_yaml>

            - define channel <[interaction].channel>
            - ~discordmessage id:magbungkal channel:<[channel]> <[msg_embed]> rows:<[rows]>

            - ~discordinteraction delete interaction:<[interaction]>


        #
        # handles the logging for transcript
        #
        after discord message received:
        - define channel <context.channel>
        - define message <context.new_message>
        - define text <[message].text>
        - define user <[message].author>
        - stop if:<[user].is_bot>
        - stop if:!<[channel].has_flag[discord_ticket]>

        - define name <[user].name>
        - define text <[message].text>
        - define transcript_format "<util.time_now.format> <[name]>: <[text]>"
        - flag <[channel]> discord_transcript:->:<[transcript_format]>
        - define ticket_creator <[channel].flag[ticket_creator]>

        - wait 1t
        - define group <script[discord_ticket_config].data_key[group-id]>
        - define ticket_helper_role <script[discord_ticket_config].data_key[ticket-helper-role]>

        - if <[text].starts_with[!close]> && <[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
            - flag <[channel]> ticket_closer:<[user]>
            - flag <[channel]> ticket_closer_name:<[user].mention>
            - inject discord_ticket_close

        - if <[text].starts_with[!close]> && !<[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
            - define no.permission <script[discord_ticket_config].parsed_key[messages].get[no-permission]>
            - define no.permission_embed <discord_embed.with_map[<[no.permission]>]>
            - discordmessage id:magbungkal reply:<[message]> <[no.permission_embed]>

        - if <[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
          - adjust <[channel]> name:Awaiting-Response-<[ticket_creator].name>
 
        - if !<[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
          - adjust <[channel]> name:<[ticket_creator].name>

        - if <[text].starts_with[!ticketrename]> && <[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
          - adjust <[channel]> name:<[text].split.get[2]>
          - discordmessage id:magbungkal channel:<[channel]> "[Ticket] Channel renamed to **<[text].split.get[2]>**"

        - else if <[text].starts_with[!ticketrename]> && <[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
          - discordmessage id:magbungkal channel:<[channel]> "[Ticket] You don't have permission"


        # check active-ticket hours
        - define active_ticket_hours <script[discord_ticket_config].data_key[active-hours]>
        - define start_hour <[active_ticket_hours].get[start]>
        - define end_hour <[active_ticket_hours].get[end]>
        - define current_time <util.time_now.to_zone[+8].hour>
        - if <[current_time]> < <[start_hour]> || <[current_time]> > <[end_hour]>:
            - define ticket_role <script[discord_ticket_config].data_key[ticket-helper-role]>
            - define group <script[discord_ticket_config].data_key[group-id]>
            - if <[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
               - determine cancelled
            - define message_map <script[discord_ticket_config].parsed_key[messages].get[active-hours]>
            - define embed_message <discord_embed.with_map[<[message_map]>].with[color].as[#7C4751]>
            - if <server.has_flag[cooldown]>:
               - stop
            - flag server cooldown expire:1m
            - discordmessage id:magbungkal reply:<[message]> <[embed_message]>
            - stop

        after discord button clicked:
        - define button <context.button>
        - define channel <context.channel>

        - define user <context.interaction.user>
        - define interaction <context.interaction>
        - define group <script[discord_ticket_config].data_key[group-id]>
        - define ticket_helper_role <script[discord_ticket_config].data_key[ticket-helper-role]>

        - if <[button].map.get[id]> == open_ticket:
            - define modal_forms <script[discord_ticket_config].data_key[modal]>
            - define rows <map>
            - foreach <[modal_forms]> as:modal:
                - define index <[loop_index]>
                - define modal <discord_text_input.with_map[<[modal]>]>
                - define m <map[<[index]>=<[modal]>]>
                - define rows <[rows].include[<[index]>=<[m]>]>

            # show modal
            - ~discordmodal interaction:<[interaction]> name:discord_ticket_open title:Ticket rows:<[rows]>

        - if <[button].map.get[id]> == discord_ticket_close:
            - flag <[channel]> ticket_closer:<[user]>
            - flag <[channel]> ticket_closer_name:<[user].mention>

            - definemap close_rows:
                1:
                    1: <discord_text_input.with[id].as[closemodal].with[label].as[Type reason here].with[style].as[short]>

            - discordmodal interaction:<[interaction]> name:close_modal title:Reason rows:<[close_rows]>

        - if <[button].map.get[id]> == discord_ticket_claim && <[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
            - define ticket-claim.message <script[discord_ticket_config].parsed_key[messages].get[ticket-claim]>
            - define ticket-claim <discord_embed.with_map[<[ticket-claim.message]>]>
            - ~discordinteraction defer interaction:<[interaction]> ephemeral:false
            - discordinteraction reply interaction:<[interaction]> <[ticket-claim]>
            - flag <[channel]> ticket_claimer:<[user]>
            - flag <[channel]> ticket_claimer_name:<[user].mention>

        - if <[button].map.get[id]> == discord_ticket_claim && !<[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
            - define no-permission.message <script[discord_ticket_config].parsed_key[messages].get[no-permission]>
            - define no-permission <discord_embed.with_map[<[no-permission.message]>]>
            - ~discordinteraction defer interaction:<[interaction]> ephemeral:true
            - discordinteraction reply interaction:<[interaction]> <[no-permission]>

        - if <[button].map.get[id]> == discord_ticket_higherups && <[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
            - define higherups <script[discord_ticket_config].parsed_key[messages].get[higherups]>
            - define higherups.message <discord_embed.with_map[<[higherups]>]>
            - define higherups.role <discord_role[magbungkal,1126475444837949500,1201881961334046751]>
            - define developer.role <discord_role[magbungkal,1126475444837949500,1254116220572270612]>
            - define owner.role <discord_role[magbungkal,1126475444837949500,1161789366058897478]>

            - ~discordinteraction defer interaction:<[interaction]> ephemeral:false
            - discordinteraction reply interaction:<[interaction]> embed:<[higherups.message]> "<[higherups.role].mention> - <[developer.role].mention> - <[owner.role].mention>"

        - if <[button].map.get[id]> == discord_ticket_higherups && !<[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
            - define no-permission.message <script[discord_ticket_config].parsed_key[messages].get[no-permission]>
            - define no-permission <discord_embed.with_map[<[no-permission.message]>]>
            - ~discordinteraction defer interaction:<[interaction]> ephemeral:true
            - discordinteraction reply interaction:<[interaction]> <[no-permission]>


        - if <[button].map.get[id]> == discord_ticket_rating && <[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:

            - definemap options:
                1:
                  label: 1 Star
                  value: one_star
                  description: Rate how was your ticket handled!
                  emoji: ⭐
                2:
                  label: 2 Star
                  value: two_star
                  description: Rate how was your ticket handled!
                  emoji: ⭐
                3:
                  label: 3 Star
                  value: three_star
                  description: Rate how was your ticket handled!
                  emoji: ⭐
                4:
                  label: 4 Star
                  value: four_star
                  description: Rate how was your ticket handled!
                  emoji: ⭐
                5:
                  label: 5 Star
                  value: five_star
                  description: Rate how was your ticket handled!
                  emoji: ⭐

            - define message <script[discord_ticket_config].parsed_key[messages].get[rating]>
            - define embed <discord_embed.with_map[<[message]>]>
            - define rating <discord_selection.with[id].as[rating_selection].with[options].as[<[options]>]>
            - ~discordinteraction reply interaction:<[interaction]> rows:<[rating]> <[embed]>

        - if <[button].map.get[id]> == discord_ticket_rating && !<[user].roles[<[group]>].parse[id].contains[<[ticket_helper_role]>]>:
            - define no-permission.message <script[discord_ticket_config].parsed_key[messages].get[no-permission]>
            - define no-permission <discord_embed.with_map[<[no-permission.message]>]>
            - ~discordinteraction defer interaction:<[interaction]> ephemeral:true
            - discordinteraction reply interaction:<[interaction]> <[no-permission]>

        after discord modal submitted name:close_modal for:magbungkal:
        - define name <context.name>
        - define value <context.values>
        - define interaction <context.interaction>
        - define channel <context.channel>
        - define user <context.interaction.user>

        - flag <[channel]> ticket_closer:<[user]>
        - flag <[channel]> ticket_closer_name:<[user].mention>
        - flag <[channel]> ticket_closer_reason:<context.values.get[closemodal]>
        - inject discord_ticket_close

        on discord selection used id:rating_selection:
        - define name <context.name>
        - define value <context.values>
        - define interaction <context.interaction>
        - define channel <context.channel>
        - define user <context.interaction.user>
        - ~discordinteraction defer interaction:<[interaction]> ephemeral:true

        - choose <context.option.get[value]>:
           - case one_star:
              - define sucess_message <script[discord_ticket_config].parsed_key[messages].get[rating-success]>
              - define embed <discord_embed.with_map[<[sucess_message]>]>
              - define message <[embed]>
              # send to staff discord
              - define recorded-1 <script[discord_ticket_config].parsed_key[messages].get[rating-recorded-1]>
              - define recorded-1.embed <discord_embed.with_map[<[recorded-1]>]>
              - discordmessage id:magbungkal channel:1299450783674405006 <[recorded-1.embed]>
              - discordmessage id:magbungkal user:<[channel].flag[ticket_claimer]> <[recorded-1.embed]>
           - case two_star:
              - define sucess_message <script[discord_ticket_config].parsed_key[messages].get[rating-success]>
              - define embed <discord_embed.with_map[<[sucess_message]>]>
              - define message <[embed]>
              # send to staff discord
              - define recorded-2 <script[discord_ticket_config].parsed_key[messages].get[rating-recorded-2]>
              - define recorded-2.embed <discord_embed.with_map[<[recorded-2]>]>
              - discordmessage id:magbungkal channel:1299450783674405006 <[recorded-2.embed]>
              - discordmessage id:magbungkal user:<[channel].flag[ticket_claimer]> <[recorded-2.embed]>
           - case three_star:
              - define sucess_message <script[discord_ticket_config].parsed_key[messages].get[rating-success]>
              - define embed <discord_embed.with_map[<[sucess_message]>]>
              - define message <[embed]>
              # send to staff discord
              - define recorded-3 <script[discord_ticket_config].parsed_key[messages].get[rating-recorded-3]>
              - define recorded-3.embed <discord_embed.with_map[<[recorded-3]>]>
              - discordmessage id:magbungkal channel:1299450783674405006 <[recorded-3.embed]>
              - discordmessage id:magbungkal user:<[channel].flag[ticket_claimer]> <[recorded-3.embed]>
           - case four_star:
              - define sucess_message <script[discord_ticket_config].parsed_key[messages].get[rating-success]>
              - define embed <discord_embed.with_map[<[sucess_message]>]>
              - define message <[embed]>
              # send to staff discord
              - define recorded-4 <script[discord_ticket_config].parsed_key[messages].get[rating-recorded-4]>
              - define recorded-4.embed <discord_embed.with_map[<[recorded-4]>]>
              - discordmessage id:magbungkal channel:1299450783674405006 <[recorded-4.embed]>
              - discordmessage id:magbungkal user:<[channel].flag[ticket_claimer]> <[recorded-4.embed]>
           - case five_star:
              - define sucess_message <script[discord_ticket_config].parsed_key[messages].get[rating-success]>
              - define embed <discord_embed.with_map[<[sucess_message]>]>
              # send to staff discord
              - define recorded-5 <script[discord_ticket_config].parsed_key[messages].get[rating-recorded-5]>
              - define recorded-5.embed <discord_embed.with_map[<[recorded-5]>]>
              - discordmessage id:magbungkal channel:1299450783674405006 <[recorded-5.embed]>
              - discordmessage id:magbungkal user:<[channel].flag[ticket_claimer]> <[recorded-5.embed]>

        - ~discordinteraction reply interaction:<[interaction]> <[embed]>
        #
        # generates the ticket channel
        #
        on discord modal submitted:
        - define interaction <context.interaction>
        - ~discordinteraction defer interaction:<[interaction]> ephemeral
        - define user <[interaction].user>
        - define username <[user].name>
        - define name <context.name>
        - define values <context.values>
        - stop if:!<[name].contains[discord_ticket]>

        # create the ticket channel based on the config category
        - define ticket_index <server.flag[discord_ticket.index].if_null[1]>
        - flag server discord_ticket.index:++

        - define group <script[discord_ticket_config].data_key[group-id]>
        - define ticket_channel_category <script[discord_ticket_config].data_key[ticket-channel-category]>
        - define ticket_helper_role <script[discord_ticket_config].data_key[ticket-helper-role]>
        - ~discordcreatechannel id:magbungkal group:<[group]> name:<[user].name> users:<[user]> roles:<list[<[ticket_helper_role]>]> category:<[ticket_channel_category]> save:created_channel

        # generate the initial message for the ticket
        - define created_channel <entry[created_channel].channel>

        # if discord user has not linked - do not have any nickname on magbungkal discord
        - if <[user].contains[ticket_creatornickname]>:
            - adjust <[created_channel]> name:<[username]>

        - define ticket_message_map <script[discord_ticket_config].parsed_key[messages].get[ticket]>
        - define ticket_embed <discord_embed.with_map[<[ticket_message_map]>].with[color].as[#7C4751]>

        - define modal_data <script[discord_ticket_config].data_key[modal]>
        - define description "We will be with you as soon as possible for us to assist you.<n><n>Ticket ID: **<&ns><[ticket_index]>**<n>Date: **<util.time_now.to_zone[+8].format_discord>**<n><&nl>"
        - foreach <[values]>:
            - define name <[modal_data].get[<[key]>]>
            - define description "<[description]><[name].get[label]><n>**```<[value]>```**<&nl>"
        - define ticket_embed <[ticket_embed].with[description].as[<[description]>]>

        # ping staff for the ticket
        - define ticket_role <script[discord_ticket_config].data_key[ticket-helper-role]>
        - define staff_ping <discord_role[magbungkal,<[group]>,<[ticket_role]>].mention>
        # ping the ticket creator
        - define player_ping <[user].mention>
        # generate buttons
        - definemap buttons:
             1:
                1: <script[discord_ticket_config].parsed_key[buttons].get[ticket_claim_button]>
                2: <script[discord_ticket_config].parsed_key[buttons].get[ticket_close_button]>
                3: <script[discord_ticket_config].parsed_key[buttons].get[ticket_higherups_button]>
                4: <script[discord_ticket_config].parsed_key[buttons].get[ticket_rating_button]>

        # info message for the user
        - ~discordmessage id:magbungkal channel:<[created_channel]> rows:<[buttons]> embed:<[ticket_embed]> "<[staff_ping]> <[player_ping]>"
        - define ticket-ready <script[discord_ticket_config].parsed_key[messages].get[ticket-ready]>
        - define ticket-ready_message <discord_embed.with_map[<[ticket-ready]>]>
        - ~discordinteraction reply interaction:<[interaction]> <[ticket-ready_message]>

        # flag channel for logging
        - flag <[created_channel]> ticket_creation_time:<util.time_now.to_zone[+8].format_discord>
        - flag <[created_channel]> ticket_id:<[ticket_index]>
        - flag <[created_channel]> discord_ticket:true
        - flag <[created_channel]> ticket_creator:<[user]>
        - flag <[created_channel]> discord_transcript:->:<[description]>

discord_ticket_close:
    type: task
    debug: false
    definitions: channel
    script:
    # send logging data
    - define logging_channel <script[discord_ticket_config].data_key[logging-channel]>
    - define ticket_creator <[channel].flag[ticket_creator]>
    - define transcript_msg <script[discord_ticket_config].parsed_key[messages].get[ticket-close]>
    # generate description
    - define description <[transcript_msg].get[description].if_null[<empty>]>
    - define reason "⚒️ **Reason**: <[channel].flag[ticket_closer_reason].if_null[None provided!]>"
    - define ticket_opener "📥 **Opened by**: <[ticket_creator].mention>"
    - define ticket_closer "📤 **Closed by**: <[channel].flag[ticket_closer_name]>"
    - define ticket_claimer "🔐 **Claimed by**: <[channel].flag[ticket_claimer_name].if_null["-"]>"
    - define ticket_id "❔ **Ticket ID**: **`<[channel].flag[ticket_id].if_null["-"]>`**"
    - define open_time "📂 **Opened at**: <[channel].flag[ticket_creation_time]>"
    - define close_time "❕ **Closed on**: <util.time_now.to_zone[+8].format_discord>"
    - define description <[reason]><&nl><[ticket_claimer]><&nl><[ticket_id]><&nl><[ticket_opener]><&sp>---<&sp><[open_time]><&nl><[ticket_closer]><&sp>---<&sp><[close_time]><&nl><&nl><[description]>
    - define transcript_msg <[transcript_msg].with[description].as[<[description]>]>

    - define transcript_msg <discord_embed.with_map[<[transcript_msg]>].with[color].as[#7C4751]>
    - define transcript_logs <[channel].flag[discord_transcript].separated_by[<&nl>]>
    - define paste_server_url logs.magbungkal.net
    - define paste_server_port 443
    - define protocol http
    - if <[paste_server_port]> == 443:
        - define protocol https
    - ~webget <[protocol]>://<[paste_server_url]>:<[paste_server_port]>/documents method:post data:<[transcript_logs]> save:upload
    - foreach <[ticket_creator]> as:user:
        - define result_url <[protocol]>://<[paste_server_url]>:<[paste_server_port]>/<entry[upload].result.after[{"key":"].before["}]>

        - definemap button_map:
             1:
               style: link
               id: <[result_url]>
               label: Transcript link here
        - define button_list <list>
        - foreach <[button_map]>:
           - define my_button <discord_button.with_map[<[value]>]>
           - define button_list:->:<[my_button]>

        - ~discordmessage id:magbungkal user:<[user]> rows:<list_single[<[button_list]>]> <[transcript_msg]>

    - foreach <[logging_channel]> as:channel:
        - define result_url <[protocol]>://<[paste_server_url]>:<[paste_server_port]>/<entry[upload].result.after[{"key":"].before["}]>

        - definemap button_map:
             1:
               style: link
               id: <[result_url]>
               label: Transcript link here
        - define button_list <list>
        - foreach <[button_map]>:
           - define my_button <discord_button.with_map[<[value]>]>
           - define button_list:->:<[my_button]>

        - ~discordmessage id:magbungkal channel:<[channel]> rows:<list_single[<[button_list]>]> <[transcript_msg]>

    - adjust <[channel]> delete
