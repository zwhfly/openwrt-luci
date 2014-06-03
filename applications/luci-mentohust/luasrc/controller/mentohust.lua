--[[

LuCI mentohust
Author:tsl0922
Email:tsl0922@sina.com
Author:zwhfly
Email:zwhfly@163.com

]]--

module("luci.controller.mentohust", package.seeall)

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

	page = entry({"admin", "services", "mentohust", "screen"}, call("get_mentohust_screen"))
	page.i18n = "mentohust"
	page.leaf = true

	page = entry({"admin", "services", "mentohust", "enable"}, call("enable_mentohust"))
	page.i18n = "mentohust"
	page.leaf = true

	page = entry({"admin", "services", "mentohust", "disable"}, call("disable_mentohust"))
	page.i18n = "mentohust"
	page.leaf = true
end

function get_mentohust_screen()
	luci.http.prepare_content("application/json")

	local status
	status = luci.sys.exec("mentohust-get-status")
	if status:find("^no running mentohust found") ~= nil then
		luci.http.write_json(luci.i18n.translate("no running mentohust found"))
		return
	end
	luci.http.write_json(status)
end

function enable_mentohust()
	luci.sys.call("/etc/init.d/mentohust enable")
	luci.sys.call("/etc/init.d/mentohust start")
	get_mentohust_screen()
end

function disable_mentohust()
	luci.sys.call("/etc/init.d/mentohust disable")
	luci.sys.call("/etc/init.d/mentohust stop")
	get_mentohust_screen()
end

