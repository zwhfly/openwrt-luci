--[[

LuCI mentohust
Author:tsl0922
Email:tsl0922@sina.com
Author:zwhfly
Email:zwhfly@163.com

]]--

require("luci.tools.webadmin")

m = Map("mentohust", translate("Mentohust Config"), translate("A Ruijie and Cernet supplicant on Linux and MacOS from HustMoon Studio."))
function m.on_after_commit(self)
	luci.sys.call("mentohust-reconfig > /dev/null 2>&1")
end

s = m:section(TypedSection, "mentohust", translate("The options below are all of mentohust's arguments."))
s.anonymous = true

s:option(Value, "Username", translate("Username"))

pw=s:option(Value, "Password", translate("Password"))
pw.password = true
pw.rmempty = false

nic=s:option(ListValue, "Nic", translate("net card name"))
nic.anonymous = true
for k, v in pairs(luci.sys.net.devices()) do
	nic:value(v)
end


s:option(Value, "IP", translate("IP")).placeholder=translate("use localhost's IP by default")

s:option(Value, "Mask", translate("netmask")).placeholder=translate("left blank to use default")

s:option(Value, "Gateway", translate("gateway")).placeholder=translate("left blank to use default")

s:option(Value, "DNS", translate("DNS")).placeholder=translate("left blank to use default")

s:option(Value, "PingHost", translate("Ping host"), translate("Connection checking")).placeholder=translate("disabled by default")

s:option(Value, "Timeout", translate("authenticate timeout(s)")).placeholder=translate("8s by default")

s:option(Value, "EchoInterval", translate("heartbeat timeout(s)")).placeholder=translate("30s by default")

s:option(Value, "RestartWait", translate("wait on failure timeout(s)")).placeholder=translate("15s by default")

s:option(Value, "MaxFail", translate("max failure times")).placeholder=translate("unlimited by default")

t=s:option(ListValue, "StartMode", translate("mulcast address"))
t:value("0", translate("0(standard)"))
t:value("1", translate("1(ruijjie)"))
t:value("2", translate("2(saier)"))

t=s:option(ListValue, "DhcpMode", translate("DHCP type"))
t:value("0", translate("0(not in used)"))
t:value("1", translate("1(secondary authenticate)"))
t:value("2", translate("2(post authenticate)"))
t:value("3", translate("3(pre authenticate)"))

s:option(Value, "ShowNotify", translate("display notification"), translate("0(no),1-20(yes)")).placeholder=translate("5 by default")

s:option(Value, "Version", translate("client version")).placeholder=translate("left blank to use default")

s:option(Value, "DataFile", translate("customized data file")).placeholder=translate("not in use by default")

t=s:option(Value, "dhcpscript", translate("DHCP script"), translate("this value will be followed by the net card name to form the actual script"))
t.placeholder=translate("'udhcpc -i' by default")
t.default="udhcpc -i"


return m

