howtolink:
  type: command
  debug: false
  name: howtolink
  usage: /howtolink
  description: Shows the discord link
  script:
    - define text <list[<&0><n><n>Hello <&l><player.name>, <&0>to link your account you must be on discord first by using command <&l>/discordserver<n><&0>]>
    - define text <list[<&0><n><n>Hello <&l><player.name>, <&0>to link your account you must be on discord first by using command <&l>/discordserver<n><&0>]>
    - adjust <player> show_book:written_book[book_pages=<[text]>;book_title=nan;book_author=nan]