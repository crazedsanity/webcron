#!/usr/bin/php
<?php

//TODO: use namespaces and stuff

$E_BADARGS=85;
$E_ERROR=1;
$E_OK=0;

$shortOpts  = "";
$longOpts   = array();


$shortOpts	.= "h";		//specifying "-h" will print out usage info then exit
$longOpts[]	 = "help";	//"--help" is equivalent to "-h"; print usage info then exit.

$options = getopt($shortOpts, $longOpts);

//TODO: get cs-content/__autoload.php work here...
require_once(dirname(__FILE__) .'/../lib/cs-content/cs_version.class.php');
require_once(dirname(__FILE__) .'/../lib/cs-multiproc/cs_SingleProcess.class.php');
require_once(dirname(__FILE__) .'/../lib/cs-multiproc/cs_MultiProcess.class.php');


$p = new cs_SingleProcess();


$basename = basename(__FILE__);
$project = $p->project;
$version = $p->version;
$USAGE = <<<EOT
usage: daemon $basename [options]
options: 
      -h, --help              - Print a help message then exit

This script acts as a daemon (spawned and kept running via the "daemon" package) 
to spawn other scripts.  The output, errors, and exit code are logged via a web-
based API.

For more information, view the library's project page:
	https://github.com/crazedsanity/$project
		
For usage examples, take a look at the WebCron project:
	wiki: https://github.com/crazedsanity/WebCron/wiki
	main: https://github.com/crazedsanity/WebCron

PROJECT NAME: $project
VERSION: $version

EOT;


if($_SERVER['argc'] >= 2) {
	$bits = $_SERVER['argv'];
	array_shift($bits);
	
	$implodeThis = array();
	foreach($bits as $xBit) {
		if(preg_match('/ /', $xBit)) {
			$xBit = '"'. $xBit .'"';
		}
		$implodeThis[] = $xBit;
	}
//	$testScript = implode(' ', $implodeThis);
}
else {
	//TODO: support config path based on argument (e.g. -c /path/to/config.ini)
	#echo "Invalid command: no command specified\n";
	#echo $USAGE;
	fwrite(STDERR, "Invalid command: no command specified\n");
	fwrite(STDERR, $USAGE);
	exit($E_BADARGS);
}

//since the only actual options at this time are to get help, not much to check.
if(count($options)) {
	fwrite(STDOUT, $USAGE);
	exit($E_OK);
}