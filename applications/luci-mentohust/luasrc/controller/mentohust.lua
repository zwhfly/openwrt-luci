--[[

LuCI mentohust
Author:tsl0922
Email:tsl0922@sina.com
Author:zwhfly
Email:zwhfly@163.com

]]--

module("luci.controller.mentohust", package.seeall)

require "luci.model.uci"

function index()
	local page 

	page = entry({"admin", "services", "mentohust"}, template("mentohust"), _("Ruijie/Saier Authentication"))
	page.i18n = "mentohust"
	page.dependent = true

	page = entry({"admin", "services", "mentohust", "status"}, template("mentohust"), _("Running Status"), 2)
	page.i18n = "mentohust"
	page.dependent = true

	page = entry({"admin", "services", "mentohust", "config"}, cbi("mentohust_config"), _("Config"), 1)
	page.i18n = "mentohust"
	page.dependent = true

	page = entry({"admin", "services", "mentohust", "screen"}, call("get_screen"))
	page.i18n = "mentohust"
	page.leaf = true

	page = entry({"admin", "services", "mentohust", "enable"}, call("enable_mentohust"))
	page.i18n = "mentohust"
	page.leaf = true

	page = entry({"admin", "services", "mentohust", "disable"}, call("disable_mentohust"))
	page.i18n = "mentohust"
	page.leaf = true
end

function get_status()
	local c = luci.model.uci.cursor()
	local enabled = (c:get("mentohust", "mentohust", "enabled") == '1')

	local screen = luci.sys.exec("mentohust-get-screen")
	if screen:find("^no running mentohust found") ~= nil then
		screen = luci.i18n.translate("no running mentohust found")
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json({enabled=enabled, screen=screen})
end

function get_screen()
	get_status()
end

function enable_mentohust()
	local c = luci.model.uci.cursor()
	c.set("mentohust", "mentohust", "enabled", "1")
	c.commit("mentohust")
	luci.sys.call("/etc/init.d/mentohust start")
	get_status()
end

function disable_mentohust()
	local c = luci.model.uci.cursor()
	c.set("mentohust", "mentohust", "enabled", "0")
	c.commit("mentohust")
	luci.sys.call("/etc/init.d/mentohust stop")
	get_status()
end

