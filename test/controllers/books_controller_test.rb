require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:one)
    @book = books(:one)
  end
  
  test "should redirect new when not logged in" do
    get :new
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect create when not logged in" do
    get :create
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when not logged in" do
    get :edit, id: @book
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch :update, id: @book, book: { title: @book.title, author: @book.author }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Book.count' do
      delete :destroy, id: @book
    end
    assert_redirected_to login_url
  end
  
end
