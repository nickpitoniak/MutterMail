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
$URLUsername = $_REQUEST['username'];
$secretKey = $_REQUEST['secretKey'];
$database_username = "nick_nick";
$database_password = "Rssl9254!";
$database_host = "localhost";
$database_name = "nick_gone";
//echo "Username: " . $URLUsername . "<br>";
//echo "Password: " . $URLPassword . "<br>";
if(validateInputString($URLUsername) == False) {
exit("Fuck");
         //exit("Username: " . $URLUsername . "<br>Password: " . $URLPassword . "<br>Invalid input");
     }
if($secretKey == "fsjdfb3ilu45rejd394idjnv") {
	if(mysql_connect($database_host, $database_username, $database_password)) {
		if(mysql_select_db($database_name)) {
			$URLUsername = mysql_real_escape_string($URLUsername);
			if($sql = "SELECT * FROM users WHERE `username`='" . $URLUsername . "'") {
				if($result = mysql_query($sql) or die(mysql_error())) {
				    if(mysql_num_rows($result) != 0) {
				        $incr = 0;
					while($row = mysql_fetch_assoc($result)) {
					        if($row['ban'] == "yes") {
					            exit("banned");
					        }
						$incr++;
					}
				        exit("success");
				    } else {
				        exit("error1");
				    }
				} else {
					exit("error2");
				}
			} else {
				exit("error3");
			}
	    } else {
	    	exit("error4");
	    }
	} else {
		exit("error5");
	}
} else {
	exit("error6");
}

?>