DiscordConsoleData:
    type: data
    messages:
     console:
      color: orange
      description: "```<context.message>```"

DiscordConsoleEvents:
    type: world
    debug: false
    events:
      after console output:
      - define console.message <script[discordconsoledata].parsed_key[messages].get[console]>
      - define embed <discord_embed.with_map[<[console.message]>]>
      - discordmessage id:magbungkal channel:1292510136539287603 <[embed]>