<?php 
    require_once("../php/inc/header.inc.php");
    require_once("php/inc/turns_report.php");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<?=$language;?>" lang="<?=$language;?>">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><?php 
            $page_title = 'Informes IVA';
      		echo $Text['global_title'] . " - " . $page_title;  ?></title>

 	<link rel="stylesheet" type="text/css"   media="screen" href="../css/aixada_main.css" />
  	<link rel="stylesheet" type="text/css"   media="screen" href="../js/fgmenu/fg.menu.css"   />
    <link rel="stylesheet" type="text/css"   media="screen" href="../css/ui-themes/<?=$default_theme;?>/jqueryui.css"/>
    <link rel="stylesheet" type="text/css"                  href="css/reports_layout.css" />
     
    <script type="text/javascript" src="../js/jquery/jquery.js"></script>
    <script type="text/javascript" src="../js/jqueryui/jqueryui.js"></script>
    <?php echo str_replace('"js/','"../js/', aixada_js_src()); ?>
    <style>
        .aix-style-entry-widget {margin-bottom:0; margin-top: 20px;}
        .uf_turns {
            color:#555;
            font-size:11pt;
        }
        tr.uf_turns td {
            padding-top:0;
        }
    </style>
</head>
<body>
<div id="wrap">
	<div id="headwrap">
		<?php include "../php/inc/menu.inc.php" ?>
	</div>
    <script>
        // rebase menus to up
        $('a').prop('href', 
            function(i, val) {
            console.log(val);
                return val.replace('/local_custom/','/');
            }
        );
    </script>
	<div id="stagewrap">
          <div class="aix-layout-center60 ui-widget">
            <div class="aix-style-entry-widget">
                <h2>Informes IVA</h2>
		<table>
                <tr>
		    <td>
			<form>
			    <label for="sdate">Data inici:</label>
			    <input type="date" id="sdate">
			</form>
		    </td>
		    <td>
			<form>
			    <label for="edate">Data fi:</label>
			    <input type="date" id="edate">
			</form>
		    </td>
                </tr>
                <tr>
                    <td><button class="aix-layout-fixW150"
                            onclick="sdate = document.getElementById('sdate').value; edate = document.getElementById('edate').value; window.open('tax_report_emited.php?start_date='+ sdate +'&end_date='+ edate,'_blank');"
                            >
                        IVA Emeses
                    </button></td>
					<td><p>
                        Llistat factures emeses.
                    </p></td>
		</tr>
                <tr>
                    <td><button class="aix-layout-fixW150"
                            onclick="sdate = document.getElementById('sdate').value; edate = document.getElementById('edate').value; window.open('tax_report_received.php?start_date='+ sdate +'&end_date='+ edate,'_blank');"
                            >
                        IVA Rebudes
                    </button></td>
					<td><p>
                        Llistat factures rebudes.
                    </p></td>
				</tr>

 
                </table>
			</div>
		</div>

	</div>
</div>
</body>
</html>
