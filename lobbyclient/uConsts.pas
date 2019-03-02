unit uConsts;

interface

const

{ indexes of ping in latency resource }
  PING_RED_IDX         = 0;
  PING_YELLOW_IDX      = 1;
  PING_GREEN_IDX       = 2;
  PING_PUREGREEN_IDX   = 3;

  ROOM_OFF_IDX         = 0;
  ROOM_ON_IDX          = 1;

  JOIN_OFF_IDX         = 0;
  JOIN_ON_IDX          = 1;
  JOIN_DOWN_IDX        = 2;
  JOIN_DISABLED_IDX    = 3;
  HOST_OFF_IDX         = 4;
  HOST_ON_IDX          = 5;
  HOST_DOWN_IDX        = 6;

  INFO_OFF_IDX         = 0;
  INFO_ON_IDX          = 1;
  INFO_DOWN_IDX        = 2;

  JOINBTN_OFF_IDX      = 0;
  JOINBTN_ON_IDX       = 1;
  JOINBTN_DOWN_IDX     = 2;
  LEAVEBTN_OFF_IDX     = 3;
  LEAVEBTN_ON_IDX      = 4;
  LEAVEBTN_DOWN_IDX    = 5;
  LAUNCHBTN_OFF_IDX    = 6;
  LAUNCHBTN_ON_IDX     = 7;
  LAUNCHBTN_DOWN_IDX   = 8;
  SETTINGSBTN_OFF_IDX  = 9;
  SETTINGSBTN_ON_IDX   = 10;
  SETTINGSBTN_DOWN_IDX = 11;

  SEND_UP_IDX       = 0;
  SEND_HOVER_IDX    = 1;
  SEND_DOWN_IDX     = 2;
  SEND_DISABLED_IDX = 3;

  FONT_UP_IDX       = 0;
  FONT_HOVER_IDX    = 1;
  FONT_DOWN_IDX     = 2;
  FONT_DISABLED_IDX = 3;
  EMOT_UP_IDX       = 4;
  EMOT_HOVER_IDX    = 5;
  EMOT_DOWN_IDX     = 6;
  EMOT_DISABLED_IDX = 7;


  PING_PUREGREEN_MAX   = 180;
  PING_GREEN_MAX       = 300;
  PING_YELLOW_MAX      = 600;
  LOOKING_COLOR        = $FFFFFF;
  WAITING_COLOR        = $CBCBCB;
  PLAYING_COLOR        = $999999;
  LINE_COLOR           = $999966;
  WAITING_FOR_PLAYERS  = 'Waiting for Players';
  GAME_IN_PROGRESS     = 'Game in Progress';
  JOIN_IN_PROGRESS     = 'Join in Progress';

{ Resource Names }
  RESOURCES_FILE      = 'CommonRes.dll'; { do not localize }
  RN_LATENCY          = 'LATENCY'; { do not localize }
  RN_BUBBLE           = 'BUBBLE'; { do not localize }
  RN_ROOM             = 'ROOM'; { do not localize }
  RN_TOOL             = 'TOOL'; { do not localize }
  RN_BUTTON           = 'BUTTON'; { do not localize }
  RN_INFO             = 'INFO'; { do not localize }
  RN_LOGO             = 'LOGO'; { do not localize }
  RN_BANNER           = 'BANNER'; { do not localize }
  RN_ROOMBKG          = 'ROOMBKG'; { do not localize }
  RN_AGE2LOBBY        = 'AGE2LOBBY'; { do not localize }
  RN_AGE2XLOBBY       = 'AGE2XLOBBY'; { do not localize }
  RN_SPLASH           = 'SPLASH'; { do not localize }
  RN_LOCK             = 'LOCK'; { do not localize }
  RN_DOT              = 'DOT'; { do not localize }
  RN_CONFIG           = 'CONFIG'; { do not localize }
  RN_CHAT             = 'CHAT'; { do not localize }
  RN_SEND             = 'SEND'; { do not localize }
  RN_EMOFONT          = 'EMOFONT'; { do not localize }
  RN_EMOTS            = 'EMOTS'; { do not localize }

{ PlayersTreeView Node Names }
  TOTAL_PLAYERS       = 'TOTAL PLAYERS';
  MEMBER_PLUS         = 'MEMBER PLUS';
  FRIENDS             = 'FRIENDS';
  LOOKING             = 'LOOKING';
  WAITING             = 'WAITING';
  PLAYING             = 'PLAYING';
  HOST_CAP            = 'HOST';
  PLAYERS_CAP         = 'PLAYERS';

  GAME_ID             = 'Game %d';

  LOOKING_STATUS      = 'Looking';
  WAITING_STATUS      = 'Waiting in Game %d';
  PLAYING_STATUS      = 'Playing in Game %d%s';

  { Game Types }
   gtRandomMap       = 0;
   grRegicide        = 1;
   gtDeathMatch      = 2;
   gtScenario        = 3;
   gtKingOfTheHill   = 4;
   gtWonderRace      = 5;
   gtDefendTheWonder = 6;
   gtTurboRandomMap  = 7;
   { Map Styles }
   msStandard  = 0;
   msRealWorld = 1;
   msCustom    = 2;
   { Maps }
   mArabia           = 0;
   mNomad            = 22;
   mIberia           = 23;
   mByzantinum       = 32;
   mCustom           = 33;
   mRandomLandMap    = 34;
   mFullRandom       = 35;
   mCustomFullRandom = 36;
   mBlindRandom      = 37;
   { Difficulties }
   { Victories }
   vStandard        = 0;
   vConquest        = 1;
   vTimeLimit       = 2;
   vScore           = 3;
   vLastManStanding = 4;

implementation

end.
