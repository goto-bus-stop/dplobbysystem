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

$sql = 'SELECT *
        FROM lobbyserver_games
        ORDER BY id DESC';
if (!($result = $db->sql_query($sql))) {
  exit;
}
$games = array();
while ($row = $db->sql_fetchrow($result)) {
  $games[] = array(
    'id'       => (int)$row['id'],
    'duration' => (int)$row['duration'],
    'map'      => (int)$row['map'],
    'datetime' => $row['datetime']
  );
}
foreach ($games as $game) {
    $template->assign_block_vars('game', array(
      'ID'       => $game['id'],
      'DURATION' => GameHelper::formatGameTime($game['duration']),
      'MAP'      => GameHelper::$MAPS[$game['map']],
      'DATETIME' => sprintf('%s GMT', $game['datetime'])
    ));
}

$template->set_filenames(array(
  'body' => 'games.html'
));

$template->display('body', '', true);  
?>
