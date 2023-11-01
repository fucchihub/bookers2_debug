class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save

  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy

  end
end


#
#if request.referer.include?("books/#{book.id}")
#  redirect_to book_path(book)
#elsif request.referer.include?("users")
#  redirect_to user_path(current_user.id)
#else
#  redirect_to books_path
#end

#簡略化バージョン
#class FavoritesController < ApplicationController
#  def create
#    create_favorite
#    redirect_back(fallback_location: root_path)
#  end

#  def destroy
#    destroy_favorite
#    redirect_back(fallback_location: root_path)
#  end

#  private

#  def create_favorite
#    book = Book.find(params[:book_id])
#    current_user.favorites.create(book: book)
#  end

#  def destroy_favorite
#    book = Book.find(params[:book_id])
#    current_user.favorites.find_by(book: book).destroy
#  end
#end