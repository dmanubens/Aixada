<?php
$data = unserialize($_POST['export_data']);

$filename = 'users' . '.csv';
$delimiter = ',';

$f = fopen('php://memory', 'w');

//$headings = array('id', 'name', 'email');

//fputcsv($f, $headings, $delimiter);
fputcsv($f, $delimiter);

foreach($data as $row) {
    fputcsv($f, $row, $delimiter);
}

fseek($f, 0);

header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename="' . $filename . '";');

fpassthru($f);

fclose($f);
exit();
