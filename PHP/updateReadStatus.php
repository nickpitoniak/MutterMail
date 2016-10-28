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
$theID = $_REQUEST['id'];
$secretKey = $_REQUEST['secretKey'];
$database_username = "nick_nick";
$database_password = "Rssl9254!";
$database_host = "localhost";
$database_name = "nick_gone";
$currentMicrotime = round(microtime('get_as_float'));
/*if(validateInputString(strval($theId)) == False) {
         echo "THE id: %" . $theID . "%<br>";
         exit("Invalid input");
     }
     */
if($secretKey == "kjdfb4u7bksSDDF44wlksdnw33j4") {
	if(mysql_connect($database_host, $database_username, $database_password)) {
		if(mysql_select_db($database_name)) {
		$theID = mysql_real_escape_string($theID);
			if($sql = "UPDATE messages SET didRead='yes', timeOpened='" . strval($currentMicrotime) . "' WHERE id='" . $theID . "'") {
				if($result = mysql_query($sql)) {
					echo "success";
				} else {
					echo mysql_error($result);
					echo "failure0";
				}
			} else {
				echo "failure1";
			}
		} else {
			echo "failure2";
		}
	} else {
		echo "failure3";
	}
} else {
	echo "failure4";
}
?>