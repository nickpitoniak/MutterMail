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
$secretKey = $_REQUEST['secretKey'];
$username = strval($_REQUEST['username']);
$encryption = $_REQUEST['encryption'];
$chatPartner = $_REQUEST['chatPartner'];
$database_username = "nick_nick";
$database_password = "Rssl9254!";
$database_host = "localhost";
$database_name = "nick_gone";
if(validateInputString($chatPartner) == False || validateInputString($username) == False) {
         exit("Invalid input");
     }
if($secretKey == "fsjdfb3ilu45rejd394idjnv") {
	if(mysql_connect($database_host, $database_username, $database_password)) {
		if(mysql_select_db($database_name)) {
		    $username = mysql_real_escape_string($username);
                    $chatPartner = mysql_real_escape_string($chatPartner);
                    $message = mysql_real_escape_string($message);
			if($sql = "SELECT * FROM block WHERE (blocker='" . $username . "' AND blockee='" . $chatPartner . "') OR (blocker='" . $chatPartner . "' AND blockee='" . $username . "')") {
				if($result = mysql_query($sql)) {
				    if(mysql_num_rows($result) > 0) {
				        echo "yes";
				    } else {
				        echo "no";
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