class BooksController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @currently_reading = Book.currently_reading
    @books_by_year = Book.books_by_year
  end
  
  def new
    @book = Book.new
  end
  
  def create
    @book = Book.new(book_params)
    if @book.save
      flash[:success] = "Successfully added #{@book.title} to the reading list!"
      redirect_to books_path
    else
      render 'new'
    end
  end
  
  def edit
    @book = Book.find(params[:id])
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      flash[:success] = "Successfully edited #{@book.title}!"
      redirect_to books_path
    else
      render 'edit'
    end
  end
  
  def destroy
    Book.find(params[:id]).destroy
    flash[:success] = "Successfully deleted book!"
    redirect_to books_path
  end
  
  private
  
    def book_params
      params.require(:book).permit(:title, :subtitle, :author, :amazon_id, :completion_date)
    end
  
end
