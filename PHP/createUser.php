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
$passedUsernameRaw = $_REQUEST['username'];
$passedPasswordRaw = $_REQUEST['password'];
$passedUsername = $passedUsernameRaw;
$passedPassword = $passedPasswordRaw;
$database_username = "nick_nick";
$database_password = "Rssl9254!";
$database_host = "localhost";
$database_name = "nick_gone";
$firstQuery = false;
$secondQuery = false;
if($secretKey == "kjdfb4u7bksSDDF44wlksdnw33j4") {
     if(validateInputString($passedPassword) == False || validateInputString($passedUsername) == False) {
         exit("Invalid input");
     }
	if(mysql_connect($database_host, $database_username, $database_password)) {
		if(mysql_select_db($database_name)) {
			$passedUsername = mysql_real_escape_string($passedUsername);
			$passedPassword = mysql_real_escape_string($passedPassword);
			if($sql = "INSERT INTO users (username, password) VALUES ('$passedUsername', '$passedPassword')") {
				if(mysql_query($sql)) {
					echo "success";
				} else {
					exit('error');
				}
			} else {
				exit('error');
			}
	    } else {
	    	exit('error');
	    }
	} else {
		exit('error');
	}
} else {
	exit('error');
}

?>