require "net/http"
require "net/https"
require "uri"
require File.dirname(__FILE__) + "/http_requestor_multipart"

module HTTP
  class Requestor
    #============== Instance Methods ===================
    def initialize(domain, options={})
      domain = "http://#{domain}" if domain.match(/^(http|https):\/\//).nil?
  
      @defaults = {:domain => domain}
      @uri = URI.parse(@defaults[:domain])
      if @uri.scheme == "http"
        @http = Net::HTTP.new(@uri.host, @uri.port)
      else
        @http = Net::HTTP.new(@uri.host, @uri.port)
        @http.use_ssl = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end
  
    def get(path,data={},headers=nil)
      data_to_query(data)
      if headers == nil
        response = @http.send_request('GET', path, @defaults[:data])
      else
        response = @http.send_request('GET', path, @defaults[:data], headers)
      end
      response
    end
  
    def post(path,data={},headers=nil)
      data_to_query(data)
      if headers == nil
        response = @http.send_request('POST', path, @defaults[:data])
      else
        response = @http.send_request('POST', path, @defaults[:data], headers)
      end
      response
    end
  
    def put(path,data={},headers=nil)
      data_to_query(data)
      if headers == nil
        response = @http.send_request('PUT', path, @defaults[:data])
      else
        response = @http.send_request('PUT', path, @defaults[:data], headers)
      end
      response
    end
    
    def delete(path,data={},headers=nil)
      data_to_query(data)
      if headers == nil
        response = @http.send_request('DELETE', path, @defaults[:data])
      else
        response = @http.send_request('DELETE', path, @defaults[:data], headers)
      end
      response
    end
    
    def options(path,data={},headers=nil)
      data_to_query(data)
      if headers == nil
        response = @http.send_request('OPTIONS', path, @defaults[:data])
      else
        response = @http.send_request('OPTIONS', path, @defaults[:data], headers)
      end
      response
    end
    
    def patch(path,data={},headers=nil)
      data_to_query(data)
      if headers == nil
        response = @http.send_request('PATCH', path, @defaults[:data])
      else
        response = @http.send_request('PATCH', path, @defaults[:data], headers)
      end
      response
    end
    
    def move(path,data={},headers=nil)
      data_to_query(data)
      if headers == nil
        response = @http.send_request('MOVE', path, @defaults[:data])
      else
        response = @http.send_request('MOVE', path, @defaults[:data], headers)
      end
      response
    end
    
    def head(path,data={},headers=nil)
      data_to_query(data)
      if headers == nil
        response = @http.send_request('HEAD', path, @defaults[:data])
      else
        response = @http.send_request('HEAD', path, @defaults[:data], headers)
      end
      response
    end
    
    def trace(path,data={},headers=nil)
      data_to_query(data)
      if headers == nil
        response = @http.send_request('TRACE', path, @defaults[:data])
      else
        response = @http.send_request('TRACE', path, @defaults[:data], headers)
      end
      response
    end
    
    def data_to_query(data)
      @defaults[:data] = (data.nil? || data.empty?) ? "" : data.to_query
    end
  
    #============== Class Methods ===================
    def self.request(domain, request_type, request_path, data={}, headers={}, options={})
      request_type.to_s.upcase!
      request_type = valid_request_types[0] unless valid_request_types.include?(request_type)
      req = self.new(domain, options)
      if request_type == "GET"
        return req.get(request_path, data, headers)
      elsif request_type == "POST"
        return req.post(request_path, data, headers)
      elsif request_type == "PUT"
        return req.put(request_path, data, headers)
      elsif request_type == "DELETE"
        return req.delete(request_path, data, headers)
      elsif request_type == "OPTIONS"
        return req.options(request_path, data, headers)
      elsif request_type == "PATCH"
        return req.patch(request_path, data, headers)
      elsif request_type == "MOVE"
        return req.move(request_path, data, headers)
      elsif request_type == "HEAD"
        return req.head(request_path, data, headers)
      elsif request_type == "TRACE"
        return req.trace(request_path, data, headers)
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
      ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH", "MOVE", "HEAD", "TRACE"]
    end
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

class Symbol
  def to_query(key)
    to_s.to_query(key)
  end

  def to_param
    to_s
  end
end

class NilClass
  def to_query(key)
    to_s.to_query(key)
  end

  def to_param
    to_s
  end
end

class File
  require 'mime/types'
  def original_filename
    path.split("/").last
  end
  
  def content_type
    MIME::Types.type_for(original_filename).first
  end
end