howto:

1) import cacti_host_template_apc_smart_ups.xml
2) apply "APC Smart UPS" template to desired host


source:

http://docs.cacti.net/usertemplate:host:ups:apc


misc:

If you receive "ERROR: the RRD does not contain an RRA matching the chosen CF" in your temperature graph debug mode...
	1) edit graph template
	2) change item #1 CF Type from Last to Average
