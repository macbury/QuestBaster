require 'test_helper'

class QuestTemplatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quest_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quest_template" do
    assert_difference('QuestTemplate.count') do
      post :create, :quest_template => { }
    end

    assert_redirected_to quest_template_path(assigns(:quest_template))
  end

  test "should show quest_template" do
    get :show, :id => quest_templates(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => quest_templates(:one).to_param
    assert_response :success
  end

  test "should update quest_template" do
    put :update, :id => quest_templates(:one).to_param, :quest_template => { }
    assert_redirected_to quest_template_path(assigns(:quest_template))
  end

  test "should destroy quest_template" do
    assert_difference('QuestTemplate.count', -1) do
      delete :destroy, :id => quest_templates(:one).to_param
    end

    assert_redirected_to quest_templates_path
  end
end
