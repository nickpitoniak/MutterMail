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
$secretKey = $_REQUEST['secretKey'];
$database_username = "nick_nick";
$database_password = "Rssl9254!";
$database_host = "localhost";
$database_name = "nick_gone";
if(validateInputString($username) == False) {
         exit("Invalid input");
     }
if($secretKey == "kjdfb4u7bksSDDF44wlksdnw33j4") {
	if(mysql_connect($database_host, $database_username, $database_password)) {
		if(mysql_select_db($database_name)) {
			if($sql = "SELECT * FROM requests WHERE requestee='" . mysql_real_escape_string($username) . "'") {
				if($result = mysql_query($sql)) {
					$requestString = "";
					while($row = mysql_fetch_assoc($result)) {
						$requestString = $requestString . strval($row['requestor']) . "9254203598";
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
?>