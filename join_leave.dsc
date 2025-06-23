join_leave_message:
  type: world
  debug: false
  events:
    on player join:
    - announce "<&a>+ <&7><player.name>"
    - determine none passively
    - if <player.name> == Palangga:
       - wait 41s
       - execute as_server "cmi server survival <player.name>" 
    - if <player.name> == Chromea:
       - wait 41s
       - execute as_server "cmi server survival <player.name>"        
    - if <player.name> == AltTab:
       - wait 41s
       - execute as_server "cmi server survival <player.name>"     
    - if <player.name> == EyeSkreem:
       - wait 41s
       - execute as_server "cmi server survival <player.name>"     
    - if <player.name> == brickz:
       - wait 41s
       - execute as_server "cmi server survival <player.name>"      
    - if <player.name> == briickz:
       - wait 41s
       - execute as_server "cmi server survival <player.name>"            
    - if <player.name> == fishyzx:
       - wait 41s
       - execute as_server "cmi server survival <player.name>"  
    - if <player.name> == Shiroekuroe:
       - wait 41s
       - execute as_server "cmi server survival <player.name>"         
    - if <player.name> == Cooke:
       - wait 41s
       - execute as_server "cmi server survival <player.name>"         
    - if <player.name> == Pipsi:
       - wait 41s
       - execute as_server "cmi server survival <player.name>"           
    on player quit:
    - announce "<&c>- <&7><player.name>"
    - determine none passively
   
   
    

