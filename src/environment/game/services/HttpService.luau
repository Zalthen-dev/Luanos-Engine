local Instance = require("@Instance")
local signal = require("@signal")

local net = zune.net

local HttpService = Instance.new("HttpService")

local JSON = zune.serde.json

local function request(method, url, body, headers, opts)
	opts = opts or {}
	headers = headers or {}

	HttpService.RequestStarted:Fire({ Method = method, URL = url })

	local success, response = pcall(function()
		return net.request(url, {
			Method = method,
			Headers = headers,
			Body = body,
			Timeout = opts.Timeout,
			AllowRedirects = opts.AllowRedirects,
		})
	end)

	if not success then
		HttpService.RequestFailed:Fire({ Method = method, URL = url, Error = response })
		error("HttpService Request Error: " .. tostring(response))
	end

	local res = {
		Body = response.body,
		StatusCode = response.status_code,
		StatusReason = response.status_reason,
		Headers = response.headers,
		Ok = response.ok,
	}

	HttpService.RequestFinished:Fire(res)
	return res
end

function HttpService:GetAsync(url, headers, opts)
	local res = request("GET", url, nil, headers, opts)
	return res.Body, res
end

function HttpService:PostAsync(url, body, headers, opts)
	local res = request("POST", url, body, headers, opts)
	return res.Body, res
end

function HttpService:JSONEncode(tbl)
	return JSON.encode(tbl)
end

function HttpService:JSONDecode(str)
	return JSON.decode(str)
end

local urlEncoding = {
    ["!"] = "%21",
    ["#"] = "%23",
    ["$"] = "%24",
    ["&"] = "%26",
    ["'"] = "%27",
    ["("] = "%28",
    [")"] = "%29",
    ["*"] = "%2A",
    [","] = "%2C",
    ["/"] = "%2F",
    [":"] = "%3A",
    [";"] = "%3B",
}

function HttpService:UrlEncode(input: string): string
    for decoded, encoded in pairs(urlEncoding) do
        input = input:gsub(decoded, encoded)
    end

    return input
end

function HttpService:UrlDecode(input: string): string
    for decoded, encoded in pairs(urlEncoding) do
        input = input:gsub(encoded, decoded)
    end

    return input
end

return HttpService