<?php
/**
* @package dplobbysystem
* @copyright (c) 2010 biegleux <biegleux@gmail.com>
* @license http://opensource.org/licenses/gpl-2.0.php GNU GPLv2
*/ 

class LobbyServer {

  const REQ_REGISTER = 0;
  const REQ_LOGIN = 1;
  const REQ_LOGOUT = 2;
  const REQ_GET_GAMES = 3;
  const REQ_HOST_GAME = 4;
  const REQ_JOIN_GAME = 5;
  const REQ_LEAVE_GAME = 6;
  const REQ_GAME_STATS = 7;
  const REQ_GET_RATINGS = 8;
  const REQ_UNKNOWN = 9;

  const VERSION = 2.01;

  private $_db;
  private $_data;
  private $_responseString;

  public function __construct($db) {

    $this->_db = $db;
    $this->_data = array();
    $this->_responseString = '';
  }

  private function generatePassword() {

    $length = 8;
    $characters = '0123456789abcdefghijklmnopqrstuvwxyz';
    $pwd = '';
    for ($i = 0; $i < $length; $i++) {
      $pwd .= $characters[mt_rand(0, strlen($characters) - 1)];
    }
    return $pwd;
  }

  public function serveRequest($data) {

    $this->_data = $data;
    $this->_responseString = '';
    $request = isset($this->_data['req']) ? $this->_data['req'] : self::REQ_UNKNOWN;
    switch ($request) {
      case self::REQ_LOGIN:
        $ret = $this->loginUser();
        break;
      case self::REQ_REGISTER:
        $ret = $this->registerUser();
        break;
      case self::REQ_LOGOUT:
        $ret = $this->logoutUser();
        break;
      case self::REQ_GET_GAMES:
        $ret = $this->getHostedGames();
        break;
      case self::REQ_HOST_GAME:
        $ret = $this->hostGame();
        break;
      case self::REQ_JOIN_GAME:
        $ret = $this->joinGame();
        break;
      case self::REQ_LEAVE_GAME:
        $ret = $this->leaveGame();
        break;
      case self::REQ_GAME_STATS:
        $ret = $this->processGameStats();
        break;
      case self::REQ_GET_RATINGS:
        $ret = $this->getRatings();
        break;
      case self::REQ_UNKNOWN:
      default:
        return;
        break;
    }
    $this->_responseString = sprintf("%d\n%s", $ret ? 1 : 0, $this->_responseString);
    print($this->_responseString);
    return;
  }

  private function registerUser() {

    if (!isset($this->_data['username']) || !isset($this->_data['email']) || !isset($this->_data['version'])) {
      return false;
    }
    if (defined('HAMACHI')) {
      if (!isset($this->_data['ip'])) {
        return false;
      }
    }
    // send server version
    $this->_responseString = sprintf("%s\n", self::VERSION);
    // check versions
    if (self::VERSION != $this->_data['version']) {
      $this->_responseString .= UPDATE_URL;
      return false;
    }
    $username = $this->_data['username'];
    $email = $this->_data['email'];
    if (!preg_match(USERNAME_PATTERN, $username)) {
      $this->_responseString .= 'Username must contain only alphanumeric characters
        and the characters []_ and cannot begin with a digit.';
      return false;
    }
    if (strlen($username) < MIN_USERNAME_LEN || strlen($username) > MAX_USERNAME_LEN) {
      $this->_responseString .= sprintf('Username must be at least %d characters
        long and %d characters long at most.', MIN_USERNAME_LEN, MAX_USERNAME_LEN);
      return false;
    }
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
      $this->_responseString .= 'Your e-mail is not valid.';
      return false;
    }
    $sql = "SELECT *
            FROM lobbyserver_users
            WHERE username = '" . $this->_db->sql_escape($username) . "'";
    if (!($result = $this->_db->sql_query($sql))) {
      $this->_responseString .= 'Database error.';
      return false;
    }
    if ($this->_db->sql_fetchrow($result)) {
      $this->_responseString .= 'Username has been already taken. Please choose another one.';
      return false;
    }
    $password = $this->generatePassword();
    $message = sprintf(MAIL_MESSAGE, $username, $password);
    if (mail($email, MAIL_SUBJECT, $message, sprintf("From: %s\r\n", MAIL_FROM))) {
      $dt = new DateTime(null, new DateTimeZone('GMT'));
      $sql_ary = array(
        'username'    => $username,
        'password'    => $password,
        'email'       => $email,
        'registered'  => $dt->format('Y-m-d H:i:s')
      );
      if (defined('HAMACHI')) {
        $sql_ary['hamachi_ip'] = $this->_data['ip'];
      }
      $this->_db->sql_transaction('begin');
      $sql = 'INSERT INTO lobbyserver_users ' . $this->_db->sql_build_array('INSERT', $sql_ary);
      if (!$this->_db->sql_query($sql)) {
        $this->_db->sql_transaction('rollback');
        $this->_responseString .= 'Database error.';
        return false;
      }
      if (!($userId = $this->_db->sql_nextid())) {
        $this->_db->sql_transaction('rollback');
        $this->_responseString .= 'Database error.';
        return false;
      }
      $sql_ary = array(
        'uid' => $userId
      );
      $sql = 'INSERT INTO lobbyserver_ratings ' . $this->_db->sql_build_array('INSERT', $sql_ary);
      if (!$this->_db->sql_query($sql)) {
        $this->_db->sql_transaction('rollback');
        $this->_responseString .= 'Database error.';
        return false;
      } 
      $this->_db->sql_transaction('commit');
      $this->_responseString .= 'A password has been sent to your e-mail address.';
      return true;
    } else {
      $this->_responseString .= 'Unable to send e-mail from the server.';
      return false;
    }
  }

  private function loginUser() {

    if (!isset($this->_data['username']) || !isset($this->_data['password']) || !isset($this->_data['version'])) {
      return false;
    }
    // send server version
    $this->_responseString = sprintf("%s\n", self::VERSION);
    // check versions
    if (self::VERSION != $this->_data['version']) {
      $this->_responseString .= UPDATE_URL;
      return false;
    }
    $username = $this->_data['username'];
    $password = $this->_data['password'];
    $sql = "SELECT u.*, r.rating
            FROM lobbyserver_users u
            JOIN lobbyserver_ratings r ON r.uid = u.id
            WHERE username = '" . $this->_db->sql_escape($username) . "'
            AND password = '" . $this->_db->sql_escape($password) . "'";
    if (!($result = $this->_db->sql_query($sql))) {
      $this->_responseString .= 'Database error.';
      return false;
    }
    if (!($row = $this->_db->sql_fetchrow($result))) {
      $this->_responseString .= 'Incorrect username or password.';
      return false;
    }
    $userId = $row['id'];
    $username = $row['username'];
    $token = md5(uniqid(mt_rand(), true));
    $rating = $row['rating'];
    $dt = new DateTime(null, new DateTimeZone('GMT'));
    $sql_ary = array(
      'lastlogin' => $dt->format('Y-m-d H:i:s'),
      'token'     => $token
    );
    $sql = 'UPDATE lobbyserver_users SET ' . $this->_db->sql_build_array('UPDATE', $sql_ary) . ' WHERE id = ' . (int)$userId;
    if ($this->_db->sql_query($sql) && $this->_db->sql_affectedrows() > 0) {
      // here we are sending additional required information from server
      $this->_responseString .= sprintf("%d\n%s\n%s\n%d\n%s\n%d\n%s\n%d\n%s\n%s", $userId, $token,
        $username, $rating, IRC_SERVER, IRC_PORT, IRC_CHANNEL, ONLY_CLIENT_JOINS, WELCOME_MESSAGE, LOBBY_URL);
      return true;
    }
    $this->_responseString .= 'Database error.';
    return false;
  }

  private function logoutUser() {

    if (!isset($this->_data['id']) || !isset($this->_data['token'])) {
      return false;
    }
    $userId = $this->_data['id'];
    $token = $this->_data['token'];
    $sql = 'UPDATE lobbyserver_hostedgames_users SET is_in = 0 WHERE uid = ' . (int)$userId;
    $this->_db->sql_query($sql);
    $sql_ary = array(
      'token' => NULL
    );
    $sql = 'UPDATE lobbyserver_users
            SET ' . $this->_db->sql_build_array('UPDATE', $sql_ary) . ' WHERE id = ' . (int)$userId
        . " AND token = '" . $this->_db->sql_escape($token) . "'";
    return $this->_db->sql_query($sql) && ($this->_db->sql_affectedrows() > 0);
  }

  private function isUserAuthed() {

    if (!isset($this->_data['id']) || !isset($this->_data['token'])) {
      return false;
    }
    $userId = $this->_data['id'];
    $token = $this->_data['token'];
    $sql = "SELECT *
            FROM lobbyserver_users
            WHERE id = " . (int)$userId . " AND token = '" . $this->_db->sql_escape($token) . "'";
    if (!($result = $this->_db->sql_query($sql))) {
      return false;
    }
    if (!($row = $this->_db->sql_fetchrow($result))) {
      return false;
    }
    $this->_data['_username'] = $row['username']; // we can use it later
    if (defined('HAMACHI')) {
      $this->_data['_hamachi_ip'] = $row['hamachi_ip'];
    } 
    return true;
  }

  private function getHostedGames() {

    if (!$this->isUserAuthed()) {
      return false;
    }
    $this->removeGhostGames();
    $sql = 'SELECT DISTINCT hg.*, u.id AS uid, u.username, r.rating, hgu.id AS hguid
            FROM lobbyserver_hostedgames hg
            JOIN lobbyserver_hostedgames_users hgu ON hgu.gid = hg.id
            JOIN lobbyserver_users u ON u.id = hgu.uid
            JOIN lobbyserver_ratings r ON r.uid = u.id
            WHERE hgu.is_in = 1
            ORDER BY hg.id ASC, hguid ASC';
    if (!($result = $this->_db->sql_query($sql))) {
      return false;
    }
    $hostedGames = array();
    $lastId = 0;
    while ($row = $this->_db->sql_fetchrow($result)) {
      $id = (int)$row['id'];
      if ($id != $lastId) {
        $lastId = $id;
        $hostedGame = array();
        $hostedGame['playerlist'] = '';
        $hostedGame['id'] = $id;
        $hostedGame['game'] = $row['game'];
        $hostedGame['guid'] = $row['guid'];
        $hostedGame['sessguid'] = $row['sessguid'];
        $hostedGame['ip'] = $row['ip'];
        $hostedGame['title'] = $row['title'];
        $hostedGame['desc'] = $row['description'];
        $hostedGame['max_players'] = $row['max_players'];
        $hostedGame['datetime'] = $row['datetime'];
        $hostedGame['password'] = $row['password'];
        $hostedGame['status'] = $row['status'];
        $hostedGame['room_id'] = $row['room_id'];
        $hostedGames[] = $hostedGame;
        $idx = count($hostedGames) - 1;
      }
      $hostedGames[$idx]['playerlist'] .= sprintf('%s=%d;', $row['username'], $row['rating']);
    }
    foreach ($hostedGames as $hostedGame) {
      $id = $hostedGame['id'];
      $game = $hostedGame['game'];
      $guid = $hostedGame['guid'];
      $sessguid = $hostedGame['sessguid'];
      $ip = $hostedGame['ip'];
      $title = $hostedGame['title'];
      $desc = $hostedGame['desc'];
      $maxplayers = $hostedGame['max_players'];
      $datetime = $hostedGame['datetime'];
      $password = $hostedGame['password'];
      $status = $hostedGame['status'];
      $roomId = $hostedGame['room_id'];
      $playerlist = rtrim($hostedGame['playerlist'], ';');
      $this->_responseString .= sprintf("%d;%s;%s;%s;%s;%s;%s;%d;%d;%s;%d;%d;%s\n",
        $id, base64_encode($game), $guid, $sessguid, $ip, base64_encode($title),
        base64_encode($desc), $maxplayers, $password, base64_encode($datetime),
        $status, $roomId, base64_encode($playerlist));
    }
    return true;
  }

  private function hostGame() {

    if (!$this->isUserAuthed()) {
      return false;
    }
    $roomId = $this->_data['roomid'];
    // check if we can allocate the room
    $this->_db->sql_transaction('begin');
    $sql = 'SELECT DISTINCT hg.id
            FROM lobbyserver_hostedgames hg
            JOIN lobbyserver_hostedgames_users hgu ON hgu.gid = hg.id
            WHERE hgu.is_in = 1 AND room_id = ' . (int)$roomId;
    if (!($result = $this->_db->sql_query($sql)) || $this->_db->sql_fetchrow($result)) {
      $this->_db->sql_transaction('rollback');
      return false;
    }
    $dt = new DateTime(null, new DateTimeZone('GMT'));
    $sql_ary = array(
      'game'        => base64_decode($this->_data['game']),
      'guid'        => $this->_data['guid'],
      'sessguid'    => $this->_data['sessguid'],
      'ip'          => defined('HAMACHI') ? $this->_data['_hamachi_ip'] : $_SERVER['REMOTE_ADDR'],
      'title'       => base64_decode($this->_data['title']),
      'description' => base64_decode($this->_data['desc']),
      'max_players' => $this->_data['max'],
      'datetime'    => $dt->format('Y-m-d H:i:s'),
      'password'    => $this->_data['pwd'],
      'status'      => 1, // napevno nadratovane
      'room_id'     => $this->_data['roomid']
    );
    $sql = 'INSERT INTO lobbyserver_hostedgames ' . $this->_db->sql_build_array('INSERT', $sql_ary);
    if (!$this->_db->sql_query($sql)) {
      $this->_db->sql_transaction('rollback');
      return false;
    }
    if (!($gameId = $this->_db->sql_nextid())) {
      $this->_db->sql_transaction('rollback');
      return false;
    }
    $userId = $this->_data['id'];
    $sql_ary = array(
      'gid' =>  $gameId,
      'uid' =>  $userId
    );
    $sql = 'INSERT INTO lobbyserver_hostedgames_users ' . $this->_db->sql_build_array('INSERT', $sql_ary);
    if (!$this->_db->sql_query($sql)) {
      $this->_db->sql_transaction('rollback');
      return false;
    }
    $this->_db->sql_transaction('commit');
    $this->_responseString = $gameId;
    return true;
  }

  private function joinGame() {

    if (!$this->isUserAuthed()) {
      return false;
    }
    $gameId = isset($this->_data['gid']) ? (int)$this->_data['gid'] : 0;
    if (!$gameId) {
      return false;
    }
    $userId = $this->_data['id'];
    $sql_ary = array(
      'gid' =>  $gameId,
      'uid' =>  $userId
    );
    $sql = 'INSERT INTO lobbyserver_hostedgames_users ' . $this->_db->sql_build_array('INSERT', $sql_ary);    
    return $this->_db->sql_query($sql);
  }

  private function leaveGame() {

    if (!$this->isUserAuthed()) {
      return false;
    }
    $gameId = isset($this->_data['gid']) ? (int)$this->_data['gid'] : 0;
    $userId = $this->_data['id'];
    if (!$gameId) {
      return false;
    }
    $sql = 'UPDATE lobbyserver_hostedgames_users SET is_in = 0
            WHERE gid = ' . (int)$gameId . ' AND uid = ' . (int)$userId;
    return $this->_db->sql_query($sql) && $this->_db->sql_affectedrows() > 0;
  }

  private function removeGhostGames() {

    $dt = new DateTime(null, new DateTimeZone('GMT'));
    $datetime = $dt->format('Y-m-d H:i:s');
    $sql = "DELETE hg
            FROM lobbyserver_hostedgames hg
            WHERE hg.datetime < DATE_SUB('" . $datetime . "', INTERVAL " . (int)GHOST_HOURS. ' HOUR)';
    return $this->_db->sql_query($sql) && $this->_db->sql_affectedrows() > 0;  
  }

  private function processGameStats() {

    if (!$this->isUserAuthed()) {
      return false;
    }
    $gameId = isset($this->_data['gid']) ? (int)$this->_data['gid'] : 0;
    $sessionGuid = isset($this->_data['sessguid']) ? $this->_data['sessguid'] : '';
    if (!$gameId || $sessionGuid == '') {
      return false;
    }
    if (!isset($this->_data['data'])) {
      return false;
    }
    $lobbyGame = new LobbyGame($this->_db);
    if (!$lobbyGame->parse(base64_decode($this->_data['data']))) {
      return false;
    }
    // Don't accept incompletes or cheats-enabled games.
    if (!$lobbyGame->complete || $lobbyGame->allowCheats) {
      return false;
    }
    // Don't rate games which take less than MIN_RATE_DURATION minutes.
    if ($lobbyGame->duration < MIN_RATE_DURATION * 60) {
      return false;
    }
    // Am I the sender?
    if (strtolower($lobbyGame->getSender()) != strtolower($this->_data['_username'])) {
      return false;
    }
    // Rate only games with exactly two teams.
    if (!$lobbyGame->hasExactlyTwoTeams()) {
      return false;
    }    
    // Don't rate games with a cooping player.
    if ($lobbyGame->hasCoopingPlayer()) {
      return false;
    }
    // Are there any incomplete results?
    // TODO handle disconnections
    // TODO scenario? pick another rating type

    $players = array();
    $this->_db->sql_transaction('begin'); 
    $sql = 'SELECT DISTINCT hg.*, u.id AS uid, u.username, r.rating, r.streak
            FROM lobbyserver_hostedgames hg
            JOIN lobbyserver_hostedgames_users hgu ON hgu.gid = hg.id
            JOIN lobbyserver_users u ON u.id = hgu.uid
            JOIN lobbyserver_ratings r ON r.uid = u.id
            WHERE hg.rated = 0 AND hg.id = ' . (int)$gameId . " AND hg.sessguid = '" . $this->_db->sql_escape($sessionGuid) . "'
            FOR UPDATE";
            // AND r.rating_type = 0
    if (!($result = $this->_db->sql_query($sql))) {
      $this->_db->sql_transaction('rollback');
      return false;
    }
    while ($row = $this->_db->sql_fetchrow($result)) {
      $players[] = array(
        'id' => (int)$row['uid'],
        'username' => $row['username'],  // we will need it later
        'rating' => (int)$row['rating'], // as above
        'streak' => (int)$row['streak']  // for rating updates
      );
    }
    // Is game valid and not already rated?
    if (empty($players)) {
      $this->_db->sql_transaction('rollback');
      return false;
    }
    // Do the players match?
    $allfound = true;
    foreach ($lobbyGame->players as $lobbyPlayer) {
      $found = false;
      foreach ($players as $player) {
        if (strtolower($player['username']) == strtolower($lobbyPlayer->playerName)) {
          $lobbyPlayer->id = $player['id'];
          $lobbyPlayer->rating = $player['rating'];
          $lobbyPlayer->streak = $player['streak'];
          $found = true;
          break;
        }
      }
      $allfound = $allfound && $found;
      if (!$allfound) {
        break;
      } 
    }
    if (!$allfound) {
      // Players mismatch.
      $this->_db->sql_transaction('rollback');
      return false;
    }
    $sql = 'UPDATE lobbyserver_hostedgames SET rated = 1 WHERE id = ' . (int)$gameId;
    $this->_db->sql_query($sql);
    $this->_db->sql_transaction('commit');

    if (!$lobbyGame->insert()) {
      $sql = 'UPDATE lobbyserver_hostedgames SET rated = 0 WHERE id = ' . (int)$gameId;
      $this->_db->sql_query($sql);
      return false;
    }
    return true;
  }

  private function getRatings() {

    if (!$this->isUserAuthed()) {
      return false;
    }
    if (!isset($this->_data['players'])) {
      return false;
    }
    $playerNames = $this->_data['players'];
    $players = explode(';', $playerNames);
    if (!is_array($players) || empty($players)) {
      return false;
    }
    $interval = '';
    foreach ($players as $playerName) {
      $interval .= "'" . $this->_db->sql_escape($playerName) . "',";
    }
    $interval = trim($interval, ',');

    $sql = 'SELECT u.username, r.rating
            FROM lobbyserver_users u
            JOIN lobbyserver_ratings r ON r.uid = u.id AND u.username IN (' . $interval . ')';
    if (!($result = $this->_db->sql_query($sql))) {
      return false;
    }
    while ($row = $this->_db->sql_fetchrow($result)) {
      $this->_responseString .= sprintf("%s;%d\n", $row['username'], (int)$row['rating']);
    }
    return true;
  }

  public function exportGames() {

    $sql = 'SELECT DISTINCT hg.*, u.id AS uid, u.username, r.rating
            FROM lobbyserver_hostedgames hg
            JOIN lobbyserver_hostedgames_users hgu ON hgu.gid = hg.id
            JOIN lobbyserver_users u ON u.id = hgu.uid
            JOIN lobbyserver_ratings r ON r.uid = u.id
            WHERE hgu.is_in = 1
            ORDER BY hg.id ASC';
    if (!($result = $this->_db->sql_query($sql))) {
      return false;
    }
    $hostedGames = array();
    $lastId = 0;
    while ($row = $this->_db->sql_fetchrow($result)) {
      $id = (int)$row['id'];
      if ($id != $lastId) {
        $lastId = $id;
        $hostedGame = array();
        $hostedGame['playerlist'] = array();
        $hostedGame['id'] = $id;
        $hostedGame['game'] = $row['game'];
        $hostedGame['guid'] = $row['guid'];
        $hostedGame['sessguid'] = $row['sessguid'];
        $hostedGame['ip'] = $row['ip'];
        $hostedGame['title'] = $row['title'];
        $hostedGame['desc'] = $row['description'];
        $hostedGame['datetime'] = $row['datetime'];
        $hostedGames[] = $hostedGame;
        $idx = count($hostedGames) - 1;
      }
      $hostedGames[$idx]['playerlist'][] = array(
        'id' => $row['uid'],
        'username' => $row['username'],
        'rating' => $row['rating']
      );
    }
    return $hostedGames;
  } 
}
?>
