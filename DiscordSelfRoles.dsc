self_role_button_handler_discord:
  type: world
  debug: false
  events:
    on discord button clicked for:magbungkal channel:1380927196679634974:
    - define by <context.interaction.user.nickname[<context.group>].substring[2]>
    - define player <server.match_player[<[by]>].if_null[null]>
    - define rank <context.button.map.deep_get[id]>
    - define normal_roles <script[normal_roles_data_discord].data_key[list]>

    - define message "✔️ Role has been added to you"
    - define role <context.group.role[<[rank]>]>
    - ~discord id:magbungkal add_role user:<context.interaction.user> role:<[role]> group:<context.group>
      # - define message "Role has been added to you."
    #- else:
      #- define message "You don't have the permission to claim this role."

    - definemap embed_map:
        title: <[message]>
    - define embed <discord_embed.with_map[<[embed_map]>]>
    - ~discordinteraction reply interaction:<context.interaction> <[embed].with[color].as[#7C4751]> ephemeral:true

normal_roles_data_discord:
    type: data
    list:
    - 1182513726914580483
    - 1143937079991095326
    - 1143936995291316234
    - 1143937111431581823
    - 1182533680342777947
    - 1256350747780579329

# Send button message
self_role_task_discord:
    type: task
    debug: false
    script:
    - define channel 1380927196679634974

    - definemap embed_map:
        title: Discord - Toggle Notification
        description: React below with you want to toggle notifications.<n><n>React 🚨 for Announcements<n>React 🎊 for Events<n>React 🔧 for Updates<n>React 🎉 for Giveaways<n>React 🎬 for Uploads/Live Ping
    - define embed <discord_embed.with_map[<[embed_map]>]>

    - definemap button_map:
        1:
          style: secondary
          id: Announcements Ping
          label: 🚨
        2:
          style: secondary
          id: Events Ping
          label: 🎊
        3:
          style: secondary
          id: Updates Ping
          label: 🔧
        4:
          style: secondary
          id: Giveaways Ping
          label: 🎉
        5:
          style: secondary
          id: Live Ping
          label: 🎬
          
    - define button_list <list>
    - foreach <[button_map]>:
      - define my_button <discord_button.with_map[<[value]>]>
      - define button_list <[button_list].include[<[my_button]>]>

    - ~discordmessage id:magbungkal channel:<discord_channel[<[channel]>]> rows:<list_single[<[button_list]>]> <[embed].with[color].as[#7C4751]>

self_role_button_handler_client:
  type: world
  debug: false
  events:
    on discord button clicked for:magbungkal channel:1380927196679634974:
    - define by <context.interaction.user.nickname[<context.group>].substring[2]>
    - define player <server.match_player[<[by]>].if_null[null]>
    - define rank <context.button.map.deep_get[id]>
    - define normal_roles <script[normal_roles_data_client].data_key[list]>

    # - if <[player]> == null:
    #   - define message "You must be online to claim a role."
    - define message "Role has been added to you"
    - define role <context.group.role[<[rank]>]>
    - ~discord id:magbungkal add_role user:<context.interaction.user> role:<[role]> group:<context.group>
      # - define message "Role has been added to you."
    #- else:
      #- define message "You don't have the permission to claim this role."

    #- definemap embed_map:
        #color: orange
        #description: <[message]>
    #- define embed <discord_embed.with_map[<[embed_map]>]>
    # - ~discordinteraction reply interaction:<context.interaction> <[message]> ephemeral:true

normal_roles_data_client:
    type: data
    list:
    - 1183437544403251291
    - 1183437570122711211
    - 1183437593543721044

# Send button message
self_role_task_client:
    type: task
    debug: false
    script:
    - define channel 1380927196679634974

    - definemap embed_map:
        title: Client - Toggle Notification
        description: React below with you want to toggle notifications.<n><n>React 🏹 for Java<n>React 🗡️ for Bedrock<n>React 🪓 for Pojav
    - define embed <discord_embed.with_map[<[embed_map]>]>

    - definemap button_map:
        1:
          style: secondary
          id: Java Edition
          label: 🏹
        2:
          style: secondary
          id:  Bedrock Edition
          label: 🗡️
        3:
          style: secondary
          id: Pojav Launcher
          label: 🪓
          
    - define button_list <list>
    - foreach <[button_map]>:
      - define my_button <discord_button.with_map[<[value]>]>
      - define button_list <[button_list].include[<[my_button]>]>

    - ~discordmessage id:magbungkal channel:<discord_channel[<[channel]>]> rows:<list_single[<[button_list]>]> <[embed].with[color].as[#7C4751]>

self_role_button_handler_gamemode:
  type: world
  debug: false
  events:
    on discord button clicked for:magbungkal channel:1380927196679634974:
    - define by <context.interaction.user.nickname[<context.group>].substring[2]>
    - define player <server.match_player[<[by]>].if_null[null]>
    - define rank <context.button.map.deep_get[id]>
    - define normal_roles <script[normal_roles_data_client].data_key[list]>
    - define message "Role has been added to you"
    - define role <context.group.role[<[rank]>]>
    - ~discord id:magbungkal add_role user:<context.interaction.user> role:<[role]> group:<context.group>
      # - define message "Role has been added to you."
    #- else:
      #- define message "You don't have the permission to claim this role."

    #- definemap embed_map:
        #color: orange
        #description: <[message]>
    #- define embed <discord_embed.with_map[<[embed_map]>]>
    # - ~discordinteraction reply interaction:<context.interaction> <[message]> ephemeral:true

normal_roles_data_gamemode:
    type: data
    list:
    - 1143935233956270121
    - 1182513726914580483

# Send button message
self_role_task_gamemode:
    type: task
    debug: false
    script:
    - define channel 1380927196679634974

    - definemap embed_map:
        title: Gamemode - Toggle Notification
        description: React below with you want to toggle notifications.<n><n>React ☁️ for Skyblock<n>React 🛖 for Survival
    - define embed <discord_embed.with_map[<[embed_map]>]>

    - definemap button_map:
        1:
          style: secondary
          id: Skyblock
          label: ☁️
        2:
          style: secondary
          id: Survival
          label: 🛖

    - define button_list <list>
    - foreach <[button_map]>:
      - define my_button <discord_button.with_map[<[value]>]>
      - define button_list <[button_list].include[<[my_button]>]>

    - ~discordmessage id:magbungkal channel:<discord_channel[<[channel]>]> rows:<list_single[<[button_list]>]> <[embed].with[color].as[#7C4751]>