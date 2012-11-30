<?php

$no_http_headers = true;

/* display ALL errors */
error_reporting(E_ALL);

if (!isset($called_by_script_server)) {
	include_once(dirname(__FILE__) . "/../include/global.php");

	print call_user_func("ss_poller") . "\n";
	print call_user_func("ss_poller_items") . "\n";
	print call_user_func("ss_recache") . "\n";
	print call_user_func("ss_boost") . "\n";
	print call_user_func("ss_boost_mem") . "\n";
	print call_user_func("ss_export") . "\n";
}

function ss_poller() {
	global $database_username;
	global $database_password;
	global $database_hostname;
	global $database_default;
	global $database_type;
	global $database_port;

/*	db_connect_real($database_hostname, $database_username, $database_password, $database_default, $database_type);*/
	$stats = db_fetch_cell("select value from settings where name='stats_poller'");

	return trim($stats);
}

function ss_poller_items() {
	global $database_username;
	global $database_password;
	global $database_hostname;
	global $database_default;
	global $database_type;
	global $database_port;

#	fetch data from cacti's tables
#	db_connect_real($database_hostname, $database_username, $database_password, $database_default, $database_type);
#	SELECT action, count(*) AS count FROM `poller_item`  Group BY `action`
	$poller_sql = "SELECT action, count(*) AS count FROM `poller_item`  GROUP BY `action`";
	# print "$poller_sql\n";
	$poller_cache = db_fetch_assoc($poller_sql);

#	initialize all data input method types in case one of them is not present
	$entries = array(0, 0, 0);
#	map all existing entries to $entries array
        if (sizeof($poller_cache) > 0) {
		foreach ($poller_cache as $item) {
			# print $item["action"] . ":" . $item["count"] . "\n";
			$entries[$item["action"]] = $item["count"];
		}
	}
#	build output string
	return trim(("snmp:" . $entries[0] . " " . "script:" . $entries[1] . " " . "script_server:" . $entries[2]));
}

function ss_recache() {
	global $database_username;
	global $database_password;
	global $database_hostname;
	global $database_default;
	global $database_type;
	global $database_port;

/*	db_connect_real($database_hostname, $database_username, $database_password, $database_default, $database_type);*/
	$stats = db_fetch_cell("select value from settings where name='stats_recache'");

	return trim($stats);
}

function ss_boost() {
	global $database_username;
	global $database_password;
	global $database_hostname;
	global $database_default;
	global $database_type;
	global $database_port;

/*	db_connect_real($database_hostname, $database_username, $database_password, $database_default, $database_type);*/
	$stats = db_fetch_cell("select value from settings where name='stats_boost'");

	return trim($stats);
}

function ss_boost_mem() {
	global $database_username;
	global $database_password;
	global $database_hostname;
	global $database_default;
	global $database_type;
	global $database_port;

/*	db_connect_real($database_hostname, $database_username, $database_password, $database_default, $database_type);*/
	$stats = db_fetch_cell("select value from settings where name='boost_peak_memory'");

	return trim($stats);
}

function ss_export() {
	global $database_username;
	global $database_password;
	global $database_hostname;
	global $database_default;
	global $database_type;
	global $database_port;

/*	db_connect_real($database_hostname, $database_username, $database_password, $database_default, $database_type);*/
	$_stats = explode(" ", db_fetch_cell("select value from settings where name='stats_export'"));

	/* Cacti does not like a format like ExportDate:2011-01-08_23:15:12
	 * so we have to select only the parts of interest of stats_export */
	$stats = '';
	foreach ($_stats as $_stat) {
		if (preg_match('/^ExportDuration/', $_stat)) $stats .= $_stat . " ";
		if (preg_match('/^TotalGraphsExported/', $_stat)) $stats .= $_stat . " ";
	}

	return trim($stats);
}

?>
