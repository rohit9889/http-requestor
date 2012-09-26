require "../lib/http-requestor"
require "test/unit"
 
class HttpRequestorTest < Test::Unit::TestCase
 
  def test_should_raise_error_for_invalid_url_scheme
    assert_raise(InvalidURISchemeException) { HttpRequestor.new("some://www.invalid_url_scheme.com") }
  end
  
  def test_should_not_raise_error_for_valid_url_scheme
    assert_nothing_raised(InvalidURISchemeException) { HttpRequestor.new("http://www.google.com") }
    assert_nothing_raised(InvalidURISchemeException) { HttpRequestor.new("https://www.yahoo.com") }
  end

  def test_should_raise_error_on_invalid_request_type
    assert_raise(InvalidRequestTypeException) { HttpRequestor.request("http://en.wikibooks.org", "OPTIONS", "/wiki/Ruby_Programming/Unit_testing#A_Simple_Introduction") }
  end
  
  def test_should_not_raise_error_on_valid_request_type
    assert_nothing_raised(InvalidRequestTypeException) { HttpRequestor.request("http://en.wikibooks.org", "GET", "/wiki/Ruby_Programming/Unit_testing#A_Simple_Introduction") }
  end
end