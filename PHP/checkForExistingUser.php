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
$allUsers = array();
$secretKey = $_REQUEST['secretKey'];
$usernameToCheck = $_REQUEST['username'];
$database_username = "nick_nick";
$database_password = "Rssl9254!";
$database_host = "localhost";
$database_name = "nick_gone";
     if(validateInputString($usernameToCheck) == False) {
         exit("Invalid input");
     }
if($secretKey == "kjdfb4u7bksSDDF44wlksdnw33j4") {
	if(mysql_connect($database_host, $database_username, $database_password)) {
		if(mysql_select_db($database_name)) {
			if($sql = "SELECT * FROM users") {
				if($result = mysql_query($sql) or die(mysql_error())) {
					while($row = mysql_fetch_assoc($result)) {
						if(!(array_push($allUsers, $row['username']))) {
						    exit("error");
						}
					}
				} else {
				    exit("error");
				}
			} else {
			    exit("error");
			}
	    } else {
	    	exit("error");
	    }
	} else {
	    exit("error");
	}
} else {
    exit("error");
}
$doesExitst = false;
foreach($allUsers as $currentUser) {
    if(strval($currentUser) == strval($usernameToCheck)) {
        $doesExist = true;
    }
}
if($doesExist) {
    echo "exists";
} else {
    echo "vacant";
}




?>