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

$id = isset($_GET['id']) ? $_GET['id'] : 0;

$lobbyGame = new LobbyGame($db);
if (!$lobbyGame->get($id)) {
  echo 'Game has not been found.';
  exit;
}

$template->assign_vars(array(
  'ID'       => $lobbyGame->id,
  'DURATION' => GameHelper::formatGameTime($lobbyGame->duration),
  'MAP'      => GameHelper::$MAPS[$lobbyGame->map],
  'DATETIME' => sprintf('%s GMT', $lobbyGame->datetime),
  'PLAYERS'  => sprintf('%d vs %d', count($lobbyGame->teams[0]), count($lobbyGame->teams[1]))
));

$R = array(0, 0);
$C = array(0, 0);
foreach ($lobbyGame->players as $player) {
  $R[$player->team] += $player->rating;
  $C[$player->team]++;
}
$elo = new EloRating($R[0], $R[1], $C[0], $C[1]);

foreach ($lobbyGame->teams as $team) {
  $template->assign_block_vars('team', array());
  foreach ($team as $player) {
    $template->assign_block_vars('team.player', array(
      'ID'           => $player->id,
      'RATING'       => $player->rating,
      'NAME'         => htmlspecialchars($player->playerName, ENT_QUOTES),
      'CIV_ID'       => $player->civilization,
      'CIVILIZATION' => GameHelper::$CIVS[$player->civilization],
      'TEAM'         => $player->team,
      'MEDAL'        => $player->medal,
      'RESULT'       => $player->result,
      'WIN_PTS'      => sprintf('+%d', ($player->team == 0) ? $elo->winP1() : $elo->winP2()),
      'LOSS_PTS'     => ($player->team == 0) ? $elo->lossP1() : $elo->lossP2()
    ));
  }    
}

foreach ($lobbyGame->players as $player) {
  $template->assign_block_vars('player', array(
    'ID'               => $player->id,
    'NAME'             => htmlspecialchars($player->playerName, ENT_QUOTES),
    'TOTAL_SCORE'      => $player->totalScore,
    'MILITARY_SCORE'   => $player->militaryStats->militaryScore,
    'ECONOMY_SCORE'    => $player->economyStats->economyScore,
    'TECHNOLOGY_SCORE' => $player->technologyStats->technologyScore,
    'SOCIETY_SCORE'    => $player->societyStats->societyScore,
    'UNITS_KILLED'     => $player->militaryStats->unitsKilled,
    'UNITS_LOST'       => $player->militaryStats->unitsLost,
    'BUILDINGS_RAZED'  => $player->militaryStats->buildingsRazed,
    'BUILDINGS_LOST'   => $player->militaryStats->buildingsLost,
    'UNITS_CONVERTED'  => $player->militaryStats->unitsConverted,
    'FOOD_COLLECTED'   => $player->economyStats->foodCollected,
    'WOOD_COLLECTED'   => $player->economyStats->woodCollected,
    'STONE_COLLECTED'  => $player->economyStats->stoneCollected,
    'GOLD_COLLECTED'   => $player->economyStats->goldCollected,
    'TRIBUTE_SENT'     => $player->economyStats->tributeSent,
    'TRIBUTE_RCVD'     => $player->economyStats->tributeRcvd,
    'TRADE_PROFIT'     => $player->economyStats->tradeProfit,
    'RELIC_GOLD'       => $player->economyStats->relicGold,
    'FEUDAL_AGE'       => GameHelper::formatGameTime($player->technologyStats->feudalAge),
    'CASTLE_AGE'       => GameHelper::formatGameTime($player->technologyStats->castleAge),
    'IMPERIAL_AGE'     => GameHelper::formatGameTime($player->technologyStats->imperialAge),
    'MAP_EXPLORED'     => sprintf('%d%%', $player->technologyStats->mapExplored),
    'RESEARCH_COUNT'   => $player->technologyStats->researchCount,
    'RESEARCH_PERCENT' => sprintf('%d%%', $player->technologyStats->researchPercent),
    'TOTAL_WONDERS'    => $player->societyStats->totalWonders,
    'TOTAL_CASTLES'    => $player->societyStats->totalCastles,
    'RELICS_CAPTURED'  => $player->societyStats->relicsCaptured,
    'VILLAGER_HIGH'    => $player->societyStats->villagerHigh
  ));
}

$template->set_filenames(array(
  'body' => 'game.html'
));

$template->display('body', '', true); 
?>
