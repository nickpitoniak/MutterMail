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
$requestee = $_REQUEST['requestee'];
$secretKey = $_REQUEST['secretKey'];
$actualSecretKey = "kjdfb4u7bksSDDF44wlksdnw33j4";
$theDate = "nooo";
$database_username = "nick_nick";
$database_password = "Rssl9254!";
$database_host = "localhost";
$database_name = "nick_gone";
if(validateInputString($username) == False || validateInputString($requestee) == False) {
         exit("Invalid input");
     }
if($secretKey == $actualSecretKey) {
	if(mysql_connect($database_host, $database_username, $database_password)) {
		if(mysql_select_db($database_name)) {
		    $requestee = mysql_real_escape_string($requestee);
                    $username = mysql_real_escape_string($username);
			if($sql = "INSERT INTO requests (requestor, requestee) VALUES ('$username', '$requestee')") {
				if($result = mysql_query($sql)) {
					echo "success";
				} else {
					echo mysql_error($result);
				}
			} else {
				echo "errorw";
			}
		} else {
			echo "errorwo";
		}
	} else {
		echo "errorwoo";
	}
} else {
	echo "errorwooo";
}
?>