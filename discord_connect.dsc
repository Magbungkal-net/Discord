magbungkal_bot_connect:
  type: task
  debug: false
  script:
  - ~discordconnect id:magbungkal token:<secret[token]>
  - run magbungkal_bot_status_set


magbungkal_bot_status_set:
  type: task
  debug: false
  script:
  - ~discord id:magbungkal status "play.magbungkal.net" status:ONLINE activity:PLAYING
    # - define discord_members <discord_group[magbungkal,1126475444837949500].members.size>
    # - ~discord id:magbungkal status "over <[discord_members]> discord players!" status:ONLINE activity:Watching

magbungkal_bot_main_events:
  type: world
  debug: false
  events:
    after server start:
    - run magbungkal_bot_connect