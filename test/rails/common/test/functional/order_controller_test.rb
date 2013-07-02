require 'test_helper'

class OrderControllerTest < ActionController::TestCase
  def setup
    @central_logger = Rails.logger
    @central_logger.reset_collection
    common_setup
  end

  test "should have log level set" do
    assert_equal ActiveSupport::Logger.const_get(Rails.configuration.log_level.to_s.upcase), Rails.logger.level
  end

  test "should have auto flushing set in development" do
    assert @central_logger.auto_flushing
  end

  test "should log a single record" do
    get :index
    assert_response :success
    assert_equal 1, @collection.find({"controller" => "order","action"=> "index"}).count
  end

  test "should log a debug message" do
    get :index
    assert_equal OrderController::LOG_MESSAGE, @collection.find_one({}, :fields => ["messages"])["messages"]["debug"][0]
  end

  test "should log extra metadata" do
    get :index
    assert_equal Rails.root.basename.to_s, @collection.find_one({}, :fields => "application_name_again")["application_name_again"]
  end

  test "should log exceptions" do
    assert_raise(RuntimeError, OrderController::LOG_MESSAGE) {get :blow_up}
    assert_equal 1, @collection.find_one({"messages.error" => /^#{OrderController::LOG_MESSAGE}/})["messages"]["error"].count
  end

  test "should not log passwords" do
    post :create, :order => {:password => OrderController::LOG_MESSAGE }
    assert_equal 1, @collection.find_one({"params.order.password" => "[FILTERED]"})["params"]["order"].count
  end

  test "should set the application name" do
    if Rails::VERSION::MAJOR == 3
      assert_equal 'LoggerAndRails3', @central_logger.instance_variable_get(:@application_name)
    else
      # 2 is the base dir, so it assumes it should go up two directories due to
      # capistrano deployment
      assert_equal 'test', @central_logger.instance_variable_get(:@application_name)
    end
  end
end
