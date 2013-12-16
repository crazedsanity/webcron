<?php

//load script that has the magic "__autoload()" function, to automatically load libraries if not included/required.
require_once(dirname(__FILE__) .'/../lib/cs-content/__autoload.php');

$siteConfig = new cs_siteConfig(dirname(__FILE__) .'/../rw/siteConfig.xml', 'website');

require_once(dirname(__FILE__) .'/../lib/cs-content/contentSystem.class.php');
#require_once(dirname(__FILE__) .'/../lib/website.class.php');

$contentObj = new contentSystem();
#$contentObj->inject_var('websiteObj', new website());
$contentObj->finish();

?>
