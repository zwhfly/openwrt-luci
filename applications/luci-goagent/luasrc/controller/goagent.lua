module("luci.controller.goagent", package.seeall)

require "luci.model.uci"

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

	page = entry({"admin", "services", "goagent", "screen"}, call("get_screen"))
	page.i18n = "goagent"
	page.leaf = true

	page = entry({"admin", "services", "goagent", "enable"}, call("enable_goagent"))
	page.i18n = "goagent"
	page.leaf = true

	page = entry({"admin", "services", "goagent", "disable"}, call("disable_goagent"))
	page.i18n = "goagent"
	page.leaf = true
end

function get_status()
	local c = luci.model.uci.cursor()
	local enabled = (c:get("goagent", "goagent", "enabled") == '1')

	local screen = luci.sys.exec("goagent-get-screen")
	if screen:find("^no running goagent found") ~= nil then
		screen = luci.i18n.translate("no running goagent found")
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json({enabled=enabled, screen=screen})
end

function get_screen()
	get_status()
end

function enable_goagent()
	local c = luci.model.uci.cursor()
	c.set("goagent", "goagent", "enabled", "1")
	c.commit("goagent")
	luci.sys.call("/etc/init.d/goagent start")
	get_status()
end

function disable_goagent()
	local c = luci.model.uci.cursor()
	c.set("goagent", "goagent", "enabled", "0")
	c.commit("goagent")
	luci.sys.call("/etc/init.d/goagent stop")
	get_status()
end

