<?php
$noHp = isset($_POST["nohp"]) ? $_POST["nohp"] : null;
$message = isset($_POST["message"]) ? $_POST["message"] : null;

if ($noHp == null && $message == null) {
    echo ("Perintah tidak valid");
    return;
}

//TODO: Masukan authkey Onesignal anda disini
$authKey = "AUTH KEY DISINI";
//TODO: Masukan APPID Onesignal anda disini
$appId = "APP ID DISINI";

$dataToSend = [
    "app_id" => $appId,
    "data" => ["nohp" => $noHp, "message" => $message],
    'included_segments' => array('Active Users'),
    "headings" => ["en" => "Sending message to " . substr($noHp, 0, 4) . "***"],
    "contents" => ["en" => "$message"],
];

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "https://onesignal.com/api/v1/notifications");
curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    'Content-Type: application/json; charset=utf-8',
    'Authorization: Basic ' . $authKey
));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
curl_setopt($ch, CURLOPT_HEADER, FALSE);
curl_setopt($ch, CURLOPT_POST, TRUE);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($dataToSend));
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);

$response = curl_exec($ch);
curl_close($ch);

echo json_encode($response);
