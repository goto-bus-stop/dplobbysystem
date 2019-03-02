<?php
/**
* @package dplobbysystem
* @copyright (c) 2010 biegleux <biegleux@gmail.com>
* @license http://opensource.org/licenses/gpl-2.0.php GNU GPLv2
*/ 

error_reporting(E_ALL);
define('DOCUMENT_ROOT', dirname(__FILE__) . DIRECTORY_SEPARATOR);
include(DOCUMENT_ROOT . 'config.php');
include(DOCUMENT_ROOT . 'db/mysql.php');
include(DOCUMENT_ROOT . 'LobbyGame.php');
include(DOCUMENT_ROOT . 'LobbyServer.php');

// instantiate db class
$db = new $sql_db();
// connect to db
$db->sql_connect($dbhost, $dbuser, $dbpasswd, $dbname, $dbport, false, false);
// we do not need this any longer, unset for safety purpose
unset($dbpasswd);

if ($_SERVER['REQUEST_METHOD'] != 'POST' || !isset($_POST)) {
  exit();
}

$lobbyServer = new LobbyServer($db);
$lobbyServer->serveRequest($_POST);
?>
