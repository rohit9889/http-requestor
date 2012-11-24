require "../lib/http_requestor"
require "test/unit"
 
class HttpRequestorTest < Test::Unit::TestCase
  def test_should_get_data_when_request_type_not_specified
    assert_equal("200", HTTP::Requestor.request("http://en.wikibooks.org", "", "/wiki/Ruby_Programming/Unit_testing#A_Simple_Introduction").code )
  end
  
  def test_should_post_file_properly
    uri = "https://www.google.co.in/searchbyimage/upload"
    f=File.open("testfile.txt", "w+")
    f.syswrite("This is testing")
    f.close
    data = {:encoded_image => File.open("images.jpg")}

    assert_equal("302", HTTP::Requestor.multipart_request(uri, "post", data).code)
  end
  
  def test_should_post_file_properly_with_instance_method_used
    http = HTTP::Requestor.new("https://www.google.co.in")
    path = "/searchbyimage/upload"
    data = {:encoded_image => File.open("images.jpg")}
    assert_equal("302", http.post_multipart(path, data).code)
  end
  
  def test_should_post_multiple_files
    uri = "http://www.imaaage.com/upload.php"
    data = {:image => [File.open("images.jpg"), File.open("images.jpg")]}

    assert_equal("200", HTTP::Requestor.multipart_request(uri, "post", data).code)
  end
end