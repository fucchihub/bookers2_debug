class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
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
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def search_form
    @user = User.find(params[:user_id])
    @books = @user.books.where(created_at: params[:created_at].to_date.all_day)
    render :search_form
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
