<?php
/**
* @package dplobbysystem
* @copyright (c) 2010 biegleux <biegleux@gmail.com>
* @license http://opensource.org/licenses/gpl-2.0.php GNU GPLv2
*/ 

class EloRating {

  private $WP1;
  private $WP2;
  private $C1;
  private $C2;

  public function __construct($R1, $R2, $C1 = 1, $C2 = 1) {

    $R1 = $R1 / $C1;
    $R2 = $R2 / $C2;
    $f1 = max(min(($R2 - $R1) / 400, 1), -1);
    $f2 = -$f1;
    $kF = 16;
    $this->WP1 = max($kF * (1 + $f1), 1);
    $this->WP2 = max($kF * (1 + $f2), 1);
    $this->C1 = $C1;
    $this->C2 = $C2;
  }
  public function winP1() {
    return round($this->WP1 / $this->C1);
  }
  public function winP2() {
    return round($this->WP2 / $this->C2);
  }
  public function lossP1() {
    return -round($this->WP2 / $this->C1);
  }
  public function lossP2() {
    return -round($this->WP1 / $this->C2);
  }
}

class MilitaryStats {

  public 
    $militaryScore,
    $unitsKilled,
    $unitsLost,
    $buildingsRazed,
    $buildingsLost,
    $unitsConverted;

  public function assign($militaryStats) {

    if (!is_array($militaryStats) || count($militaryStats) < 6) {
      return false;
    }
    if (array_keys($militaryStats) === range(0, sizeof($militaryStats) - 1)) {
      $this->militaryScore  = (int)$militaryStats[0];
      $this->unitsKilled    = (int)$militaryStats[1];
      $this->unitsLost      = (int)$militaryStats[2];
      $this->buildingsRazed = (int)$militaryStats[3];
      $this->buildingsLost  = (int)$militaryStats[4];
      $this->unitsConverted = (int)$militaryStats[5];
    } else {
      $this->militaryScore  = (int)$militaryStats['military'];
      $this->unitsKilled    = (int)$militaryStats['units_killed'];
      $this->unitsLost      = (int)$militaryStats['units_lost'];
      $this->buildingsRazed = (int)$militaryStats['buildings_razed'];
      $this->buildingsLost  = (int)$militaryStats['buildings_lost'];
      $this->unitsConverted = (int)$militaryStats['units_converted'];
    }
    return true;    
  }  
}

class EconomyStats {

  public
    $economyScore,
    $foodCollected,
    $woodCollected,
    $stoneCollected,
    $goldCollected,
    $tributeSent,
    $tributeRcvd,
    $tradeProfit,
    $relicGold;

  public function assign($economyStats) {

    if (!is_array($economyStats) || count($economyStats) < 9) {
      return false;
    }
    if (array_keys($economyStats) === range(0, sizeof($economyStats) - 1)) {
      $this->economyScore   = (int)$economyStats[0];
      $this->foodCollected  = (int)$economyStats[1];
      $this->woodCollected  = (int)$economyStats[2];
      $this->stoneCollected = (int)$economyStats[3];
      $this->goldCollected  = (int)$economyStats[4];
      $this->tributeSent    = (int)$economyStats[5];
      $this->tributeRcvd    = (int)$economyStats[6];
      $this->tradeProfit    = (int)$economyStats[7];
      $this->relicGold      = (int)$economyStats[8];
    } else {
      $this->economyScore   = (int)$economyStats['economy'];
      $this->foodCollected  = (int)$economyStats['food_collected'];
      $this->woodCollected  = (int)$economyStats['wood_collected'];
      $this->stoneCollected = (int)$economyStats['stone_collected'];
      $this->goldCollected  = (int)$economyStats['gold_collected'];
      $this->tributeSent    = (int)$economyStats['tribute_sent'];
      $this->tributeRcvd    = (int)$economyStats['tribute_rcvd'];
      $this->tradeProfit    = (int)$economyStats['trade_profit'];
      $this->relicGold      = (int)$economyStats['relic_gold'];
    }
    return true;
  }
}

class TechnologyStats {

  public
    $technologyScore,
    $feudalAge,
    $castleAge,
    $imperialAge,
    $mapExplored,
    $researchCount,
    $researchPercent;

  public function assign($technologyStats) {

    if (!is_array($technologyStats) || count($technologyStats) < 7) {
      return false;
    }
    if (array_keys($technologyStats) === range(0, sizeof($technologyStats) - 1)) {
      $this->technologyScore = (int)$technologyStats[0];
      $this->feudalAge       = (int)$technologyStats[1];
      $this->castleAge       = (int)$technologyStats[2];
      $this->imperialAge     = (int)$technologyStats[3];
      $this->mapExplored     = (int)$technologyStats[4];
      $this->researchCount   = (int)$technologyStats[5];
      $this->researchPercent = (int)$technologyStats[6];
    } else {
      $this->technologyScore = (int)$technologyStats['technology'];
      $this->feudalAge       = (int)$technologyStats['feudal_age'];
      $this->castleAge       = (int)$technologyStats['castle_age'];
      $this->imperialAge     = (int)$technologyStats['imperial_age'];
      $this->mapExplored     = (int)$technologyStats['map_explored'];
      $this->researchCount   = (int)$technologyStats['research_count'];
      $this->researchPercent = (int)$technologyStats['research_percent'];
    }
    return true;
  }
}

class SocietyStats {

  public
    $societyScore,
    $totalWonders,
    $totalCastles,
    $relicsCaptured,
    $villagerHigh;

  public function assign($societyStats) {

    if (!is_array($societyStats) || count($societyStats) < 5) {
      return false;
    }
    if (array_keys($societyStats) === range(0, sizeof($societyStats) - 1)) {
      $this->societyScore   = (int)$societyStats[0];
      $this->totalWonders   = (int)$societyStats[1];
      $this->totalCastles   = (int)$societyStats[2];
      $this->relicsCaptured = (int)$societyStats[3];
      $this->villagerHigh   = (int)$societyStats[4];
    } else {
      $this->societyScore   = (int)$societyStats['society'];
      $this->totalWonders   = (int)$societyStats['total_wonders'];
      $this->totalCastles   = (int)$societyStats['total_castles'];
      $this->relicsCaptured = (int)$societyStats['relics_captured'];
      $this->villagerHigh   = (int)$societyStats['villager_high'];
    }
    return true;
  }
}

class LobbyPlayer {

  public
    $id,
    $rating,
    $streak,
    $playerName,
    $totalScore,
    $civilization,
    $index,
    $team,
    $medal,
    $result,
    $militaryStats,
    $economyStats,
    $technologyStats,
    $societyStats;

  public function __construct() {

    $this->militaryStats = new MilitaryStats();
    $this->economyStats = new EconomyStats();
    $this->technologyStats = new TechnologyStats();
    $this->societyStats = new SocietyStats();
  }

  public function assign($playerStats) {

    if (!is_array($playerStats) || count($playerStats) != 5) {
      return false; 
    }
    $data = explode(';', $playerStats[0]);
    if (count($data) != 7) {
      return false;
    }
    $this->playerName   = base64_decode($data[0]);
    $this->totalScore   = (int)$data[1]; 
    $this->civilization = (int)$data[2];
    $this->index        = (int)$data[3];
    $this->team         = (int)$data[4];         
    $this->medal        = (int)$data[5];
    $this->result       = (int)$data[6];

    if (!$this->militaryStats->assign(explode(';', $playerStats[1]))
      || !$this->economyStats->assign(explode(';', $playerStats[2]))
      || !$this->technologyStats->assign(explode(';', $playerStats[3]))
      || !$this->societyStats->assign(explode(';', $playerStats[4]))) {
      return false;
    }

    return true;
  }
}

class LobbyGame {

  private
    $_db,
    $_senderIndex,
    $_twoTeams;
  public
    $id,
    $allowCheats,
    $complete,
    $duration,
    $map,
    $datetime,
    $players,
    $teams;

  public function __construct($db) {

    $this->_db = $db;
    $this->_senderIndex = 0;
    $this->_twoTeams = false;
    $this->players = array();
    $this->teams = array(array(), array());
  }

  public function parse($input) {

    if (!isset($input) || ($input == '')) {
      return false;
    }
    $ary = explode('#', $input);
    if (count($ary) < 2) {  // gamestats plus at least two players
      return false;
    }
    $gameStats = explode(';', $ary[0]);
    if (count($gameStats) != 5) {
      return false;
    }
    $this->duration    = $gameStats[0];
    $this->allowCheats = $gameStats[1];
    $this->complete    = $gameStats[2];
    $this->map         = $gameStats[3];
    $this->_senderIndex  = $gameStats[4]; 
    for ($i = 1; $i < count($ary); $i++) {
      $playerStats = explode('|', $ary[$i]);
      $lobbyPlayer = new LobbyPlayer();
      if (!$lobbyPlayer->assign($playerStats)) {
        return false;
      }
      $this->players[] = $lobbyPlayer; 
    }
    
    // adjust teams
    $hashMap = array(); $team = 0;
    foreach ($this->players as $lobbyPlayer) {
      $teamId = $lobbyPlayer->team;
      $teamId--;
      if ($teamId == 0) {
        $lobbyPlayer->team = $team;
        $team++;
      } else {
        if (!isset($hashMap[$teamId])) {
          $hashMap[$teamId] = $team;
          $team++;
        }
        $lobbyPlayer->team = $hashMap[$teamId];
      }
    }
    $this->_twoTeams = ($team == 2);
    return true;
  }

  public function getSender() {

    if (isset($this->players[$this->_senderIndex])) {
      return $this->players[$this->_senderIndex]->playerName; 
    }
    return '';
  }

  public function hasExactlyTwoTeams() {

    return $this->_twoTeams;
  }

  public function hasCoopingPlayer() {

    $indexes = array();
    foreach ($this->players as $player) {
      if (in_array($player->index, $indexes)) {
        return true;
      }
      $indexes[] = $player->index;
    }
    return false;
  }

  public function insert() {

    // additional check
    if (!$this->hasExactlyTwoTeams()) {
      return false;
    }
    $this->_db->sql_transaction('begin');
    $dt = new DateTime(null, new DateTimeZone('GMT'));
    $sql_ary = array(
      'duration'  => $this->duration,
      'map'       => $this->map,
      'datetime'  => $dt->format('Y-m-d H:i:s')
    );
    $sql = 'INSERT INTO lobbyserver_games ' . $this->_db->sql_build_array('INSERT', $sql_ary);
    if (!$this->_db->sql_query($sql)) {
      $this->_db->sql_transaction('rollback');
      return false;
    }
    if (!($this->id = $this->_db->sql_nextid())) {
      $this->_db->sql_transaction('rollback');
      return false;
    }
    $sql_ary = array();
    foreach ($this->players as $lobbyPlayer) {
      $sql_ary[] = array(
        'gid'               => $this->id,
        'uid'               => $lobbyPlayer->id,
        'rating'            => $lobbyPlayer->rating,
        'total_score'       => $lobbyPlayer->totalScore,
        'civilization'      => $lobbyPlayer->civilization,
        'team'              => $lobbyPlayer->team,
        'medal'             => $lobbyPlayer->medal,
        'result'            => $lobbyPlayer->result,
        'military'          => $lobbyPlayer->militaryStats->militaryScore,
        'units_killed'      => $lobbyPlayer->militaryStats->unitsKilled,
        'units_lost'        => $lobbyPlayer->militaryStats->unitsLost,
        'buildings_razed'   => $lobbyPlayer->militaryStats->buildingsRazed,
        'buildings_lost'    => $lobbyPlayer->militaryStats->buildingsLost,
        'units_converted'   => $lobbyPlayer->militaryStats->unitsConverted,
        'economy'           => $lobbyPlayer->economyStats->economyScore,
        'food_collected'    => $lobbyPlayer->economyStats->foodCollected,
        'wood_collected'    => $lobbyPlayer->economyStats->woodCollected,
        'stone_collected'   => $lobbyPlayer->economyStats->stoneCollected,
        'gold_collected'    => $lobbyPlayer->economyStats->goldCollected,
        'tribute_sent'      => $lobbyPlayer->economyStats->tributeSent,
        'tribute_rcvd'      => $lobbyPlayer->economyStats->tributeRcvd,
        'trade_profit'      => $lobbyPlayer->economyStats->tradeProfit,
        'relic_gold'        => $lobbyPlayer->economyStats->relicGold,
        'technology'        => $lobbyPlayer->technologyStats->technologyScore,
        'feudal_age'        => $lobbyPlayer->technologyStats->feudalAge,
        'castle_age'        => $lobbyPlayer->technologyStats->castleAge,
        'imperial_age'      => $lobbyPlayer->technologyStats->imperialAge,
        'map_explored'      => $lobbyPlayer->technologyStats->mapExplored,
        'research_count'    => $lobbyPlayer->technologyStats->researchCount,
        'research_percent'  => $lobbyPlayer->technologyStats->researchPercent,
        'society'           => $lobbyPlayer->societyStats->societyScore,
        'total_wonders'     => $lobbyPlayer->societyStats->totalWonders,
        'total_castles'     => $lobbyPlayer->societyStats->totalCastles,
        'relics_captured'   => $lobbyPlayer->societyStats->relicsCaptured,
        'villager_high'     => $lobbyPlayer->societyStats->villagerHigh
      );
    }
    if (empty($sql_ary)) {
      $this->_db->sql_transaction('rollback');
      return false;
    }
    $this->_db->sql_multi_insert('lobbyserver_players', $sql_ary);
 
    //update ratings
    $teams = array();
    for ($i = 0; $i < 2; $i++) {
      $teams[] = array(
        'players' => 0,
        'rating'  => 0
      );
    }
    foreach ($this->players as $lobbyPlayer) {
      $teamId = $lobbyPlayer->team;
      $teams[$teamId]['players']++;
      $teams[$teamId]['rating'] += $lobbyPlayer->rating;
    }
    $R1 = $teams[0]['rating'] / $teams[0]['players'];
    $R2 = $teams[1]['rating'] / $teams[1]['players']; 
    $elo = new EloRating($R1, $R2);
    $teams[0]['win']  = round($elo->winP1()  / $teams[0]['players']);
    $teams[0]['loss'] = round($elo->lossP1() / $teams[0]['players']);
    $teams[1]['win']  = round($elo->winP2()  / $teams[1]['players']);
    $teams[1]['loss'] = round($elo->lossP2() / $teams[1]['players']);

    $sql_ary = array();    
    foreach ($this->players as $lobbyPlayer) {
      $teamId = $lobbyPlayer->team;
      $streak = $lobbyPlayer->streak;
      $sql = 'UPDATE lobbyserver_ratings
              SET rating = rating + %d, wins = wins + %d, losses = losses + %d, streak = %d, incompletes = incompletes + %d
              WHERE uid = %d';
      switch ($lobbyPlayer->result) {
        case 0:
          ($streak < 0) ? $streak-- : $streak = -1;          
          $sql = sprintf($sql, $teams[$teamId]['loss'], 0, 1, $streak, 0, $lobbyPlayer->id);
          break;
        case 1:
          ($streak > 0) ? $streak++ : $streak = 1;
          $sql = sprintf($sql, $teams[$teamId]['win'], 1, 0, $streak, 0, $lobbyPlayer->id);
          break;
        case 2:
          ($streak < 0) ? $streak-- : $streak = -1;
          $sql = sprintf($sql, $teams[$teamId]['loss'], 0, 1, $streak, 0, $lobbyPlayer->id);
          break;
        case 3:
          ($streak < 0) ? $streak-- : $streak = -1;
          $sql = sprintf($sql, $teams[$teamId]['loss'], 0, 1, $streak, 1, $lobbyPlayer->id);
          break;
      }
      $this->_db->sql_query($sql);
    }
    $this->_db->sql_transaction('commit');
    return true;
  }

  public function get($id) {

    $sql = 'SELECT g.*, g.id AS game_id, p.*, u.username 
            FROM lobbyserver_games g
            JOIN lobbyserver_players p ON p.gid = g.id
            JOIN lobbyserver_users u ON u.id = p.uid
            WHERE g.id = ' . (int)$id . '
            ORDER BY g.id DESC';
    if (!($result = $this->_db->sql_query($sql))) {
      return false;
    }
    $this->players = array();
    $this->teams = array(array(), array());
    while ($row = $this->_db->sql_fetchrow($result)) {
      $this->id = (int)$row['game_id'];
      $this->duration = (int)$row['duration'];
      $this->map = (int)$row['map'];
      $this->datetime = $row['datetime'];
      $lobbyPlayer = new LobbyPlayer();
      $lobbyPlayer->id = $row['uid'];
      $lobbyPlayer->rating = $row['rating'];
      $lobbyPlayer->playerName = $row['username'];
      $lobbyPlayer->totalScore = $row['total_score'];
      $lobbyPlayer->civilization = $row['civilization'];
      $lobbyPlayer->team = $row['team'];
      $lobbyPlayer->medal = $row['medal'];
      $lobbyPlayer->result = $row['result'];
      $lobbyPlayer->militaryStats->assign($row);
      $lobbyPlayer->economyStats->assign($row);
      $lobbyPlayer->technologyStats->assign($row);
      $lobbyPlayer->societyStats->assign($row);
      $this->players[] = $lobbyPlayer;
      $this->teams[$lobbyPlayer->team][] = $lobbyPlayer;
    }
    return (!empty($this->players));
  }
}
?>
