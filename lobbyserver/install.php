<?php
/**
* @package dplobbysystem
* @copyright (c) 2010 biegleux <biegleux@gmail.com>
* @license http://opensource.org/licenses/gpl-2.0.php GNU GPLv2
*/ 

/*
  version 2.00
*/
error_reporting(E_ALL);
define('DOCUMENT_ROOT', dirname(__FILE__) . DIRECTORY_SEPARATOR);
include(DOCUMENT_ROOT . 'config.php');
include(DOCUMENT_ROOT . 'db/mysql.php');

// instantiate db class
$db = new $sql_db();
// connect to db
$db->sql_connect($dbhost, $dbuser, $dbpasswd, $dbname, $dbport, false, false);
// we do not need this any longer, unset for safety purpose
unset($dbpasswd);

$sql = 'CREATE TABLE IF NOT EXISTS lobbyserver_users (
        	id INT unsigned NOT NULL AUTO_INCREMENT,
        	username TEXT NOT NULL,
        	password TEXT CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
        	email TEXT NOT NULL,
        	registered DATETIME NOT NULL,
        	lastlogin DATETIME DEFAULT NULL,
        	token TEXT,
        	PRIMARY KEY(id)
      	) ENGINE=InnoDB DEFAULT CHARSET=utf8;';
$result = $db->sql_query($sql);
var_dump($result);

if (defined('HAMACHI')) {
  $sql = 'ALTER TABLE lobbyserver_users ADD hamachi_ip TEXT AFTER email;';
  $result = $db->sql_query($sql);
  var_dump($result);
}

$sql = 'CREATE TABLE IF NOT EXISTS lobbyserver_hostedgames (
         	id INT unsigned NOT NULL AUTO_INCREMENT,
        	game TEXT,
        	guid TEXT,
        	sessguid TEXT,
          ip TEXT,
          title TEXT,
        	description TEXT,
        	max_players TINYINT unsigned NOT NULL,
        	datetime DATETIME NOT NULL,
        	password TINYINT unsigned NOT NULL DEFAULT 0,
        	rated TINYINT unsigned NOT NULL DEFAULT 0,
        	status TINYINT unsigned NOT NULL DEFAULT 0,
        	room_id TINYINT unsigned NOT NULL,
        	PRIMARY KEY(id)
      	) ENGINE=InnoDB DEFAULT CHARSET=utf8;';
$result = $db->sql_query($sql);
var_dump($result);

$sql = 'CREATE TABLE IF NOT EXISTS lobbyserver_hostedgames_users (
          id INT unsigned NOT NULL AUTO_INCREMENT,
          gid INT unsigned NOT NULL,
          uid INT unsigned NOT NULL,
          is_in TINYINT unsigned NOT NULL DEFAULT 1,
          PRIMARY KEY(id),
        	FOREIGN KEY(gid) REFERENCES lobbyserver_hostedgames(id) ON DELETE CASCADE,
        	FOREIGN KEY(uid) REFERENCES lobbyserver_users(id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;';
$result = $db->sql_query($sql);
var_dump($result);

$sql = "CREATE TABLE IF NOT EXISTS lobbyserver_ratings (
          id INT unsigned NOT NULL AUTO_INCREMENT,
          uid INT unsigned NOT NULL,
          rating_type TINYINT unsigned NOT NULL DEFAULT 0 COMMENT '0=AOCRM',
          rating INT unsigned NOT NULL DEFAULT 1600,
          wins INT unsigned NOT NULL DEFAULT 0,
          losses INT unsigned NOT NULL DEFAULT 0,
          streak INT NOT NULL DEFAULT 0,
          incompletes INT unsigned NOT NULL DEFAULT 0,	
          PRIMARY KEY(id),
          FOREIGN KEY(uid) REFERENCES lobbyserver_users(id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
$result = $db->sql_query($sql);
var_dump($result);

$sql = 'CREATE TABLE IF NOT EXISTS lobbyserver_games (
          id INT unsigned NOT NULL AUTO_INCREMENT,
          duration INT unsigned NOT NULL,
          map TINYINT unsigned NOT NULL,
          datetime DATETIME NOT NULL,
          PRIMARY KEY(id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;';
$result = $db->sql_query($sql);
var_dump($result);

$sql = 'CREATE TABLE IF NOT EXISTS lobbyserver_players (
          id INT unsigned NOT NULL AUTO_INCREMENT,
          gid INT unsigned NOT NULL,
          uid INT unsigned NOT NULL,
          rating INT unsigned NOT NULL DEFAULT 1600,
          total_score SMALLINT unsigned NOT NULL,
          civilization TINYINT unsigned NOT NULL,
          team TINYINT unsigned NOT NULL,
          medal TINYINT unsigned NOT NULL,
          result TINYINT unsigned NOT NULL,
          military SMALLINT unsigned NOT NULL,
          units_killed SMALLINT unsigned NOT NULL,
          units_lost SMALLINT unsigned NOT NULL,
          buildings_razed SMALLINT unsigned NOT NULL,
          buildings_lost SMALLINT unsigned NOT NULL,
          units_converted SMALLINT unsigned NOT NULL,
          economy SMALLINT unsigned NOT NULL,
          food_collected INT unsigned NOT NULL,
          wood_collected INT unsigned NOT NULL,
          stone_collected INT unsigned NOT NULL,
          gold_collected INT unsigned NOT NULL,
          tribute_sent SMALLINT unsigned NOT NULL,
          tribute_rcvd SMALLINT unsigned NOT NULL,
          trade_profit SMALLINT unsigned NOT NULL,
          relic_gold SMALLINT unsigned NOT NULL,
          technology SMALLINT unsigned NOT NULL,
          feudal_age INT unsigned NOT NULL,
          castle_age INT unsigned NOT NULL,
          imperial_age INT unsigned NOT NULL,
          map_explored TINYINT unsigned NOT NULL,
          research_count TINYINT unsigned NOT NULL,
          research_percent TINYINT unsigned NOT NULL,
          society SMALLINT unsigned NOT NULL,
          total_wonders TINYINT unsigned NOT NULL,
          total_castles TINYINT unsigned NOT NULL,
          relics_captured TINYINT unsigned NOT NULL,
          villager_high SMALLINT unsigned NOT NULL,
          PRIMARY KEY(id),
          FOREIGN KEY(gid) REFERENCES lobbyserver_games(id) ON DELETE CASCADE,
          FOREIGN KEY(uid) REFERENCES lobbyserver_users(id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;';
$result = $db->sql_query($sql);
var_dump($result);
?>
