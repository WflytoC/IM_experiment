<?php
//publish_longitude
//publish_latitude
//filter_distance
//choice_type 0表示需求 1表示服务 2表示全部
//publish_keyword

header ( "Content-Type: textml; charset=UTF-8" );

//定义函数：计算给定经纬度的两个位置之间的距离
function getdistance($lng1,$lat1,$lng2,$lat2){
	//将角度转为狐度
	$radLat1=deg2rad($lat1);//deg2rad()函数将角度转换为弧度
	$radLat2=deg2rad($lat2);
	$radLng1=deg2rad($lng1);
	$radLng2=deg2rad($lng2);
	$a=$radLat1-$radLat2;
	$b=$radLng1-$radLng2;
	$s=2*asin(sqrt(pow(sin($a/2),2)+cos($radLat1)*cos($radLat2)*pow(sin($b/2),2)))*6378.137*1000;
	return $s;
}

require_once 'connect.php';
$success = array("code"=>"ok");
$failure = array("code"=>"error");
if(isset($_GET['publish_longitude']) && isset($_GET['publish_latitude']) && isset($_GET['filter_distance']) && isset($_GET['choice_type']) && isset($_GET['publish_keyword'])){

	$longitude = $_GET['publish_longitude'];
	$latitude = $_GET['publish_latitude'];
	$distance = $_GET['filter_distance'];
	$type = $_GET['choice_type'];
	$keyword = $_GET['publish_keyword'];

	$sql = "";

	if ($keyword == "all") {

	$sql = ($type > 1) ? "SELECT * FROM table_publish " : "SELECT * FROM table_publish where publish_type = '$type' ";
	
	} else {

	$sql = ($type > 1) ? "SELECT * FROM table_publish where publish_info like '%$keyword%' " : "SELECT * FROM table_publish where publish_type = '$type' AND publish_info like '%$keyword%' ";

	}

	//连接数据库
	$connect = new connectDatabase();
		$link = $connect ->connectTo();
		if($link == "no") {
			echo json_encode($failure,JSON_UNESCAPED_UNICODE);
			exit();
		}

	//$sql = （$type == 2 ） ? "SELECT * FROM table_publish" : "SELECT * FROM table_publish where publish_type = ('$type') ";

	$result = mysql_query($sql,$link);
	$details = array();
	while($row=mysql_fetch_array($result)){
		$type = $row["publish_type"];
		$info = $row["publish_info"];
		$location = $row["publish_location"];
		$locationA = $row["publish_locationA"];
		$longit = $row["publish_longitude"];
		$lat = $row["publish_latitude"];
		$dist = $row["publish_distance"];
		$email = $row["user_email"];
		$totalDistance = getdistance($longit,$lat,$longitude,$latitude);
		if (($totalDistance < $distance) && ($totalDistance < $dist)) {
			$newEle = array("detail_email" => $email,"detail_location" => $location,"detail_locationA" => $locationA,"detail_distance" => $totalDistance,"detail_type" => $type,"detail_info" => $info);
			array_push($details, $newEle);
		}
    //注意，$row是一个索引数组，但是该数组的索引不仅有文字字符串，还有数字字符串：$row["0"]=>"ricky",$row["name"]=>"ricky",$row["1"]=21,$row["age"]=>21，即`mysql_fetch_array($result)`函数返回的数组元素是每一行记录个数的两倍。
	}

	echo json_encode($details,JSON_UNESCAPED_UNICODE);

	}


?>