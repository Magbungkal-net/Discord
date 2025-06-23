# register the ticket command
discord_applications_command_reg:
    type: task
    debug: false
    script:
    - define group <script[discord_applications_config].data_key[group-id]>
    - define msg_command <script[discord_applications_config].data_key[msg-command]>
    - define command_desc <script[discord_applications_config].data_key[msg-command-desc]>
    - ~discordcommand id:magbungkal create group:<[group]> name:<[msg_command]> description:<[command_desc]>

discord_applications_events_handler:
    type: world
    debug: true
    events:
        #
        # handles the generation of the support msg
        #
        on discord slash command:
        - define interaction <context.interaction>
        - define command <script[discord_applications_config].data_key[msg-command]>
        - define command_name <context.command.name>
        - if <[command]> == <[command_name]>:
            # check if user has allowed roles
            - define user <[interaction].user>
            - define group <script[discord_applications_config].data_key[group-id]>
            - define msg_command_roles <script[discord_applications_config].data_key[msg-command-roles]>
            - if !<[msg_command_roles].contains_any[<[user].roles[<[group]>].parse[id]>]>:
                # - ~discordinteraction reply interaction:<[interaction]> "You're not allowed to use this command"
                - stop
            - ~discordinteraction defer interaction:<[interaction]>

            # main msg for ticket
            - define msg_data <script[discord_applications_config].data_key[messages]>
            - define msg_map <[msg_data].get[main].unescaped.parsed>
            - define msg_embed <discord_embed.with_map[<[msg_map]>]>

            # selector for the ticket categories
            - define cat_placeholder <script[discord_applications_config].data_key[category-placeholder]>
            - define cat_data <script[discord_applications_config].data_key[categories]>

            - definemap cat_selection:
                id: category_selection
                placeholder: <[cat_placeholder]>

            - define options <map>
            - foreach <[cat_data]> as:data:
                - define index <[loop_index]>
                - define name <[key]>
                - define emoji <[data].get[emoji]>
                - define description <[data].get[description]>
                - definemap cat_option:
                    label: <[name].to_titlecase>
                    value: <[name]>
                    description: <[description]>
                    emoji: <[emoji]>
                - define options <[options].with[<[loop_index]>].as[<[cat_option]>]>

            - define cat_selection <[cat_selection].with[options].as[<[options]>]>
            - define cat_selection <discord_selection.with_map[<[cat_selection]>]>


            - define channel <[interaction].channel>
            - ~discordinteraction delete interaction:<[interaction]>
            - ~discordmessage id:magbungkal channel:<[channel]> <[msg_embed]> rows:<[cat_selection]>
            # - ~discordinteraction reply interaction:<[interaction]> <[msg_embed]> rows:<[cat_selection]>

        #
        # generates the category modal forms
        #
        on discord selection used:
        - define option <context.option>
        - define label <[option].get[label]>
        # - define emoji <[option].get[emoji]>
        - define cat_data <script[discord_applications_config].data_key[categories]>
        - define cat_data <[cat_data].get[<[label]>]>

        - define cat_modals <[cat_data].get[modal-forms]>
        - define modals <map>
        - foreach <[cat_modals]> key:id as:data:
            - define index <[loop_index]>
            - define data <[data].with[id].as[<[id]>]>
            - define modal_input <discord_text_input.with_map[<[data]>]>
            - define modals <[modals].with[<[index]>].as[<[modal_input]>]>

        - define interaction <context.interaction>
        - ~discordmodal interaction:<[interaction]> name:discord_applications_<[label]> title:<[label].to_titlecase> rows:<[modals]>


        #
        # generates the ticket channel
        #
        on discord modal submitted:
        - define interaction <context.interaction>
        - ~discordinteraction defer interaction:<[interaction]> ephemeral
        - define user <[interaction].user>
        - define name <context.name>
        - define values <context.values>
        - stop if:!<[name].contains[discord_applications]>

        - define category <[name].after[discord_applications_]>
        - define cat_data <script[discord_applications_config].data_key[categories].get[<[category]>]>

        # create the ticket channel based on the config category
        - define ticket_index <server.flag[discord_applications.index].if_null[1]>
        - flag server discord_applications.index:++

        - define group <script[discord_applications_config].data_key[group-id]>
        - define channel_category <[cat_data].get[channel-category]>
        - define allowed_roles <[cat_data].get[allowed-roles]>
        - ~discordcreatechannel id:magbungkal group:<[group]> name:<[user].name> users:<[user]> roles:<[allowed_roles]> category:<[channel_category]> save:created_channel

        # generate the initial message for the ticket
        - define created_channel <entry[created_channel].channel>

        - define ticket_message_map <script[discord_applications_config].data_key[messages].get[ticket].unescaped.parsed>
        - define ticket_embed <discord_embed.with_map[<[ticket_message_map]>]>

        - define modal_data <[cat_data].get[modal-forms]>
        - define description "This ticket was requested by <[user].mention> on <util.time_now.format_discord><&nl>"
        - foreach <[values]>:
            - define name <[modal_data].get[<[key]>]>
            - define description "<[description]>**<[name].get[label]>**: <[value]><&nl>"
        - define ticket_embed <[ticket_embed].with[description].as[<[description]>]>

        # generate buttons
        - definemap buttons:
             1:
                1: <script[discord_applications_config].parsed_key[buttons].get[discord_applications_claim]>
                2: <script[discord_applications_config].parsed_key[buttons].get[discord_applications_close]>

        - ~discordmessage id:magbungkal channel:<[created_channel]> <[ticket_embed]> rows:<[buttons]>
        - define ticket-ready <script[discord_applications_config].parsed_key[messages].get[ticket-ready]>
        - define ticket-ready_message <discord_embed.with_map[<[ticket-ready]>]>
        # - ~discordinteraction reply interaction:<[interaction]> "Your ticket is ready, head over to <[created_channel].mention>"
        - ~discordinteraction reply interaction:<[interaction]> <[ticket-ready_message]>

        # flag channel for logging
        - flag <[created_channel]> ticket_creation_time:<util.time_now.to_zone[+8].format_discord>
        - flag <[created_channel]> ticket_id:<[ticket_index]>
        - flag <[created_channel]> discord_applications:true
        - flag <[created_channel]> ticket_creator:<[user]>
        - flag <[created_channel]> discord_transcript:->:<[description]>

        #
        # handles the logging for transcript
        #
        after discord message received:
        - define channel <context.channel>
        - define message <context.new_message>
        - define user <[message].author>
        - stop if:<[user].is_bot>
        - stop if:!<[channel].has_flag[discord_applications]>

        - define name <[user].name>
        - define text <[message].text>
        - define transcript_format "<util.time_now.format> <[name]>: <[text]>"
        - flag <[channel]> discord_transcript:->:<[transcript_format]>
        - define ticket_creator <[channel].flag[ticket_creator]>

        - define group <script[discord_applications_config].data_key[group-id]>
        - define ticket.admin <script[discord_applications_config].data_key[ticket-admin-role]>
       
        - if <[text].contains_any[!close]> && <[user].roles[<[group]>].parse[id].contains[<[ticket.admin]>]>:
            - flag <[channel]> ticket_closer:<[user]>
            - flag <[channel]> ticket_closer_name:<[user].mention>
            - inject discord_applications_close

        - if <[user].roles[<[group]>].parse[id].contains[<[ticket.admin]>]>:
          - adjust <[channel]> name:Awaiting-Response-<[ticket_creator].name>
       
        - if !<[user].roles[<[group]>].parse[id].contains[<[ticket.admin]>]>:
          - adjust <[channel]> name:<[ticket_creator].name>

        # this msg will be uhm tangina katamad mag explain
        - define message_map <script[discord_applications_config].parsed_key[messages].get[interviewmsg]>
        - define embed_message <discord_embed.with_map[<[message_map]>]>
        - if !<[user].has_flag[applicant-staff]>:
            - discordmessage id:magbungkal reply:<[message]> <[embed_message]>
        - wait 1s
        - flag  <[user]> applicant-staff
        - stop


        after discord button clicked:
        - define button <context.button>
        - define channel <context.channel>
        - define interaction <context.interaction>
        - define user <context.interaction.user>
        - define group <script[discord_applications_config].data_key[group-id]>
        - define ticket_category <[channel].flag[discord_applications]>
        - define ticket.admin <script[discord_applications_config].data_key[ticket-admin-role]>

        - if <[button].map.get[id]> == discord_applications_close:
            - flag <[channel]> ticket_closer:<[user]>
            - flag <[channel]> ticket_closer_name:<[user].mention>
            - inject discord_applications_close

        - if <[button].map.get[id]> == discord_applications_claim && <[user].roles[<[group]>].parse[id].contains[<[ticket.admin]>]>:
            - define ticket-claim.message <script[discord_applications_config].parsed_key[messages].get[ticket-claim]>
            - define ticket-claim <discord_embed.with_map[<[ticket-claim.message]>]>
            - ~discordinteraction defer interaction:<[interaction]> ephemeral:false
            - discordinteraction reply interaction:<[interaction]> <[ticket-claim]>

        - if <[button].map.get[id]> == discord_applications_claim && !<[user].roles[<[group]>].parse[id].contains[<[ticket.admin]>]>:
            - define no-permission.message <script[discord_applications_config].parsed_key[messages].get[no-permission]>
            - define no-permission <discord_embed.with_map[<[no-permission.message]>]>
            - ~discordinteraction defer interaction:<[interaction]> ephemeral:true
            - discordinteraction reply interaction:<[interaction]> <[no-permission]>

discord_applications_close:
    type: task
    debug: false
    definitions: channel
    script:
    # send logging data
    - define logging_channel <script[discord_applications_config].data_key[logging-channel]>
    - define ticket_creator <[channel].flag[ticket_creator]>
    - define transcript_msg <script[discord_applications_config].data_key[messages].get[ticket-close].unescaped.parsed>
    - define transcript_msg <discord_embed.with_map[<[transcript_msg]>]>
    - define transcript_logs <[channel].flag[discord_transcript].separated_by[<&nl>]>

    - ~discordmessage id:magbungkal channel:<[logging_channel]> <[transcript_msg]> attach_file_name:transcript.txt attach_file_text:<[transcript_logs]>
    - ~discordmessage id:magbungkal user:<[ticket_creator]> <[transcript_msg]> attach_file_name:transcript.txt attach_file_text:<[transcript_logs]>

    - adjust <[channel]> delete