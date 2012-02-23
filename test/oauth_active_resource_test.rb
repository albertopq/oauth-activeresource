require 'test_helper'

class OauthActiveResourceTest < ActiveSupport::TestCase
  
  def setup
    oauth_mock = stub("oauth")
    oauth_mock.stubs(:get).with('http://example.com:80/users.json', {'Accept' => 'application/json'}).returns(valid_response_all)
    oauth_mock.stubs(:post).with('http://example.com:80/users.json', list_users.first.to_json.to_s, {'Content-Type' => 'application/json'}).returns(valid_response_post)
    User.oauth_connection = oauth_mock
  end
  
  def test_user_model_should_inheritate_from_oauth_active_resource
    assert_equal OauthActiveResource::Base, User.superclass
  end
  
  def test_user_model_should_assign_access_token_after_assigning_to_base
    OauthActiveResource::Base.oauth_connection = "test"
    assert_equal User.oauth_connection, "test"
  end

  def test_find_should_request_get
    user = User.find(:all).first
    assert_kind_of User, user
    assert_equal user.name, "test"
  end 
  
  def test_create_should_request_post
    user = User.create(list_users.first)
    assert_kind_of User, user
    assert_equal user.name, list_users.first[:user][:name]
  end
  
  private
  
  def list_users
    [{:user => {:name => "test"}}]
  end

  def valid_response_all
    response = stub("http_response")
    response.stubs(:code).returns(200)
    response.stubs(:body).returns(list_users.to_json)
    response
  end

  def valid_response_post
    [{:user => {:name => "test"}}]
    response = stub("http_response")
    response.stubs(:code).returns(200)
    response.stubs(:[]).returns(nil)
    response.stubs(:body).returns(nil)
    response
  end  

end
  