require "net/http"

class HttpRequestor
  def initialize(domain)
    @defaults = {:domain => domain}
  end

  def get(path,data,headers=nil)
    uri = URI.parse(@defaults[:domain])
    http = Net::HTTP.new(uri.host, uri.port)
    if headers == nil
      response = http.send_request('GET',path,data)
    else
      response = http.send_request('GET',path,data,headers)
    end
    response
  end

  def post(path,data,headers=nil)
    uri = URI.parse(@defaults[:domain])
    http = Net::HTTP.new(uri.host, uri.port)
    if headers == nil
      response = http.send_request('POST',path,data)
    else
      response = http.send_request('POST',path,data,headers)
    end
    response
  end

  def put(path,data,headers=nil)
    uri = URI.parse(@defaults[:domain])
    http = Net::HTTP.new(uri.host, uri.port)

    if headers == nil
      response = http.send_request('PUT',path,data)
    else
      response = http.send_request('PUT',path,data,headers)
    end
    response
  end
  
  def delete(path,data,headers=nil)
    uri = URI.parse(@defaults[:domain])
    http = Net::HTTP.new(uri.host, uri.port)

    if headers == nil
      response = http.send_request('DELETE',path,data)
    else
      response = http.send_request('DELETE',path,data,headers)
    end
    response
  end

  def self.request(domain, request_type, request_path, data={}, headers={})
    data = data.to_query
    request = HttpRequestor.new(domain)
    if request_type == "GET"
      return request.get(request_path, data, headers)
    elsif request_type == "POST"
      return request.post(request_path, data, headers)
    elsif request_type == "PUT"
      return request.put(request_path, data, headers)
    elsif request_type == "DELETE"
      return request.delete(request_path, data, headers)
    end
  end
end

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