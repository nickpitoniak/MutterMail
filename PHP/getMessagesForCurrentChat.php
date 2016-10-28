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
$username = strval($_REQUEST['username']);
$chatPartner = strval($_REQUEST['chatPartner']);
$database_username = "nick_nick";
$database_password = "Rssl9254!";
$database_host = "localhost";
$database_name = "nick_gone";
$returnArray = array();
$returnString = "";
if(validateInputString($chatPartner) == False || validateInputString($username) == False) {
         exit("Invalid input");
     }
if(mysql_connect($database_host, $database_username, $database_password)) {
	if(mysql_select_db($database_name)) {
		if($sql = "SELECT * FROM messages WHERE (sender='" . $username . "' OR sender='". $chatPartner ."') AND (receiver='" . $chatPartner . "' OR receiver='" . $username ."') ORDER BY id") {
			if($result = mysql_query($sql)) {
				while($row = mysql_fetch_assoc($result)) {
					array_push($returnArray, array(strval($row['message']), strval($row['id']), strval($row['timeOpened']), strval($row['sender']), strval($row['hasBeenDecrypted']), strval($row['encryption'])));
				}
				foreach($returnArray as $raIndex) {
					foreach($raIndex as $index) {
						$returnString = $returnString . $index . "9254203598";
					}
					$returnString = substr($returnString, 0, -10);
					$returnString = $returnString . "3292985383";
				}
				$returnString = substr($returnString, 0, -10);
				echo "gfggfgfgf" . $returnString;
			} else {
				echo mysql_error($result);
				exit("exit");
			}
		} else {
			exit("exit");
		}
	} else {
		exit("exit");
	}
} else {
	exit("exit");
}
?>