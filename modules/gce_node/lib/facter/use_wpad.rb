require "puppet"
require "facter"
require "net/http"
require "uri"

def url_exist(url_string)
  begin
    url = URI.parse(url_string)
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)
    case response
    when Net::HTTPSuccess
      return true
    else
      return false
    end
  rescue
    return false
  end
end

Facter.add("use_wpad") do
  # Check if wpad exists
  has_wpad = url_exist("http://wpad/wpad.dat")

  # return boolean result
  if has_wpad
    setcode { true }
  else
    setcode { false }
  end
end
