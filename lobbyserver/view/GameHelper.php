<?php
final class GameHelper {
 
  public static $MAPS = array(
    9  => 'Arabia',
    10 => 'Archipelago',
    11 => 'Baltic',
    12 => 'Black Forest',
    13 => 'Coastal',
    14 => 'Continental',
    15 => 'Crater Lake',
    16 => 'Fortress',
    17 => 'Gold Rush',
    18 => 'Highland',
    19 => 'Islands',
    20 => 'Mediterranean',
    21 => 'Migration',
    22 => 'Rivers',
    23 => 'Team Islands',
    24 => 'Random',
    25 => 'Scandinavia',
    26 => 'Mongolia',
    27 => 'Yucatan',
    28 => 'Salt Marsh',
    29 => 'Arena',
    30 => 'King of the Hill',
    31 => 'Oasis',
    32 => 'Ghost Lake',
    33 => 'Nomad',
    34 => 'Iberia',
    35 => 'Britain',
    36 => 'Mideast',
    37 => 'Texas',
    38 => 'Italy',
    39 => 'Central America',
    40 => 'France',
    41 => 'Norse Lands',
    42 => 'Sea of Japan (East Sea)',
    43 => 'Byzantinum',
    44 => 'Custom',
    48 => 'Blind Random'
  );

  public static $CIVS = array(
    '',
    'Britons',
    'Franks',
    'Goths',
    'Teutons',
    'Japanese',
    'Chinese',
    'Byzantines',
    'Persians',
    'Saracens',
    'Turks',
    'Vikings',
    'Mongols',
    'Celts',
    'Spanish',
    'Aztecs',
    'Mayans',
    'Huns',
    'Koreans'
  );
     
  public static function formatGameTime($time, $format = '%02d:%02d:%02d') {

    if ($time == 0) {
      return '-';
    }
    $hour   = (int)($time / 3600);
    $minute = (int)($time / 60) % 60;
    $second = (int)($time) % 60;

    return sprintf($format, $hour, $minute, $second);
  }

  private function __construct() {}
}
?>
