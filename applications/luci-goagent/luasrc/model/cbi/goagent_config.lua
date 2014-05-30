require("luci.sys")

local fs = require "nixio.fs"

local f = SimpleForm("goagent", translate("config"), '<p>' .. translate("Edit <em>proxy.ini</em> of goagent here.") .. '</p>' .. '<p>' .. translate("Generally ip=0.0.0.0 and appid=<em>your gae appid</em>.") .. '</p>' .. '<p>' .. translate("<a href='https://code.google.com/p/goagent/'>Go to goagent homepage</a> for further information.") .. '</p>')

local o = f:field(TextValue, "config_file")
o.rows = 21

function o.cfgvalue(self, section)
	return fs.readfile("/usr/lib/goagent/local/proxy.ini")
end

function o.write(self, section, value)
	fs.writefile("/usr/lib/goagent/local/proxy.ini", value)
end

return f
