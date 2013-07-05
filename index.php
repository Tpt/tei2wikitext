<?php
$tei = isset( $_POST['tei'] ) ? $_POST['tei'] : '';
$wikitext = '';

if( $tei ) {
	$doc = new DOMDocument();
	$xsl = new XSLTProcessor();

	$doc->load( 'tei2wikitext.xsl' );
	$xsl->importStyleSheet( $doc );

	if( !$doc->loadXML( $tei ) ) {
		$error = 'Fail to load TEI document';
	} else {
		$result = $xsl->transformToXML($doc);
		if( !$result ) {
			$error = 'The transformation failed';
		} else {
			$wikitext = preg_replace( '/ *xmlns(:[a-z]+)?="[^"]+"/', '', $result );
			$success = 'The transformation succeded';
		}
	}
}

header('Content-type: text/html; charset=UTF-8');
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8" />
	<title>tei2wikitext</title>
	<link href="//tools.wmflabs.org/magnustools/resources/css/bootstrap.min.css" rel="stylesheet">
	<script type="text/javascript" src="//tools.wmflabs.org/magnustools/resources/js/jquery/jquery-1.10.1.min.js"></script>
	<script src="//tools.wmflabs.org/magnustools/resources/js/bootstrap.min.js"></script>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<style type="text/css">
	html, body {
		background-color: #eee;
	}
	.content {
		background-color: #fff;
		padding: 20px;
		margin: 0 -20px; /* negative indent the amount of the padding to maintain the grid system */
		-webkit-border-radius: 0 0 6px 6px;
		-moz-border-radius: 0 0 6px 6px;
		border-radius: 0 0 6px 6
		-webkit-box-shadow: 0 1px 2px rgba(0,0,0,.15);
		-moz-box-shadow: 0 1px 2px rgba(0,0,0,.15);
		box-shadow: 0 1px 2px rgba(0,0,0,.15);
	}
	.page-header {
		background-color: #f5f5f5;
		padding: 20px 20px 10px;
		margin: -20px -20px 20px;
	}
	textarea {
		font-family: monospace;
	}
	</style>
</head>
<body>
	<div class="container">
		<div class="content">
			<div class="page-header">
				<h1>Convert from TEI to WikiText</h1>
			</div>
			<?php if(isset($error)) {
				echo '<div class="alert alert-error">' . $error . '</div>' . "\n";
			} ?>
			<?php if(isset($warning)) {
				echo '<div class="alert alert-warning">' . $warning . '</div>' . "\n";
			} ?>
			<?php if(isset($success)) {
				echo '<div class="alert alert-success">' . $success . '</div>' . "\n";
			} ?>
			<form method="POST">
				<fieldset>
					<div style="clear:both;"></div>
					<div class="control-group" style="float:left; width:49%;">
						<label for="description" class="control-label">TEI file content: </label>
						<div class="controls">
							<textarea name="tei" id="tei" required="required" rows="30" cols="60" class="span6" ><?php echo $tei; ?></textarea>
						</div>
					</div>
					<div class="control-group" style="float:right; width:49%;">
						<label for="description" class="control-label">WikiText: </label>
						<div class="controls">
							<textarea name="wikitext" id="wikitext" readonly="readonly" rows="30" cols="60" class="span6" ><?php echo $wikitext; ?></textarea>
						</div>
					</div>
					<div class="form-actions" style="clear:both;">
						<input class="btn btn-primary" type="submit" value="Convert" />
					</div>
				</fieldset>
			</form>
		</div>
	</div>
</body>
</html>
