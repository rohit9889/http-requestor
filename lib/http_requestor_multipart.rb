module HTTP
  class Requestor
    def post_multipart(path="", data={},headers=nil)
      @uri = URI.parse(@defaults[:domain] + path) unless path.empty?
      build_data(data)
      req = Net::HTTP::Post.new(@uri.request_uri)
      req.initialize_http_header(headers) unless headers.nil?
      req.body = @post_body
      req["Content-Type"] = "multipart/form-data; boundary=#{@boundary}"
      res = @http.request(req)
      @post_body = ""
      @boundary = ""
      res
    end
  
    def put_multipart(path="", data={},headers=nil)
      @uri = URI.parse(@defaults[:domain] + path) unless path.empty?
      build_data(data)
      req = Net::HTTP::Put.new(@uri.request_uri)
      req.initialize_http_header(headers) unless headers.nil?
      req.body = @post_body
      req["Content-Type"] = "multipart/form-data; boundary=#{@boundary}"
      res = @http.request(req)
      @post_body = ""
      @boundary = ""
      res
    end
  
    def self.multipart_request(domain, request_type, data={}, headers={}, options={})
      request_type.to_s.upcase!
      request_type = "POST" unless ["POST", "PUT"].include?(request_type)
      req = self.new(domain, options)

      if request_type == "POST"
        return req.post_multipart("", data, headers)
      elsif request_type == "PUT"
        return req.put_multipart("", data, headers)
      end
    end

    private
      def create_boundary
        chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
        boundary = ""
        20.times { boundary = boundary + chars.sample }
        boundary
      end

      def build_data(data)
        @boundary = create_boundary
        @post_body = ""

        create_post_body(data)

        @post_body << "\r\n--#{@boundary}--\r\n"
      end

      def create_post_body(parameters, datafile="")
        parameters.each_pair do |key, value|
          unless value.nil?
            disposition = datafile.empty? ? key : "#{datafile}[#{key}]"
            if value.is_a?(File)
              @post_body << "\r\n--#{@boundary}\r\n"
              @post_body << "Content-Disposition: form-data; name=\"#{disposition}\"; filename=\"#{value.original_filename}\"\r\n"
              @post_body << "Content-Type: #{value.content_type}\r\n"
              @post_body << "\r\n"
              @post_body << File.read(value)
            elsif [Hash].include?(value.class)
              create_post_body(value, disposition)
            elsif value.is_a?(Array)
              value.each do |a|
                if [Hash].include?(a.class)
                  create_post_body(a, "#{disposition}[]")
                elsif [File].include?(a.class)
                  @post_body << "\r\n--#{@boundary}\r\n"
                  @post_body << "Content-Disposition: form-data; name=\"#{disposition}[]\"; filename=\"#{a.original_filename}\"\r\n"
                  @post_body << "Content-Type: #{a.content_type}\r\n"
                  @post_body << "\r\n"
                  @post_body << File.read(a)
                else
                  @post_body << "\r\n--#{@boundary}\r\n"
                  @post_body << "Content-Disposition: form-data; name=\"#{disposition}[]\"\r\n\r\n"
                  @post_body << "#{a}"
                end
              end
            else
              @post_body << "\r\n--#{@boundary}\r\n"
              @post_body << "Content-Disposition: form-data; name=\"#{disposition}\"\r\n\r\n"
              @post_body << "#{value}"
            end
          end
        end
      end
  end
end