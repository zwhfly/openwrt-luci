--[[
Copyright 2014 zwhfly <zwhfly@163.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--

module("luci.controller.wwwroot", package.seeall)

function index()
	local page = entry({"admin", "wwwroot"}, template("wwwroot"))
	page.i18n = "wwwroot"
	page.dependent = true
end
