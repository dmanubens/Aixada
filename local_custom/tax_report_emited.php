<?php 
    require_once '../php/inc/header.inc.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<?=$language;?>" lang="<?=$language;?>">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><?php echo 'Tax';?></title>
	<link rel="stylesheet" type="text/css"               href="css/reports_paper.css"/>
    <link rel="stylesheet" type="text/css"               href="css/reports_layout.css"/>
  	<link rel="stylesheet" type="text/css" media="print" href="css/reports-print.css"/>
</head>
<body>
    <div class="page-p lite">
    <h2 class="start"><?php echo "Llistat factures emeses"; ?></h2>
    <?php
    $db = DBWrap::get_instance();
    $strSQL = 'select * from emeses';
    $rs = $db->Execute($strSQL);
    ?>
	<div class="container">
	 
	 <form method='post' action='download.php'>
	  <input type='submit' value='Export' name='Export'>
	 
	  <table border='1' style='border-collapse:collapse;'>
	    <tr>
	     <th>Num Fra</th>
	     <th>Data</th>
	     <th>Client</th>
	     <th>NIF</th>
	     <th>BASE IMPOSABLE 4%</th>
	     <th>BASE IMPOSABLE 10%</th>
	     <th>BASE IMPOSABLE 21%</th>
	     <th>BASE IMPOSABLE 0%</th>
	     <th>IVA 4%</th>
	     <th>IVA 10%</th>
	     <th>IVA 21%</th>
	     <th>Total factura</th>
	    </tr>
	    <?php
     	    $user_arr = array();
	    $user_arr[0] = array('Num Fra','Data','Client','NIF','BASE IMPOSABLE 4%','BASE IMPOSABLE 10%','BASE IMPOSABLE 21%','BASE IMPOSABLE 0%','IVA 4%','IVA 10%','IVA 21%','Total factura');
            while ($row = $rs->fetch_array()) {
	      	$invoice = $row['cart_id'];
	      	$date = $row['data_c'];
	      	$client = $row['client_n'];
	      	$id = $row['nif'];
	      	$base4 = $row['base_4'];
	      	$base10 = $row['base_10'];
	      	$base21 = $row['base_21'];
	      	$base0 = $row['base_0'];
	      	$vat4 = $row['iva_4'];
	      	$vat10 = $row['iva_10'];
	      	$vat21 = $row['iva_21'];
	      	$total = $row['total_factura'];
	      	array_push($user_arr, array($invoice,$date,$client,$id,$base4,$base10,$base21,$base0,$vat4,$vat10,$vat21,$total));
	    ?>
	      <tr>
	       <td><?php echo $invoice; ?></td>
	       <td><?php echo $date; ?></td>
	       <td><?php echo $client; ?></td>
	       <td><?php echo $id; ?></td>
	       <td><?php echo $base4; ?></td>
	       <td><?php echo $base10; ?></td>
	       <td><?php echo $base21; ?></td>
	       <td><?php echo $base0; ?></td>
	       <td><?php echo $vat4; ?></td>
	       <td><?php echo $vat10; ?></td>
	       <td><?php echo $vat21; ?></td>
	       <td><?php echo $total; ?></td>
	      </tr>
	   <?php
	    }
	   ?>
	   </table>
	   <?php 
	    $serialize_user_arr = serialize($user_arr);
	   ?>
	  <textarea name='export_data' style='display: none;'><?php echo $serialize_user_arr; ?></textarea>
	 </form>
	</div>
    </div>
</body>
</html>
