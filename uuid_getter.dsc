UUID_Getter:
    type: command
    name: uuid
    usage: /uuid [player]
    description: Gets the UUID of a player.
    permission: denizen.admin
    permission message: <red>YOU DARE TRY TO WIELD THE POWERS OF THE GODS?
    script:
    - if <context.args.size> != 1:
        - narrate "<red>Invalid command usage; proper usage is <green>/uuid [player]"
        - stop
    - define target <server.match_offline_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<red>Invalid target specified; <bold><context.args.get[1]><red> did not match any player"
        - stop
    - narrate "<context.args.get[1]>'s UUID is <server.match_offline_player[<context.args.get[1]>].uuid>"