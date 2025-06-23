staff_application_config:
    type: data
    # roles for the people
    # who can use the !roleadd command
    permission-roles:
    - 1171782271783678013
    messages:
        not-authorized:
            title: ❌ You are not authorized to use this command
            color: maroon
        discord-user-not-found:
            title: ❌ Please insert discord user tag
            color: maroon
        successfully-denied:
            title: ✔️ Successfully denied the application of applicant
            color: lime
        successfully-approved:
            title: ✔️ Successfully approved the application of applicant
            color: lime

rejection_message:
    type: world
    debug: false
    events:
        after discord message received:
        - define message <context.new_message>
        - define author <[message].author>
        - define text <[message].text>
        - define deny_cmd !denystaff
        - if <[text].starts_with[<[deny_cmd]>]>:
            - define adder_roles <script[staff_application_config].data_key[permission-roles]>
            - if <[text].split.size> <= 1:
                  - define not_authorized_message <script[staff_application_config].parsed_key[messages].get[discord-user-not-found]>
                  - define reply <discord_embed.with_map[<[not_authorized_message]>]>
                  - discordmessage id:magbungkal reply:<[message]> <[reply]>
                  - stop
            - else:
                  - define username <discord_user[<element[<[text].split.get[2]>].parsed>].mention>
                  - definemap message_map:
                        title: Application Rejected
                        description: Dear <[username]><n><n> Thank you for taking time to apply for the staff team of Magbungkal.<n><n>We value your desire to become a member of our team. We will not be proceeding with your application at this time.<n><n>We're encourage you to apply again in the future!<n><n>Sincerely,<n><context.new_message.author.name><n>
                        color: orange
                        footer: play.magbungkal.net
                        footer_icon: https://media.discordapp.net/attachments/1144631328545972254/1235249617545728141/Magbungkal.png?ex=666719da&is=6665c85a&hm=dc1e81d6025a5453a220010f1702bd3657c39dcaeb44c58933063856c27e81fe&=&format=webp&quality=lossless&width=671&height=671
                  - define message_embed <discord_embed.with_map[<[message_map]>]>
                  - define user <element[<[text].split.get[2]>].parsed>
                  - ~discordmessage id:magbungkal user:<[user]> <[message_embed]>
                  - define not_authorized_message <script[staff_application_config].parsed_key[messages].get[successfully-denied]>
                  - define reply_1 <discord_embed.with_map[<[not_authorized_message]>]>
                  - discordmessage id:magbungkal reply:<[message]> <[reply_1]>

approved_message:
    type: world
    debug: false
    events:
        after discord message received:
        - define message <context.new_message>
        - define author <[message].author>
        - define text <[message].text>
        - define approved_cmd !approvestaff
        - if <[text].starts_with[<[approved_cmd]>]>:
            - define adder_roles <script[staff_application_config].data_key[permission-roles]>
            - if <[text].split.size> <= 1:
                  - define not_authorized_message <script[staff_application_config].parsed_key[messages].get[discord-user-not-found]>
                  - define reply <discord_embed.with_map[<[not_authorized_message]>]>
                  - discordmessage id:magbungkal reply:<[message]> <[reply]>
                  - stop
            - else:
                  - define username <discord_user[<element[<[text].split.get[2]>].parsed>].mention>
                  - definemap message_map:
                        title: Application Approved
                        description: Dear <[username]><n><n>Congratulations, your application has been approved!<n><n>Welcome to the Magbungkal staff team!<n><n>Magbungkal discord staff link --> https://discord.gg/pcUV8Jgh27<n><n>Sincerely,<n><context.new_message.author.name><n>
                        color: orange
                        footer: play.magbungkal.net
                        footer_icon: https://media.discordapp.net/attachments/1144631328545972254/1235249617545728141/Magbungkal.png?ex=666719da&is=6665c85a&hm=dc1e81d6025a5453a220010f1702bd3657c39dcaeb44c58933063856c27e81fe&=&format=webp&quality=lossless&width=671&height=671
                  - define message_embed <discord_embed.with_map[<[message_map]>]>
                  - define user <element[<[text].split.get[2]>].parsed>
                  - ~discordmessage id:magbungkal user:<[user]> <[message_embed]>
                  - define not_authorized_message <script[staff_application_config].parsed_key[messages].get[successfully-approved]>
                  - define reply_1 <discord_embed.with_map[<[not_authorized_message]>]>
                  - discordmessage id:magbungkal reply:<[message]> <[reply_1]>