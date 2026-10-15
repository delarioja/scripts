#!/bin/bash
##Nos presentamos y preguntamos en que año ha nacido el cliente y lo metemos en la variable anac
echo "Hola. Vamos a averiguar cual es el animal que te corresponde segun tu horoscopo chino"
echo "¿Cual es tu año de nacimiento? (4 cifras):"
read anac
clear
##Dividimos el año de nacimiento y cogemos el resto y lo almacenamos en la variante signo
signo=$(($anac%12)) 

## con el numero de signo buscamos el bicho que le corresponde y que nos devuelva el mensaje
## Para que quede mas chulo hemos buscado los animales dibujados en ASCII
## https://ascii.co.uk/art
case $signo in
    0) echo 'Si naciste en $anac te corresponde El Mono según el horóscopo chino.
                         __
                        / _,\
                        \_\
             ,,,,    _,_)  #      /)
            (= =)D__/    __/     //
           C/^__)/     _(    ___//
             \_,/  -.   `-._/,--`
       _\\_,  /           -//.
        \_ \_/  -,._ _     ) )
          \/    /    )    / /
          \-__,/    (    ( (
                     \.__,-)\_
                      )\_ / -(
                     / -(////
                    ////                    
    ' ;;
    1) echo 'Si naciste en $anac te corresponde El Gallo según el horóscopo chino.\
                           ~-.\
          ,,,;            ~-.~-.~-\
         (.../           ~-.~-.~-.~-.~-.\
         } o~`,         ~-.~-.~-.~-.~-.~-.\
         (/    \      ~-.~-.~-.~-.~-.~-.~-.\
          ;    \    ~-.~-.~-.~-.~-.~-.~-.\
         ;     {_.~-.~-.~-.~-.~-.~-.~\
        ;:  .-~`    ~-.~-.~-.~-.~-.\
       ;.: :`    ._   ~-.~-.~-.~-.~-\
        ;::`-.    `-._  ~-.~-.~-.~-\
         ;::. `-.    `-,~-.~-.~-.\
          `;::::.```-.-`\
            `;::;;:,:`\
               `||"\
               / |\
             ~` ~"`\
    ' ;;
    
    2) echo 'Si naciste en $anac te corresponde El Perro según el horóscopo chino
         ,--._______,-. 
       ,`,`  ,    .  ,_`-. 
      / /  ,` , _` ``. |  )       `-.. 
     (,`;`""`/ `"`-._ ` \/ ______    \\ 
       : ,o.-`- ,o.  )\` -`      `---.)) 
       : , d8b ^-.   `|   `.      `    `. 
       |/ __:_     `. |  ,  `       `    \ 
       | ( ,-.`-.    ;`  ;   `       :    ; 
       | |  ,   `.      /     ;      :    \ 
       ;-``:::._,`.__),`             :     ; 
      / ,  `-   `--                  ;     | 
     /  \                   `       ,      | 
    (    `     :              :    ,\      | 
     \   `.    :     :        :  ,`  \    : 
      \    `|-- `     \ ,`    ,-`     :-.-`; 
      :     |`--.______;     |        :    : 
       :    /           |    |         |   \ 
       |    ;           ;    ;        /     ; 
     _/--` |           :`-- /         \_:_:_| 
   ,`,`,`  |           |___ \ 
   `^._,--`           / , , .) 
                      `-._,-`
    ' ;;
    3) echo 'Si naciste en $anac te corresponde El Cerdo según el horóscopo chino
    
                                             )\   /|
                                          .-/`-|_/ |
                       __            __,-` (   / \/          
                   .-`"  "`-..__,-`""          -o.`-._   
                  /                                   `/
          *--._ ./                                 _.-- 
                |                              _.-` 
                :                           .-/   
                 \                       )_ /
                  \                _)   / \(
                    `.   /-.___.---`(  /   \\
                     (  /   \\       \(     L\
                      \(     L\       \\
                       \\              \\
                        L\              L\
    ' ;;
    4) echo 'Si naciste en $anac te corresponde La Rata según el horóscopo chino
                        .  ,
                        (\;/)
                       oo   \//,        _
                     ,/_;~      \,     / `
                     "`    (  (   \    !
                           //  \   |__.`
                         `~  `~----``
    ' ;;
    5) echo 'Si naciste en $anac te corresponde El Buey según el horóscopo chino
                          /|                        /|
                          | \           __ _ _     / ;
                    ___    \ \   _.-"-" `~"\  `"--` /
                _.-`   ""-._\ ""   ._,"  ; "\"--._./
            _.-`       \./    "-""", )  ~"  |
           / ,- .`          ,     `  `o.  ;  )
           \ ;/       `                 ;   /
            |/        `      |      \   `   |
            /        |             J."\  ,  |
           "         :       \   .`  : | ,. _)
           |         |     /     f |  |`--"--`
            \_        \    \    / _/  |
             \ "-._  _.|   (   j/; -`/
              \  | "/  (   |   /,    |
               | \  |  /\  |\_///   /
               \ /   \ | \  \  /   /
                ||    \ \|  |  |  |
                ||     \ \  |  | /
                |\      |_|/   ||
                L \       ||   ||
                `"`       |\   |\
                          ( \. \ `.
                          |_ _\|_ _\
                            "    "
    ' ;;
    6) echo 'Si naciste en $anac te corresponde El Tigre según el horóscopo chino
                         __,,,,_
          _ __..-;```--/`/ /.`,-`-.
      (`/` ` |  \ \ \\ / / / / .-`/`,_
     /``\ \   |  \ | \| // // / -.,/_,`-,
    /<7` ;  \ \  | ; ||/ /| | \/    |`-/,/-.,_,/`)
   /  _.-, `,-\,__|  _-| / \ \/|_/  |    `-/.;.\`
   `-`  f/ ;      / __/ \__ `/ |__/ |
        `-`      |  -| =|\_  \  |-` |
              __/   /_..-` `  ),`  //
             ((__.-`((___..-`` \__.`
    ' ;;
    7) echo 'Si naciste en $anac te corresponde El Conejo según el horóscopo chino
             		  .".
                         /  |
                        /  /
                       / ,"
           .-------.--- /
          "._ __.-/ o. o\  
             "   (    Y  )
                  )     /
                 /     (
                /       Y
            .-"         |
           /  _     \    \ 
          /    `. ". ) /` )
         Y       )( / /(,/
        ,|      /     )
       ( |     /     /
        " \_  (__   (__        
            "-._,)--._,)
    ' ;;
    8) echo 'Si naciste en $anac te corresponde El Dragón según el horóscopo chino
                                 ,- 
                               //        
                              /:      ,
                             ;.(     //
                   |   ,     /`|    //
                   |\  |\    |,|   //
                |  (\  (\    |`|   |(
                (\  \\  \\   |,|   ;|
            .   ||   \\  \\  |`(   ;( 
            \\   \\  \\  \\  |.\\  ((                              
             \\   \\  \\  \\  \\ \;/:\                 
               \\  \\  \`. \\_,\\ /\""-._                
                \\  \\  \ \-"   \/ `;._ ".
               ___\\-\\-" \ \_  /,  |_ "._\
         _,--""___ \ \,_   "-_"- |".|(._ ".".-.
     _,-"_,--"""__ ) "."-_    "--\ \"("o\_\ "- ".
   ,",-""" _.-```_-"   "-_"-.__   \ \_\_//\)__"\_)
 ,"    `,-`  ,-""   7"  _ "-.._""_>\__`""`"__ ""``-._
        ;  ," ,-",`/` ,":\.    `   `  `"""___`""-._  ".   )
        ;,"_," ,` /`,"}}::\\         `... \____``` "\  `.|\
       ,","   :  /`/{{)/:::"\__,---._    \  \_____```\    \
      , ,"_  ;  /`/ ///::::::::` ,-"-\    \__   \____``\ \ \
     ,,"   `;| ";; /}}/::````:::(._``."-.__  """--    `_\ \ \
    (`       ;// / {;;:```````:; /`._."""  ""-.._ `"-. " (   )
    /         )(/ <";"```   ``/ /_.(             "_  "-_"\`);
              (/ <";"``     `/ /`,(                "._ _".\; 
               |<";"`   ``  / /"-"          "  
               <";"` ``    / /__,;   
    ' ;;
    9) echo 'Si naciste en $anac te corresponde La Serpiente según el horóscopo chino
                            _.--....
                 _....---;:`::` ^__/
               .` ```___....---=-``
              /::` (`
              \`   `:.
               `\::.  `;-"":::-._  {}
            _.--``\:` .``-.```.` `{I}
         .-` `` .;;`\::.   `. _: {-I}`\
       .`  .:.  `:: _):::  _;` `{=I}.:|
      /.  ::::`":::` `:`.-```:. {_I}::/
      |:. `:`  :::::  .`:``:. ``|`:|:`
       \:   .:. ``` .:| .:, _:./`:.|
        `--.:::...---`\:`.:``:``:./
                       `-::..:::-`
    ' ;;
    10) echo 'Si naciste en $anac te corresponde El Caballo según el horóscopo chino
                                      (__
                                   ,_) \_,-/
                                  /__      )__,
                                 )/  _\_    /
                                 /d   \ \   \__
                                /  _.`  /    ( `
                               (,-,) |  |_   |_,
                               ,-.___|_  /_,  /
                               ) .__        ) \
                                \ \\`-..-    \(`.
                                 \( \_\          `._
                                  \`-,``.           `-.
                                   ``    `-.__         \
                                              `,`      |-,._)
                                              !       ,`)   `-.
                                              (    ,-`  (   ,-.)
                                               \   \  \ _/   \_
                                                \_ |\_ \`-`._  )
                                                ( ,`( /      )/
                                            __,`,`__/(
                                           /__(^ 7..1"
    ' ;;
    11) echo 'Si naciste en $anac te corresponde La Cabra según el horóscopo chino
                                      ,,~~--___---,
                                     /            .~,
                               /  _,~             )
                              (_-(~)   ~, ),,,(  /`
                               Z6  .~`` ||     \ |
                               /_,/     ||      ||
                         ~~~~~~~~~~~~~~~W`~~~~~~W`~~~~~~~~~
    ' ;;
esac
