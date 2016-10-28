<?php
function validateInputString($inputString) {
    $acceptableCharacters = array (
        "A",
        "B",
        "C",
        "D",
        "E",
        "F",
        "G",
        "H",
        "I",
        "J",
        "K",
        "L",
        "M",
        "N",
        "O",
        "P",
        "Q",
        "R",
        "S",
        "T",
        "U",
        "V",
        "W",
        "X",
        "Y",
        "Z",
        "a",
        "b",
        "c",
        "d",
        "e",
        "f",
        "g",
        "h",
        "i",
        "j",
        "k",
        "l",
        "m",
        "n",
        "o",
        "p",
        "q",
        "r",
        "s",
        "t",
        "u",
        "v",
        "w",
        "x",
        "y",
        "z",
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        " "
    );
    $characterArray = str_split($inputString);
    foreach($characterArray as $character) {
        $match = False;
        foreach($acceptableCharacters as $acceptableChar) {
            if($character == $acceptableChar) {
                $match = True;
                //print("Match for " . $character . "<br>");
            }
        }
        if($match == False) {
            return False;
        }
    }
    return True;
}
$username = $_REQUEST['username'];
$possibleUsername = $_REQUEST['possibleUsername'];
$secretKey = $_REQUEST['secretKey'];
$database_username = "nick_nick";
$database_password = "Rssl9254!";
$database_host = "localhost";
$database_name = "nick_gone";
$matchCount = 0;
$possibleUsernameLength = strlen($possibleUsername);
$matches = array();
$currentFriends = array();
array_push($currentFriends, strval($username));
$masterArray = array();
if(validateInputString($username) == False || validateInputString($possibleUsername) == False) {
         exit("Invalid input");
     }
if($secretKey == "kjdfb4u7bksSDDF44wlksdnw33j4") {
	if(mysql_connect($database_host, $database_username, $database_password)) {
		if(mysql_select_db($database_name)) {
			if($sql = "SELECT * FROM users") {
				if($result = mysql_query($sql)) {
					$requestString = "";
					while($row = mysql_fetch_assoc($result)) {
						if (substr(strtolower($row['username']), 0, strtolower($possibleUsernameLength)) == strtolower($possibleUsername)) {
							array_push($matches, strval($row['username']));
						}
					}
					$username = mysql_real_escape_string($username);
                                        $possibleUsername = mysql_real_escape_string($possibleUsername);
					if($threeSql = "SELECT * FROM requests WHERE requestor='" . $username . "'") {
						if($resultThree = mysql_query($threeSql)) {
							while($row = mysql_fetch_assoc($resultThree)) {								        						
								array_push($currentFriends, strval($row['requestee']));
							}
						} else {
							echo "error";
						}
					} else {
						echo "error";
					}
					if($fourSql = "SELECT * FROM requests WHERE requestee='" . $username . "'") {
						if($resultFour = mysql_query($fourSql)) {
							while($row = mysql_fetch_assoc($resultFour)) {
								array_push($currentFriends, strval($row['requestor']));
							}
						} else {
							echo "error";
						}
					} else {
						echo "error";
					}
					if($nextSql = "SELECT * FROM friends WHERE friend1='" . $username . "' OR friend2='" . $username . "'") {
						if($nextResult = mysql_query($nextSql)) {
							$requestString = "";
							while($row = mysql_fetch_assoc($nextResult)) {
								if($row['friend1'] ==  $username) {
								    array_push($currentFriends, strval($row['friend2']));
								} else {
								    array_push($currentFriends, strval($row['friend1']));
								}
							}
							foreach($matches as $match) {
								$doesExist = False;
								foreach($currentFriends as $friend) {
									if(strval($match) == strval($friend)) {
										$doesExist = True;
										$requestString = $requestString . "friend";
									}
								}
								if($doesExist == False) {
									array_push($masterArray, strval($match));
								}
							}
							foreach($masterArray as $index) {
							        if($matchCount > 20) {
							            continue;
							        }
								$requestString = $requestString . strval($index) . "9254203598";
								$matchCount = $matchCount + 1;
							}
							$requestString = substr($requestString, 0, -10);
							echo "gfg" . $requestString;
						} else {
							echo "error";
						}
					} else {
						echo "error";
					}
				} else {
					echo "error";
				}
			} else {
				echo "error";
			}
		} else {
			echo "error";
		}
	} else {
		echo "error";
	} 
} else {
	echo "error";
}
?>