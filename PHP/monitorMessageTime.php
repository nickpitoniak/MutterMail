<?php
ini_set('max_execution_time', 0);
$database_username = "nick_nick";
$database_password = "Rssl9254!";
$database_host = "localhost";
$database_name = "nick_gone";
$messagesToDelete = array();
$sqlDeleteString = "";
$theEarthSpins = true;
$counter = 0;
$inc = 0;
if(mysql_connect($database_host, $database_username, $database_password)) {
	if(mysql_select_db($database_name)) {
		while($theEarthSpins) {
			/*if($counter % 10 == 0) {
				//echo "<strong>" . $inc . "</strong><br>";
				//$inc = $inc + 1;
			}*/
			if($sql = "SELECT * FROM messages") {
				if($result = mysql_query($sql)) {
					$currentMicrotime = microtime(true);
					while($row = mysql_fetch_assoc($result)) {
						$timeOpened = $row['timeOpened'];
						//echo $timeOpened . "<br>";
						if($timeOpened != 0) {
							if($currentMicrotime - $timeOpened > 30) {
								array_push($messagesToDelete, strval($row['id']));
							}
						}
					}
					$sqlDeleteString = "(";
					foreach($messagesToDelete as $messageId) {
						$sqlDeleteString = $sqlDeleteString . $messageId . ",";
					}
					$sqlDeleteString = $sqlDeleteString . "123456789)";
					$sqlDelete = "DELETE FROM messages WHERE id in " . $sqlDeleteString . "";
					if($deleteResult = mysql_query($sqlDelete)) {
						echo "success!";
					}
				}
			}
			sleep(15);
		}
	} else {
		echo "Error selecting database";
	}
} else {
	echo "Error connecting to database";
}
?>