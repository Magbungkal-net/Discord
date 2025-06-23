
discord_applications_config:
    type: data
    msg-command: applicantmsg
    msg-command-desc: Generates the main ticket message
    # roles that can use the command
    msg-command-roles: 1373177324127916103

    ticket-admin-role: 1373177324127916103
    ticket-close-msg: !close
    # where to send the transcript messages after closing
    logging-channel: 1379391880583974922
    ticket-close-button:
        # format for the discord button
        # change anything except the "id"
        style: secondary
        id: discord_applications_close
        label: Close ticket
        disabled: false
        emoji: 🔒
    ticket-claim-button:
        # format for the discord button
        # change anything except the "id"
        style: secondary
        id: discord_applications_claim
        label: Claim
        disabled: false
        emoji: 🔑
    # discord group/server id
    group-id: 1372014440874119180
    # embedded messages for the different text responses
    # feel free to remove/add properties to each of em
    buttons:
        discord_applications_close:
            style: secondary
            id: discord_applications_close
            label: 🔒 Close
            # emoji: ElementTag
        discord_applications_claim:
            style: secondary
            id: discord_applications_claim
            label: 🔑 Claim
            # emoji: ElementTag
        open_ticket:
            style: secondary
            id: open_ticket
            label: Open a Ticket
            # emoji: ElementTag
        ask_channel:
            style: link
            id: https://discord.com/channels/1126475444837949500/1182338159032401930
            label: Community Support
            # emoji: ElementTag
    messages:
        main:
            title: Apply Here!
            color: <&color[#7C4751]>
            description: "# Magbungkal.net Staff Recruitment<n>> Recruitment to the server team is underway!<n><n>Criteria:<n>▶ 15 years old and above<n>▶ Adequacy<n>▶ Literacy<n>▶ Knowledge of Game Mechanics<n><n>Leave your requests below this message. As soon as there is a need on the server, you will be informed. Upon acceptance to the team, you may be interviewed via voice chat"
            thumbnail: https://media.discordapp.net/attachments/1142368712461135963/1321706135132311626/Magbungkal_new_logo_PNG_Transparent.png?ex=683fd4c2&is=683e8342&hm=c5cc754c2588272bf9ade9d98b3b43836504243f38295298e18472bc0cdc2e5e&=&format=webp&quality=lossless&width=960&height=960
            # image: URL of image
            # author_name: text
            # author_url: URL of image (requires author_name set)
            # author_icon_url: URL of image (requires author_name set)
            # footer: text
            # footer_icon: URL of image (requires footer set)
            # thumbnail: URL of image of image
            # title_url: URL of image (requires title set)
        interviewmsg:
            title: "Hi there, Applicant <[channel].flag[ticket_id]>"
            thumbnail: <[user].avatar_url>
            color: <&color[#7C4751]>
            description: "**# Introduce Yourself~<n>**Name**:<n>**Age**:<n>**Birthday**:<n>**Occupation**:<n>**Likes**:<n>**Dislikes**:<n>**Games you play**:<n>**Time available**:<n>**Message for everybody**:<n><n># Interview Questions~<n>Why would you like to become a member of the team?**:<n>**Why should we choose YOU for our team?**:<n>**Game mode knowledge (1-10)**:<n>**Adequacy (1-10)**:<n>**Game mode knowledge (1-10)**:"
        ticket:
            title: <[user].name>'s Application
            description: We will assist you as soon as possible.
            color: <&color[#7C4751]>
            #timestamp: <util.time_now.format_discord[R]>
            thumbnail: <[user].avatar_url>
        ticket-close:
            title: Application Closed!
            description: ⚒️ **Reason**: No reason provided! <&nl>❔ **APP ID**: **`<[channel].flag[ticket_id].if_null["-"]>`**<&nl>📥 **Opened by**: <[ticket_creator].mention> **---** 📂 **Opened at**: <[channel].flag[ticket_creation_time]><&nl>📤 **Closed by**: <[channel].flag[ticket_closer_name]> **---** ❕ **Closed on**: <util.time_now.to_zone[+8].format_discord><&nl><&nl>
            color: <&color[#7C4751]>
        ticket-ready:
            title: Application has been generated, head over to <[created_channel].mention>
            color: <&color[#7C4751]>
        ticket-claim:
            title: Claimed Application
            description: Your application will be handled by <[user].mention>
            color: green
        no-permission:
            title: ❌ You don't have permission
            color: <&color[#7C4751]>
    category-placeholder: Make a selection
    # categories for the ticket msg selector
    # create more categories as needed, they just
    # have to follow the format below
    # note: if you add a category you might need to
    # reload & generate the ticket message again
    
    categories:
        staff:
            allowed-roles:
            - 1373177324127916103
            # add a new role here
            # - <new role>
            emoji: 📝
            description: Become part of our volunteer team
            channel-category: 1379390630232592496
            modal-forms:
                role:
                    label: WHAT ROLE(S) ARE YOU APPLYING FOR?
                    is_required: true
                    style: short
                    placeholder: (Moderator, Builder or Helper)
                ign:
                    label: IGN (Minecraft Username)
                    is_required: true
                    style: short
                    placeholder: (e.g. akyyaky)
                age:
                    label: HOW OLD ARE YOU?
                    is_required: true
                    style: short
                previous:
                    label: TIME ZONE
                    is_required: true
                    style: short
                    placeholder: (e.g. UTC+8)
                why:
                    label: WHY WOULD YOU LIKE TO BE PART OF STAFF TEAM?
                    is_required: true
                    style: short
                    placeholder: (e.g. idk cuz im bored)