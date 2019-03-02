<?php
/**
* @package dplobbysystem
* @copyright (c) 2010 biegleux <biegleux@gmail.com>
* @license http://opensource.org/licenses/gpl-2.0.php GNU GPLv2
*/ 

/* Database settings. */
$dbhost    = '';  // database host
$dbuser    = '';  // database user
$dbpasswd  = '';  // database password
$dbname    = '';  // database name
$dbport    = '';  // database port if required 

/* Your IRC settings. */
define('IRC_SERVER', 'irc.foonetic.net');
define('IRC_PORT', 6667);
define('IRC_CHANNEL', '#lobbyserver');

/* Minimum length allowed for an username. If your IRC server limits you to use
 at least 4 characters long usernames, than this value can't be lower than 4. */ 
define('MIN_USERNAME_LEN', 4);

/* Maximum length allowed for an username. Consider 4 chars as reserved for the
 client. If your IRC server limits you to use at most 18 characters long
 usernames, than this value can't exceed the value 14. */
define('MAX_USERNAME_LEN', 14);

/* Regular expression for valid usernames. Set it according to your IRC server.
 Default pattern limits usernames in containing only alphanumeric characters and
 the characters []_. And the username cannot begin with a digit. If you modify
 the pattern, consider changing also the string about at line 88 in file
 LobbyServer.php informing users about valid characters they can use. */
define('USERNAME_PATTERN', '/^[a-z_\[\]][a-z0-9_\[\]]*$/i');

/* From this email passwords will be sent to newly registered users. */ 
define('MAIL_FROM', 'lobbyserver@yourdomain.com');

/* Mail subject. */
define('MAIL_SUBJECT', 'Account Information');

/* Mail body. Make sure you preserve both format specifiers ("%s"). First one
 for the username, the second for the password. */
define('MAIL_MESSAGE', "Username: %s\nPassword: %s");

/* Remove ghost games after specified (real-time) hours. */
define('GHOST_HOURS', 3);

/* Defines if the players can join hosted games directly by entering the IP
 address of the host. Set to 0 if you allow IP joins. Set to 1, if you require
 the users to join hosted games only through the client. */
define('ONLY_CLIENT_JOINS', 1);

/* Defines the minimal time the game should take so it may be rated. */
define('MIN_RATE_DURATION', 5);

/* Welcome message displaying when user enters the lobby */
define('WELCOME_MESSAGE', 'Welcome here. To deploy your own matchmaking lobby'
 . ' follow the instructions at http://dplobbysystem.googlecode.com/.');

/* Uncomment if you want to set the lobby for hamachi users */
//define('HAMACHI', true);

/* Update URL where the users can find the latest client. May point to a web
 page with the client file or directly to the client file on a remote server. */
define('UPDATE_URL', 'http://www.yourdomain.com/lobbyserver/update/lobby.7z');

/* URL where the client's built-in browser navigates to by default. May point
 to a web page with users games, ratings,... etc. */
define('LOBBY_URL', 'http://www.yourdomain.com/lobbyserver/view/games.php');
?>
