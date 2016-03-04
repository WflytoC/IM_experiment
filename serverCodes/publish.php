<?php
	header ( "Content-Type: textml; charset=UTF-8" );
	require_once 'connect.php';
	$success = array("code"=>"ok");
	$failure1 = array("code"=>"connect error");
	$failure2 = array("code"=>"insert error");
	if(isset($_GET['user_email']) && isset($_GET['publish_location'])&& isset($_GET['publish_locationA'])&& isset($_GET['publish_info'])&& isset($_GET['publish_private'])&& isset($_GET['publish_type'])&& isset($_GET['publish_distance'])&& isset($_GET['publish_longitude'])&& isset($_GET['publish_latitude'])){

		$email = $_GET['user_email'];
		$location = $_GET['publish_location'];
		$locationA = $_GET['publish_locationA'];
		$info = $_GET['publish_info'];
		$private = $_GET['publish_private'];
		$type = $_GET['publish_type'];
		$distance = $_GET['publish_distance'];
		$longitude = $_GET['publish_longitude'];
		$latitude = $_GET['publish_latitude'];

		$connect = new connectDatabase();
		$link = $connect ->connectTo();
		if($link == "no") {
			echo json_encode($failure1,JSON_UNESCAPED_UNICODE);
			exit();
		}

		$sql = "INSERT INTO table_publish (user_email,publish_location,publish_locationA,publish_info,publish_private,publish_type,publish_distance,publish_longitude,publish_latitude) VALUES ('$email','$location','$locationA','$info','$private','$type','$distance','$longitude','$latitude')";
		if (!mysql_query($sql,$link)) {
			echo json_encode($failure2,JSON_UNESCAPED_UNICODE);
			exit();
		}

		echo json_encode($success,JSON_UNESCAPED_UNICODE);

	}



?>