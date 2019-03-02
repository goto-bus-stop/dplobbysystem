<?php
include('../config.php');
include('../db/mysql.php');
include('../LobbyServer.php');

include_once('template.php');
$template = new template();
$template->set_custom_template('templates');

$db = new $sql_db();
$db->sql_connect($dbhost, $dbuser, $dbpasswd, $dbname, $dbport, false, false);
unset($dbpasswd);

$lobbyServer = new LobbyServer($db);
$games = $lobbyServer->exportGames();

date_default_timezone_set('UTC');
function diffInMins($dt2) {
  $now = strtotime(gmdate('Y-m-d H:i:s'));
  $timestamp = strtotime($dt2);
  return round(abs($now - $timestamp) / 60); 
}

foreach ($games as $game) {
  $template->assign_block_vars('game', array(
    'NAME'     => htmlspecialchars($game['game'], ENT_QUOTES),
    'PLAYERS'  => count($game['playerlist']),
    'DESC'     => htmlspecialchars($game['desc'], ENT_QUOTES),
    'PLAYTIME' => diffInMins($game['datetime'])
  ));
  foreach ($game['playerlist'] as $player) {
    $template->assign_block_vars('game.player', array(
      'ID'    => $player['id'],
      'NAME'  => htmlspecialchars($player['username'], ENT_QUOTES)
    ));
  }
}

$template->set_filenames(array(
  'body' => 'hostedgames.html'
));

$template->display('body', '', true);  
?>
