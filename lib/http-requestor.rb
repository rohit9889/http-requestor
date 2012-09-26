require "net/http"
require "net/https"
require "uri"

class HttpRequestor

  #============== Instance Methods ===================
  
  def initialize(domain, options={})
    raise InvalidURISchemeException, "Please send a valid URI scheme." if domain.match(/(http|https):\/\//).nil?

    @defaults = {:domain => domain}
    uri = URI.parse(@defaults[:domain])
    if uri.scheme == "http"
      @http = Net::HTTP.new(uri.host, uri.port)
    else
      @http = Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def get(path,data={},headers=nil)
    data = data_to_query(data)
    if headers == nil
      response = @http.send_request('GET',path,data)
    else
      response = @http.send_request('GET',path,data,headers)
    end
    response
  end

  def post(path,data={},headers=nil)
    data = data_to_query(data)
    if headers == nil
      response = @http.send_request('POST',path,data)
    else
      response = @http.send_request('POST',path,data,headers)
    end
    response
  end

  def put(path,data={},headers=nil)
    data = data_to_query(data)
    if headers == nil
      response = @http.send_request('PUT',path,data)
    else
      response = @http.send_request('PUT',path,data,headers)
    end
    response
  end
  
  def delete(path,data={},headers=nil)
    data = data_to_query(data)
    if headers == nil
      response = @http.send_request('DELETE',path,data)
    else
      response = @http.send_request('DELETE',path,data,headers)
    end
    response
  end
  
  def data_to_query(data)
    return (data.nil? || data.empty?) ? "" : data.to_query
  end

  #============== Class Methods ===================
  def self.request(domain, request_type, request_path, data={}, headers={})
    request_type.upcase!
    raise InvalidRequestTypeException, "Please pass a valid request type." unless valid_request_types.include?(request_type)
    req = HttpRequestor.new(domain)
    if request_type == "GET"
      return req.get(request_path, data, headers)
    elsif request_type == "POST"
      return req.post(request_path, data, headers)
    elsif request_type == "PUT"
      return req.put(request_path, data, headers)
    elsif request_type == "DELETE"
      return req.delete(request_path, data, headers)
    end
  end
  
  def self.request_with_url(url, request_type, data={}, headers={})
    uri = URI.parse(url)
    return self.request("#{uri.scheme}://#{uri.host}:#{uri.port}", request_type, uri.request_uri, data, headers)
  end
  
  def self.send_basic_auth_request(url, username, password)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(username, password)
    http.request(request)
  end

  def self.valid_request_types
    ["GET", "POST", "UPDATE", "DELETE"]
  end
end

#================ ActiveSupport Like object#to_query methods =========================
class Hash
  def to_query(namespace = nil)
    collect do |key, value|
      value.to_query(namespace ? "#{namespace}[#{key}]" : key)
    end.sort * '&'
  end
end

class Array
  def to_query(key)
    prefix = "#{key}[]"
    collect { |value| value.to_query(prefix) }.join '&'
  end
end

class String
  def to_query(key)
    require 'cgi' unless defined?(CGI) && defined?(CGI::escape)
    "#{CGI.escape(key.to_param)}=#{CGI.escape(to_param.to_s)}"
  end
  
  def to_param
    to_s
  end
end

#================= Exceptions ======================
class InvalidRequestTypeException < Exception
end

class InvalidURISchemeException < Exception
end