module("luci.controller.goagent", package.seeall)

function index()
	local page 

	page = entry({"admin", "services", "goagent"}, template("goagent"), _("GoAgent Proxy"))
	page.i18n = "goagent"
	page.dependent = true

	page = entry({"admin", "services", "goagent", "status"}, template("goagent"), _("Running Status"), 2)
	page.i18n = "goagent"
	page.dependent = true

	page = entry({"admin", "services", "goagent", "config"}, cbi("goagent_config"), _("Config"), 1)
	page.i18n = "goagent"
	page.dependent = true

	page = entry({"admin", "services", "goagent", "screen"}, call("get_goagent_screen"))
	page.i18n = "goagent"
	page.leaf = true

	page = entry({"admin", "services", "goagent", "enable"}, call("enable_goagent"))
	page.i18n = "goagent"
	page.leaf = true

	page = entry({"admin", "services", "goagent", "disable"}, call("disable_goagent"))
	page.i18n = "goagent"
	page.leaf = true
end

function get_goagent_screen()
	luci.http.prepare_content("application/json")

	local status
	status = luci.sys.exec("goagent-get-status")
	if status:find("^no running goagent found") ~= nil then
		luci.http.write_json(luci.i18n.translate("no running goagent found"))
		return
	end
	luci.http.write_json(status)
end

function enable_goagent()
	luci.sys.call("/etc/init.d/goagent enable")
	luci.sys.call("/etc/init.d/goagent start")
	get_goagent_screen()
end

function disable_goagent()
	luci.sys.call("/etc/init.d/goagent disable")
	luci.sys.call("/etc/init.d/goagent stop")
	get_goagent_screen()
end

