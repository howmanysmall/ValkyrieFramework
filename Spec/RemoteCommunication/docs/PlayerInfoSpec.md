# Player Info Specifications #

## Getting information about a player ##
An example request to get information about a player would be:

    http://gskw.noip.me:5678/playerinfo/getUserinfo/testGame/testKey
    
The MIME type would be set to `text/plain` and the POST body would contain:

    id=36537369
    
An example response would be:

    error="";result=[1427645378,[36537369,"gskw",false],[["15 min","just now","1 h 32 min"],["999","1427639731","1427639752"]],[["basic_bronze","test","Basic Bronze Achievement","This achievement is awarded to you once you complete the first quest.

    Should not be challenging at all!",1,231496690],["basic_bronze_master","test","Epic Bronze Achievement","The super duper achievement!!",2,186253726]],3,[[31442735,"destrojet",false],[3838167,"Naruto6192",false],[65765854,"eLunate",false],[58718869,"HttpGetAsync",false],[61441223,"Temppeliherra",false],[19641443,"michaelkeysgate",false],[28893687,"storadow",false],[37586818,"averywalters11",false],[27578143,"Ninja560000",false]]];success=true
    
Let's break it down and indent it.

    error="";result=[
        1427645378,     # Current timestamp. Might be removed.
        [
            36537369,   # ID
            "gskw",     # Username
            false       # Online?
                        # If online, the GID here
                        # If online, the name of the game here
        ],
        [
            [
                "15 min",       # 15 mins of play time
                "just now",     # Registered "just now" (the same day)
                "1 h 32 min"    # Last seen 1h 32min ago
            ],
            [
                "999",          # 999 seconds of play time
                "1427639731",   # Timestamp registered at
                "1427639752"    # Timestamp last seen
            ]
        ],
        [
            [
                "basic_bronze",                                                         # Achievement ID: basic_bronze
                "test",                                                                 # Achievement GID: test
                "Basic Bronze Achievement",                                             # Achievement name: Basic Bronze Achievement
                "This achievement is awarded to you once you complete the first quest.  # Achievement description
                                                                                        # ...
                Should not be challenging at all!",                                     # ...
                1,                                                                      # Achievement reward: 1
                231496690                                                               # Achievement icon ID
            ],
            [
                "basic_bronze_master",
                "test",
                "Epic Bronze Achievement",
                "The super duper achievement!!",
                2,
                186253726
            ]
        ],
        3, # Total reward: 3
        [
            [
                31442735,       # Friend #1 ID 
                "destrojet",    # Friend #1 username
                false           # Friend #1 online?
                                # If online, the GID here
                                # If online, the name of the game here
            ],
            ...
        ]
    ];success=true
    
That should clarify things a lot.