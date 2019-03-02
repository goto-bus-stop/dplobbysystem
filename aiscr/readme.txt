Archive contains sample application and its source code.
See DPlay.pas file and "TAgePresetData" structure for description of data structure
AOC is requesting while starting DirectPlay session.

Use IDirectPlayLobby3::ReceiveLobbyMessage() method to receive messages sent between a lobby client application and DirectPlay aplication (AOC).
AOC sends system message of type DPLSYS_GETPROPERTY requesting a property from the lobby.
Guid identifying the property that is being requested (guidPropertyTag) is {B3F2E132-FE6A-11D2-8DEE-00A0C90832B4} ("AGE_PresetGuid" constant in source code).

Lobby will response with DPLMSG_GETPROPERTYRESPONSE message setting its dwPropertyData
to buffer containing TAgePresetData structure. Response will be sent back to AOC with IDirectPlayLobby3A::SendLobbyMessage() method.

AgePresetData structure notes:
- if you lock available civs and allow random civ, than if player picks random civ, game can assign any civ, also locked one, same for maps locking
- to lock available maps you need to lock game type as well
- valid values for locking victory by time limit are 300, 500, 700, 900, 1100, 1300, 1500
- valid values for locking victory by score are from 4000 to 14000, by 1000
- locking team bonuses is not tested so far
- to lock custom map type, lock map type, set available map to 33 and set filename pointing to desired custom map from "Random" directory (filename has to be set without path and extension)
- to lock scenario, lock game type, set game type to 3 and set filename pointing to desired scenario file from "Scenario" directory (filename has to be set without path and extension)
- to host restored game, find latest created file in "Multi" directory (msx files), fill filename data with this file (without the path, extension remains), set game type to 8 or 9 and set dwUser1 flag to 1 in DPSESSIONDESC2 structure, see IDirectPlayLobby3::RunApplication() method and DirectPlay documetation for more details.
- to join such game... ? (not covered yet)

Civ ids used for locking available civs (bCivAvail data):
0 = ? (not used)
1 = Britons
2 = Franks
3 = Goths
4 = Teutons
5 = Japanese
6 = Chinese
7 = Byzantines
8 = Persians
9 = Saracens
10 = Turks
11 = Vikings
12 = Mongols
13 = Celts
14 = Spanish
15 = Aztecs
16 = Mayans
17 = Huns
18 = Koreans
19 = Random

Map ids used for locking available maps (bLockMapTypeAvail data):
0 = Arabia
1 = Archipelago
2 = Baltic
3 = Black Forest
4 = Coastal
5 = Continental
6 = Crater Lake
7 = Fortress
8 = Gold Rush
9 = Highland
10 = Islands
11 = Mediterranean
12 = Migration
13 = Rivers
14 = Team Islands
15 = Scandinavia
16 = Mongolia
17 = Yucatan
18 = Salt Marsh
19 = Arena
20 = Oasis
21 = Ghost Lake
22 = Nomad
23 = Iberia
24 = Britain
25 = Mideast
26 = Texas
27 = Italy
28 = Central America
29 = France
30 = Norse Lands
31 = Sea of Japan
32 = Byzantinum
33 = Custom
34 = Random Land Map
35 = Full Random
36 = Map Style:Custom, Full Random or Real World, Full Random
37 = Blind Random
38 = ?
