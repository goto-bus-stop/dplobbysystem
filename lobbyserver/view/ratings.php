<?php
include('../config.php');
include('../db/mysql.php');

include_once('template.php');
$template = new template();
$template->set_custom_template('templates');

$db = new $sql_db();
$db->sql_connect($dbhost, $dbuser, $dbpasswd, $dbname, $dbport, false, false);
unset($dbpasswd);

$all = isset($_GET['all']);

$sql = 'SELECT r.*, u.username
        FROM lobbyserver_ratings r
        JOIN lobbyserver_users u ON u.id = r.uid
        ORDER BY rating DESC, r.wins DESC, r.losses DESC, u.id ASC';
if (!($result = $db->sql_query($sql))) {
  exit;
}
$players = array();
while ($row = $db->sql_fetchrow($result)) {
  $players[] = array(
    'id'          => $row['id'],
    'rank'        => count($players) + 1,
    'username'    => $row['username'],
    'rating'      => $row['rating'],
    'games'       => $row['wins'] + $row['losses'] + $row['incompletes'],
    'wins'        => $row['wins'],
    'losses'      => $row['losses'],
    'streak'      => $row['streak'],
    'incompletes' => $row['incompletes'],
  ); 
}

foreach ($players as $player) {
  if (!$all && $player['games'] == 0) {
    continue;
  }
  $template->assign_block_vars('player', array(
    'ID'          => $player['id'],
    'RANK'        => $player['rank'],
    'PLAYERNAME'  => htmlspecialchars($player['username'], ENT_QUOTES),
    'RATING'      => $player['rating'],
    'GAMES'       => $player['games'],
    'WINS'        => $player['wins'],
    'LOSSES'      => $player['losses'],
    'WINPERC'     => $player['games'] > 0 ? round($player['wins'] *  100 / $player['games'], 1) : 0,
    'STREAK'      => $player['streak'],
    'INCOMPLETES' => $player['incompletes'],
  ));
}

$template->set_filenames(array(
  'body' => 'ratings.html'
));

$template->display('body', '', true);
?>
