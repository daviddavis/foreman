require 'test_helper'

class Api::V2::OperatingsystemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, { }
    assert_response :success
    assert_not_nil assigns(:operatingsystems)
  end

  test "should show os" do
    get :show, { :id => operatingsystems(:redhat).to_param }
    assert_response :success
    assert_not_nil assigns(:operatingsystem)
    show_response = ActiveSupport::JSON.decode(@response.body)
    assert !show_response.empty?
  end

  test "should create os" do
    assert_difference('Operatingsystem.count') do
      post :create, { :operatingsystem => os_params }
    end
    assert_response :created
    assert_not_nil assigns(:operatingsystem)
  end

  test "should create os with os parameters" do
    os_with_params = os_params.merge(:os_parameters_attributes => {0=>{:name => "foo", :value => "bar"}})
    assert_difference('OsParameter.count') do
      assert_difference('Operatingsystem.count') do
        post :create, { :operatingsystem => os_with_params }
      end
    end
    assert_response :created
    assert_not_nil assigns(:operatingsystem)
  end

  test "should not create os without version" do
    assert_difference('Operatingsystem.count', 0) do
      post :create, { :operatingsystem => os_params.except(:major) }
    end
    assert_response :unprocessable_entity
  end

  test "should update os" do
    put :update, { :id => operatingsystems(:redhat).to_param, :operatingsystem => { :name => "new_name" } }
    assert_response :success
  end

  test "should destroy os" do
    assert_difference('Operatingsystem.count', -1) do
      delete :destroy, { :id => operatingsystems(:no_hosts_os).to_param }
    end
    assert_response :success
  end

  test "should update associated architectures by ids with UNWRAPPED node" do
    os = operatingsystems(:redhat)
    assert_difference('os.architectures.count') do
      put :update, { :id => os.to_param, :operatingsystem => { },
                     :architectures => [{ :id => architectures(:x86_64).id }, { :id => architectures(:sparc).id } ] }
    end
    assert_response :success
  end

  test "should update associated architectures by name with UNWRAPPED node" do
    os = operatingsystems(:redhat)
    assert_difference('os.architectures.count') do
      put :update, { :id => os.to_param,  :operatingsystem => { },
                     :architectures => [{ :name => architectures(:x86_64).name }, { :name => architectures(:sparc).name } ] }
    end
    assert_response :success
  end

  test "should add association of architectures by ids with WRAPPED node" do
    os = operatingsystems(:redhat)
    assert_difference('os.architectures.count') do
      put :update, { :id => os.to_param, :operatingsystem => { :architectures => [{ :id => architectures(:x86_64).id }, { :id => architectures(:sparc).id }] } }
    end
    assert_response :success
  end

  test "should add association of architectures by name with WRAPPED node" do
    os = operatingsystems(:redhat)
    assert_difference('os.architectures.count') do
      put :update, { :id => os.to_param, :operatingsystem => { :architectures => [{ :name => architectures(:x86_64).name }, { :name => architectures(:sparc).name }] } }
    end
    assert_response :success
  end

  test "should remove association of architectures with WRAPPED node" do
    os = operatingsystems(:redhat)
    assert_difference('os.architectures.count', -1) do
      put :update, { :id => os.to_param, :operatingsystem => {:architectures => [] } }
    end
    assert_response :success
  end

  test "should show os if id is fullname" do
    get :show, { :id => operatingsystems(:centos5_3).fullname }
    assert_response :success
    assert_equal operatingsystems(:centos5_3), assigns(:operatingsystem)
  end

  test "should show os if id is description" do
    get :show, { :id => operatingsystems(:redhat).description }
    assert_response :success
    assert_equal operatingsystems(:redhat), assigns(:operatingsystem)
  end

  private

  def os_params
    {
      :name  => "awsome_os",
      :major => "1",
      :minor => "2"
    }
  end
end
