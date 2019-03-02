<?php
include('../config.php');
include('../db/mysql.php');
include('../LobbyGame.php');
include('GameHelper.php');

include_once('template.php');
$template = new template();
$template->set_custom_template('templates');

$db = new $sql_db();
$db->sql_connect($dbhost, $dbuser, $dbpasswd, $dbname, $dbport, false, false);
unset($dbpasswd);

$userId = isset($_GET['id']) ? $_GET['id'] : 0;

if (!is_numeric($userId)) {
  $sql = "SELECT r.*, u.username
          FROM lobbyserver_ratings r
          JOIN lobbyserver_users u ON u.id = r.uid
          WHERE u.username = '" . $db->sql_escape($userId) . "'";
} else {
  $sql = 'SELECT r.*, u.username
          FROM lobbyserver_ratings r
          JOIN lobbyserver_users u ON u.id = r.uid
          WHERE u.id = ' . (int)$userId;
}
if (!($result = $db->sql_query($sql)) || !($row = $db->sql_fetchrow($result))) {
  exit;
}

$userId = (int)$row['id'];
 
$player = array(
  'username'    => $row['username'],
  'rating'      => (int)$row['rating'],
  'games'       => (int)($row['wins'] + $row['losses'] + $row['incompletes']),
  'wins'        => (int)$row['wins'],
  'losses'      => (int)$row['losses'],
  'streak'      => (int)$row['streak'],
  'incompletes' => (int)$row['incompletes'],
);

$sql = 'SELECT g.*, p.result 
        FROM lobbyserver_games g
        JOIN lobbyserver_players p ON p.gid = g.id AND p.uid = ' . (int) $userId . '
        ORDER BY g.id ASC'; // ASC kvoli map streak, inac zobrazovat hry DESC
if (!($result = $db->sql_query($sql))) {
  exit;
}
$games = array();
$maps = array();
while ($row = $db->sql_fetchrow($result)) {
  $mapId = (int)$row['map'];
  $res = (int)$row['result']; 
  $games[] = array(
    'id'       => (int)$row['id'],
    'duration' => (int)$row['duration'],
    'map'      => $mapId,
    'datetime' => $row['datetime'],
    'result'   => $res
  );
  if (isset($maps[$mapId])) {
    $map = $maps[$mapId];
  } else {
    $map = array(
      'games'       => 0,
      'wins'        => 0,
      'losses'      => 0,
      'streak'      => 0,
      'incompletes' => 0
    );
  } 
  switch ($res) {
    case 0:
    case 2:
      ($map['streak'] < 0) ? $map['streak']-- : $map['streak'] = -1;
      $map['losses']++; 
      break;
    case 1:
      ($map['streak'] > 0) ? $map['streak']++ : $map['streak'] = 1;
      $map['wins']++;
      break;
    case 3:
      ($streak < 0) ? $streak-- : $streak = -1;
      $map['incompletes']++;
      break;
  }
  $map['games']++;
  $maps[$mapId] = $map;
}

ksort($maps);

$template->assign_vars(array(
  'PLAYERNAME'  => htmlspecialchars($player['username'], ENT_QUOTES),
  'RATING'      => $player['rating'],
  'GAMES'       => $player['games'],
  'WINS'        => $player['wins'],
  'LOSSES'      => $player['losses'],
  'WINPERC'     => $player['games'] > 0 ? round($player['wins'] *  100 / $player['games'], 1) : 0,
  'STREAK'      => $player['streak'],
  'INCOMPLETES' => $player['incompletes'],
));

foreach ($maps as $mapId => $map) {
  $template->assign_block_vars('map', array(
    'MAP'         => GameHelper::$MAPS[$mapId],
    'GAMES'       => $map['games'], 
    'WINS'        => $map['wins'],
    'LOSSES'      => $map['losses'],
    'WINPERC'     => round($map['wins'] *  100 / $map['games'], 1),
    'STREAK'      => $map['streak'],
    'INCOMPLETES' => $map['incompletes'],
  ));
}
 
for ($i = count($games) - 1; $i >= 0; $i--) {
  $game = $games[$i];
  $template->assign_block_vars('game', array(
    'ID'       => $game['id'],
    'DURATION' => GameHelper::formatGameTime($game['duration']),
    'MAP'      => GameHelper::$MAPS[$game['map']],
    'DATETIME' => sprintf('%s GMT', $game['datetime']),
  ));
}

$template->set_filenames(array(
  'body' => 'player.html'
));

$template->display('body', '', true);
?>