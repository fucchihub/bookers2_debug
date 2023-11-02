class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @books = Book.find(params[:id])
    @user = @books.user
    @book = Book.new
    @book_comment = BookComment.new
    @currentUserEntry = Entry.where(user_id: current_user.id)   #Entryモデルからログインユーザーを取得
    @userEntry = Entry.where(user_id: @user.id)   #Entryモデルからチャット相手ユーザーを取得
    unless @user.id == current_user.id      #ログインユーザーではない場合、以下の処理をする。
      @currentUserEntry.each do |cu|        #ログインユーザーとチャット相手を一つずつ取り出す
        @userEntry.each do |u|
          if cu.room_id == u.room_id then   #ユーザー同士のroom_idが共通している場合の処理。
            @isRoom = true                  #Roomがすでにあるということ。
            @roomId = cu.room_id            #@roomId = cu.room_idという変数を指定.すでに作成されているroom_idを特定できる.
          end
        end
      end
      if @isRoom                           #Roomがまだない場合、新たにRoomとEntryを作成する
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorites).sort_by { |book| -book.favorites.where(created_at: from...to).count }
    @book = Book.new
  end




  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
      redirect_to books_path
    end
  end
end
